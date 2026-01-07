import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:genet_church_portal/shared_widgets/notification_system.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:genet_church_portal/shared_widgets/modern_input.dart';
import 'package:genet_church_portal/shared_widgets/page_header.dart';
import 'package:genet_church_portal/shared_widgets/modern_button.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/localization/app_localization.dart';
import '../../core/utils/password_validator.dart';

class AddPastorsScreen extends HookConsumerWidget {
  const AddPastorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final locale = ref.watch(languageNotifierProvider);
    final l10n = AppLocalization(locale);

    void clearForm() {
      nameController.clear();
      emailController.clear();
      passwordController.clear();
    }

    Future<void> addPastor() async {
      if (formKey.currentState?.validate() ?? false) {
        try {
          await ref
              .read(pastorsProvider.notifier)
              .addPastor(
                fullName: nameController.text,
                email: emailController.text,
                password: passwordController.text,
              );
          if (context.mounted) {
            context.showSuccessNotification(
              title: l10n.success,
              message: '${nameController.text} ${l10n.pastorAddedMessage}',
            );
            clearForm();
            context.go('/report-pastors');
          }
        } catch (e) {
          if (context.mounted) {
            context.showErrorNotification(
              title: l10n.error,
              message: l10n.failedAddPastor,
            );
          }
          rethrow;
        }
      }
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          PageHeader(
            title: l10n.newPastorDetails,
            description: l10n.newPastorDesc,
            action: PrimaryButton(
              text: l10n.addPastor,
              onPressedAsync: addPastor,
            ),
          ),
          const SizedBox(height: 24),
          ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModernInput(
                  controller: nameController,
                  label: l10n.pastorFullName,
                  prefixIcon: Iconsax.user,
                  validator: (value) => value!.isEmpty ? l10n.nameEmpty : null,
                ),
                const SizedBox(height: 16),
                EmailInput(controller: emailController),
                const SizedBox(height: 16),
                PasswordInput(
                  controller: passwordController,
                  label: l10n.temporaryPassword,
                  validator: PasswordValidator.validate,
                ),
                const SizedBox(height: 32),
                SecondaryButton(text: l10n.clearForm, onPressed: clearForm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
