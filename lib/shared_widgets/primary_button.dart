// import 'package:flutter/material.dart';
// import 'package:genet_church_portal/core/theme/app_colors.dart';
// import 'package:iconsax/iconsax.dart';
//
// enum _ButtonState { idle, loading, success }
//
// typedef FutureVoidCallback = Future<void> Function();
//
// class PrimaryButton extends StatefulWidget {
//   final String text;
//   final FutureVoidCallback onPressed;
//   final IconData? icon;
//   final double? width;
//   final String successText;
//
//   const PrimaryButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.icon,
//     this.width,
//     this.successText = 'Success',
//   });
//
//   @override
//   State<PrimaryButton> createState() => _PrimaryButtonState();
// }
//
// class _PrimaryButtonState extends State<PrimaryButton>
//     with TickerProviderStateMixin {
//   _ButtonState _state = _ButtonState.idle;
//   late AnimationController _hoverController;
//   late AnimationController _pressController;
//   late AnimationController _shimmerController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _elevationAnimation;
//   late Animation<double> _shimmerAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _hoverController = AnimationController(
//         duration: const Duration(milliseconds: 200), vsync: this);
//     _pressController = AnimationController(
//         duration: const Duration(milliseconds: 100), vsync: this);
//     _shimmerController = AnimationController(
//         duration: const Duration(milliseconds: 1500), vsync: this)
//       ..repeat();
//
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03)
//         .animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut));
//     _elevationAnimation = Tween<double>(begin: 8.0, end: 16.0)
//         .animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut));
//     _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0)
//         .animate(CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut));
//   }
//
//   @override
//   void dispose() {
//     _hoverController.dispose();
//     _pressController.dispose();
//     _shimmerController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _handlePress() async {
//     if (_state != _ButtonState.idle) return;
//
//     setState(() => _state = _ButtonState.loading);
//     try {
//       await widget.onPressed();
//       setState(() => _state = _ButtonState.success);
//       await Future.delayed(const Duration(seconds: 2));
//       if (mounted) {
//         setState(() => _state = _ButtonState.idle);
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _state = _ButtonState.idle);
//       }
//       rethrow;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final appColors = theme.extension<AppColors>()!;
//     bool isLoading = _state == _ButtonState.loading;
//
//     return MouseRegion(
//       onEnter: (_) => _hoverController.forward(),
//       onExit: (_) => _hoverController.reverse(),
//       child: GestureDetector(
//         onTapDown: (_) => _pressController.forward(),
//         onTapUp: (_) => _pressController.reverse(),
//         onTapCancel: () => _pressController.reverse(),
//         child: AnimatedBuilder(
//           animation:
//           Listenable.merge([_scaleAnimation, _elevationAnimation, _shimmerAnimation]),
//           builder: (context, child) {
//             return Transform.scale(
//               scale: _scaleAnimation.value * (1.0 - _pressController.value * 0.05),
//               child: Container(
//                 width: widget.width,
//                 height: 52,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   gradient: appColors.primaryGradient,
//                   boxShadow: [
//                     BoxShadow(
//                       color: theme.colorScheme.primary.withValues(alpha: 0.4),
//                       blurRadius: _elevationAnimation.value,
//                       offset: Offset(0, _elevationAnimation.value / 2),
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   children: [
//                     Positioned.fill(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: AnimatedBuilder(
//                           animation: _shimmerAnimation,
//                           builder: (context, child) {
//                             return Transform.translate(
//                               offset: Offset(_shimmerAnimation.value * 200, 0),
//                               child: Container(
//                                 width: 100,
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.transparent,
//                                       Colors.white.withValues(alpha: 0.2),
//                                       Colors.transparent,
//                                     ],
//                                     stops: const [0.0, 0.5, 1.0],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         borderRadius: BorderRadius.circular(16),
//                         onTap: isLoading ? null : _handlePress,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Center(
//                             child: AnimatedSwitcher(
//                               duration: const Duration(milliseconds: 300),
//                               transitionBuilder: (child, animation) {
//                                 return FadeTransition(
//                                   opacity: animation,
//                                   child: ScaleTransition(
//                                     scale: animation,
//                                     child: child,
//                                   ),
//                                 );
//                               },
//                               child: _buildButtonChild(),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButtonChild() {
//     switch (_state) {
//       case _ButtonState.loading:
//         return const SizedBox(
//           key: ValueKey('loading'),
//           height: 24,
//           width: 24,
//           child: CircularProgressIndicator(
//             strokeWidth: 2.5,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//         );
//       case _ButtonState.success:
//         return Row(
//           key: const ValueKey('success'),
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Iconsax.tick_circle, color: Colors.white, size: 20),
//             const SizedBox(width: 12),
//             Text(
//               widget.successText,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ],
//         );
//       case _ButtonState.idle:
//       default:
//         return Row(
//           key: const ValueKey('idle'),
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (widget.icon != null) ...[
//               Icon(widget.icon, color: Colors.white, size: 20),
//               const SizedBox(width: 12),
//             ],
//             Text(
//               widget.text,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ],
//         );
//     }
//   }
// }