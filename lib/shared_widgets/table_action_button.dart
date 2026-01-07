// import 'package:flutter/material.dart';
//
// class TableActionButton extends StatefulWidget {
//   final String label;
//   final Color color;
//   final VoidCallback onPressed;
//   final IconData? icon;
//   final bool isLoading;
//
//   const TableActionButton({
//     super.key,
//     required this.label,
//     required this.color,
//     required this.onPressed,
//     this.icon,
//     this.isLoading = false,
//   });
//
//   @override
//   State<TableActionButton> createState() => _TableActionButtonState();
// }
//
// class _TableActionButtonState extends State<TableActionButton>
//     with TickerProviderStateMixin {
//   bool _isHovered = false;
//   late AnimationController _animationController;
//   late AnimationController _pulseController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _rotationAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 150),
//       vsync: this,
//     );
//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );
//
//     _rotationAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) {
//         if (widget.isLoading) return;
//         setState(() => _isHovered = true);
//         _pulseController.repeat(reverse: true);
//       },
//       onExit: (_) {
//         if (widget.isLoading) return;
//         setState(() => _isHovered = false);
//         _pulseController.stop();
//         _pulseController.reset();
//       },
//       child: GestureDetector(
//         onTapDown: (_) => _animationController.forward(),
//         onTapUp: (_) => _animationController.reverse(),
//         onTapCancel: () => _animationController.reverse(),
//         child: AnimatedBuilder(
//           animation: Listenable.merge([_scaleAnimation, _pulseAnimation, _rotationAnimation]),
//           builder: (context, child) {
//             return Transform.scale(
//               scale: _scaleAnimation.value * (_isHovered ? _pulseAnimation.value : 1.0),
//               child: Transform.rotate(
//                 angle: _rotationAnimation.value,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   height: 36,
//                   constraints: const BoxConstraints(minWidth: 80),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: _isHovered && !widget.isLoading
//                           ? [
//                         widget.color,
//                         widget.color.withValues(alpha: 0.7),
//                         widget.color.withValues(alpha: 0.9),
//                       ]
//                           : [
//                         widget.color,
//                         widget.color.withValues(alpha: 0.8),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       stops: _isHovered && !widget.isLoading ? [0.0, 0.5, 1.0] : [0.0, 1.0],
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: widget.color.withValues(alpha: 0.3),
//                       width: 1,
//                     ),
//                     boxShadow: _isHovered && !widget.isLoading
//                         ? [
//                       BoxShadow(
//                         color: widget.color.withValues(alpha: 0.4),
//                         blurRadius: 16,
//                         offset: const Offset(0, 8),
//                         spreadRadius: -2,
//                       ),
//                       BoxShadow(
//                         color: widget.color.withValues(alpha: 0.2),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                         spreadRadius: -1,
//                       )
//                     ]
//                         : [
//                       BoxShadow(
//                         color: widget.color.withValues(alpha: 0.25),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                         spreadRadius: -1,
//                       )
//                     ],
//                   ),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(12),
//                       onTap: widget.isLoading ? null : widget.onPressed,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         child: Center(
//                           child: widget.isLoading
//                               ? const SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2.0,
//                               color: Colors.white,
//                             ),
//                           )
//                               : Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               if (widget.icon != null) ...[
//                                 Container(
//                                   padding: const EdgeInsets.all(2),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withValues(alpha: 0.2),
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   child: Icon(
//                                     widget.icon,
//                                     size: 14,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 6),
//                               ],
//                               Text(
//                                 widget.label,
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white,
//                                   letterSpacing: 0.8,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }