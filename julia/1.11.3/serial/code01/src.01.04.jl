# Code from:
# https://stackoverflow.com/questions/21056991/access-command-line-arguments-in-julia

# Must have at least three CLAs.

# Command line arguments (CLAs) are automatically in variable ARGS.
#
using Pkg 
## Pkg.activate("Venv/.")
Pkg.activate("/home/ckuhlman/env-julia/owl/trial/tutorial-example/.")
import Example

# Some new strings.
friendString01 = Example.hello("friend01")
friendString02 = Example.hello("friend02")
arg3String = Example.hello(  string(ARGS[3])  )


# Output file.
outfile = string(ARGS[4])

open(outfile, "w") do fh
    write(fh, "CLA 4: " * string(ARGS[4]) * "\n" )
    write(fh, "CLA 3: " * string(ARGS[3]) * "\n" )
    write(fh, "CLA 2: " * string(ARGS[2]) * "\n" )
    write(fh, "CLA 1: " * string(ARGS[1]) * "\n" )
    write(fh, "Julia also has argparse" * "\n" )
    write(fh, "friendString01: " * string(friendString01) * "\n" )
    write(fh, "friendString02: " * string(friendString02) * "\n" )
    write(fh, "arg3String: " * string(arg3String) * "\n" )
end


