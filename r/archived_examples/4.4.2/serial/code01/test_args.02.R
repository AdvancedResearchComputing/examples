# Load the stringr package
library(stringr)

args = commandArgs(trailingOnly=TRUE)

fmt_str = paste("Guten tag, from ", Sys.info()["nodename"], "...   Arguments: ")

# Write to stdout the CLAs.
for (a in args) {fmt_str <- paste(fmt_str, " ",  a)}
print(fmt_str)

# Generate the output filename.
jobid=args[4]
arrayid=args[5]
outName<-str_c("output", jobid, arrayid, "txt", sep=".")

# Write to file.
fhout<-file(outName,"w")
for (a in args) {
    print(a)
    writeLines(a,fhout)
}
close(fhout)
