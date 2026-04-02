todo: build
build: mpi_cudss.cu
	nvcc -Xcompiler -fopenmp -c mpi_cudss.cu
	mpicxx -fopenmp -o mpi_cudss mpi_cudss.o -L${CUDSS_DIR}/lib -lcudart -lcublas -lcudss
clean:
	rm mpi_cudss mpi_cudss.o