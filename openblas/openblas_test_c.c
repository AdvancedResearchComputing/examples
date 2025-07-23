#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>
#include <cblas.h>

int main() {
    // Set matrix size (square matrix)
    int N = 100000;  // Adjust this to study scaling with different matrix sizes
    size_t matrix_size = (size_t)N * N;

    printf("Matrix size: %d x %d\n", N, N);
    printf("OpenMP threads: %d\n", omp_get_max_threads());

    // Allocate memory
    double *A = (double *) malloc(matrix_size * sizeof(double));
    double *B = (double *) malloc(matrix_size * sizeof(double));
    double *C = (double *) calloc(matrix_size, sizeof(double));  // initialize C to zeros

    if (A == NULL || B == NULL || C == NULL) {
        fprintf(stderr, "Memory allocation failed!\n");
        exit(EXIT_FAILURE);
    }

    // Initialize A and B with random values in parallel
    #pragma omp parallel
    {
        unsigned int seed = time(NULL) ^ omp_get_thread_num();  // thread-safe seed

        #pragma omp for
        for (size_t i = 0; i < matrix_size; i++) {
            A[i] = (double) rand_r(&seed) / RAND_MAX;
            B[i] = (double) rand_r(&seed) / RAND_MAX;
        }
    }

    // Set BLAS parameters
    double alpha = 1.0;
    double beta = 0.0;

    // Time the DGEMM computation
    double start = omp_get_wtime();

    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                N, N, N, alpha, A, N, B, N, beta, C, N);

    double end = omp_get_wtime();
    printf("DGEMM took %.3f seconds\n", end - start);

    // Free memory
    free(A);
    free(B);
    free(C);

    return 0;
}
