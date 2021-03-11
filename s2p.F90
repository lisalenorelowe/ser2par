PROGRAM  Main

implicit none

include 'mpif.h'

integer :: ierr, istatus(MPI_STATUS_SIZE), numprocs
integer :: myid,i,nlines,iskip,narg,lines_left
double precision :: time1,time2,time3
character*200 :: command
character*10 :: cskip  !Command line arguments are taken as characters


! MPI Initialization 
 call MPI_INIT (ierr)
 call MPI_COMM_SIZE (MPI_COMM_WORLD, numprocs,ierr)
 call MPI_COMM_RANK (MPI_COMM_WORLD, myid, ierr)

! start timer
time1 = MPI_Wtime()

! --- Command Line Arguments for file names ---
      if(myid.eq.0) then
         narg = command_argument_count()
         iskip=0
       if (narg.eq.1) then
         call get_command_argument(1,cskip)
         read(cskip,*) iskip
#ifdef debug
        write(6,*) "Skip ", iskip," lines in the input file."
#endif
       endif
     endif


!--- ERROR CHECKING SECTION -------------------
! numprocs must be greater than 1
if(numprocs.eq.1) then
 write(6,*) "Code expects the number of tasks to be greater than 1."
 write(6,*) "Program will terminate."
  call MPI_FINALIZE(ierr)
 stop
endif

! First make sure there are enough lines in file, should be lt or eq numprocs
! If there was a skip, then subtract that from available lines in the file
if(myid.eq.0) then
 nlines = 0 
 OPEN (1, file = 's2p_commands.txt')
 DO
   READ(1,*,iostat=ierr)
   IF (ierr/=0) EXIT
   nlines = nlines + 1
 END DO
 CLOSE (1)
 lines_left = nlines - iskip 
 if(lines_left.lt.numprocs) then
   write(6,*) "The number of commands, ",lines_left,", is less than the number of tasks, ",numprocs,"."
   write(6,*) "Program will terminate"
   stop
 endif
endif

call MPI_BCAST(lines_left,1,MPI_INT,0,MPI_COMM_WORLD,ierr)
if(lines_left.lt.numprocs) then
 call MPI_FINALIZE(ierr)
 stop
endif
!--- END ERROR CHECKING SECTION -------------



! Processor with myid=0 (proc0) reads in parameters and sends to others 
 if(myid.eq.0) then 

  ! open file
  open(100,file="s2p_commands.txt")

  ! Skip lines...FORTRAN won't execute do loop if iskip=0, 
  do i=1,iskip
   read(100,'(A)') command
  enddo

  ! Read the rest, send after each read
  do i=1,(numprocs-1)
   read(100,'(A)') command
   call MPI_SEND(command,200,MPI_CHAR,i,i,MPI_COMM_WORLD,ierr)
#ifdef debug
!  write(6,*) "Command string for myid=0 ", command 
#endif
  enddo

  ! Read the first line to get params for itself 
  read(100,'(A)') command
#ifdef debug
!  write(6,*) "Command string for myid=0 ", command
#endif


  !close file
  close(100)

 else

! Other processors recieve inputs from proc0
  call MPI_RECV(command,200,MPI_CHAR,0,myid,MPI_COMM_WORLD,istatus,ierr)

endif

! Each processor create the executate command string and then call the program
! with system command
#ifdef debug
 write(6,*) "Processor ",myid," executes: ",trim(command)
#endif

 time2 = MPI_Wtime()
 call system (trim(command))
 time3 = MPI_Wtime()
#ifdef debug
 write(6,*) "System call on myid=",myid," took ",time3-time2," seconds"
#endif
 if(myid.eq.0)  write(6,*) "Total time was ",time3-time1," seconds" 

 call MPI_FINALIZE(ierr)
 
 stop
END
