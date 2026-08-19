import os
import sys
import argparse
import mariadb

def main():
    # 1. Parse the user-specified filename from the command line arguments
    parser = argparse.ArgumentParser(description="Query MariaDB and save results to a file.")
    parser.add_argument(
        "-o", "--output_file", 
        required=True, 
        help="Path to the output file where records will be saved"
    )
    parser.add_argument(
        "-t", "--total_table_file", 
        required=True, 
        help="Path to the output file where ALL records will be saved"
    )
    args = parser.parse_args()

    # Connection configuration using local loopback
    conn_params = {
        "host": "127.0.0.1",
        "port": int(os.environ.get("DB_PORT", 3306)),
        "user": "root",          
        "password": "", 
        "database": "mysql"      
    }

    try:
        conn = mariadb.connect(**conn_params)
        cursor = conn.cursor()
        
        # Create table matching your schema
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS cluster_experiment (
                id INT AUTO_INCREMENT PRIMARY KEY,
                experiment_id INT,
                sample_count INT,
                status_code VARCHAR(20),
                location_name VARCHAR(50),
                quality_grade CHAR(1),
                tier_level CHAR(1)
            )
        """)
        
        # Clear old data for a clean run
        cursor.execute("TRUNCATE TABLE cluster_experiment")
        
        # Insert exactly four records
        records_to_insert = [
            (101, 45, "COMPLETED", "Lab_A", "A", "1"),
            (102, 12, "PENDING",   "Lab_B", "B", "2"),
            (103, 88, "COMPLETED", "Lab_A", "A", "3"),
            (104, 95, "COMPLETED", "Lab_C", "O", "1")
        ]
        
        insert_query = """
            INSERT INTO cluster_experiment 
            (experiment_id, sample_count, status_code, location_name, quality_grade, tier_level) 
            VALUES (?, ?, ?, ?, ?, ?)
        """
        cursor.executemany(insert_query, records_to_insert)
        conn.commit()
        print(f"Successfully database-inserted {cursor.rowcount} records.")


        # Query to fetch ALL records.
        cursor.execute("""
            SELECT experiment_id, sample_count, status_code, location_name, quality_grade, tier_level 
            FROM cluster_experiment 
        """)
        
        # Open the user-specified file and write the results
        with open(args.total_table_file, "w", encoding="utf-8") as f:
            # Write a header row to the file
            f.write("Exp_ID\tSamples\tStatus\tLocation\tGrade\tTier\n")
            
            records_saved = 0
            for row in cursor:
                # Format row elements as tab-separated values
                line = f"{row[0]}\t{row[1]}\t{row[2]}\t{row[3]}\t{row[4]}\t{row[5]}\n"
                f.write(line)
                records_saved += 1
                

        print(f"Successfully saved {records_saved} records to: {args.total_table_file}")
        


        # Query to fetch exactly 3 out of 4 records
        cursor.execute("""
            SELECT experiment_id, sample_count, status_code, location_name, quality_grade, tier_level 
            FROM cluster_experiment 
            WHERE status_code = 'COMPLETED'
        """)
        
        # Open the user-specified file and write the results
        with open(args.output_file, "w", encoding="utf-8") as f:
            # Write a header row to the file
            f.write("Exp_ID\tSamples\tStatus\tLocation\tGrade\tTier\n")
            
            records_saved = 0
            for row in cursor:
                # Format row elements as tab-separated values
                line = f"{row[0]}\t{row[1]}\t{row[2]}\t{row[3]}\t{row[4]}\t{row[5]}\n"
                f.write(line)
                records_saved += 1
                
        print(f"Successfully saved {records_saved} records to: {args.output_file}")

    except mariadb.Error as e:
        print(f"Database error: {e}", file=sys.stderr)
        sys.exit(1)
    except IOError as e:
        print(f"File writing error: {e}", file=sys.stderr)
        sys.exit(1)
    finally:
        if 'conn' in locals() and conn.open:
            cursor.close()
            conn.close()

if __name__ == "__main__":
    main()

