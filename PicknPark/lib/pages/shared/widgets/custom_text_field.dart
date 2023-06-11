import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picknpark/config/config.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final double? height;
  final void Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final bool showPrefixIcon;
  final bool enabled;
  final int? maxLength;
  const CustomTextField({
    Key? key,
    this.controller,
    this.height,
    this.onChanged,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.errorText,
    this.inputFormatters,
    this.obscureText,
    this.showPrefixIcon = true,
    this.maxLength, this.enabled = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? errorText = this.errorText;

    if(errorText != null && errorText.isEmpty){
      errorText = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        if(labelText != null)
          Container(
            padding: const EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            child: Text(
              labelText!,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 18,
                color: CustomColors.primaryColor
              )
            ),
          ),

        if(labelText != null)
          SizedBox(height: height == null ? 5 : height! * 0.1),

        SizedBox(
          height: height ?? 50,
          child: TextField(
            enabled: enabled,
            controller: controller,
            textAlign: TextAlign.right,
            onChanged: onChanged,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText ?? '',
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: Colors.grey)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                      color: errorText != null
                          ? Colors.redAccent : CustomColors.primaryTextColor
                  )
              ),
              focusedBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(18),
                 borderSide: BorderSide(
                     color: errorText != null
                         ? Colors.redAccent : CustomColors.primaryColor
                 )
              ),
              errorBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(18),
                 borderSide: const BorderSide(color: Colors.redAccent)
              ),
              focusedErrorBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(18),
                 borderSide: const BorderSide(color: Colors.redAccent)
              ),
              suffixIcon: suffixIcon,
              prefixIcon: showPrefixIcon ?
                prefixIcon ?? Icon(
                    Icons.info_rounded,
                    color: errorText != null ? Colors.redAccent : CustomColors.primaryColor
                ) : null,
              counterText: ""
            ),
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            obscureText: obscureText ?? false,
          ),
        ),

        if(errorText != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: height == null ? 6 : height! * 0.15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                    errorText,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: errorText.length > 56 ? 12 : 14,
                      color: Colors.redAccent,
                    ),
                ),
              ],
            ),
          )

      ],
    );
  }
}
