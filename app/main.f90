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

program main
    ! Use the cairo-fortran bindings:
    use cairo
    use cairo_enums
    ! Cairo uses C doubles:
    use, intrinsic :: iso_c_binding, only: dp=>c_double, c_ptr
    use triangles, only: phi, acute_triangle, nb_acute, nb_obtuse

    implicit none
    ! Cairo surface and Cairo context:
    type(c_ptr) :: surface, cr
    character(*), parameter :: FILENAME = "penrose_tiling.svg"
    ! Size of the surface in mm (landscape A4 paper):
    real(dp), parameter :: IMAGE_WIDTH  = 297._dp
    real(dp), parameter :: IMAGE_HEIGHT = 210._dp
    real(dp), parameter :: d = 150._dp
    real(dp), parameter :: h = d * sqrt(phi**2 - 1._dp/4._dp)
    ! Vertices of the main triangle:
    complex(dp) :: P1, P2, P3
    ! Be careful, 12 recursions will generate a 12.7 Mio SVG file, and it grows
    ! like the Fibonacci sequence...
    integer, parameter  :: MAX_RECURSION = 10

    ! The object will be rendered in a SVG file:
    surface = cairo_svg_surface_create(FILENAME//c_null_char, &
                                      & IMAGE_WIDTH, IMAGE_HEIGHT)
    call cairo_svg_surface_set_document_unit(surface, CAIRO_SVG_UNIT_MM)
    cr = cairo_create(surface)

    ! Initialize parameters:
    call cairo_set_antialias(cr, CAIRO_ANTIALIAS_BEST)
    call cairo_set_line_width(cr, 0.02_dp)

    ! We work in the complex plane:
    P1 = 0
    P2 = cmplx(0, d,   dp)
    P3 = cmplx(h, d/2, dp)

    ! Starting the recursive algorithm:
    call acute_triangle(P1, P2, P3, 1, MAX_RECURSION, cr)

    ! Finalyze:
    call cairo_destroy(cr)
    call cairo_surface_destroy(surface)

    print *, "----------------------------------"
    print *, MAX_RECURSION, "recursions"
    print *, "These are Fibonacci numbers:"
    print *, nb_acute, "blue acute triangles"
    print *, nb_obtuse, "yellow obtuse triangles"
    print *, "----------------------------------"
    print *, "Output file: ", FILENAME
    print *, "----------------------------------"
end program main
