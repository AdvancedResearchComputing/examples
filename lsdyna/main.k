*KEYWORD
*TITLE
ARC_Tinkercliffs_Test_Job
$
$ --- 1. SIMULATION CONTROLS ---
$ Run for 0.002 seconds
*CONTROL_TERMINATION
$  ENDTIM  ENDCYC  DTMIN  ENDENG  ENDMAS
    0.002       0      0.0     0.0     0.0
$
$ Output data (d3plot) every 0.0001 seconds (20 frames)
*DATABASE_BINARY_D3PLOT
$      DT      LADT
   0.0001         0
$
$ --- 2. MATERIAL DEFINITION ---
$ Steel: Density=7.85e-9 tonnes/mm^3, Youngs Mod=2.1e5 MPa, Poison=0.3
*MAT_ELASTIC
$     MID        RO         E        PR        DA        DB
        1   7.85E-9   2.10E+5       0.3       0.0       0.0
$
$ --- 3. ELEMENT PROPERTIES ---
$ Solid element formulation 1 (Constant Stress)
*SECTION_SOLID
$     SID    ELFORM
        1         1
$
$ --- 4. PART DEFINITION ---
$ Combine Material 1 and Section 1 into Part 1
*PART
$                                                                         TITLE
Steel_Cube
$     PID       SECID       MID     EOSID      HGID      GRAV    ADPOPT      TMID
        1           1         1         0         0         0         0         0
$
$ --- 5. MESH (GEOMETRY) ---
$ A simple 10mm x 10mm x 10mm cube floating at Z=1.0mm
*NODE
       1,       0.0,       0.0,       1.0
       2,      10.0,       0.0,       1.0
       3,      10.0,      10.0,       1.0
       4,       0.0,      10.0,       1.0
       5,       0.0,       0.0,      11.0
       6,      10.0,       0.0,      11.0
       7,      10.0,      10.0,      11.0
       8,       0.0,      10.0,      11.0
*ELEMENT_SOLID
$     EID       PID      N1      N2      N3      N4      N5      N6      N7      N8
        1         1       1       2       3       4       5       6       7       8
$
$ --- 6. INITIAL CONDITIONS ---
$ Give the whole model a velocity of -10,000 mm/s (10 m/s) in Z-direction
*INITIAL_VELOCITY
$    NSID      NSIDEX      BOXID      IRIGID
        0           0          0           0
$      VX          VY         VZ        VXR        VYR        VZR
      0.0         0.0  -10000.00         0.0        0.0        0.0
$
$ --- 7. BOUNDARY CONDITIONS ---
$ A rigid floor at Z=0.0 with friction 0.5
*RIGIDWALL_PLANAR
$    NSID      NSIDEX      BOXID
        0           0          0
$      XT          YT         ZT        XH         YH         ZH      FRIC
      0.0         0.0        0.0       0.0        0.0        1.0       0.5
*END