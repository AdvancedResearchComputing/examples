import os
import sys
# Always time your code.
import time
import argparse
import sqlite3

def main():
    # Start time.
    begin_time = time.time()

    # CLAs.
    # Parse the user-specified filename from the command line arguments
    parser = argparse.ArgumentParser(description="sqlite me.")
    parser.add_argument(
        "-o", "--db_out_file",
        required=True,
        help="Database output file"
    )
    args = parser.parse_args()

    db_output_file = args.db_out_file

    # Connect to a database file (it will be created if it doesn't exist)
    connection = sqlite3.connect(db_output_file)
    
    # Create a cursor object to execute SQL commands
    cursor = connection.cursor()
    
    # Create a table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        role TEXT NOT NULL,
        salary INTEGER
    )
    """)
    
    # Insert data (records) into the table
    
    cursor.execute("""
    INSERT INTO employees (name, role, salary) 
    VALUES ('Alice Smith', 'Rock Star', 95000)
    """)
    
    cursor.execute("""
    INSERT INTO employees (name, role, salary) 
    VALUES ('Bob Jones', 'Baby Sitter', 82000)
    """)
    
    cursor.execute("""
    INSERT INTO employees (name, role, salary) 
    VALUES ('Don Weed', 'Philosopher, Human Behaviorist', 1222333444)
    """)
    
    # Save (commit) the changes
    connection.commit()
    
    # Query and display the data
    cursor.execute("SELECT * FROM employees")
    rows = cursor.fetchall()
    
    print("--- Employee Records ---")
    for row in rows:
        print(f"ID: {row[0]} | Name: {row[1]} | Role: {row[2]} | Salary: ${row[3]}")
    
    # Close the connection
    connection.close()

    # Timing data.
    end_time = time.time()

    duration_seconds = end_time-begin_time
    duration_hours = float(duration_seconds)/3600.0

    return duration_seconds, duration_hours 
    

if __name__ == "__main__":
    duration_seconds, duration_hours = main()
    print("   execution duration (s) : ",duration_seconds)
    print("   execution duration (hr) : ",duration_hours)
    print("  ---- good termination ----")

