import 'package:flutter/cupertino.dart';
import 'package:quicktodo/styles/color/colors_state.dart';

class TextStyles {
  final ColorsState colors;
  TextStyles({required this.colors});

  /*---------------------------OpenSans-Regular--------------------*/

  TextStyle get openSansRegular {
    return TextStyle(
        fontFamily: 'OpenSansRegular',
        // fontSize: 16,
        // fontWeight: FontWeight.w400,
        color: colors.primary);
  }

  /*---------------------------OpenSans-Medium--------------------*/

  TextStyle get openSansMedium {
    return TextStyle(
      fontFamily: 'OpenSans-Medium',
      color: colors.primary,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  /*---------------------------OpenSans-SemiBold--------------------*/

  TextStyle get openSansSemiBold {
    return TextStyle(
      fontFamily: 'OpenSans-SemiBold', color: colors.primary,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      // fontWeight: FontWeight.w400,
    );
  }
  /*---------------------------Orbitron-Regular--------------------*/

  TextStyle get orbitronRegular {
    return TextStyle(
      fontFamily: 'OrbitronRegular',
      color: colors.primary,
      // fontSize: 18,
      // fontWeight: FontWeight.bold,
      // fontWeight: FontWeight.w400,
    );
  }
  /*---------------------------Orbitron-Medium--------------------*/

  TextStyle get orbitronMedium {
    return TextStyle(
      fontFamily: 'OrbitronMedium',
      color: colors.primary,
      // fontSize: 18,
      // fontWeight: FontWeight.bold,
      // fontWeight: FontWeight.w400,
    );
  }
  /*---------------------------OpenSans-SemiBold--------------------*/

  TextStyle get orbitronSemiBold {
    return TextStyle(
      fontFamily: 'OrbitronSemiBold',
      color: colors.primary,
      // fontSize: 18,
      // fontWeight: FontWeight.bold,
      // fontWeight: FontWeight.w400,
    );
  }
}
