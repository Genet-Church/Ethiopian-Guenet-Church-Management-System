import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:genet_church_portal/core/constants.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:genet_church_portal/data/models/church_model.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:genet_church_portal/shared_widgets/modern_date_picker.dart';
import 'package:genet_church_portal/shared_widgets/modern_input.dart';
import 'package:genet_church_portal/shared_widgets/page_header.dart';
import 'package:genet_church_portal/shared_widgets/modern_button.dart';
import 'package:genet_church_portal/shared_widgets/notification_system.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/localization/app_localization.dart';

class AddChurchScreen extends HookConsumerWidget {
  const AddChurchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final locationLinkController = useTextEditingController();
    final establishmentDate = useState<DateTime?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final currentLocale = ref.watch(languageNotifierProvider);
    final l10n = AppLocalization(currentLocale);

    void clearForm() {
      nameController.clear();
      locationLinkController.clear();
      establishmentDate.value = null;
    }

    Future<void> addChurch() async {
      if (!(formKey.currentState?.validate() ?? false)) {
        context.showWarningNotification(
          title: l10n.invalidForm,
          message: l10n.correctErrors,
        );
        return;
      }

      final newChurch = Church(
        id: '',
        name: nameController.text,
        locationLink: locationLinkController.text.isNotEmpty
            ? locationLinkController.text
            : null,
        establishmentDate: establishmentDate.value?.toUtc().toIso8601String(),
        headOfficeId: AppConstants.addisAbabaHeadOfficeId,
      );

      try {
        await ref.read(churchesProvider.notifier).addChurch(newChurch);
        if (context.mounted) {
          clearForm();
          context.showSuccessNotification(
            title: l10n.success,
            message: l10n.churchAdded,
          );
          context.go('/report-churchs');
        }
      } catch (e) {
        if (context.mounted) {
          context.showErrorNotification(
            title: l10n.error,
            message: l10n.failedAddChurch,
          );
        }
        rethrow;
      }
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          PageHeader(
            title: l10n.newChurchDetails,
            description: l10n.newChurchDesc,
            action: PrimaryButton(
              text: l10n.saveChurch,
              onPressedAsync: addChurch,
              icon: Iconsax.save_2,
            ),
          ),
          const SizedBox(height: 24),
          ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModernInput(
                      controller: nameController,
                      label: l10n.churchName,
                      prefixIcon: Iconsax.building,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? l10n.churchNameEmpty
                          : null,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOut),
                const SizedBox(height: 16),
                ModernInput(
                      controller: locationLinkController,
                      label: l10n.googleMapsLink,
                      prefixIcon: Iconsax.map_1,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms)
                    .slideY(begin: 0.1, curve: Curves.easeOut),
                const SizedBox(height: 16),
                ModernDatePicker(
                  hintText: l10n.establishmentDateOptional,
                  icon: Iconsax.calendar_1,
                  selectedDate: establishmentDate.value,
                  onDateSelected: (date) {
                    establishmentDate.value = date;
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    SecondaryButton(text: l10n.clearForm, onPressed: clearForm),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
