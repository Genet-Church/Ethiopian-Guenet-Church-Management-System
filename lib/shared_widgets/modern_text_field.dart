// import 'package:flutter/material.dart';
// import 'package:genet_church_portal/core/theme/app_colors.dart';
//
// class ModernTextField extends StatefulWidget {
//   final TextEditingController? controller;
//   final String hintText;
//   final IconData icon;
//   final bool obscureText;
//   final String? Function(String?)? validator;
//   final void Function(String)? onChanged;
//
//   const ModernTextField({
//     super.key,
//     this.controller,
//     required this.hintText,
//     required this.icon,
//     this.obscureText = false,
//     this.validator,
//     this.onChanged,
//   });
//
//   @override
//   State<ModernTextField> createState() => _ModernTextFieldState();
// }
//
// class _ModernTextFieldState extends State<ModernTextField>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   bool _isFocused = false;
//   late FocusNode _focusNode;
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _focusNode.addListener(() {
//       setState(() {
//         _isFocused = _focusNode.hasFocus;
//         if (_isFocused) {
//           _animationController.forward();
//         } else {
//           _animationController.reverse();
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _focusNode.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final appColors = theme.extension<AppColors>()!;
//
//     return AnimatedBuilder(
//       animation: _scaleAnimation,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _scaleAnimation.value,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: _isFocused
//                   ? [
//                 BoxShadow(
//                   color: theme.colorScheme.primary.withValues(alpha: 0.15),
//                   blurRadius: 20,
//                   offset: const Offset(0, 8),
//                   spreadRadius: -2,
//                 )
//               ]
//                   : [],
//             ),
//             child: TextFormField(
//               controller: widget.controller,
//               focusNode: _focusNode,
//               obscureText: widget.obscureText,
//               validator: widget.validator,
//               onChanged: widget.onChanged,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: appColors.textPrimary,
//                 fontSize: 15,
//                 letterSpacing: 0.2,
//               ),
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: _isFocused
//                     ? appColors.scaffold.withValues(alpha: 0.8)
//                     : appColors.scaffold,
//                 hintText: widget.hintText,
//                 hintStyle: TextStyle(
//                   color: appColors.textSecondary.withValues(alpha: 0.7),
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 0.2,
//                 ),
//                 prefixIcon: Container(
//                   margin: const EdgeInsets.all(12),
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         theme.colorScheme.primary.withValues(alpha: 0.1),
//                         theme.colorScheme.primary.withValues(alpha: 0.05),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     widget.icon,
//                     color: _isFocused
//                         ? theme.colorScheme.primary
//                         : appColors.textSecondary,
//                     size: 20,
//                   ),
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide.none,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide(
//                     color: appColors.border.withValues(alpha: 0.3),
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide(
//                     color: theme.colorScheme.primary,
//                     width: 2,
//                   ),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 20,
//                   horizontal: 20,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// //modified