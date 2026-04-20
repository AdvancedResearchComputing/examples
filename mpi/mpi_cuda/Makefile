todo: build
build: mpi_cuda.cu
	nvcc -c mpi_cuda.cu
	mpicxx -o mpi_cuda mpi_cuda.o -lcudart
clean:
	rm mpi_cuda mpi_cuda.o slurm-*.out