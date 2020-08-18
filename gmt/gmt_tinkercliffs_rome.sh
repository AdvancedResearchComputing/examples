#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=1
#SBATCH -p dev_q
#

#
module reset
module load GMT
module list
#
echo "GMT_TINKERCLIFFS ROME: Normal beginning of execution."
#
gmt pscoast -R-130/-70/24/52 -JB-100/35/33/45/6i -Ba -B+t"Conic Projection" -N1/thickest -N2/thinnest -A500 -Ggray -Wthinnest -P > GMT_tut_4.ps
if [ $? -ne 0 ]; then
  echo "GMT_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
gmt pscoast -Rg -JG280/30/6i -Bag -Dc -A5000 -Gwhite -SDarkTurquoise -P > GMT_tut_5.ps
if [ $? -ne 0 ]; then
  echo "GMT_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
ls *.ps
#
echo "GMT_TINKERCLIFFS ROME: Normal end of execution."
exit 0
