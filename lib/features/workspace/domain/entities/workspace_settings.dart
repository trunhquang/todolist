import 'package:meta/meta.dart';

/// Workspace settings entity
@immutable
class WorkspaceSettings {
  const WorkspaceSettings({
    this.description,
    this.logoUrl,
    this.timezone = 'UTC',
    this.language = 'en',
    this.dateFormat = 'MM/dd/yyyy',
    this.timeFormat = '12h',
    this.currency = 'USD',
    this.notifications = true,
    this.autoSave = true,
    this.theme = 'system',
    this.customFields = const {},
  });

  /// Create from map
  factory WorkspaceSettings.fromMap(Map<String, dynamic> map) {
    return WorkspaceSettings(
      description: map['description']?.toString(),
      logoUrl: map['logoUrl']?.toString(),
      timezone: map['timezone']?.toString() ?? 'UTC',
      language: map['language']?.toString() ?? 'en',
      dateFormat: map['dateFormat']?.toString() ?? 'MM/dd/yyyy',
      timeFormat: map['timeFormat']?.toString() ?? '12h',
      currency: map['currency']?.toString() ?? 'USD',
      notifications: (map['notifications'] as bool?) ?? true,
      autoSave: (map['autoSave'] as bool?) ?? true,
      theme: map['theme']?.toString() ?? 'system',
      customFields: map['customFields'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(map['customFields'] as Map<String, dynamic>)
          : const {},
    );
  }

  final String? description;
  final String? logoUrl;
  final String timezone;
  final String language;
  final String dateFormat;
  final String timeFormat;
  final String currency;
  final bool notifications;
  final bool autoSave;
  final String theme;
  final Map<String, dynamic> customFields;

  /// Copy with method
  WorkspaceSettings copyWith({
    String? description,
    String? logoUrl,
    String? timezone,
    String? language,
    String? dateFormat,
    String? timeFormat,
    String? currency,
    bool? notifications,
    bool? autoSave,
    String? theme,
    Map<String, dynamic>? customFields,
  }) {
    return WorkspaceSettings(
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      currency: currency ?? this.currency,
      notifications: notifications ?? this.notifications,
      autoSave: autoSave ?? this.autoSave,
      theme: theme ?? this.theme,
      customFields: customFields ?? this.customFields,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'logoUrl': logoUrl,
      'timezone': timezone,
      'language': language,
      'dateFormat': dateFormat,
      'timeFormat': timeFormat,
      'currency': currency,
      'notifications': notifications,
      'autoSave': autoSave,
      'theme': theme,
      'customFields': customFields,
    };
  }

  /// Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkspaceSettings &&
        other.description == description &&
        other.logoUrl == logoUrl &&
        other.timezone == timezone &&
        other.language == language &&
        other.dateFormat == dateFormat &&
        other.timeFormat == timeFormat &&
        other.currency == currency &&
        other.notifications == notifications &&
        other.autoSave == autoSave &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return description.hashCode ^
        logoUrl.hashCode ^
        timezone.hashCode ^
        language.hashCode ^
        dateFormat.hashCode ^
        timeFormat.hashCode ^
        currency.hashCode ^
        notifications.hashCode ^
        autoSave.hashCode ^
        theme.hashCode;
  }

  @override
  String toString() {
    return 'WorkspaceSettings(timezone: $timezone, language: $language, theme: $theme)';
  }

  /// Helper methods
  bool get hasLogo => logoUrl != null && logoUrl!.isNotEmpty;
  bool get hasDescription => description != null && description!.isNotEmpty;
  bool get hasCustomFields => customFields.isNotEmpty;
}

/// Available timezones
class WorkspaceTimezones {
  static const List<String> available = [
    'UTC',
    'UTC+1',
    'UTC+2',
    'UTC+3',
    'UTC+4',
    'UTC+5',
    'UTC+6',
    'UTC+7',
    'UTC+8',
    'UTC+9',
    'UTC+10',
    'UTC+11',
    'UTC+12',
    'UTC-1',
    'UTC-2',
    'UTC-3',
    'UTC-4',
    'UTC-5',
    'UTC-6',
    'UTC-7',
    'UTC-8',
    'UTC-9',
    'UTC-10',
    'UTC-11',
    'UTC-12',
  ];
}

/// Available languages
class WorkspaceLanguages {
  static const List<String> available = [
    'en',
    'vi',
    'es',
    'fr',
    'de',
    'ja',
    'ko',
    'zh',
  ];

  static String getDisplayName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Tiếng Việt';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      default:
        return code;
    }
  }
}

/// Available date formats
class WorkspaceDateFormats {
  static const List<String> available = [
    'MM/dd/yyyy',
    'dd/MM/yyyy',
    'yyyy-MM-dd',
    'dd-MM-yyyy',
    'MMM dd, yyyy',
    'dd MMM yyyy',
  ];
}

/// Available time formats
class WorkspaceTimeFormats {
  static const List<String> available = [
    '12h',
    '24h',
  ];
}

/// Available currencies
class WorkspaceCurrencies {
  static const List<String> available = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'VND',
    'CNY',
    'KRW',
  ];

  static String getDisplayName(String code) {
    switch (code) {
      case 'USD':
        return 'US Dollar (\$)';
      case 'EUR':
        return 'Euro (€)';
      case 'GBP':
        return 'British Pound (£)';
      case 'JPY':
        return 'Japanese Yen (¥)';
      case 'VND':
        return 'Vietnamese Dong (₫)';
      case 'CNY':
        return 'Chinese Yuan (¥)';
      case 'KRW':
        return 'South Korean Won (₩)';
      default:
        return code;
    }
  }
}

/// Available themes
class WorkspaceThemes {
  static const List<String> available = [
    'light',
    'dark',
    'system',
  ];

  static String getDisplayName(String theme) {
    switch (theme) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      case 'system':
        return 'System';
      default:
        return theme;
    }
  }
}
