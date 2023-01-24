import 'package:flutter/cupertino.dart';

class CustomLogo extends SizedBox {
  CustomLogo({super.key})
      : super(
          height: 100,
          width: 100,
          child: Image.asset(
            'images/light_icon.png',color: const Color(0xFFFFFFFF),
          ),
        );
}
