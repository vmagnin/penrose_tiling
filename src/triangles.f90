! This file is part of the penrose_tiling Fortran project.
! Copyright (C) 2023 Vincent MAGNIN
!
! This is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 3, or (at your option)
! any later version.
!
! This software is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License along with
! this program; see the files LICENSE and LICENSE_EXCEPTION respectively.
! If not, see <http://www.gnu.org/licenses/>.
!------------------------------------------------------------------------------
! Contributed by Vincent Magnin
! GFA BASIC version: 1991-09-12
! Java version: 2002-12-14
! Fortran version: 2023-06-01
! Last modifications: 2023-06-05
!------------------------------------------------------------------------------

module triangles
    ! Cairo uses C doubles:
    use, intrinsic :: iso_c_binding, only: dp=>c_double, c_ptr
    ! Use the cairo-fortran bindings:
    use cairo

    implicit none
    private
    public :: phi, acute_triangle, nb_acute, nb_obtuse

    ! Golden ratio:
    real(dp), parameter :: phi = (1 + sqrt(5._dp)) / 2
    ! Triangles counters:
    integer :: nb_acute  = 0
    integer :: nb_obtuse = 0

contains

    subroutine draw_triangle(P1, P2, P3, r, g, b, cr)
        complex(dp), intent(in) :: P1, P2, P3
        real(dp), intent(in)    :: r, g, b
        ! Cairo context:
        type(c_ptr), intent(in) :: cr

        call cairo_set_source_rgb(cr, r, g, b)

        ! Path of the triangle:
        call cairo_move_to(cr, P1%re, P1%im)
        call cairo_line_to(cr, P2%re, P2%im)
        call cairo_line_to(cr, P3%re, P3%im)
        call cairo_close_path(cr)

        ! Fill the triangle:
        call cairo_fill_preserve(cr)
        ! and draw its edges in black:
        call cairo_set_source_rgb(cr, 0._dp, 0._dp, 0._dp)
        call cairo_stroke(cr)
    end subroutine draw_triangle


    recursive subroutine acute_triangle(P1, P2, P3, n, nmax, cr)
        complex(dp), intent(in) :: P1, P2, P3
        integer, intent(in)     :: n, nmax
        type(c_ptr), intent(in) :: cr
        complex(dp) :: PP1, PP2, PP3, PP4, PP5
        real(dp) :: d1, d2, d3

        if (n < nmax) then  ! *** Recursion case ***
            ! Lengths of the sides of the triangle:
            d1 = abs(P1 - P2)
            d2 = abs(P1 - P3)
            d3 = abs(P2 - P3)

            if ((d1 <= d2) .and. (d1 <= d3)) then
                PP1 = P3
                PP2 = P2
                PP3 = P1
            else if ((d2 <= d1) .and. (d2 <= d3)) then
                PP1 = P2
                PP2 = P1
                PP3 = P3
            else
                PP1 = P1
                PP2 = P2
                PP3 = P3
            end if

            PP4 = (phi*PP3 + PP1) / (1 + phi)
            PP5 = (phi*PP1 + PP2) / (1 + phi)

            call acute_triangle (PP4, PP5, PP2, n+1, nmax,  cr)
            call acute_triangle (PP2, PP3, PP4, n+1, nmax,  cr)
            call obtuse_triangle(PP1, PP4, PP5, n+1, nmax,  cr)
        else                ! *** Terminating case ***
            nb_acute = nb_acute + 1
            ! Draw the triangle with a blue:
            call draw_triangle(P1, P2, P3, 0._dp, 0.392_dp, 1._dp, cr)
        end if
    end subroutine acute_triangle


    recursive subroutine obtuse_triangle(P1, P2, P3, n, nmax, cr)
        complex(dp), intent(in) :: P1, P2, P3
        integer, intent(in)     :: n, nmax
        type(c_ptr), intent(in) :: cr
        complex(dp) :: PP1, PP2, PP3, PP4
        real(dp) :: d1, d2, d3

        if (n < nmax) then  ! *** Recursion case ***
            ! Sides lengths of the triangle:
            d1 = abs(P1 - P2)
            d2 = abs(P1 - P3)
            d3 = abs(P2 - P3)

            if (((d1 >= d2) .and. (d1 >= d3))) then
                PP1 = P3
                PP2 = P2
                PP3 = P1
            else if ((d2 >= d1) .and. (d2 >= d3)) then
                PP1 = P2
                PP2 = P1
                PP3 = P3
            else
                PP1 = P1
                PP2 = P2
                PP3 = P3
            end if

            PP4 = (phi*PP2 + PP3) / (1 + phi)

            call acute_triangle (PP1, PP3, PP4, n+1, nmax,  cr)
            call obtuse_triangle(PP1, PP2, PP4, n+1, nmax,  cr)
        else                ! *** Terminating case ***
            nb_obtuse = nb_obtuse + 1
            ! Draw the triangle in yellow:
            call draw_triangle(P1, P2, P3, 1._dp, 1._dp, 0._dp, cr)
        end if
    end subroutine obtuse_triangle

end module triangles
