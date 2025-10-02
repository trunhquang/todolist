import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// String extensions
extension StringExtensions on String {
  // Capitalize first letter
  String get capitalizeFirst {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  // Capitalize all words
  String get capitalizeWords {
    return split(' ').map((word) => word.capitalizeFirst).join(' ');
  }

  // Check if string is email
  bool get isEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this);
  }

  // Check if string is phone number
  bool get isPhoneNumber {
    final digitsOnly = replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly.length >= 10 && digitsOnly.length <= 15;
  }

  // Check if string is URL
  bool get isUrl {
    return RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    ).hasMatch(this);
  }

  // Remove all whitespace
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  // Truncate with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  // Convert to slug
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .trim();
  }

  // Check if string is numeric
  bool get isNumeric {
    return RegExp(r'^-?[0-9]+$').hasMatch(this);
  }

  // Check if string is alphanumeric
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  // Convert to int
  int? get toInt {
    return int.tryParse(this);
  }

  // Convert to double
  double? get toDouble {
    return double.tryParse(this);
  }

  // Convert to bool
  bool get toBool {
    return toLowerCase() == 'true';
  }
}

// DateTime extensions
extension DateTimeExtensions on DateTime {
  // Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  // Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  // Check if date is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) && 
           isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  // Check if date is this month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  // Check if date is this year
  bool get isThisYear {
    return year == DateTime.now().year;
  }

  // Get start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  // Get end of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  // Get start of week
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1)).startOfDay;
  }

  // Get end of week
  DateTime get endOfWeek {
    return add(Duration(days: 7 - weekday)).endOfDay;
  }

  // Get start of month
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  // Get end of month
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0, 23, 59, 59, 999);
  }

  // Get start of year
  DateTime get startOfYear {
    return DateTime(year, 1, 1);
  }

  // Get end of year
  DateTime get endOfYear {
    return DateTime(year, 12, 31, 23, 59, 59, 999);
  }

  // Format as date string
  String get toDateString {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  // Format as time string
  String get toTimeString {
    return DateFormat('HH:mm:ss').format(this);
  }

  // Format as date time string
  String get toDateTimeString {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
  }

  // Format as display date
  String get toDisplayDate {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  // Format as display date time
  String get toDisplayDateTime {
    return DateFormat('MMM dd, yyyy HH:mm').format(this);
  }

  // Format as relative time
  String get toRelativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Add days
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  // Subtract days
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }

  // Add months
  DateTime addMonths(int months) {
    return DateTime(year, month + months, day, hour, minute, second, millisecond);
  }

  // Subtract months
  DateTime subtractMonths(int months) {
    return DateTime(year, month - months, day, hour, minute, second, millisecond);
  }

  // Add years
  DateTime addYears(int years) {
    return DateTime(year + years, month, day, hour, minute, second, millisecond);
  }

  // Subtract years
  DateTime subtractYears(int years) {
    return DateTime(year - years, month, day, hour, minute, second, millisecond);
  }
}

// Duration extensions
extension DurationExtensions on Duration {
  // Format as human readable string
  String get toHumanReadable {
    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // Format as short string
  String get toShortString {
    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);

    if (days > 0) {
      return '${days}d ${hours}h';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

// List extensions
extension ListExtensions<T> on List<T> {
  // Get first element or null
  T? get firstOrNull {
    return isEmpty ? null : first;
  }

  // Get last element or null
  T? get lastOrNull {
    return isEmpty ? null : last;
  }

  // Check if list is not empty
  bool get isNotEmpty {
    return !isEmpty;
  }

  // Get element at index or null
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  // Add element if not null
  void addIfNotNull(T? element) {
    if (element != null) add(element);
  }

  // Add all elements if not null
  void addAllIfNotNull(Iterable<T>? elements) {
    if (elements != null) addAll(elements);
  }

  // Remove duplicates
  List<T> get unique {
    return toSet().toList();
  }

  // Chunk list into smaller lists
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}

// Map extensions
extension MapExtensions<K, V> on Map<K, V> {
  // Get value or default
  V getOrDefault(K key, V defaultValue) {
    return containsKey(key) ? this[key]! : defaultValue;
  }

  // Get value or null
  V? getOrNull(K key) {
    return containsKey(key) ? this[key] : null;
  }

  // Remove null values
  Map<K, V> get removeNulls {
    return Map.fromEntries(entries.where((entry) => entry.value != null));
  }
}

// BuildContext extensions
extension BuildContextExtensions on BuildContext {
  // Get theme
  ThemeData get theme => Theme.of(this);

  // Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Get media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  // Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  // Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  // Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  // Check if screen is mobile
  bool get isMobile => screenWidth < 600;

  // Check if screen is tablet
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  // Check if screen is desktop
  bool get isDesktop => screenWidth >= 1024;

  // Get safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  // Get safe area insets
  EdgeInsets get safeAreaInsets => MediaQuery.of(this).viewPadding;

  // Show snackbar
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  // Show error snackbar
  void showErrorSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(this).colorScheme.error,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  // Show success snackbar
  void showSuccessSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }
}
