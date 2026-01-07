// import 'package:flutter/material.dart';
//
// class CustomDropdown extends StatelessWidget {
//   final String hintText;
//   final List<String> items;
//   final String? value;
//   final void Function(String?)? onChanged;
//
//   const CustomDropdown({
//     super.key,
//     required this.hintText,
//     required this.items,
//     this.value,
//     this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       items: items.map((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         hintText: hintText,
//       ),
//     );
//   }
// }