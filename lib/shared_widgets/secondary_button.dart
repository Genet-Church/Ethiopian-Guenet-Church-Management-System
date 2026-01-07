// import 'package:flutter/material.dart';
// import 'package:genet_church_portal/core/theme/app_colors.dart';
//
// class SecondaryButton extends StatefulWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final IconData? icon;
//   final bool isLoading;
//
//   const SecondaryButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.icon,
//     this.isLoading = false,
//   });
//
//   @override
//   State<SecondaryButton> createState() => _SecondaryButtonState();
// }
//
// class _SecondaryButtonState extends State<SecondaryButton>
//     with SingleTickerProviderStateMixin {
//   bool _isHovered = false;
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _glowAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final appColors = theme.extension<AppColors>()!;
//     final destructiveRed = theme.colorScheme.error;
//
//     return MouseRegion(
//       onEnter: (_) {
//         setState(() => _isHovered = true);
//         _animationController.forward();
//       },
//       onExit: (_) {
//         setState(() => _isHovered = false);
//         _animationController.reverse();
//       },
//       child: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _scaleAnimation.value,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: destructiveRed.withOpacity(
//                       0.3 + (_glowAnimation.value * 0.4),
//                     ),
//                     blurRadius: 8 + (_glowAnimation.value * 12),
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton(
//                 onPressed: widget.isLoading ? null : widget.onPressed,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: destructiveRed,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 16,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: widget.isLoading
//                     ? const SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor:
//                     AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//                     : Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (widget.icon != null) ...[
//                       Icon(widget.icon, size: 18),
//                       const SizedBox(width: 8),
//                     ],
//                     Text(
//                       widget.text,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }