## find the spam saved outputs in the CWD
files <- list.files("./", pattern="mcpi_[0-9]*.RData")

## empty initialization
pi.sum = 0.0
pi.max = 0.0
pi.min = 0.0

## loop over found RData files
for (i in 1:length(files))
{
  ## read file i and print to screen
  load(files[i])

  #add to sum
  pi.sum = pi.sum + pi.approx
  
  #set min/max
  if (i == 1) {
    pi.max = pi.approx
    pi.min = pi.approx
  }
  if (pi.max < pi.approx) {
    pi.max = pi.approx
  }
  if (pi.min > pi.approx) {
    pi.min = pi.approx
  }
}

pi.mean = pi.sum / length(files)
pi.err = abs(pi - pi.mean)/pi

cat('ran mcpi ',length(files),' times with results:\n')
cat('  mean  = ',pi.mean,'\n')
cat('  min   = ',pi.min,'\n')
cat('  max   = ',pi.max,'\n')
cat('  error = ',pi.err,'\n')

