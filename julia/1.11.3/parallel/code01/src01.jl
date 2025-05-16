
# -----------------
# Packages and environments.
using Pkg
Pkg.activate("/home/ckuhlman/env-julia/falcon/benchmarking/BenchmarkTools/.")
using BenchmarkTools 
using CUDA

# -----------------
# Constants.
## Too long.
# outerLoop=100000
outerLoop=500
exponent=20

# -----------------
# Functions.

# Do addition.
function gpu_add1!(y, x)
    for i = 1:length(y)
        @inbounds y[i] += x[i]
    end
    return nothing
end


# Do performance eval call.
function bench_gpu1!(y, x)
    CUDA.@sync begin
        @cuda gpu_add1!(y, x)
    end
end


# ----------------
# Commands.


for itime in 1:outerLoop

   # Initialize.
   N = 2^exponent
   x_d = CUDA.fill(1.0f0, N)  # a vector stored on the GPU filled with 1.0 (Float32)
   y_d = CUDA.fill(2.0f0, N)  # a vector stored on the GPU filled with 2.0 (Float32)

   # Compute.
   # @btime bench_gpu1!($y_d, $x_d)
   ## bench_gpu1!($y_d, $x_d)
   bench_gpu1!(y_d, x_d)

end


