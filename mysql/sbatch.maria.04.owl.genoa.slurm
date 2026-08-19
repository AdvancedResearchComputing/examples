#!/bin/bash
#SBATCH --job-name=mariadb_python_job
#SBATCH --time=00:10:00
#SBATCH --account=<account_name_no_beaks>
#SBATCH --partition=normal_q
#SBATCH --constraint=avx512
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err

# Load the cluster modules for Python and MariaDB
module purge
module reset
module load Miniforge3
module load MariaDB/11.7.0-GCC-13.3.0

echo " " 
echo "scontrol show job --details"
scontrol show job --details $SLURM_JOB_ID
echo " " 

# echo "python version"
# python --version
# echo " "

# Set up a lot of stuff for the MySQL server.

# Set up private database directories in your user space
DB_DIR="$HOME/my_private_db"
DB_DATA="$DB_DIR/data"
DB_LOG="$DB_DIR/mysql.log"
DB_PID="$DB_DIR/mysql.pid"
DB_SOCKET="$DB_DIR/mysql.sock"


# Clean up any old data directories if you want a fresh start
rm -rf "$DB_DIR"
mkdir -p "$DB_DATA"

# Initialize the database system tables
mariadb-install-db --auth-root-authentication-method=normal \
                   --datadir="$DB_DATA" 
#                    --basedir=$CONDA_PREFIX_OR_MODULE_PATH_IF_NEEDED



# Dynamically find a free port to avoid conflicts with other cluster users.
export DB_PORT=$(python3 -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
export DB_HOST=$(hostname)

echo "Starting database server on Host: $DB_HOST, Port: $DB_PORT"

# Start the MariaDB/MySQL server daemon in the background
mariadbd --datadir="$DB_DATA" \
         --port=$DB_PORT \
         --pid-file="$DB_PID" \
         --socket="$DB_SOCKET" \
         --skip-networking=0 \
         --log-error="$DB_LOG" &

# Alternative to setting (forcing) 127.0.0.1.

# Start the server daemon by completely bypassing host URLs
# on conn_params.
##  mariadbd --datadir="$DB_DATA" \
##           --port=$DB_PORT \
##           --pid-file="$DB_PID" \
##           --socket="$DB_SOCKET" \
##           --skip-networking=0 \
##           --skip-grant-tables \
##           --log-error="$DB_LOG" &


# Give the mariadb server 10 seconds to fully boot up.
sleep 10


# Activate your Python environment and run your script.
# (Pass host and port as environment variables to Python)
# Virtual environment for mariadb.
# We are assuming that it is in the same directory as
# the source code; if not, alter the path to py314_mf_mariad
# in the "source activate" command.
# ME TRYING THINGS:  source activate /home/ckuhlman/env-python/tc/normal_q/amd-base-nodes/py314_mf_mariadb
source activate ./py314_mf_mariadb_owl_genoa

# Now run the python code. Two CLAs. 
output_file=selected_records.tsv
total_table_file=all_records.tsv
python few_records.py  --total_table_file ${total_table_file}   --output_file  ${output_file}


# Cleanly shut down the server when your Python script finishes.
if [ -f "$DB_PID" ]; then
    kill $(cat "$DB_PID")
    wait
    echo "Database server stopped cleanly."
fi

