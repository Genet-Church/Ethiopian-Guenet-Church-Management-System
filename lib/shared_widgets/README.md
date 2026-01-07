# Modern UI Component Library

This document outlines the modern UI component library created for the Genet Church Portal. These components provide a consistent, beautiful, and modern design system throughout the application.

## 🎨 Design System Overview

The modern design system includes:
- **Material 3 Design** with Google Fonts Inter typography
- **Consistent theming** with light and dark mode support
- **Modern animations** and micro-interactions
- **Accessibility** considerations
- **Responsive design** patterns

## 📦 Components

### 1. Notification System (`notification_system.dart`)

A modern replacement for SnackBars with beautiful animations and better UX.

#### Usage:
```dart
// Success notification
context.showSuccessNotification(
  title: 'Success!',
  message: 'Your data has been saved successfully.',
);

// Error notification
context.showErrorNotification(
  title: 'Error',
  message: 'Something went wrong. Please try again.',
);

// Warning notification
context.showWarningNotification(
  title: 'Warning',
  message: 'Please check your input before proceeding.',
);

// Info notification
context.showInfoNotification(
  title: 'Info',
  message: 'This feature is coming soon.',
);
```

#### Features:
- ✅ Auto-dismiss with customizable duration
- ✅ Action buttons support
- ✅ Beautiful animations
- ✅ Multiple notification types
- ✅ Stacked notifications
- ✅ Global overlay system

### 2. Modern Cards (`modern_card.dart`)

Flexible card components with multiple variants and hover effects.

#### Usage:
```dart
// Basic elevated card
ModernCard(
  child: Text('Content here'),
)

// Info card with icon
InfoCard(
  title: 'User Profile',
  subtitle: 'Manage your account settings',
  icon: Iconsax.user,
  onTap: () => navigateToProfile(),
)

// Stat card for dashboards
StatCard(
  title: 'Total Members',
  value: '1,234',
  icon: Iconsax.people,
  trend: '+12%',
  isPositiveTrend: true,
)
```

#### Variants:
- `CardVariant.elevated` - Default with shadow
- `CardVariant.outlined` - Border only
- `CardVariant.filled` - Filled background
- `CardVariant.glass` - Glass morphism effect

### 3. Modern Buttons (`modern_button.dart`)

Comprehensive button system with multiple variants and built-in loading states.

#### Usage:
```dart
// Primary button
PrimaryButton(
  text: 'Save Changes',
  icon: Iconsax.save_2,
  onPressed: () => saveData(),
)

// Async button with loading
PrimaryButton(
  text: 'Submit',
  onPressedAsync: () async {
    await submitForm();
  },
)

// Secondary button
SecondaryButton(
  text: 'Cancel',
  onPressed: () => Navigator.pop(context),
)

// Outline button
OutlineButton(
  text: 'Learn More',
  icon: Iconsax.info_circle,
  onPressed: () => showInfo(),
)

// Destructive button
DestructiveButton(
  text: 'Delete',
  onPressed: () => deleteItem(),
)
```

#### Features:
- ✅ Multiple variants (primary, secondary, outline, ghost, destructive)
- ✅ Built-in loading states
- ✅ Async operation support
- ✅ Hover animations
- ✅ Multiple sizes (small, medium, large)
- ✅ Icon support

### 4. Modern Inputs (`modern_input.dart`)

Advanced input fields with beautiful animations and validation.

#### Usage:
```dart
// Basic input
ModernInput(
  label: 'Full Name',
  hintText: 'Enter your full name',
  prefixIcon: Iconsax.user,
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
)

// Email input (with built-in validation)
EmailInput(
  controller: emailController,
  label: 'Email Address',
)

// Password input (with toggle visibility)
PasswordInput(
  controller: passwordController,
  label: 'Password',
)

// Search input
SearchInput(
  hintText: 'Search members...',
  onChanged: (query) => performSearch(query),
)
```

#### Variants:
- `InputVariant.filled` - Filled background (default)
- `InputVariant.outlined` - Outlined border
- `InputVariant.underlined` - Underlined style

#### Specialized Inputs:
- `EmailInput` - Email with validation
- `PasswordInput` - Password with visibility toggle
- `SearchInput` - Search with clear button

### 5. Loading States (`modern_loading.dart`)

Modern loading indicators and state management.

#### Usage:
```dart
// Circular loading
ModernLoading(
  type: LoadingType.circular,
  message: 'Loading data...',
  showMessage: true,
)

// Dots loading
ModernLoading(
  type: LoadingType.dots,
  size: 32,
)

// Loading overlay
LoadingOverlay(
  isLoading: isLoadingData,
  child: YourContent(),
)

// Empty state
EmptyState(
  icon: Iconsax.box,
  title: 'No Data Found',
  subtitle: 'There are no items to display.',
  actionText: 'Add New Item',
  onAction: () => addNewItem(),
)

// Error state
ErrorState(
  title: 'Something went wrong',
  subtitle: 'Please try again later.',
  actionText: 'Retry',
  onRetry: () => retryOperation(),
)
```

#### Loading Types:
- `LoadingType.circular` - Circular progress indicator
- `LoadingType.linear` - Linear progress bar
- `LoadingType.dots` - Animated dots
- `LoadingType.pulse` - Pulsing circle
- `LoadingType.skeleton` - Skeleton loader

## 🎯 Best Practices

### 1. Consistent Spacing
Use the predefined spacing values:
- Small: 8px
- Medium: 16px
- Large: 24px
- Extra Large: 32px

### 2. Color Usage
Always use theme colors:
```dart
final theme = Theme.of(context);
final appColors = theme.extension<AppColors>()!;

// Use theme colors
color: appColors.textPrimary
color: theme.colorScheme.primary
```

### 3. Typography
Use theme text styles:
```dart
Text(
  'Heading',
  style: theme.textTheme.headlineMedium,
)
```

### 4. Animations
All components include built-in animations. For custom animations, use:
```dart
widget.animate()
  .fadeIn(duration: 300.ms)
  .slideY(begin: 0.1, curve: Curves.easeOut)
```

### 5. Responsive Design
Consider different screen sizes:
```dart
final isSmallScreen = MediaQuery.of(context).size.width < 600;
final padding = isSmallScreen ? 16.0 : 24.0;
```

## 🔄 Migration Guide

### From SnackBar to Notifications
```dart
// Old
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Success!')),
);

// New
context.showSuccessNotification(
  title: 'Success!',
  message: 'Operation completed successfully.',
);
```

### From Old Buttons to Modern Buttons
```dart
// Old
ElevatedButton(
  onPressed: () => save(),
  child: Text('Save'),
)

// New
PrimaryButton(
  text: 'Save',
  onPressed: () => save(),
)
```

### From TextFormField to Modern Input
```dart
// Old
TextFormField(
  decoration: InputDecoration(
    labelText: 'Email',
    prefixIcon: Icon(Icons.email),
  ),
)

// New
EmailInput(
  label: 'Email',
)
```

## 🎨 Theming

The design system supports both light and dark themes with:
- **Inter font family** for modern typography
- **Material 3 design** principles
- **Custom color extensions** for brand consistency
- **Smooth animations** and transitions

## 🚀 Performance

All components are optimized for performance:
- Efficient animations using `AnimationController`
- Proper disposal of resources
- Minimal rebuilds with `const` constructors
- Lazy loading where appropriate

## 📱 Accessibility

Components include accessibility features:
- Proper semantic labels
- Keyboard navigation support
- Screen reader compatibility
- High contrast support
- Touch target sizing

---

For more examples and advanced usage, check the individual component files and the updated screens in the application.
