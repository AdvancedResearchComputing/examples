import argparse
import os
import socket

import torch
import torch.distributed as dist
import torch.nn.functional as F

from torch.nn.parallel import DistributedDataParallel as DDP
from torch.utils.data import Dataset, DataLoader
from torch.utils.data.distributed import DistributedSampler


# ----------------------------------------------------------------------
# Based on PyTorch's official multi-node DDP example:
# https://github.com/pytorch/examples/blob/main/distributed/ddp-tutorial-series/multinode.py
#
# ARC adaptations:
#   - Slurm-aware diagnostics
#   - CUDA compute smoke test
#   - explicit NCCL all_reduce validation
#   - node/GPU reporting
# ----------------------------------------------------------------------


class SyntheticDataset(Dataset):
    def __init__(self, size=2048):
        self.data = torch.randn(size, 20)
        self.targets = torch.randint(0, 4, (size,))

    def __len__(self):
        return len(self.data)

    def __getitem__(self, index):
        return self.data[index], self.targets[index]


def ddp_setup():
    local_rank = int(os.environ["LOCAL_RANK"])
    torch.cuda.set_device(local_rank)

    dist.init_process_group(
        backend="nccl",
        init_method="env://",
    )


# ----------------------------------------------------------------------
# ARC ADDITION: report the allocated node/GPU
# ----------------------------------------------------------------------
def report_environment():
    rank = dist.get_rank()
    world_size = dist.get_world_size()
    local_rank = int(os.environ["LOCAL_RANK"])

    print(
        f"[rank {rank}/{world_size}] "
        f"host={socket.gethostname()} "
        f"local_rank={local_rank} "
        f"CUDA_VISIBLE_DEVICES={os.environ.get('CUDA_VISIBLE_DEVICES')} "
        f"GPU={torch.cuda.get_device_name(local_rank)}",
        flush=True,
    )


# ----------------------------------------------------------------------
# ARC ADDITION: make sure CUDA computation itself works
# ----------------------------------------------------------------------
def cuda_smoke_test():
    rank = dist.get_rank()
    local_rank = int(os.environ["LOCAL_RANK"])

    device = torch.device("cuda", local_rank)

    x = torch.randn(4096, 4096, device=device)
    y = x @ x

    torch.cuda.synchronize()

    print(
        f"[rank {rank}] CUDA matrix multiplication passed "
        f"(sample={y[0, 0].item():.6f})",
        flush=True,
    )


# ----------------------------------------------------------------------
# ARC ADDITION: explicitly test cross-rank NCCL communication
# ----------------------------------------------------------------------
def nccl_allreduce_test():
    rank = dist.get_rank()
    world_size = dist.get_world_size()
    local_rank = int(os.environ["LOCAL_RANK"])

    device = torch.device("cuda", local_rank)

    value = torch.tensor(
        [float(rank + 1)],
        device=device,
    )

    dist.all_reduce(
        value,
        op=dist.ReduceOp.SUM,
    )

    expected = world_size * (world_size + 1) / 2

    if value.item() != expected:
        raise RuntimeError(
            f"Rank {rank}: all_reduce returned {value.item()}, "
            f"expected {expected}"
        )

    print(
        f"[rank {rank}] NCCL all_reduce passed; "
        f"value={value.item():.1f}",
        flush=True,
    )


class Trainer:
    def __init__(
        self,
        model,
        train_data,
        optimizer,
        save_every,
        snapshot_path,
    ):
        self.local_rank = int(os.environ["LOCAL_RANK"])
        self.global_rank = int(os.environ["RANK"])

        self.model = model.to(self.local_rank)
        self.train_data = train_data
        self.optimizer = optimizer

        self.save_every = save_every
        self.snapshot_path = snapshot_path
        self.epochs_run = 0

        if os.path.exists(snapshot_path):
            print("Loading snapshot")
            self._load_snapshot(snapshot_path)

        self.model = DDP(
            self.model,
            device_ids=[self.local_rank],
        )

    def _load_snapshot(self, snapshot_path):
        location = f"cuda:{self.local_rank}"

        snapshot = torch.load(
            snapshot_path,
            map_location=location,
        )

        self.model.load_state_dict(
            snapshot["MODEL_STATE"]
        )

        self.epochs_run = snapshot["EPOCHS_RUN"]

        print(
            f"Resuming training from epoch "
            f"{self.epochs_run}"
        )

    def _run_batch(self, source, targets):
        self.optimizer.zero_grad()

        output = self.model(source)

        loss = F.cross_entropy(
            output,
            targets,
        )

        loss.backward()
        self.optimizer.step()

        return loss

    def _run_epoch(self, epoch):
        self.train_data.sampler.set_epoch(epoch)

        for source, targets in self.train_data:
            source = source.to(
                self.local_rank,
                non_blocking=True,
            )

            targets = targets.to(
                self.local_rank,
                non_blocking=True,
            )

            loss = self._run_batch(
                source,
                targets,
            )

        if self.global_rank == 0:
            print(
                f"Epoch {epoch} completed "
                f"(last loss={loss.item():.6f})",
                flush=True,
            )

    def _save_snapshot(self, epoch):
        snapshot = {
            "MODEL_STATE":
                self.model.module.state_dict(),
            "EPOCHS_RUN":
                epoch + 1,
        }

        torch.save(
            snapshot,
            self.snapshot_path,
        )

        print(
            f"Epoch {epoch}: snapshot saved "
            f"to {self.snapshot_path}"
        )

    def train(self, max_epochs):
        for epoch in range(
            self.epochs_run,
            max_epochs,
        ):
            self._run_epoch(epoch)

            if (
                self.global_rank == 0
                and epoch % self.save_every == 0
            ):
                self._save_snapshot(epoch)


def load_train_objs():
    dataset = SyntheticDataset(2048)

    model = torch.nn.Sequential(
        torch.nn.Linear(20, 64),
        torch.nn.ReLU(),
        torch.nn.Linear(64, 4),
    )

    optimizer = torch.optim.SGD(
        model.parameters(),
        lr=1e-3,
    )

    return dataset, model, optimizer


def prepare_dataloader(
    dataset,
    batch_size,
):
    return DataLoader(
        dataset,
        batch_size=batch_size,
        pin_memory=True,
        shuffle=False,
        sampler=DistributedSampler(dataset),
    )


def main(
    save_every,
    total_epochs,
    batch_size,
    snapshot_path,
):
    ddp_setup()

    # ARC-specific validation before training.
    report_environment()
    cuda_smoke_test()
    nccl_allreduce_test()

    dataset, model, optimizer = load_train_objs()

    train_data = prepare_dataloader(
        dataset,
        batch_size,
    )

    trainer = Trainer(
        model,
        train_data,
        optimizer,
        save_every,
        snapshot_path,
    )

    trainer.train(total_epochs)

    dist.barrier()

    if dist.get_rank() == 0:
        print(
            "SUCCESS: multi-node DDP training "
            "completed.",
            flush=True,
        )

    dist.destroy_process_group()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description=(
            "ARC adaptation of the PyTorch "
            "multi-node DDP tutorial"
        )
    )

    parser.add_argument(
        "total_epochs",
        type=int,
    )

    parser.add_argument(
        "save_every",
        type=int,
    )

    parser.add_argument(
        "--batch-size",
        default=32,
        type=int,
    )

    parser.add_argument(
        "--snapshot-path",
        default="snapshot.pt",
    )

    args = parser.parse_args()

    main(
        args.save_every,
        args.total_epochs,
        args.batch_size,
        args.snapshot_path,
    )