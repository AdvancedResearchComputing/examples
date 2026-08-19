import sys

# CLAs.
input_file=sys.argv[1]
output_file=sys.argv[2]


# Input file.
# Read string.
fh_in = open(input_file,"r")
my_string = fh_in.readline()
fh_in.close()


# Output file.
fh_out = open(output_file,"w")
 

d_letter_count = dict()

len_string = len(my_string)

fh_out.write("  The inputted string : " + my_string + "\n")

fh_out.write("  Number of characters in string : " + str(len_string) + "\n")

for itime in range(0, len_string):
    ichar = my_string[itime]

    # Do not allow non-alphabetic characters.
    if ichar == " " or ichar == "." or ichar == "," or ichar == "?" or ichar == "\n":
        continue

    if ichar not in d_letter_count:
        d_letter_count[ichar]=1
    else:
        d_letter_count[ichar] +=1

fh_out.write("  Letter occurrences counts are :" + "\n")

for ikey in d_letter_count:
    fh_out.write("  letter :  " + str(ikey) +  "  count : " + str(d_letter_count[ikey])  + "\n")

fh_out.close()
