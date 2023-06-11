import 'package:flutter/material.dart';
import 'package:picknpark/config/colors.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final void Function() onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  const CustomButton({Key? key, this.height, this.width,
    required this.onPressed, required this.text,
    this.color, this.textColor, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 52,
      width: width ?? MediaQuery.of(context).size.width * 0.9,
      child: MaterialButton(
        padding: const EdgeInsets.all(10),
        color: color ?? CustomColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20000)
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(icon != null)
              Icon(
                icon,
                size: 24,
                color: textColor ?? Colors.white,
              ),

            if(icon != null)
              const SizedBox(width: 15),

            Text(
              text,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 20,
                color: textColor ?? Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
