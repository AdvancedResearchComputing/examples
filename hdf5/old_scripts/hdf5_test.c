# include <stdio.h>
# include <stdlib.h>
# include <time.h>

# include "hdf5.h"

int main ( );
int *create_data ( int nc, int nr );
void write_data ( char *filename, int nc, int nr, int *array );
void read_data ( char *filename, int nc, int nr, int **array2 );
int compare_data ( int nc, int nr, int *array, int *array2 );
void timestamp ( );

/******************************************************************************/

int main ( )

/******************************************************************************/
/*
  Purpose:

    MAIN is the main program for HDF5_TEST.

  Modified:
 
    31 March 2017
*/
{
  int *array;
  int *array2;
  char filename[] = "hdf5_test.h5";
  int nc = 12;
  int nr = 6;
  int status;

  timestamp ( );
  printf ( "\n" );
  printf ( "HDF5_TEST:\n" );
  printf ( "  Write and read an HDF5 file.\n" );
/*
  Create the data.
*/
  printf ( "\n" );
  printf ( "  Create data array.\n" );
  array = create_data ( nc, nr );
/*
  Write the data to a file.
*/
  write_data ( filename, nc, nr, array );
/*
  Read the data from the file.
*/
  read_data ( filename, nc, nr, &array2 );
  printf ( "  Data read from file '%s'\n", filename );
/*
  Compare the two versions of the data.
*/
  status = compare_data ( nc, nr, array, array2 );
  if ( status == 0 )
  {
    printf ( "  Recovered data agrees with original data.\n" );
  }
  else
  {
    printf ( "  Recovered data does not agree with original data.\n" );
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
  printf ( "HDF5_TEST:\n" );
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

    31 March 2017

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

void write_data ( char *filename, int nc, int nr, int *array )

/******************************************************************************/
/*
  Purpose:

    WRITE_DATA writes the data array to an HDF5 file.

  Modified:

    31 March 2017

  Parameters:

    Input, char *FILENAME, the name of the file to create.

    Input, int NC, NR, the number of rows and columns.

    Input, int ARRAY[NC*NR], the data array.
*/
{
  hid_t dataset;
  char datasetname[] = "array";
  hid_t dataspace;
  hid_t datatype;
  hsize_t dims[2];
  hid_t file;
  int rank;
  herr_t status;
/*
  Define the file's properties.
*/
  file = H5Fcreate ( filename, H5F_ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT );
/*
  Define the shape of the array, and create space for it.
*/
  rank = 2;
  dims[0] = nc;
  dims[1] = nr;
  dataspace = H5Screate_simple ( rank, dims, NULL );
/*
  Define the datatype for the data.
*/
  datatype = H5Tcopy ( H5T_NATIVE_INT );
  status = H5Tset_order ( datatype, H5T_ORDER_LE );
/*
  Create a dataset within the file using the datasetname, dataspace and
  datatype we defined, and the default dataset creation properties.
*/
  dataset = H5Dcreate2 ( file, datasetname, datatype, dataspace,
    H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT );
/*
  Write the data to the dataset using default transfer properties.
*/
  status = H5Dwrite ( dataset, H5T_NATIVE_INT, H5S_ALL, H5S_ALL, 
    H5P_DEFAULT, array );
/*
  Free the resources.
*/
  H5Sclose ( dataspace );
  H5Tclose ( datatype );
  H5Dclose ( dataset );
  H5Fclose ( file );

  return;
}
/******************************************************************************/

void read_data ( char *filename, int nc, int nr, int **array2 )

/******************************************************************************/
/*
  Purpose:

    READ_DATA reads the data array from an HDF file.

  Modified:

    31 March 2017

  Parameters:

    Input, char *FILENAME, the name of the file to create.

    Input, int NC, NR, the number of rows and columns.

    Output, int *ARRAY2[NC*NR], the data array.
*/
{
  hid_t dataset;
  char datasetname[] = "array";
  hid_t dataspace;
  hid_t file;
  herr_t status;
/*
  Open the file and the dataset.
*/
  file = H5Fopen ( filename, H5F_ACC_RDONLY, H5P_DEFAULT );
/*
  Open the dataset "array".
*/
  dataset = H5Dopen2 ( file, datasetname, H5P_DEFAULT );
/*
  Get the dataspace.
*/
  dataspace = H5Dget_space(dataset); 
/*
  Read all the "array" data into array2.
*/
  *array2 = ( int * ) malloc ( nc * nr * sizeof ( int ) );
  status = H5Dread ( dataset, H5T_NATIVE_INT, H5S_ALL, H5S_ALL,
    H5P_DEFAULT, *array2 );
/*
  Release resources.
*/
  H5Dclose ( dataset );
  H5Sclose ( dataspace );
  H5Fclose ( file );

  return;
}
/******************************************************************************/

int compare_data ( int nc, int nr, int *array, int *array2 )

/******************************************************************************/
/*
  Purpose:

    COMPARE_DATA compares the original data to the data retrieved from the file.

  Modified:

    31 March 2017

  Parameters:

    Input, int NC, NR, the number of rows and columns.

    Input, int ARRAY[NC*NR], the data array.

    Input, int ARRAY2[NC*NR], the second data array.

    Output, int COMPARE_DATA:
    0, the information matches.
    1, some entry of ARRAY and ARRAY2 differs.
*/
{
  int i;
  int j;
  int k;
  int status;
 
  k = 0;
  for ( i = 0; i < nr; i++ )
  {
    for ( j = 0; j < nc; j++ )
    {
      if ( array[k] != array2[k] )
      {
        status = 1;
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
