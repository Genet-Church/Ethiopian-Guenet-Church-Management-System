// import 'package:flutter/material.dart';
// import 'package:genet_church_portal/core/theme/app_colors.dart';
//
// class ContentCard extends StatelessWidget {
//   final Widget child;
//   final EdgeInsets? padding;
//
//   const ContentCard({super.key, required this.child, this.padding});
//
//   @override
//   Widget build(BuildContext context) {
//     final appColors = Theme.of(context).extension<AppColors>()!;
//     return Container(
//       padding: padding ?? const EdgeInsets.all(24.0),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             appColors.surface,
//             appColors.surface.withValues(alpha: 0.95),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: appColors.border.withValues(alpha: 0.3),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: appColors.shadow.withValues(alpha: 0.08),
//             blurRadius: 40,
//             offset: const Offset(0, 12),
//             spreadRadius: -4,
//           ),
//           BoxShadow(
//             color: appColors.shadow.withValues(alpha: 0.04),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//             spreadRadius: -2,
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }