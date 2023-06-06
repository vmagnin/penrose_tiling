// This file is part of the penrose_tiling Fortran project.
// Copyright (C) 2023 Vincent MAGNIN
//
// This is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3, or (at your option)
// any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with
// this program; see the files LICENSE and LICENSE_EXCEPTION respectively.
// If not, see <http://www.gnu.org/licenses/>.
//------------------------------------------------------------------------------
// Contributed by Vincent Magnin
// Java version: 2002-12-14
// Last modifications: 2023-06-05
//------------------------------------------------------------------------------

/* Pavage de Penrose avec triangles d'or (pavage de type 0)
   Vincent MAGNIN
   date de création (GFA BASIC) : 12 septembre 1991
   en java : 14 décembre 2002
   Dernières modifications :
     - 12-03-2018 : javac 1.8.0_151
     - 05-06-2023 : amélioration de la présentation
   https://fr.wikipedia.org/wiki/Pavage_de_Penrose
   $ javac penrose.java && java -cp . penrose
*/

import java.awt.* ;
import javax.swing.* ;

public class penrose
{

  public static void main (String args[])
    {
      maFenetre fenetre= new maFenetre() ;
      fenetre.setVisible(true) ;
    }
}


class maFenetre extends JFrame {
   private Panneau pano ;
   public maFenetre()
         {
      setTitle("Un pavage de Penrose (a Penrose tiling)") ;
          setSize(1600, 1024) ;
          pano = new Panneau() ;
          getContentPane().add(pano) ;
          setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE) ;
          }
}

class Panneau extends JPanel
{
  double or ;
  long niveau ;
  Color jaune  = new Color (255, 255, 0) ;
  Color noir   = new Color (0, 0, 0) ;
  Color bleu   = new Color (0, 100, 255) ;

  public void paintComponent (Graphics g)
  {
    super.paintComponent(g) ;

    or = (1.0 + Math.sqrt(5)) / 2.0 ;  //Nombre d'or
    niveau = 9 ; // on peut aller jusque 10 environ
    double d = 960 ;
    double h = d*Math.sqrt(or*or - 1.0/4.0) ;

    acute_triangle(0, 0 , 0, d, h, d/2.0, 1, g) ;
  }

  void acute_triangle(double x1, double y1, double x2, double y2, double x3, double y3, long n, Graphics g)
  {
    double x4, y4, x5, y5 ;
    double d1, d2, d3 ;
    double inter ;

    if (n < niveau) {
      d1 = distance(x1, y1, x2, y2) ;
      d2 = distance(x1, y1, x3, y3) ;
      d3 = distance(x2, y2, x3, y3) ;

      n++ ;

      if (MIN(d1, d2, d3) == d1) {
        inter = x1 ;
        x1 = x3 ;
        x3 = inter ;
        inter = y1 ;
        y1 = y3 ;
        y3 = inter ;
      }
      else if (MIN(d1, d2, d3) == d2) {
        inter = x1 ;
        x1 = x2 ;
        x2 = inter ;
        inter = y1 ;
        y1 = y2 ;
        y2 = inter ;
      }

      x4 = (or*x3 + x1) / (or + 1) ;
      y4 = (or*y3 + y1) / (or + 1) ;
      x5 = (or*x1 + x2) / (or + 1) ;
      y5 = (or*y1 + y2) / (or + 1) ;

      acute_triangle(x4, y4, x5, y5, x2, y2, n, g) ;
      acute_triangle(x2, y2, x3, y3, x4, y4, n, g) ;
      obtuse_triangle(x1, y1, x4, y4, x5, y5, n, g) ;
    }
    else
    {
      int px [] = {0, 0, 0} ;
      px[0] = (int)x1 ;       px[1] = (int)x2 ;       px[2] = (int)x3 ;
      int py [] = {0, 0, 0} ;
      py[0] = (int)y1 ;       py[1] = (int)y2 ;       py[2] = (int)y3 ;
      Polygon p  =  new Polygon (px, py, 3) ;

      g.setColor(bleu) ;
      g.fillPolygon(p) ;

      g.setColor(noir) ;
      g.drawPolygon(p) ;
    }
  }

  void obtuse_triangle(double x1, double y1, double x2, double y2, double x3, double y3, long n, Graphics g)  {
    double x4, y4 ;
    double d1, d2, d3 ;
    double inter ;

    if (n < niveau) {
      d1 = distance(x1, y1, x2, y2) ;
      d2 = distance(x1, y1, x3, y3) ;
      d3 = distance(x2, y2, x3, y3) ;

      n++ ;

      if (MAX(d1, d2, d3) == d1) {
        inter = x1 ;
        x1 = x3 ;
        x3 = inter ;
        inter = y1 ;
        y1 = y3 ;
        y3 = inter ;
      }
      else if (MAX(d1, d2, d3) == d2) {
        inter = x1 ;
        x1 = x2 ;
        x2 = inter ;
        inter = y1 ;
        y1 = y2 ;
        y2 = inter ;
      }

      x4 = (or*x2 + x3) / (or + 1) ;
      y4 = (or*y2 + y3) / (or + 1) ;

      acute_triangle(x1, y1, x3, y3, x4, y4, n, g) ;
      obtuse_triangle(x1, y1, x2, y2, x4, y4, n, g) ;
    }
    else
    {
      int px [] = {0, 0, 0} ;
      px[0] = (int)x1 ;       px[1] = (int)x2 ;       px[2] = (int)x3 ;
      int py [] = {0, 0, 0} ;
      py[0] = (int)y1 ;       py[1] = (int)y2 ;       py[2] = (int)y3 ;
      Polygon p  =  new Polygon (px, py, 3) ;

      g.setColor(jaune) ;
      g.fillPolygon(p) ;

      g.setColor(noir) ;
      g.drawPolygon(p) ;
    }
  }

  double distance(double x1, double y1, double x2, double y2)   {
    return Math.sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1)) ;
  }

  double MIN(double x1, double x2, double x3)   {
    if ((x1 <= x2) & (x1 <= x3)) {
      return x1 ;
    }
    else if ((x2 <= x1) & (x2 <= x3)) {
      return x2 ;
    }
    else {
      return x3 ;
    }
  }

  double MAX(double x1, double x2, double x3)   {
    if ((x1 >= x2) & (x1 >= x3)) {
      return x1 ;
    }
    else if ((x2 >= x1) & (x2 >= x3)) {
      return x2 ;
    }
    else {
      return x3 ;
    }
  }

}
