
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/member_model.dart';
import 'package:genet_church_portal/state/church_selection_provider.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:genet_church_portal/shared_widgets/modern_dropdown.dart';
import 'package:genet_church_portal/shared_widgets/modern_input.dart';
import 'package:genet_church_portal/shared_widgets/notification_system.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/localization/app_localization.dart';
import '../../shared_widgets/modern_date_picker.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';

class MemberFormData {
  final String fullName;
  final String phoneNumber;
  final DateTime? birthDate;
  final String birthPlace;
  final String motherTongue;
  final Gender? gender;
  final String city;
  final String subCity;
  final String woreda;
  final String placeName;
  final MarriageStatus? marriageStatus;
  final EducationLevel? educationLevel;
  final JobStatus? jobStatus;
  final IncomeRange? incomeRange;
  final BaptismStatus? baptismStatus;
  final DateTime? bornAgainDate;
  final DateTime? baptizedAt;

  MemberFormData({
    this.fullName = '',
    this.phoneNumber = '',
    this.birthDate,
    this.birthPlace = '',
    this.motherTongue = '',
    this.gender,
    this.city = '',
    this.subCity = '',
    this.woreda = '',
    this.placeName = '',
    this.marriageStatus,
    this.educationLevel,
    this.jobStatus,
    this.incomeRange,
    this.baptismStatus,
    this.bornAgainDate,
    this.baptizedAt,
  });

  MemberFormData copyWith({
    String? fullName,
    String? phoneNumber,
    DateTime? birthDate,
    String? birthPlace,
    String? motherTongue,
    Gender? gender,
    String? city,
    String? subCity,
    String? woreda,
    String? placeName,
    MarriageStatus? marriageStatus,
    EducationLevel? educationLevel,
    JobStatus? jobStatus,
    IncomeRange? incomeRange,
    BaptismStatus? baptismStatus,
    DateTime? bornAgainDate,
    DateTime? baptizedAt,
  }) {
    return MemberFormData(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      motherTongue: motherTongue ?? this.motherTongue,
      gender: gender ?? this.gender,
      city: city ?? this.city,
      subCity: subCity ?? this.subCity,
      woreda: woreda ?? this.woreda,
      placeName: placeName ?? this.placeName,
      marriageStatus: marriageStatus ?? this.marriageStatus,
      educationLevel: educationLevel ?? this.educationLevel,
      jobStatus: jobStatus ?? this.jobStatus,
      incomeRange: incomeRange ?? this.incomeRange,
      baptismStatus: baptismStatus ?? this.baptismStatus,
      bornAgainDate: bornAgainDate ?? this.bornAgainDate,
      baptizedAt: baptizedAt ?? this.baptizedAt,
    );
  }
}

final addMemberFormProvider = StateProvider.autoDispose(
      (ref) => MemberFormData(),
);

class AddMembersScreen extends HookConsumerWidget {
  const AddMembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final pageController = usePageController();
    final currentPage = useState(0);
    final locale = ref.watch(languageNotifierProvider);
    final l10n = AppLocalization(locale);

    final formKeys = useMemoized(
          () => [
        GlobalKey<FormState>(),
        GlobalKey<FormState>(),
        GlobalKey<FormState>(),
      ],
    );

    final stepInfo = [
      _StepInfo(
        title: l10n.personalInfo,
        subtitle: l10n.basicDetails,
        icon: Iconsax.user,
        gradientColors: [
          theme.colorScheme.primary,
          theme.colorScheme.secondary,
        ],
      ),
      _StepInfo(
        title: l10n.address,
        subtitle: l10n.locationDetails,
        icon: Iconsax.location,
        gradientColors: const [Color(0xFF11998e), Color(0xFF38ef7d)],
      ),
      _StepInfo(
        title: l10n.additionalInfo,
        subtitle: l10n.churchInfo,
        icon: Iconsax.document,
        gradientColors: const [Color(0xFFf093fb), Color(0xFFf5576c)],
      ),
    ];

    void navigateToPage(int page) {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }

    pageController.addListener(() {
      if (pageController.page?.round() != currentPage.value) {
        currentPage.value = pageController.page!.round();
      }
    });

    Future<void> addMember() async {
      bool allFormsValid = true;
      for (int i = 0; i < formKeys.length; i++) {
        if (!(formKeys[i].currentState?.validate() ?? false)) {
          context.showWarningNotification(
            title: l10n.incompleteForm,
            message: l10n.completeAllFields,
          );
          if (currentPage.value != i) {
            navigateToPage(i);
          }
          allFormsValid = false;
          break;
        }
      }

      if (!allFormsValid) return;

      // Get church ID - automatically from pastor if available, or from selection
      String? selectedChurchId = ref.read(currentChurchProvider);
      
      // If no church ID from selection, try to get it from pastor directly
      if (selectedChurchId == null) {
        final user = ref.read(authStateProvider);
        if (user != null && user.roleEnum == UserRole.PASTOR) {
          // Try from pastorDetails first
          if (user.pastorDetails != null &&
              user.pastorDetails!['churchId'] != null) {
            selectedChurchId = user.pastorDetails!['churchId'] as String?;
          }
          // If still null, try from currentPastorProvider
          if (selectedChurchId == null) {
            final pastorAsync = ref.read(currentPastorProvider);
            if (pastorAsync.hasValue && pastorAsync.value?.churchId != null) {
              selectedChurchId = pastorAsync.value!.churchId;
            }
          }
        }
      }
      
      if (selectedChurchId == null || selectedChurchId.isEmpty) {
        context.showWarningNotification(
          title: l10n.churchRequired,
          message: l10n.selectChurchBeforeAdding,
        );
        return;
      }
      final formData = ref.read(addMemberFormProvider);

      if (formData.bornAgainDate == null) {
        context.showWarningNotification(
          title: l10n.incompleteForm,
          message: l10n.provideBornAgainDate,
        );
        return;
      }

      final newMember = Member(
        fullName: formData.fullName,
        phoneNumber: formData.phoneNumber,
        birthDate: formData.birthDate!.toUtc().toIso8601String(),
        birthPlace: formData.birthPlace,
        motherTongue: formData.motherTongue,
        gender: formData.gender!,
        marriageStatus: formData.marriageStatus!,
        address: Address(
          city: formData.city,
          subCity: formData.subCity,
          woreda: formData.woreda,
          placeName: formData.placeName,
        ),
        educationLevel: formData.educationLevel!,
        jobStatus: formData.jobStatus!,
        incomeRange: formData.incomeRange!,
        baptismStatus: formData.baptismStatus!,
        bornAgainDate: formData.bornAgainDate!.toUtc().toIso8601String(),
        baptizedAt: formData.baptizedAt?.toUtc().toIso8601String(),
        memberStatus: MemberStatus.ACTIVE,
        deleted: false,
      );

      try {
        await ref.read(membersProvider.notifier).addMember(
          member: newMember,
          churchId: selectedChurchId!,
        );
        if (context.mounted) {
          context.showSuccessNotification(
            title: l10n.success,
            message: l10n.memberAddedSuccess,
          );
          ref.invalidate(addMemberFormProvider);
          context.go('/show-members');
        }
      } catch (e) {
        if (context.mounted) {
          context.showErrorNotification(
            title: l10n.error,
            message: '${l10n.failedAddMember}: ${e.toString()}',
          );
        }
      }
    }

    Future<void> handleNextOrSubmit() async {
      if (formKeys[currentPage.value].currentState?.validate() ?? false) {
        if (currentPage.value < formKeys.length - 1) {
          navigateToPage(currentPage.value + 1);
        } else {
          await addMember();
        }
      }
    }

    final wizardSteps = [
      _WizardStep(formKey: formKeys[0], child: _PersonalForm(loc: l10n)),
      _WizardStep(formKey: formKeys[1], child: _AddressForm(loc: l10n)),
      _WizardStep(formKey: formKeys[2], child: _AdditionalInfoForm(loc: l10n)),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [appColors.scaffold, appColors.surface.withAlpha(51)],
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Ultra-Modern Header
              _buildModernHeader(context, appColors, theme, l10n),
              const SizedBox(height: 32),

              // Main Content Card
              Animate(
                effects: [
                  FadeEffect(duration: 600.ms, delay: 200.ms),
                  SlideEffect(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                    duration: 600.ms,
                    curve: Curves.easeOutCubic,
                  ),
                ],
                child: ModernCard(
                  variant: CardVariant.elevated,
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      // Stepper Header
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary.withAlpha(13),
                              theme.colorScheme.secondary.withAlpha(13),
                            ],
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: appColors.border.withAlpha(51),
                            ),
                          ),
                        ),
                        child: _UltraModernStepper(
                          steps: stepInfo,
                          currentStep: currentPage.value,
                          onStepTapped: (index) {
                            if (index <= currentPage.value) {
                              navigateToPage(index);
                            }
                          },
                        ),
                      ),

                      // Form Content
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 420,
                              child: PageView.builder(
                                controller: pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: wizardSteps.length,
                                itemBuilder: (context, index) {
                                  return Form(
                                    key: wizardSteps[index].formKey,
                                    child: wizardSteps[index].child,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Navigation Buttons
                            Row(
                              children: [
                                if (currentPage.value > 0)
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: appColors.border.withAlpha(76),
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => navigateToPage(
                                            currentPage.value - 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 24,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Iconsax.arrow_left_2,
                                                  size: 20,
                                                  color:
                                                  appColors.textSecondary,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  l10n.previousStep,
                                                  style: TextStyle(
                                                    color:
                                                    appColors.textSecondary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  const Spacer(),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: _GradientButton(
                                    text:
                                    currentPage.value ==
                                        wizardSteps.length - 1
                                        ? l10n.saveMember
                                        : l10n.continueStep,
                                    icon:
                                    currentPage.value ==
                                        wizardSteps.length - 1
                                        ? Iconsax.save_2
                                        : Iconsax.arrow_right_3,
                                    gradientColors: stepInfo[currentPage.value]
                                        .gradientColors,
                                    onPressed: handleNextOrSubmit,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(
      BuildContext context,
      AppColors appColors,
      ThemeData theme,
      AppLocalization l10n,
      ) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withAlpha(25),
            theme.colorScheme.secondary.withAlpha(25),
          ],
        ),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha(51),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(25),
            blurRadius: 60,
            offset: const Offset(0, 20),
            spreadRadius: -10,
          ),
        ],
      ),
      child: isSmallScreen
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(102),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Iconsax.user_add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.registerNewMember,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    fontSize: 20,
                    foreground: Paint()
                      ..shader =
                      LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ).createShader(
                        const Rect.fromLTWH(0, 0, 250, 50),
                      ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.fillDetailsAddMember,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: appColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      )
          : Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withAlpha(102),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Iconsax.user_add,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.registerNewMember,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    foreground: Paint()
                      ..shader =
                      LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ).createShader(
                        const Rect.fromLTWH(0, 0, 250, 50),
                      ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.fillDetailsAddMember,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(
      begin: -0.2,
      end: 0,
      duration: 600.ms,
      curve: Curves.easeOutCubic,
    );
  }
}

class _StepInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;

  _StepInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
  });
}

class _UltraModernStepper extends StatelessWidget {
  final List<_StepInfo> steps;
  final int currentStep;
  final Function(int) onStepTapped;

  const _UltraModernStepper({
    required this.steps,
    required this.currentStep,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 500;

        return Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              // Connector line
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep;
              return Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: isCompleted
                        ? LinearGradient(
                      colors: steps[stepIndex].gradientColors,
                    )
                        : null,
                    color: isCompleted ? null : appColors.border.withAlpha(51),
                  ),
                ),
              );
            }

            final stepIndex = index ~/ 2;
            final step = steps[stepIndex];
            final isActive = stepIndex == currentStep;
            final isCompleted = stepIndex < currentStep;

            return GestureDetector(
              onTap: () => onStepTapped(stepIndex),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 12 : 16,
                  vertical: isSmall ? 8 : 12,
                ),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(colors: step.gradientColors)
                      : null,
                  color: isActive
                      ? null
                      : (isCompleted
                      ? step.gradientColors[0].withAlpha(25)
                      : appColors.surface),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive
                        ? Colors.transparent
                        : (isCompleted
                        ? step.gradientColors[0].withAlpha(76)
                        : appColors.border.withAlpha(51)),
                    width: 1.5,
                  ),
                  boxShadow: isActive
                      ? [
                    BoxShadow(
                      color: step.gradientColors[0].withAlpha(76),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: isSmall ? 28 : 32,
                      height: isSmall ? 28 : 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? Colors.white.withAlpha(51)
                            : (isCompleted
                            ? step.gradientColors[0].withAlpha(25)
                            : appColors.scaffold),
                      ),
                      child: Center(
                        child: isCompleted && !isActive
                            ? Icon(
                          Iconsax.tick_circle,
                          size: isSmall ? 16 : 18,
                          color: step.gradientColors[0],
                        )
                            : Icon(
                          step.icon,
                          size: isSmall ? 14 : 16,
                          color: isActive
                              ? Colors.white
                              : (isCompleted
                              ? step.gradientColors[0]
                              : appColors.textSecondary),
                        ),
                      ),
                    ),
                    if (!isSmall) ...[
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            step.title,
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : (isCompleted
                                  ? step.gradientColors[0]
                                  : appColors.textPrimary),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            step.subtitle,
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white.withAlpha(179)
                                  : appColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _GradientButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final List<Color> gradientColors;
  final Future<void> Function() onPressed;

  const _GradientButton({
    required this.text,
    required this.icon,
    required this.gradientColors,
    required this.onPressed,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_controller.value * 0.02),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: widget.gradientColors),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientColors[0].withAlpha(
                      (76 + _controller.value * 51).toInt(),
                    ),
                    blurRadius: 20 + _controller.value * 10,
                    offset: Offset(0, 8 + _controller.value * 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoading
                      ? null
                      : () async {
                    setState(() => _isLoading = true);
                    try {
                      await widget.onPressed();
                    } finally {
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else ...[
                          Text(
                            widget.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(widget.icon, size: 20, color: Colors.white),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WizardStep {
  final GlobalKey<FormState> formKey;
  final Widget child;
  _WizardStep({required this.formKey, required this.child});
}

Widget _formRow(List<Widget> children) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Column(
          children: children
              .map(
                (child) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: child,
            ),
          )
              .toList(),
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget widget = entry.value;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: idx == 0 ? 0 : 8.0,
                right: idx == children.length - 1 ? 0 : 8.0,
              ),
              child: widget,
            ),
          );
        }).toList(),
      );
    },
  );
}

class _PersonalForm extends ConsumerStatefulWidget {
  final AppLocalization loc;
  const _PersonalForm({required this.loc});

  @override
  ConsumerState<_PersonalForm> createState() => _PersonalFormState();
}

class _PersonalFormState extends ConsumerState<_PersonalForm>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _birthPlaceController;
  late final TextEditingController _motherTongueController;

  @override
  void initState() {
    super.initState();
    final formData = ref.read(addMemberFormProvider);
    _fullNameController = TextEditingController(text: formData.fullName);
    _phoneNumberController = TextEditingController(text: formData.phoneNumber);
    _birthPlaceController = TextEditingController(text: formData.birthPlace);
    _motherTongueController = TextEditingController(
      text: formData.motherTongue,
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _birthPlaceController.dispose();
    _motherTongueController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final formData = ref.watch(addMemberFormProvider);
    final formNotifier = ref.read(addMemberFormProvider.notifier);

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _formRow([
          ModernInput(
            controller: _fullNameController,
            label: widget.loc.fullName,
            prefixIcon: Iconsax.user_octagon,
            onChanged: (v) =>
                formNotifier.update((s) => s.copyWith(fullName: v)),
            validator: (v) => v?.isEmpty ?? true ? widget.loc.required : null,
          ),
          ModernInput(
            controller: _phoneNumberController,
            label: widget.loc.phoneNumber,
            prefixIcon: Iconsax.call,
            keyboardType: TextInputType.phone,
            onChanged: (v) =>
                formNotifier.update((s) => s.copyWith(phoneNumber: v)),
            validator: (v) {
              if (v?.isEmpty ?? true) return widget.loc.required;
              if (!RegExp(r'^\d+$').hasMatch(v!)) {
                return widget.loc.phoneNumbersOnly;
              }
              return null;
            },
          ),
        ])
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, curve: Curves.easeOut),
        const SizedBox(height: 24),
        _formRow([
          ModernDatePicker(
            hintText: widget.loc.birthDate,
            icon: Iconsax.calendar_1,
            selectedDate: formData.birthDate,
            onDateSelected: (date) =>
                formNotifier.update((s) => s.copyWith(birthDate: date)),
            validator: (_) =>
            formData.birthDate == null ? widget.loc.selectDate : null,
          ),
          ModernInput(
            controller: _birthPlaceController,
            label: widget.loc.birthPlace,
            prefixIcon: Iconsax.location,
            onChanged: (v) =>
                formNotifier.update((s) => s.copyWith(birthPlace: v)),
            validator: (v) => v?.isEmpty ?? true ? widget.loc.required : null,
          ),
        ]),
        const SizedBox(height: 24),
        _formRow([
          ModernInput(
            controller: _motherTongueController,
            label: widget.loc.motherTongue,
            prefixIcon: Iconsax.translate,
            onChanged: (v) =>
                formNotifier.update((s) => s.copyWith(motherTongue: v)),
            validator: (v) => v?.isEmpty ?? true ? widget.loc.required : null,
          ),
          ModernDropdown<Gender>(
            hintText: widget.loc.gender,
            icon: Iconsax.user,
            value: formData.gender,
            items: Gender.values
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(e.name[0] + e.name.substring(1).toLowerCase()),
              ),
            )
                .toList(),
            onChanged: (val) =>
                formNotifier.update((s) => s.copyWith(gender: val)),
            validator: (v) => v == null ? widget.loc.required : null,
          ),
        ]),
      ],
    );
  }
}

class _AddressForm extends ConsumerStatefulWidget {
  final AppLocalization loc;
  const _AddressForm({required this.loc});

  @override
  ConsumerState<_AddressForm> createState() => __AddressFormState();
}

class __AddressFormState extends ConsumerState<_AddressForm>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _cityController;
  late final TextEditingController _subCityController;
  late final TextEditingController _woredaController;
  late final TextEditingController _placeNameController;

  @override
  void initState() {
    super.initState();
    final formData = ref.read(addMemberFormProvider);
    _cityController = TextEditingController(text: formData.city);
    _subCityController = TextEditingController(text: formData.subCity);
    _woredaController = TextEditingController(text: formData.woreda);
    _placeNameController = TextEditingController(text: formData.placeName);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _subCityController.dispose();
    _woredaController.dispose();
    _placeNameController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final formNotifier = ref.read(addMemberFormProvider.notifier);

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _formRow([
          ModernInput(
            controller: _cityController,
            label: widget.loc.city,
            prefixIcon: Iconsax.buildings,
            onChanged: (v) =>
                formNotifier.update((s) => s.copyWith(city: v)),
            validator: (v) => v?.isEmpty ?? true ? widget.loc.required : null,
          ),
          ModernInput(
            controller: _subCityController,
            label: widget.loc.subCity,
            prefixIcon: Iconsax.building_3,
            onChanged: (v) =>
                formNotifier.update((s) => s.copyWith(subCity: v)),
            validator: (v) => v?.isEmpty ?? true ? widget.loc.required : null,
          ),
        ])
            .animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .slideY(begin: 0.1, curve: Curves.easeOut),
        const SizedBox(height: 24),
        _formRow([
          ModernInput(
            controller: _woredaController,
            label: widget.loc.woreda,
            prefixIcon: Iconsax.routing,
            onChanged: (v) =>
                formNotifier.update((s) => s.copyWith(woreda: v)),
            validator: (v) => v?.isEmpty ?? true ? widget.loc.required : null,
          ),
          ModernInput(
            controller: _placeNameController,
            label: widget.loc.specificPlaceName,
            prefixIcon: Iconsax.location_tick,
            onChanged: (v) =>
                formNotifier.update((s) => s.copyWith(placeName: v)),
            validator: (v) => v?.isEmpty ?? true ? widget.loc.required : null,
          ),
        ])
            .animate()
            .fadeIn(duration: 400.ms, delay: 200.ms)
            .slideY(begin: 0.1, curve: Curves.easeOut),
      ],
    );
  }
}

class _AdditionalInfoForm extends ConsumerStatefulWidget {
  final AppLocalization loc;
  const _AdditionalInfoForm({required this.loc});

  @override
  ConsumerState<_AdditionalInfoForm> createState() =>
      _AdditionalInfoFormState();
}

class _AdditionalInfoFormState extends ConsumerState<_AdditionalInfoForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final formData = ref.watch(addMemberFormProvider);
    final formNotifier = ref.read(addMemberFormProvider.notifier);

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _formRow([
          ModernDropdown<EducationLevel>(
            hintText: widget.loc.educationLevel,
            icon: Iconsax.book,
            value: formData.educationLevel,
            items: EducationLevel.values
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.name
                      .split('_')
                      .map((w) => w[0] + w.substring(1).toLowerCase())
                      .join(' '),
                ),
              ),
            )
                .toList(),
            onChanged: (val) =>
                formNotifier.update((s) => s.copyWith(educationLevel: val)),
            validator: (v) => v == null ? widget.loc.required : null,
          ),
          ModernDropdown<JobStatus>(
            hintText: widget.loc.jobStatus,
            icon: Iconsax.briefcase,
            value: formData.jobStatus,
            items: JobStatus.values
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.name
                      .split('_')
                      .map((w) => w[0] + w.substring(1).toLowerCase())
                      .join(' '),
                ),
              ),
            )
                .toList(),
            onChanged: (val) =>
                formNotifier.update((s) => s.copyWith(jobStatus: val)),
            validator: (v) => v == null ? widget.loc.required : null,
          ),
        ]),
        const SizedBox(height: 24),
        _formRow([
          ModernDropdown<MarriageStatus>(
            hintText: widget.loc.marriageStatus,
            icon: Iconsax.like,
            value: formData.marriageStatus,
            items: MarriageStatus.values
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.name
                      .split('_')
                      .map((w) => w[0] + w.substring(1).toLowerCase())
                      .join(' '),
                ),
              ),
            )
                .toList(),
            onChanged: (val) =>
                formNotifier.update((s) => s.copyWith(marriageStatus: val)),
            validator: (v) => v == null ? widget.loc.required : null,
          ),
          ModernDropdown<IncomeRange>(
            hintText: widget.loc.incomeRange,
            icon: Iconsax.wallet_money,
            value: formData.incomeRange,
            items: IncomeRange.values
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.name
                      .split('_')
                      .map((w) => w[0] + w.substring(1).toLowerCase())
                      .join(' '),
                ),
              ),
            )
                .toList(),
            onChanged: (val) =>
                formNotifier.update((s) => s.copyWith(incomeRange: val)),
            validator: (v) => v == null ? widget.loc.required : null,
          ),
        ]),
        const SizedBox(height: 24),
        _formRow([
          ModernDropdown<BaptismStatus>(
            hintText: widget.loc.baptismStatus,
            icon: Icons.church,
            value: formData.baptismStatus,
            items: BaptismStatus.values
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.name
                      .split('_')
                      .map((w) => w[0] + w.substring(1).toLowerCase())
                      .join(' '),
                ),
              ),
            )
                .toList(),
            onChanged: (val) {
              if (val != BaptismStatus.BAPTIZED) {
                formNotifier.update(
                      (s) => s.copyWith(baptismStatus: val, baptizedAt: null),
                );
              } else {
                formNotifier.update((s) => s.copyWith(baptismStatus: val));
              }
            },
            validator: (v) => v == null ? widget.loc.required : null,
          ),
          ModernDatePicker(
            hintText: widget.loc.bornAgainDate,
            icon: Iconsax.health,
            selectedDate: formData.bornAgainDate,
            onDateSelected: (date) =>
                formNotifier.update((s) => s.copyWith(bornAgainDate: date)),
            validator: (_) =>
            formData.bornAgainDate == null ? widget.loc.required : null,
          ),
        ]),
        if (formData.baptismStatus == BaptismStatus.BAPTIZED) ...[
          const SizedBox(height: 24),
          _formRow([
            ModernDatePicker(
              hintText: widget.loc.baptismDate,
              icon: Iconsax.calendar_tick,
              selectedDate: formData.baptizedAt,
              onDateSelected: (date) =>
                  formNotifier.update((s) => s.copyWith(baptizedAt: date)),
              validator: (_) {
                if (formData.baptismStatus == BaptismStatus.BAPTIZED &&
                    formData.baptizedAt == null) {
                  return widget.loc.baptismDateRequired;
                }
                return null;
              },
            ),
          ])
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, curve: Curves.easeOut),
        ],
      ],
    );
  }
}
