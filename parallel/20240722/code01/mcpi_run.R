#Script to calculate pi using Monte Carlo

## read in the command line arguments
## run with: R CMD BATCH '--args seed=0 reps=5' spam_mc.R
args <- commandArgs(TRUE)
if(length(args) > 0) 
    for(i in 1:length(args)) 
        eval(parse(text=args[[i]]))

## print seed
cat("seed is ", seed, "\n", sep="")
set.seed(seed)


#Function to approximate pi
mcpi <- function(n.pts) {
  #generate n.pts (x,y) points in the unit square
  m = matrix(runif(2*n.pts),n.pts,2)
  #determine if they are in the unit circle
  #in.ucir <- function(x) { as.integer(norm(as.matrix(x),"F") <= 1) }
  in.ucir <- function(x) { as.integer((x[1]^2 + x[2]^2) <= 1) }
  in.cir = apply(m, 1, in.ucir )
  #return the proportion of points in the unit circle * 4
  return (4*sum(in.cir)/n.pts)
}

#problem size (number of points)
n.pts <- 5000000

cat('running serial version with n.pts = ',n.pts,'\n')

tm.st = Sys.time()

pi.approx <- mcpi(n.pts)
cat('     pi estimate = ',pi.approx,'\n')

pi.err = abs(pi - pi.approx)/pi
cat('  relative error = ',pi.err,'\n')

tm.tot = as.numeric(Sys.time() - tm.st, units="secs")
cat('       time used = ',tm.tot,'\n')

## save results to a file
save(pi.approx, file=paste("mcpi_", seed, ".RData", sep=""))
