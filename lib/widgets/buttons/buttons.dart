import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class CustomizedButton extends StatelessWidget {
  final bool isLoading;
  final String title;
  final void Function()? onPressed;
  final double height;
  final double width;
  final TextStyle textStyle;
  final Widget? icon;
  final Color? color;
  CustomizedButton(
      {Key? key,
      required this.isLoading,
      required this.title,
      required this.onPressed,
      required this.height,
      required this.width,
      required this.textStyle,
      this.icon,
      this.color})
      : super(key: key);

  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5), boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 1),
      ]),
      child: GFButton(
        color: const Color(0xFF4AC85D),
        borderShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const GFLoader(
                loaderColorTwo: Colors.white,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox(),
                  Text(title, style: textStyle)
                ],
              ),
      ),
    );
  }
}
