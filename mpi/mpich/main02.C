/*
purpose:  Two MPI processes ping-ponging messages back and 
          forth.
          The number of message transmissions is a CLA.
          The output file is a CLA.


*/


#include <stdio.h>
#include "mpi.h"
#include <string>
#include <iostream>
#include <fstream>


int main(int argc,char* argv[])
{
    int my_rank=0;
    int num_procs=0;
    int dest= 0;
    int tag= 0;
    int tmp,i;
    MPI_Status status;
    int iteration_limit=0;
    std::string string_my_rank = "";
    std::string output_filename = "";
    int iteration_count = 0;
    int partner_rank = 0;


    // CLAs.
    //
    // Read in total number of back-and-forth messages
    // between two MPI processes.
    // So that this can be scaled as needed.
    iteration_limit = std::stoi(argv[1]);

    // Base output filename for all results;
    // there will be possibly many files;
    // num_procs of them.
    std::string base_output_filename = argv[2];

    // Output file handle.
    std::ofstream fh_out;

    MPI_Init(&argc, &argv);
    /* get my_rank */

    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    printf("  my rank: %d\n",my_rank);
    /* find out how many processes there are */
    MPI_Comm_size(MPI_COMM_WORLD, &num_procs);
    printf("  num procs total: %d\n",num_procs);

    // Everything is keyed off of my_rank.

    // Setup and open MPI process output file.
    string_my_rank = std::to_string(my_rank);
    output_filename=base_output_filename+"_"+string_my_rank+".out";
    fh_out.open(output_filename);
    if (!fh_out) {
        std::cout << "Error:  cannot open output file : " << output_filename << std::endl;
        exit(1);
    }


    fh_out << "  Number of MPI processes total : " << num_procs << std::endl;
    fh_out << "  My MPI process rank : " << my_rank << std::endl;
    fh_out << std::endl;





    partner_rank = (my_rank + 1) % 2;
    while (iteration_count < iteration_limit) {
        // Increment the iteration count before you send it.

        if (my_rank == iteration_count % 2) {
	    fh_out << " ------------------" << std::endl;
            // Increment the iteration count before you send it.
            iteration_count++;
            MPI_Send(&iteration_count, 1, MPI_INT, partner_rank, 0,
                     MPI_COMM_WORLD);
            // printf("iteration counter: %d;  MY_RANK: %d;   SENT from rank: %d;  TO rank %d \n",
            //       iteration_count, my_rank, my_rank, partner_rank);
	    fh_out << "iteration counter: " << iteration_count 
		  << ";   my_rank: " << my_rank
		  << ";   SENT from rank: " << my_rank
		  << ";   TO rank: " << partner_rank
		  << std::endl;
        }
        else {
	    fh_out << " ------------------" << std::endl;
            MPI_Recv(&iteration_count, 1, MPI_INT, partner_rank, 0,
                     MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            // printf("iteration counter: %d;  MY_RANK: %d;   RECEIVED by rank: %d;   FROM rank %d \n",
            //        iteration_count, my_rank,  my_rank, partner_rank);
	    fh_out << "iteration counter: " << iteration_count 
		  << ";   my_rank: " << my_rank
		  << ";   RECEIVED by rank: " << my_rank
		  << ";   FROM rank: " << partner_rank
		  << std::endl;
        }
    }

    MPI_Finalize();

    
    // Close output file.
    fh_out.close();


    return 0;
}
