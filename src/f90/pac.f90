module Types
   implicit none
   type :: string
      type(character(:)), allocatable :: s
   end type string
   type :: art
      type(string), dimension(6) :: l
   end type art
end module Types

module Consts
   implicit none
   type :: col
      character(20) :: nc = "\x1b[0m"
      character(20) :: red = "\x1b[31m"
      character(20) :: blue = "\x1b[34m"
      character(20) :: pink = "\x1b[36m"
      character(20) :: white = "\x1b[37m"
      character(20) :: yellow = "\x1b[33m"
   end type col
end module Consts

module Utils
   use Types
   use Consts
   implicit none
contains
   subroutine println(line, pcol, artType, hasEyes)
      ! Inputs
      integer, intent(in) :: line
      character(20), intent(in) :: pcol
      type(art), intent(in) :: artType
      logical, intent(in) :: hasEyes
      ! functional
      type(col) :: cols
      if ((line == 2 .or. line == 3) .and. hasEyes) then
         write (*, '(a)', advance="no") trim(pcol)
         write (*, '(a)', advance="no") artType%l(line)%s(1:4) ! 4
         write (*, '(a)', advance="no") trim(cols%white)
         write (*, '(a)', advance="no") artType%l(line)%s(5:13) ! 4+9 = 13
         write (*, '(a)', advance="no") trim(pcol)
         write (*, '(a)', advance="no") artType%l(line)%s(14:19) ! 4+9+6 = 19
         write (*, '(a)', advance="no") trim(cols%white)
         write (*, '(a)', advance="no") artType%l(line)%s(20:28) ! 4+9+6+9 = 28
         write (*, '(a)', advance="no") trim(pcol)
         write (*, '(a)', advance="no") artType%l(line)%s(29:38) ! 4+9+6+9+6+4 = 38
      else
         write (*, '(a)', advance="no") trim(pcol)
         write (*, '(a)', advance="no") artType%l(line)%s
      end if
   end subroutine println
end module Utils

program main
   ! Imports
   use Types
   use Utils
   use Consts
   ! Type decls
   type(col) :: cols
   type(art) :: pac
   type(art) :: balls
   type(art) :: ghost
   ! Pac-Man
   pac%l(1)%s = "   ▄███████▄  "
   pac%l(2)%s = " ▄█████████▀▀ "
   pac%l(3)%s = " ███████▀     "
   pac%l(4)%s = " ███████▄     "
   pac%l(5)%s = " ▀█████████▄▄ "
   pac%l(6)%s = "   ▀███████▀  "
   ! Balls
   balls%l(1)%s = "            "
   balls%l(2)%s = "            "
   balls%l(3)%s = " ▄██▄  ▄██▄ "
   balls%l(4)%s = " ▀██▀  ▀██▀ "
   balls%l(5)%s = "            "
   balls%l(6)%s = "            "
   ! Ghost
   ghost%l(1)%s = "   ▄██████▄   "
   ghost%l(2)%s = " ▄█▀████▀███▄ "
   ghost%l(3)%s = " █▄▄███▄▄████ "
   ghost%l(4)%s = " ████████████ "
   ghost%l(5)%s = " ██▀██▀▀██▀██ "
   ghost%l(6)%s = " ▀   ▀  ▀   ▀ "
   ! Print
   do i = 1, 6
      call println(i, cols%yellow, pac, .false.)
      call println(i, cols%white, balls, .false.)
      call println(i, cols%red, ghost, .true.)
      call println(i, cols%blue, ghost, .true.)
      call println(i, cols%pink, ghost, .true.)
      print *, cols%nc
   end do
end program
