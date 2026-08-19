#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <mpi.h>

__global__ void cuda_hello(int rank){
    printf("Hello from the GPU! This is MPI rank %d using the GPU\n", rank);
}

int main(int argc, char *argv[]) {
    MPI_Init(&argc, &argv);

    int world_rank, world_size;
    char hostname[256];
    gethostname(hostname, 256);

    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    int device;
    cudaGetDevice(&device);
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, device);

    printf("Host %s - MPI rank %d/%d\n", hostname, world_rank, world_size);
    printf("  GPU UUID: ");
    for (int i = 0; i < 16; i++) {
        printf("%02x", prop.uuid.bytes[i]);
    }
    printf("\n");
    fflush(stdout);

    MPI_Barrier(MPI_COMM_WORLD);
    
    cuda_hello<<<1,1>>>(world_rank);
    cudaDeviceSynchronize();

    MPI_Finalize();

    return 0;
}