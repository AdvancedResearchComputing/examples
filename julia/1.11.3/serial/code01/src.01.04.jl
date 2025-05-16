# Code from:
# https://stackoverflow.com/questions/21056991/access-command-line-arguments-in-julia

# Must have at least three CLAs.

# Command line arguments (CLAs) are automatically in variable ARGS.
#


# Output file.
outfile = string(ARGS[4])

open(outfile, "w") do fh
    write(fh, "CLA 4: " * string(ARGS[4]) * "\n" )
    write(fh, "CLA 3: " * string(ARGS[3]) * "\n" )
    write(fh, "CLA 2: " * string(ARGS[2]) * "\n" )
    write(fh, "CLA 1: " * string(ARGS[1]) * "\n" )
    write(fh, "Julia also has argparse" * "\n" )
end


