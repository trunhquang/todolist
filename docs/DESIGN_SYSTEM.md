# Design System Documentation

## Overview
This document outlines the design system for the TodoList application, including colors, typography, components, and usage guidelines.

## Color Palette

### Primary Colors
- **Primary**: `#2196F3` (Blue) - Main brand color
- **On Primary**: `#FFFFFF` (White) - Text/icons on primary
- **Primary Container**: `#BBDEFB` (Light Blue) - Background for primary elements
- **On Primary Container**: `#0D47A1` (Dark Blue) - Text on primary container

### Secondary Colors
- **Secondary**: `#03DAC6` (Teal) - Secondary brand color
- **On Secondary**: `#000000` (Black) - Text/icons on secondary
- **Secondary Container**: `#B2DFDB` (Light Teal) - Background for secondary elements
- **On Secondary Container**: `#004D40` (Dark Teal) - Text on secondary container

### Surface Colors
- **Surface**: `#FFFFFF` (White) - Card and surface backgrounds
- **On Surface**: `#1C1B1F` (Dark Gray) - Text on surfaces
- **Surface Variant**: `#F3F3F3` (Light Gray) - Alternative surface color
- **On Surface Variant**: `#49454F` (Medium Gray) - Text on surface variant

### Task Type Colors
- **Daily Task**: `#4CAF50` (Green)
- **Weekly Task**: `#FF9800` (Orange)
- **Monthly Task**: `#9C27B0` (Purple)
- **Project Task**: `#2196F3` (Blue)

### Priority Colors
- **Low Priority**: `#4CAF50` (Green)
- **Medium Priority**: `#FF9800` (Orange)
- **High Priority**: `#FF5722` (Red-Orange)
- **Urgent Priority**: `#F44336` (Red)

### Status Colors
- **Pending**: `#9E9E9E` (Gray)
- **In Progress**: `#2196F3` (Blue)
- **Completed**: `#4CAF50` (Green)
- **Cancelled**: `#F44336` (Red)

## Typography

### Headlines
- **Headline Large**: 32px, Bold, Line Height 1.2
- **Headline Medium**: 28px, Bold, Line Height 1.2
- **Headline Small**: 24px, Bold, Line Height 1.2

### Titles
- **Title Large**: 22px, Semi-Bold (600), Line Height 1.3
- **Title Medium**: 18px, Semi-Bold (600), Line Height 1.3
- **Title Small**: 16px, Semi-Bold (600), Line Height 1.3

### Body Text
- **Body Large**: 16px, Regular, Line Height 1.5
- **Body Medium**: 14px, Regular, Line Height 1.5
- **Body Small**: 12px, Regular, Line Height 1.5

### Labels
- **Label Large**: 14px, Medium (500), Line Height 1.4
- **Label Medium**: 12px, Medium (500), Line Height 1.4
- **Label Small**: 10px, Medium (500), Line Height 1.4

### Buttons
- **Button Large**: 16px, Semi-Bold (600), Line Height 1.2
- **Button Medium**: 14px, Semi-Bold (600), Line Height 1.2
- **Button Small**: 12px, Semi-Bold (600), Line Height 1.2

## Components

### TDButton
A customizable button component with multiple variants.

**Variants:**
- `filled` - Primary button with solid background
- `outlined` - Secondary button with border
- `text` - Text-only button

**Usage:**
```dart
TDButton(
  text: 'Sign In',
  onPressed: () {},
  variant: TDButtonVariant.filled,
  isLoading: false,
  icon: Icons.login,
)
```

### TDTextField
A form input field with consistent styling.

**Features:**
- Label and hint text support
- Icon support (prefix/suffix)
- Validation support
- Customizable keyboard types

**Usage:**
```dart
TDTextField(
  controller: controller,
  label: 'Email',
  hint: 'Enter your email',
  prefixIcon: Icons.email,
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
)
```

### TDCard
A container component for grouping related content.

**Features:**
- Consistent elevation and border radius
- Clickable support
- Customizable padding and margins

**Usage:**
```dart
TDCard(
  child: Text('Card content'),
  onTap: () {},
  isClickable: true,
)
```

### TDChip
A compact element representing an input, attribute, or action.

**Types:**
- `primary` - Default chip style
- `secondary` - Alternative style
- `success` - Success state
- `warning` - Warning state
- `error` - Error state
- `info` - Information state

**Usage:**
```dart
TDChip(
  label: 'Daily Task',
  type: TDChipType.success,
  icon: Icons.calendar_today,
  onDeleted: () {},
)
```

### TDLoadingIndicator
Loading states for the application.

**Variants:**
- Simple spinner
- Spinner with message
- Overlay loading

**Usage:**
```dart
TDLoadingIndicator(
  message: 'Loading tasks...',
  size: 24.0,
)
```

### TDEmptyState
Empty state component for when there's no content to display.

**Usage:**
```dart
TDEmptyState(
  title: 'No tasks found',
  subtitle: 'Create your first task to get started',
  icon: Icons.task_alt,
  actionText: 'Create Task',
  onAction: () {},
)
```

### TDAppBar
Custom app bar with consistent styling.

**Usage:**
```dart
TDAppBar(
  title: 'Dashboard',
  actions: [
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {},
    ),
  ],
)
```

## Spacing System

### Base Unit
- Base spacing unit: 8px

### Common Spacing Values
- **xs**: 4px
- **sm**: 8px
- **md**: 16px
- **lg**: 24px
- **xl**: 32px
- **xxl**: 48px

### Usage Guidelines
- Use consistent spacing multiples of 8px
- Maintain visual hierarchy with appropriate spacing
- Use larger spacing for section separation
- Use smaller spacing for related elements

## Border Radius

### Standard Values
- **Small**: 4px - For chips and small elements
- **Medium**: 8px - For buttons and inputs
- **Large**: 12px - For cards and containers
- **Extra Large**: 16px - For large containers

## Elevation

### Shadow Levels
- **Level 1**: 2px elevation - Cards and containers
- **Level 2**: 4px elevation - Floating action buttons
- **Level 3**: 8px elevation - Dialogs and modals
- **Level 4**: 16px elevation - Navigation drawers

## Accessibility

### Color Contrast
- All text meets WCAG AA contrast requirements
- Interactive elements have sufficient contrast ratios
- Color is not the only means of conveying information

### Touch Targets
- Minimum touch target size: 44px x 44px
- Adequate spacing between interactive elements
- Clear visual feedback for interactions

### Typography
- Readable font sizes (minimum 12px)
- Sufficient line height for readability
- Clear hierarchy with appropriate font weights

## Responsive Design

### Breakpoints
- **Mobile**: < 600px
- **Tablet**: 600px - 1024px
- **Desktop**: > 1024px

### Adaptive Layouts
- Flexible grid systems
- Responsive typography scaling
- Adaptive component sizing

## Usage Guidelines

### Do's
- Use consistent spacing and typography
- Maintain visual hierarchy
- Use appropriate color combinations
- Follow accessibility guidelines
- Test on multiple screen sizes

### Don'ts
- Don't mix different design patterns
- Don't use colors that don't meet contrast requirements
- Don't create inconsistent spacing
- Don't ignore accessibility requirements
- Don't use too many different font sizes

## Implementation Notes

### File Structure
```
lib/app/widgets/
├── td_button.dart
├── td_text_field.dart
├── td_card.dart
├── td_chip.dart
├── td_loading_indicator.dart
├── td_empty_state.dart
└── td_app_bar.dart
```

### Theme Integration
All components are integrated with the app theme system and automatically adapt to light/dark mode changes.

### Customization
Components can be customized through constructor parameters while maintaining design consistency.
