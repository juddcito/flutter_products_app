import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 389;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        // loginPDR (1:2)
        padding: EdgeInsets.fromLTRB(30*fem, 71*fem, 30*fem, 224*fem),
        width: double.infinity,
        decoration: BoxDecoration (
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(30*fem),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // bienvenidonPy (8:2)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 145*fem, 65*fem),
              child: Text(
                'Bienvenido',
                style: GoogleFonts.lato(
                  fontSize: 36*ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.2*ffem/fem,
                  color: Color(0xff000000),
                ),
              ),
            ),
            Container(
              // autogroup6nwydQb (KHo5d3EzU2KzSKdpvL6nwy)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 2*fem, 14*fem),
              padding: EdgeInsets.fromLTRB(15*fem, 15*fem, 15*fem, 15*fem),
              width: 327*fem,
              decoration: BoxDecoration (
                color: Color(0xfff7f7f7),
                borderRadius: BorderRadius.circular(13*fem),
              ),
              child: Text(
                'empleado@sacti.mx',
                style: GoogleFonts.lato(
                  fontSize: 15*ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.2*ffem/fem,
                  color: Color(0xff000000),
                ),
              ),
            ),
            Container(
              // autogroupygmmFRy (KHo5q2u1L6vHsmkorgYGMM)
              margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 1*fem, 14*fem),
              padding: EdgeInsets.fromLTRB(15*fem, 15*fem, 15*fem, 15*fem),
              width: double.infinity,
              decoration: BoxDecoration (
                color: Color(0xfff7f7f7),
                borderRadius: BorderRadius.circular(13*fem),
              ),
              child: Text(
                'Contraseña',
                style: GoogleFonts.lato (
                  fontSize: 15*ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.2*ffem/fem,
                  color: Color(0xff8e8d8d),
                ),
              ),
            ),
            Container(
              // olvidmicontrasea7DH (8:14)
              margin: EdgeInsets.fromLTRB(187*fem, 0*fem, 0*fem, 233*fem),
              child: Text(
                'Olvidé mi contraseña',
                style: GoogleFonts.lato(
                  fontSize: 15*ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.2*ffem/fem,
                  color: Color(0xff0419d5),
                ),
              ),
            ),
            Container(
              // autogrouphpryPgb (KHo5xN28JV4N66wX6ZhPRy)
              margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 1*fem, 0*fem),
              width: double.infinity,
              height: 65*fem,
              decoration: BoxDecoration (
                color: Color(0xff0019ff),
                borderRadius: BorderRadius.circular(13*fem),
              ),
              child: Center(
                child: Text(
                  'Sign In',
                  style: GoogleFonts.lato (
                    fontSize: 15*ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.2*ffem/fem,
                    color: Color(0xfff7f7f7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
          );
  }
}