#!/bin/bash
######################## start of slurm options #########################################
########################################
# Job Identification & Runtime         #
########################################
#SBATCH --job-name=mpi-gpu-add              # Job name
#SBATCH --account=personal                  # Account name
#SBATCH --time=00:10:00                     # Time limit (HH:MM:SS)
#SBATCH --partition=a100_normal_q           # Partition name (use correct GPU queue)
#SBATCH --output=job_output_%j.out          # Standard output file (%j = job ID)
#SBATCH --error=job_error_%j.err            # Standard error file
#######################################
# CPU and Node Configuration          #
#######################################
#SBATCH --nodes=1                           # Number of nodes
#SBATCH --ntasks-per-node=2                 # Number of MPI ranks
#SBATCH --cpus-per-task=2                   # CPUs per task
#SBATCH --mem=8G                            # Memory per node
#######################################
# GPU Configuration          #
#######################################
#SBATCH --gres=gpu:2                        # One GPU per rank
########################## end of slurm options #########################################

# Description: GPU-aware MPI vector addition with CUDA using NVHPC + OpenMPI

#########################################################################################
module reset
module load OpenMPI

# Create the CUDA-aware MPI source code
cat <<EOF > vector_add_mpi.cu
#include <mpi.h>
#include <cuda_runtime.h>
#include <stdio.h>

#define N 1024

__global__ void vector_add(float *a, float *b, float *c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n)
        c[i] = a[i] + b[i];
}

void check_cuda(cudaError_t err, const char *msg) {
    if (err != cudaSuccess) {
        fprintf(stderr, "CUDA Error: %s: %s\\n", msg, cudaGetErrorString(err));
        MPI_Abort(MPI_COMM_WORLD, -1);
    }
}

int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);
    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // Set device by rank
    check_cuda(cudaSetDevice(rank), "cudaSetDevice");

    float *a, *b, *c;
    float *d_a, *d_b, *d_c;

    // Allocate host memory
    a = (float*)malloc(N * sizeof(float));
    b = (float*)malloc(N * sizeof(float));
    c = (float*)malloc(N * sizeof(float));

    // Initialize input vectors
    for (int i = 0; i < N; ++i) {
        a[i] = rank + 1.0f;
        b[i] = i * 1.0f;
    }

    // Allocate device memory
    check_cuda(cudaMalloc(&d_a, N * sizeof(float)), "cudaMalloc d_a");
    check_cuda(cudaMalloc(&d_b, N * sizeof(float)), "cudaMalloc d_b");
    check_cuda(cudaMalloc(&d_c, N * sizeof(float)), "cudaMalloc d_c");

    // Copy to device
    check_cuda(cudaMemcpy(d_a, a, N * sizeof(float), cudaMemcpyHostToDevice), "Memcpy a");
    check_cuda(cudaMemcpy(d_b, b, N * sizeof(float), cudaMemcpyHostToDevice), "Memcpy b");

    // Launch kernel
    vector_add<<<(N + 255)/256, 256>>>(d_a, d_b, d_c, N);

    // Copy result back
    check_cuda(cudaMemcpy(c, d_c, N * sizeof(float), cudaMemcpyDeviceToHost), "Memcpy c");

    // Print a few elements from each rank
    printf("Rank %d: c[0]=%f, c[N-1]=%f\\n", rank, c[0], c[N-1]);

    // Clean up
    free(a); free(b); free(c);
    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);

    MPI_Finalize();
    return 0;
}
EOF

# Compile with NVHPC's CUDA-aware MPI support
nvcc -O2 vector_add_mpi.cu -o vector_add_mpi -I$MPI_ROOT/include -L$MPI_ROOT/lib -lmpi

# Run the program using mpirun
mpirun -np $SLURM_NTASKS ./vector_add_mpi

echo "GPU MPI job completed at \$(date)"
