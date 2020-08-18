# include <stdio.h>
# include <stdlib.h>
# include <time.h>

# include "netcdf.h"

int main ( );
int *create_data ( int nc, int nr );
int write_data ( int nc, int nr, int *array, char *filename );
int read_data ( char *filename, int *nc2, int *nr2, int **array2 );
int compare_data ( int nc, int nr, int *array, int nc2, int nr2, int *array2 );
void timestamp ( );

/******************************************************************************/

int main ( )

/******************************************************************************/
/*
  Purpose:

    MAIN is the main program for NETCDF_TEST.

  Modified:

    29 March 2017
*/
{
  int *array;
  int *array2;
  char filename[] = "netcdf_test.nc";
  int nc = 12;
  int nc2;
  int nr = 6;
  int nr2;
  int status;

  timestamp ( );
  printf ( "\n" );
  printf ( "NETCDF_TEST:\n" );
  printf ( "  C program to write and read NETCDF files.\n" );

  printf ( "\n" );
  printf ( "  Create data array.\n" );
  array = create_data ( nc, nr );

  status = write_data ( nc, nr, array, filename );
  printf ( "  Data stored in file '%s'\n", filename );

  status = read_data ( filename, &nc2, &nr2, &array2 );
  printf ( "  Data read from file '%s'\n", filename );
  status = compare_data ( nc, nr, array, nc2, nr2, array2 );
  if ( status == 0 )
  {
    printf ( "  Recovered data agrees with original data.\n" );
  }
/*
  Free memory.
*/
  free ( array );
  free ( array2 );
/*
  Terminate.
*/
  printf ( "\n" );
  printf ( "NETCDF_TEST:\n" );
  printf ( "  Normal end of execution.\n" );
  printf ( "\n" );
  timestamp ( );

  return 0;
}
/******************************************************************************/

int *create_data ( int nc, int nr )

/******************************************************************************/
/*
  Purpose:

    CREATE_DATA creates the data array.

  Discussion:

    This data is probably:

      0  1  2  3  4  5  6  7  8  9 10 11
     12 13 14 15 16 17 18 19 20 21 22 23
     24 25 26 27 28 29 30 31 32 33 34 35 
     36 37 38 39 40 41 42 43 44 45 46 47
     48 49 50 51 52 53 54 55 56 57 58 59
     60 61 62 63 64 65 66 67 68 69 70 71 

  Modified:

    29 March 2017

  Parameters:

    Input, int NC, NR, the number of rows and columns.

    Output, int CREATE_DATA[NC*NR], the data array.
*/
{
  int *array;
  int i;
  int j;
  int k;

  array = ( int * ) malloc ( nc * nr * sizeof ( int ) );

  k = 0;
  for ( i = 0; i < nr; i++ )
  {
    for ( j = 0; j < nc; j++ )
    {
      array[k] = k;
    }
  }

  return array;
}
/******************************************************************************/

int write_data ( int nc, int nr, int *array, char *filename )

/******************************************************************************/
/*
  Purpose:

    WRITE_DATA writes the data array to a NETCDF file.

  Modified:

    29 March 2017

  Parameters:

    Input, int NC, NR, the number of rows and columns.

    Input, int ARRAY[NC*NR], the data array.

    Input, char *FILENAME, the name of the file to create.
*/
{
  int dimids[2];
  int ncid;
  int nc_dimid;
  int ndims;
  int nr_dimid;
  int status;
  int varid;
/* 
  Create the file. 
  The NC_CLOBBER parameter tells netCDF to overwrite this file, 
  if it already exists.
*/
   status = nc_create ( filename, NC_CLOBBER, &ncid );

  if ( status )
  {
    printf ( "\n" );
    printf ( "WRITE_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/* 
  Define the dimensions. NetCDF will hand back an ID for each. 
*/
  status = nc_def_dim ( ncid, "nr", nr, &nr_dimid );

  if ( status )
  {
    printf ( "\n" );
    printf ( "WRITE_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }

  status = nc_def_dim ( ncid, "nc", nc, &nc_dimid );

  if ( status )
  {
    printf ( "\n" );
    printf ( "WRITE_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/*
  Tell NETCDF the shape of the ARRAY variable, by passing
  a vector listing the IDS of the dimensions!
*/
   dimids[0] = nc_dimid;
   dimids[1] = nr_dimid;
/*
  Define ARRAY.
*/
  ndims = 2;
  nc_def_var ( ncid, "array", NC_INT, ndims, dimids, &varid );

  if ( status )
  {
    printf ( "\n" );
    printf ( "WRITE_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/*
  Tell NETCDF we are done with metadata.
*/
  status = nc_enddef ( ncid );

  if ( status )
  {
    printf ( "\n" );
    printf ( "WRITE_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/*
  Write the actual numeric data in ARRAY.
*/
  status = nc_put_var_int ( ncid, varid, array );

  if ( status )
  {
    printf ( "\n" );
    printf ( "WRITE_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/*
  Close the file.
*/
  status = nc_close ( ncid );

  if ( status )
  {
    printf ( "\n" );
    printf ( "WRITE_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }

  return 0;
}
/******************************************************************************/

int read_data ( char *filename, int *nc2, int *nr2, int **array2 )

/******************************************************************************/
/*
  Purpose:

    READ_DATA reads the data array from a NETCDF file.

  Modified:

    29 March 2017

  Parameters:

    Input, char *FILENAME, the name of the file to create.

    Input, int *NC2, *NR2, the number of rows and columns.

    Input, int *ARRAY2[(*NC2)*(*NR2)], the data array.

    Output, int READ_DATA:
    0, no error.
    nonzero, an error occurred.
*/
{
  int dimids[2];
  int ncid;
  int nc_dimid;
  int ndims;
  int nr_dimid;
  int status;
  int varid;
  long unsigned int t;
/* 
  Open the file. 
  The NC_NOWRITE asks for "read-only" access.
*/
  status = nc_open ( filename, NC_NOWRITE, &ncid );

  if ( status )
  {
    printf ( "\n" );
    printf ( "READ_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/*
  Retrieve the ID of the first dimension.
*/
  status = nc_inq_dimid ( ncid, "nc", &nc_dimid );

  if ( status )
  {
    printf ( "\n" );
    printf ( "READ_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/*
  Retrieve the value of the first dimension.
*/
  status = nc_inq_dimlen ( ncid, nc_dimid, &t );
  *nc2 = t;

  if ( status )
  {
    printf ( "\n" );
    printf ( "READ_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/*
  Retrieve the ID of the second dimension.
*/
  status = nc_inq_dimid ( ncid, "nr", &nr_dimid );

  if ( status )
  {
    printf ( "\n" );
    printf ( "READ_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/*
  Retrieve the value of the second dimension.
*/
  status = nc_inq_dimlen ( ncid, nr_dimid, &t );
  *nr2 = t;

  if ( status )
  {
    printf ( "\n" );
    printf ( "READ_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/*
  Use the dimension information to allocate the array.
*/
  *array2 = ( int * ) malloc ( ( *nc2 ) * ( *nr2 ) * sizeof ( int ) );
/* 
  Get the ID of the variable, keyed off its name.
*/
  status = nc_inq_varid ( ncid, "array", &varid );

  if ( status )
  {
    printf ( "\n" );
    printf ( "READ_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/* 
  Read the data. 
*/
  status = nc_get_var_int ( ncid, varid, *array2 );

  if ( status )
  {
    printf ( "\n" );
    printf ( "READ_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }
/*
  Close the file.
*/
  status = nc_close ( ncid );

  if ( status )
  {
    printf ( "\n" );
    printf ( "READ_DATA - Error!\n" );
    printf ( "%s\n", nc_strerror ( status ) ); 
    exit ( status );
  }

  return 0;
}
/******************************************************************************/

int compare_data ( int nc, int nr, int *array, int nc2, int nr2, int *array2 )

/******************************************************************************/
/*
  Purpose:

    COMPARE_DATA compares the original data to the data retrieved from the file.

  Modified:

    29 March 2017

  Parameters:

    Input, int NC, NR, the number of rows and columns.

    Input, int ARRAY[NC*NR], the data array.

    Input, int NC2, NR2, the number of rows and columns.

    Input, int ARRAY2[NC2*NR2], the data array.

    Output, int COMPARE_DATA:
    0, the information matches.
    1, NC does not equal NC2;
    2, NR does not equal NR2;
    3, some entry of ARRAY and ARRAY2 differs.
*/
{
  int i;
  int j;
  int k;
  int status;

  if ( nc != nc2 )
  {
    status = 1;
    return status;
  }

  if ( nr != nr2 )
  {
    status = 2;
    return status;
  }
 
  k = 0;
  for ( i = 0; i < nr; i++ )
  {
    for ( j = 0; j < nc; j++ )
    {
      if ( array[k] != array2[k] )
      {
        status = 3;
        return status;
      }
    }
  }

  status = 0;

  return status;
}
/******************************************************************************/

void timestamp ( )

/******************************************************************************/
/*
  Purpose:

    TIMESTAMP prints the current YMDHMS date as a time stamp.

  Example:

    17 June 2014 09:45:54 AM

  Licensing:

    This code is distributed under the GNU LGPL license. 

  Modified:

    17 June 2014

  Author:

    John Burkardt

  Parameters:

    None
*/
{
# define TIME_SIZE 40

  static char time_buffer[TIME_SIZE];
  const struct tm *tm;
  time_t now;

  now = time ( NULL );
  tm = localtime ( &now );

  strftime ( time_buffer, TIME_SIZE, "%d %B %Y %I:%M:%S %p", tm );

  printf ( "%s\n", time_buffer );

  return;
# undef TIME_SIZE
}
