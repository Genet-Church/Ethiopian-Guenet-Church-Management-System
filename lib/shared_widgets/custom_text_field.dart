// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatelessWidget {
//   final String hintText;
//   final bool obscureText;
//   final TextEditingController? controller;
//   final int maxLines;
//
//   const CustomTextField({
//     super.key,
//     required this.hintText,
//     this.obscureText = false,
//     this.controller,
//     this.maxLines = 1,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         hintText: hintText,
//       ),
//     );
//   }
// }