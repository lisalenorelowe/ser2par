# ser2par - Serial to Parallel
FORTRAN MPI program to bundle serial jobs 

Contact lllowe@ncsu.edu for more information about the code or for questions on using or modifying it.

NOTE:  Each command used in the program must take approximately the same amount of time.  If they don't,
i.e. if one command takes significantly longer than another, cores will be left running idle and
that is a VIOLATION OF THE ACCEPTABLE USE POLICY (AUP).

To compile:
source s2p_compile.csh

To run:
bsub < s2p_run.csh

To run in chunks:
bsub < jobarray_s2p.csh

Inputs:
s2p_commands.txt

Versions:

Tag: v3.0

Date 10/17/2019

Update from V2: Added Skip

This version is stripped down so it is less confusing.  It is also completely general.

The user will have to write or create a script to write a list of commands, and put them in a file called 
s2p_commands.txt

The commands must be less than 200 characters and be on one line, or else the s2p.F90 has to be modified.

Currently, the code will execute as many commands from the file as there are mpi tasks.

There is an optional command line argument after mpirun, which is the skip.  This will tell ser2par to skip to a certain line in the input file. This is so the user can maintain a single giant input file and submit in LSF
in chunks.  In this way, it is not necessary to have different input files for each ser2par job. The skip is shown by example in jobarray_s2p.csh.   

If there are less commands than tasks, the code will terminate.  

Use the DEBUG flag when compiling (s2p_compile.csh) to check the commands read in and sent/recieved.  The DEBUG flag is default in s2p_compile.csh.
There should be very little overhead (I think) because all it does is write extra text to the screen.  The "check" flag can slow down a normal code,
but in this case, there is little checking to be done in the actual FORTRAN code.  And probably what little arrays it contains should be checked. 

The s2p_debug_run.csh uses ptile to make sure the code gets distributed over nodes.  This is soley for making sure
the MPI is working correctly.  Users should not use ptile unless each task needs more memory, and in that case,
the -x option needs to be specified as well.

EXAMPLE FILES:

There are example files for MATLAB, R, and Python.  The current examples in the main folder are for R.  The output from running the examples
are in example_output.

In example_output is the file check_s2p.out, which shows the commands used to generate the example output.  The commands were given from
the main s2p directory.

check_s2p.out:

cp examples/R_commands.txt s2p_commands.txt

cp examples/R_run.csh s2p_run.csh

bsub < s2p_run.csh

cp examples/Python_commands.txt s2p_commands.txt

cp examples/Python_run.csh s2p_run.csh

bsub < s2p_run.csh

cp examples/MATLAB_commmands.txt s2p_commands.txt

cp examples/MATLAB_run.csh s2p_run.csh

bsub < s2p_run.csh

mv *_err example_output/

mv *_out example_output/

----------------
DISCLAIMER:

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

