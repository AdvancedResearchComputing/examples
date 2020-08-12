# include <cblas.h>
# include <stdio.h>
# include <stdlib.h>
# include <time.h>

int main ( );
void dgemm_test ( );
void dnrm2_test ( );
void dtrmm_test ( );
void dtrsm_test ( );
void r8mat_print ( int m, int n, double a[], char *title );
void r8mat_print_some ( int m, int n, double a[], int ilo, int jlo, int ihi,
  int jhi, char *title );
double *r8mat_test ( char trans, int lda, int m, int n );
void timestamp ( );

/******************************************************************************/

int main ( )

/******************************************************************************/
/*
  Purpose:

    MAIN is the main program for OPENBLAS_TEST_C.

  Discussion:

    OPENBLAS_TEST_C tests the OPENBLAS library with C-style interface.

  Licensing:

    This code is distributed under the GNU LGPL license.

  Modified:

    11 March 2017

  Author:

    John Burkardt
*/
{
  timestamp ( );
  printf ( "\n" );
  printf ( "OPENBLAS_TEST_C\n" );
  printf ( "  C version\n" );
  printf ( "  Test the OPENBLAS library with C-style interface.\n" );

  dgemm_test ( );
  dnrm2_test ( );
  dtrmm_test ( );
  dtrsm_test ( );
/*
  Terminate.
*/
  printf ( "\n" );
  printf ( "OPENBLAS_TEST_C\n" );
  printf ( "  Normal end of execution.\n" );
  printf ( "\n" );
  timestamp ( );

  return 0;
}
/******************************************************************************/

void dgemm_test ( )

/******************************************************************************/
/*
  Purpose:

    DGEMM_TEST tests DGEMM.

  Licensing:

    This code is distributed under the GNU LGPL license.

  Modified:

    11 February 2017

  Author:

    John Burkardt
*/
{
  double *a;
  double alpha;
  double *b;
  double beta;
  double *c;
  int k;
  int lda;
  int ldb;
  int ldc;
  int m;
  int n;
  char transa_char;
  enum CBLAS_TRANSPOSE transa;
  char transb_char;
  enum CBLAS_TRANSPOSE transb;
  char transc_char;
  enum CBLAS_TRANSPOSE transc;

  printf ( "\n" );
  printf ( "DGEMM_TEST\n" );
  printf ( "  DGEMM carries out matrix multiplications\n" );
  printf ( "  for double precision real matrices.\n" );
  printf ( "\n" );
  printf ( "  1: C = alpha * A  * B  + beta * C;\n" );
  printf ( "  2: C = alpha * A' * B  + beta * C;\n" );
  printf ( "  3: C = alpha * A  * B' + beta * C;\n" );
  printf ( "  4: C = alpha * A' * B' + beta * C;\n" );
  printf ( "\n" );
  printf ( "  We carry out all four calculations, but in each case,\n" );
  printf ( "  we choose our input matrices so that we get the same result.\n" );
/*
  C = alpha * A * B + beta * C.
*/
  transa_char = 'N';
  transa = CblasNoTrans;
  transb_char = 'N';
  transb = CblasNoTrans;
  transc_char = 'N';
  m = 4;
  n = 5;
  k = 3;
  alpha = 2.0;
  lda = m;
  a = r8mat_test ( transa_char, lda, m, k );
  ldb = k;
  b = r8mat_test ( transb_char, ldb, k, n );
  beta = 3.0;
  ldc = m;
  c = r8mat_test ( transc_char, ldc, m, n );

  cblas_dgemm ( CblasColMajor, transa, transb, m, n, k, alpha, a, lda, b, 
    ldb, beta, c, ldc );

  r8mat_print ( m, n, c, "  C = alpha * A * B + beta * C:" );

  free ( a );
  free ( b );
  free ( c );
/*
  C = alpha * A' * B + beta * C.
*/
  transa_char = 'T';
  transa = CblasTrans;
  transb_char = 'N';
  transb = CblasNoTrans;
  transc_char = 'N';
  m = 4;
  n = 5;
  k = 3;
  alpha = 2.0;
  lda = k;
  a = r8mat_test ( transa_char, lda, m, k );
  ldb = k;
  b = r8mat_test ( transb_char, ldb, k, n );
  beta = 3.0;
  ldc = m;
  c = r8mat_test ( transc_char, ldc, m, n );

  cblas_dgemm ( CblasColMajor, transa, transb, m, n, k, alpha, a, lda, b, 
    ldb, beta, c, ldc );

  r8mat_print ( m, n, c, "  C = alpha * A' * B + beta * C:" );

  free ( a );
  free ( b );
  free ( c );
/*
  C = alpha * A * B' + beta * C.
*/
  transa_char = 'N';
  transa = CblasNoTrans;
  transb_char = 'T';
  transb = CblasTrans;
  transc_char = 'N';
  m = 4;
  n = 5;
  k = 3;
  alpha = 2.0;
  lda = m;
  a = r8mat_test ( transa_char, lda, m, k );
  ldb = n;
  b = r8mat_test ( transb_char, ldb, k, n );
  beta = 3.0;
  ldc = m;
  c = r8mat_test ( transc_char, ldc, m, n );

  cblas_dgemm ( CblasColMajor, transa, transb, m, n, k, alpha, a, lda, b, 
    ldb, beta, c, ldc );

  r8mat_print ( m, n, c, "  C = alpha * A * B' + beta * C:" );

  free ( a );
  free ( b );
  free ( c );
/*
  C = alpha * A' * B' + beta * C.
*/
  transa_char = 'T';
  transa = CblasTrans;
  transb_char = 'T';
  transb = CblasTrans;
  transc_char = 'N';
  m = 4;
  n = 5;
  k = 3;
  alpha = 2.0;
  lda = k;
  a = r8mat_test ( transa_char, lda, m, k );
  ldb = n;
  b = r8mat_test ( transb_char, ldb, k, n );
  beta = 3.0;
  ldc = m;
  c = r8mat_test ( transc_char, ldc, m, n );

  cblas_dgemm ( CblasColMajor, transa, transb, m, n, k, alpha, a, lda, b, 
    ldb, beta, c, ldc );

  r8mat_print ( m, n, c, "  C = alpha * A' * B' + beta * C:" );

  free ( a );
  free ( b );
  free ( c );

  return;
}
/******************************************************************************/

void dnrm2_test ( )

/******************************************************************************/
/*
  Purpose:

    DNRM2_TEST tests DNRM2.

  Licensing:

    This code is distributed under the GNU LGPL license.

  Modified:

    11 March 2017

  Author:

    John Burkardt
*/
{
  int n = 3;
  double v[] = { 1.0, 2.0, 3.0 };
  double v_norm;

  printf ( "\n" );
  printf ( "DNRM2_TEST\n" );
  printf ( "  DNRM2 computes the Euclidean norm of\n" );
  printf ( "  a double precision real vector.\n" );

  v_norm = cblas_dnrm2 ( n, v, 1 );

  printf ( "\n" );
  printf ( "  Norm of vector (1,2,3) is %g\n", v_norm );

  return;
}
/******************************************************************************/

void dtrmm_test ( )

/******************************************************************************/
/*
  Purpose:

    DTRMM_TEST tests DTRMM.

  Licensing:

    This code is distributed under the GNU LGPL license.

  Modified:

    11 February 2017

  Author:

    John Burkardt
*/
{
  double *a;
  double alpha;
  double *b;
  enum CBLAS_DIAG diag;
  char diag_char;
  int i;
  int j;
  int lda;
  int ldb;
  int m;
  int n;
  enum CBLAS_SIDE side;
  char side_char;
  enum CBLAS_TRANSPOSE transa;
  char transa_char;
  char transb_char;
  enum CBLAS_UPLO uplo;
  char uplo_char;

  printf ( "\n" );
  printf ( "DTRMM_TEST\n" );
  printf ( "  DTRMM multiplies a triangular matrix A and a\n" );
  printf ( "  rectangular matrix B\n" );
  printf ( "\n" );
  printf ( "  1: B = alpha * A  * B;\n" );
  printf ( "  2: B = alpha * A' * B;\n" );
/*
  B = alpha * A * B.
*/
  side_char = 'L';
  side = CblasLeft;
  uplo_char = 'U';
  uplo = CblasUpper;
  transa_char = 'N';
  transa = CblasNoTrans;
  diag_char = 'N';
  diag = CblasNonUnit;
  m = 4;
  n = 5;
  alpha = 2.0;
  lda = m;
  ldb = m;

  a = ( double * ) malloc ( lda * m * sizeof ( double ) );
  for ( j = 0; j < m; j++ )
  {
    for ( i = 0; i <= j; i++ )
    {
      a[i+j*lda] = ( double ) ( i + j + 2 );
    }
    for ( i = j + 1; i < m; i++ )
    {
      a[i+j*lda] = 0.0;
    }
  }

  transb_char = 'N';
  b = r8mat_test ( transb_char, ldb, m, n );

  cblas_dtrmm ( CblasColMajor, side, uplo, transa, diag, m, n, alpha, a, lda, b, ldb );

  r8mat_print ( m, n, b, "  B = alpha * A * B:" );

  free ( a );
  free ( b );
/*
  B = alpha * A' * B.
*/
  side_char = 'L';
  side = CblasLeft;
  uplo_char = 'U';
  uplo = CblasUpper;
  transa_char = 'T';
  transa = CblasTrans;
  diag_char = 'N';
  diag = CblasNonUnit;
  m = 4;
  n = 5;
  alpha = 2.0;
  lda = m;
  ldb = m;

  a = ( double * ) malloc ( lda * m * sizeof ( double ) );
  for ( j = 0; j < m; j++ )
  {
    for ( i = 0; i <= j; i++ )
    {
      a[i+j*lda] = ( double ) ( i + j + 2 );
    }
    for ( i = j + 1; i < m; i++ )
    {
      a[i+j*lda] = 0.0;
    }
  }

  transb_char = 'N';
  b = r8mat_test ( transb_char, ldb, m, n );

  cblas_dtrmm ( CblasColMajor, side, uplo, transa, diag, m, n, alpha, a, lda, b, ldb );

  r8mat_print ( m, n, b, "  B = alpha * A' * B:" );

  free ( a );
  free ( b );

  return;
}
/******************************************************************************/

void dtrsm_test ( )

/******************************************************************************/
/*
  Purpose:

    DTRSM_TEST tests DTRSM.

  Licensing:

    This code is distributed under the GNU LGPL license.

  Modified:

    11 February 2017

  Author:

    John Burkardt
*/
{
  double *a;
  double alpha;
  double *b;
  enum CBLAS_DIAG diag;
  char diag_char;
  int i;
  int j;
  int lda;
  int ldb;
  int m;
  int n;
  enum CBLAS_SIDE side;
  char side_char;
  enum CBLAS_TRANSPOSE transa;
  char transa_char;
  char transb_char;
  enum CBLAS_UPLO uplo;
  char uplo_char;

  printf ( "\n" );
  printf ( "DTRSM_TEST\n" );
  printf ( "  DTRSM solves a linear system involving a triangular\n" );
  printf ( "  matrix A and a rectangular matrix B.\n" );
  printf ( "\n" );
  printf ( "  1: Solve A  * X  = alpha * B;\n" );
  printf ( "  2: Solve A' * X  = alpha * B;\n" );
  printf ( "  3: Solve X  * A  = alpha * B;\n" );
  printf ( "  4: Solve X  * A' = alpha * B;\n" );
/*
  Solve A * X = alpha * B.
*/
  side_char = 'L';
  side = CblasLeft;
  uplo_char = 'U';
  uplo = CblasUpper;
  transa_char = 'N';
  transa = CblasNoTrans;
  diag_char = 'N';
  diag = CblasNonUnit;
  m = 4;
  n = 5;
  alpha = 2.0;
  lda = m;
  ldb = m;

  a = ( double * ) malloc ( lda * m * sizeof ( double ) );

  for ( j = 0; j < m; j++ )
  {
    for ( i = 0; i <= j; i++ )
    {
      a[i+j*lda] = ( double ) ( i + j + 2 );
    }
    for ( i = j + 1; i < m; i++ )
    {
      a[i+j*lda] = 0.0;
    }
  }

  transb_char = 'N';
  b = r8mat_test ( transb_char, ldb, m, n );

  cblas_dtrsm ( CblasColMajor, side, uplo, transa, diag, m, n, alpha, a, lda, b, ldb );

  r8mat_print ( m, n, b, "  X = inv ( A ) * alpha * B:" );

  free ( a );
  free ( b );
/*
  Solve A' * X = alpha * B.
*/
  side_char = 'L';
  side = CblasLeft;
  uplo_char = 'U';
  uplo = CblasUpper;
  transa_char = 'T';
  transa = CblasTrans;
  diag_char = 'N';
  diag = CblasNonUnit;
  m = 4;
  n = 5;
  alpha = 2.0;
  lda = m;
  ldb = m;

  a = ( double * ) malloc ( lda * m * sizeof ( double ) );
  for ( j = 0; j < m; j++ )
  {
    for ( i = 0; i <= j; i++ )
    {
      a[i+j*lda] = ( double ) ( i + j + 2 );
    }
    for ( i = j + 1; i < m; i++ )
    {
      a[i+j*lda] = 0.0;
    }
  }

  transb_char = 'N';
  b = r8mat_test ( transb_char, ldb, m, n );

  cblas_dtrsm ( CblasColMajor, side, uplo, transa, diag, m, n, alpha, a, lda, b, ldb );

  r8mat_print ( m, n, b, "  X = inv ( A' ) * alpha * B:" );

  free ( a );
  free ( b );
/*
  Solve X * A = alpha * B.
*/
  side_char = 'R';
  side = CblasRight;
  uplo_char = 'U';
  uplo = CblasUpper;
  transa_char = 'N';
  transa = CblasNoTrans;
  diag_char = 'N';
  diag = CblasNonUnit;
  m = 4;
  n = 5;
  alpha = 2.0;
  lda = n;
  ldb = m;

  a = ( double * ) malloc ( lda * n * sizeof ( double ) );
  for ( j = 0; j < n; j++ )
  {
    for ( i = 0; i <= j; i++ )
    {
      a[i+j*lda] = ( double ) ( i + j + 2 );
    }
    for ( i = j + 1; i < n; i++ )
    {
      a[i+j*lda] = 0.0;
    }
  }

  transb_char = 'N';
  b = r8mat_test ( transb_char, ldb, m, n );

  cblas_dtrsm ( CblasColMajor, side, uplo, transa, diag, m, n, alpha, a, lda, b, ldb );

  r8mat_print ( m, n, b, "  X = alpha * B * inv ( A ):" );

  free ( a );
  free ( b );
/*
  Solve X * A'' = alpha * B.
*/
  side_char = 'R';
  side = CblasRight;
  uplo_char = 'U';
  uplo = CblasUpper;
  transa_char = 'T';
  transa = CblasTrans;
  diag_char = 'N';
  diag = CblasNonUnit;
  m = 4;
  n = 5;
  alpha = 2.0;
  lda = n;
  ldb = m;

  a = ( double * ) malloc ( lda * n * sizeof ( double ) );
  for ( j = 0; j < n; j++ )
  {
    for ( i = 0; i <= j; i++ )
    {
      a[i+j*lda] = ( double ) ( i + j + 2 );
    }
    for ( i = j + 1; i < n; i++ )
    {
      a[i+j*lda] = 0.0;
    }
  }

  transb_char = 'N';
  b = r8mat_test ( transb_char, ldb, m, n );

  cblas_dtrsm ( CblasColMajor, side, uplo, transa, diag, m, n, alpha, a, lda, b, ldb );

  r8mat_print ( m, n, b, "  X = alpha * B * inv ( A' ):" );

  free ( a );
  free ( b );

  return;
}
/******************************************************************************/

void r8mat_print ( int m, int n, double a[], char *title )

/******************************************************************************/
/*
  Purpose:

    R8MAT_PRINT prints an R8MAT.

  Discussion:

    An R8MAT is a doubly dimensioned array of R8 values, stored as a vector
    in column-major order.

    Entry A(I,J) is stored as A[I+J*M]

  Licensing:

    This code is distributed under the GNU LGPL license.

  Modified:

    28 May 2008

  Author:

    John Burkardt

  Parameters:

    Input, int M, the number of rows in A.

    Input, int N, the number of columns in A.

    Input, double A[M*N], the M by N matrix.

    Input, char *TITLE, a title.
*/
{
  r8mat_print_some ( m, n, a, 1, 1, m, n, title );

  return;
}
/******************************************************************************/

void r8mat_print_some ( int m, int n, double a[], int ilo, int jlo, int ihi,
  int jhi, char *title )

/******************************************************************************/
/*
  Purpose:

    R8MAT_PRINT_SOME prints some of an R8MAT.

  Discussion:

    An R8MAT is a doubly dimensioned array of R8 values, stored as a vector
    in column-major order.

  Licensing:

    This code is distributed under the GNU LGPL license.

  Modified:

    26 June 2013

  Author:

    John Burkardt

  Parameters:

    Input, int M, the number of rows of the matrix.
    M must be positive.

    Input, int N, the number of columns of the matrix.
    N must be positive.

    Input, double A[M*N], the matrix.

    Input, int ILO, JLO, IHI, JHI, designate the first row and
    column, and the last row and column to be printed.

    Input, char *TITLE, a title.
*/
{
# define INCX 5

  int i;
  int i2hi;
  int i2lo;
  int j;
  int j2hi;
  int j2lo;

  fprintf ( stdout, "\n" );
  fprintf ( stdout, "%s\n", title );

  if ( m <= 0 || n <= 0 )
  {
    fprintf ( stdout, "\n" );
    fprintf ( stdout, "  (None)\n" );
    return;
  }
/*
  Print the columns of the matrix, in strips of 5.
*/
  for ( j2lo = jlo; j2lo <= jhi; j2lo = j2lo + INCX )
  {
    j2hi = j2lo + INCX - 1;
    if ( n < j2hi )
    {
      j2hi = n;
    }
    if ( jhi < j2hi )
    {
      j2hi = jhi;
    }

    fprintf ( stdout, "\n" );
/*
  For each column J in the current range...

  Write the header.
*/
    fprintf ( stdout, "  Col:  ");
    for ( j = j2lo; j <= j2hi; j++ )
    {
      fprintf ( stdout, "  %7d     ", j - 1 );
    }
    fprintf ( stdout, "\n" );
    fprintf ( stdout, "  Row\n" );
    fprintf ( stdout, "\n" );
/*
  Determine the range of the rows in this strip.
*/
    if ( 1 < ilo )
    {
      i2lo = ilo;
    }
    else
    {
      i2lo = 1;
    }
    if ( m < ihi )
    {
      i2hi = m;
    }
    else
    {
      i2hi = ihi;
    }

    for ( i = i2lo; i <= i2hi; i++ )
    {
/*
  Print out (up to) 5 entries in row I, that lie in the current strip.
*/
      fprintf ( stdout, "%5d:", i - 1 );
      for ( j = j2lo; j <= j2hi; j++ )
      {
        fprintf ( stdout, "  %14g", a[i-1+(j-1)*m] );
      }
      fprintf ( stdout, "\n" );
    }
  }

  return;
# undef INCX
}
/******************************************************************************/

double *r8mat_test ( char trans, int lda, int m, int n )

/******************************************************************************/
/*
  Purpose:

    R8MAT_TEST sets up a test matrix.

  Licensing:

    This code is distributed under the GNU LGPL license.
    
  Modified:

    10 February 2014

  Author:

    John Burkardt.

  Parameters:

    Input, char TRANS, indicates whether matrix is to be transposed.
    'N', no transpose.
    'T', transpose the matrix.

    Input, int LDA, the leading dimension of the matrix.

    Input, int M, N, the number of rows and columns of the matrix.

    Output, double R8MAT_TEST[LDA*?], the matrix.
    if TRANS is 'N', then the matrix is stored in LDA*N entries,
    as an M x N matrix;
    if TRANS is 'T', then the matrix is stored in LDA*M entries,
    as an N x M matrix.
*/
{
  double *a;
  int i;
  int j;

  if ( trans == 'N' )
  {
    a = ( double * ) malloc ( lda * n * sizeof ( double ) );

    for ( j = 0; j < n; j++ )
    {
      for ( i = 0; i < m; i++ )
      {
        a[i+j*lda] = ( double ) ( 10 * ( i + 1 ) + ( j + 1 ) );
      }
    }
  }
  else
  {
    a = ( double * ) malloc ( lda * m * sizeof ( double ) );

    for ( j = 0; j < n; j++ )
    {
      for ( i = 0; i < m; i++ )
      {
        a[j+i*lda] = ( double ) ( 10 * ( i + 1 ) + ( j + 1 ) );
      }
    }
  }
  return a;
}
/******************************************************************************/

void timestamp ( )

/******************************************************************************/
/*
  Purpose:

    TIMESTAMP prints the current YMDHMS date as a time stamp.

  Example:

    31 May 2001 09:45:54 AM

  Licensing:

    This code is distributed under the GNU LGPL license. 

  Modified:

    24 September 2003

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
