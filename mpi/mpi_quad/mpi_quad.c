#include "mpi.h"
#include "stdio.h"
#include "math.h"

double f ( double x );
int main ( int argc, char *argv[] );

/******************************************************************************/

int main ( int argc, char *argv[] )

/******************************************************************************/
/*
  Purpose:

    MAIN is the main program for QUADRATURE.

  Discussion:

    QUADRATURE estimates an integral using quadrature.

    The integral of F(X) = 4 / ( 1 + X * X ) from 0 to 1 is PI.

    We break up the interval [0,1] into N subintervals, evaluate
    F(X) at the midpoint of each subinterval, and multiply the
    sum of these values by N to get an estimate for the integral.

    If we have M processes available because we are using MPI, then
    we can ask processes 0, 1, 2, ... M-1 to handle the subintervals
    in the following order:

          0      1       2            M-1  <-- Process numbers begin at 0
     ------ ------  ------  -----  ------
          1      2       3    ...       M
        M+1    M+2     M+3    ...     2*M
      2*M+1    2*M+2 2*M+3    ...     3*M

    and so on up to subinterval N.  The partial sums collected by
    each process are then sent to the master process to be added
    together to get the estimated integral.


  Modified:

    15 October 2007

  Author:

    John Burkardt

  Reference:

    William Gropp, Ewing Lusk, Anthony Skjellum,
    Using MPI: Portable Parallel Programming with the
    Message-Passing Interface,
    Second Edition,
    MIT Press, 1999,
    ISBN: 0262571323.
*/
{
  double h;
  long int i;
  int ierr;
  int master = 0;
  int my_id;
  double my_part;
  long int n;
  int num_procs;
  double pi;
  double pi_diff;
  double pi_exact = 3.141592653589793238462643;
  double wtime_diff;
  double wtime_end;
  double wtime_start;
  double x;
/*
  Initialize MPI.
*/
  ierr = MPI_Init ( &argc, &argv );
/*
  Get the number of processes.
*/
  ierr = MPI_Comm_size ( MPI_COMM_WORLD, &num_procs );
/*
  Determine this processes's rank.
*/
  ierr = MPI_Comm_rank ( MPI_COMM_WORLD, &my_id );
/*
  Say hello.
*/
  if ( my_id == master )
  {
    printf ( "\n" );
    printf ( "QUADRATURE - Master process:\n" );
    printf ( "  C version\n" );
    printf ( "\n" );
    printf ( "  An MPI example program.\n" );
    printf ( "  Estimate the value of PI by approximating an integral.\n" );
    printf ( "  The integral is approximated by a sum,\n" );
    printf ( "  whose calculation is divided among a number of processes.\n" );
    printf ( "\n" );
    printf ( "  Compiled on %s at %s.\n", __DATE__, __TIME__ );
    printf ( "\n" );
    printf ( "  The number of processes available is %d.\n", num_procs );
  }
/*
  Record the starting time.
*/
  if ( my_id == master )
  {
    wtime_start = MPI_Wtime ( );
  }
/*
  We could assume that the number of intervals N is read in by process 0.
  To keep this program simple, we'll just assign a value to
  N, but only on process 0.
*/
  if ( my_id == master )
  {
    n = 1000000000;
    printf ( "\n" );
    printf ( "QUADRATURE - Master process:\n" );
    printf ( "  Number of intervals used is %d.\n", n );
  }
/*
  The master process broadcasts, and the other processes receive,
  the number of intervals N.
*/
  ierr = MPI_Bcast ( &n, 1, MPI_LONG, master, MPI_COMM_WORLD );
/*
  Every process integrates F(X) over a subinterval determined by its process ID.
*/
  h = 1.0 / ( double ) n;
  my_part = 0.0;
  for ( i = my_id + 1; i <= n; i = i + num_procs )
  {
    x = h * ( ( double ) i - 0.5 );
    my_part = my_part + f ( x );
  }
  //for( i = 0; i<100000000; i++) {
  //  my_part += 1.0f;
  //}
  //printf ( "\n" );
  //printf ( "QUADRATURE - Process %d:\n", my_id );
  //printf ( "  My contribution is %f.\n", my_part * h );
/*
  Each process sends its local result MY_PART to the MASTER process,
  to be added to the global result PI.
*/
  ierr = MPI_Reduce ( &my_part, &pi, 1, MPI_DOUBLE, MPI_SUM, master,
    MPI_COMM_WORLD );
/*
  The master process scales the sum and reports the results.
*/
  if ( my_id == master )
  {
    pi = pi * h;

    printf ( "\n");
    printf ( "QUADRATURE - Master process:\n");
    printf ( "  The estimate for PI is %24.16f\n", pi );
    printf ( "  The exact value is     %24.16f\n", pi_exact );
    pi_diff = fabs ( pi - pi_exact );
    printf ( "  The error is           %24.16f\n", pi_diff );

    wtime_end = MPI_Wtime ( );
    wtime_diff = wtime_end - wtime_start;

    printf ( "\n");
    printf ( "  Wall clock elapsed seconds = %f\n", wtime_diff );
  }
/*
  Shut down MPI.
*/
  ierr = MPI_Finalize ( );

  if ( my_id == master )
  {
    printf ( "\n");
    printf ( "QUADRATURE - Master process:\n");
    printf ( "  Normal end of execution.\n");
  }

  return 0;
}
/******************************************************************************/

double f ( double x )

/******************************************************************************/
/*
  Purpose:
    F evaluates the function F(X) which we are integrating.

  Discussion:
    Integral ( 0 <= X <= 1 ) 4/(1+X*X) dX = PI

  Modified:
    15 October 2007

  Author:
    John Burkardt

  Parameters:
    Input, double X, the point at which to evaluate F.
    Output, double F, the value of F(X).
*/
{
  double value;

  value = 4.0 / ( 1.0 + x * x );

  return value;
}
