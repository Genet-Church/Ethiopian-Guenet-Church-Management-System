// import 'package:flutter/material.dart';
// import 'package:genet_church_portal/core/theme/app_colors.dart';
// import 'package:iconsax/iconsax.dart';
//
// class InfoCard extends StatelessWidget {
//   final Widget child;
//   final String title;
//   final String description;
//   final EdgeInsets? padding;
//
//   const InfoCard({
//     super.key,
//     required this.child,
//     required this.title,
//     this.description =
//     "Manage and view the details for this section. Please ensure all information is accurate and up-to-date.",
//     this.padding,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final appColors = theme.extension<AppColors>()!;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: appColors.surface,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: appColors.shadow,
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           )
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.primary.withValues(alpha: 0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(Iconsax.document_upload,
//                       color: theme.colorScheme.primary, size: 28),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(title,
//                           style: Theme.of(context).textTheme.headlineMedium),
//                       if (description.isNotEmpty) ...[
//                         const SizedBox(height: 4),
//                         Text(description,
//                             style: Theme.of(context).textTheme.bodyMedium),
//                       ]
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1),
//           Flexible(
//             child: Padding(
//               padding: padding ?? const EdgeInsets.all(24.0),
//               child: child,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }