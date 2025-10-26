import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_settings.dart';

/// Workspace validation service
class WorkspaceValidator {
  /// Validate workspace name
  static String? validateWorkspaceName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Workspace name is required';
    }
    
    if (name.length < 2) {
      return 'Workspace name must be at least 2 characters';
    }
    
    if (name.length > 50) {
      return 'Workspace name must be less than 50 characters';
    }
    
    // Check for invalid characters
    final invalidChars = RegExp(r'[<>:"/\\|?*]');
    if (invalidChars.hasMatch(name)) {
      return 'Workspace name contains invalid characters';
    }
    
    return null;
  }

  /// Validate workspace description
  static String? validateWorkspaceDescription(String? description) {
    if (description == null || description.isEmpty) {
      return null; // Description is optional
    }
    
    if (description.length > 500) {
      return 'Description must be less than 500 characters';
    }
    
    return null;
  }

  /// Validate workspace settings
  static String? validateWorkspaceSettings(WorkspaceSettings settings) {
    // Validate timezone
    if (!WorkspaceTimezones.available.contains(settings.timezone)) {
      return 'Invalid timezone';
    }
    
    // Validate language
    if (!WorkspaceLanguages.available.contains(settings.language)) {
      return 'Invalid language';
    }
    
    // Validate date format
    if (!WorkspaceDateFormats.available.contains(settings.dateFormat)) {
      return 'Invalid date format';
    }
    
    // Validate time format
    if (!WorkspaceTimeFormats.available.contains(settings.timeFormat)) {
      return 'Invalid time format';
    }
    
    // Validate currency
    if (!WorkspaceCurrencies.available.contains(settings.currency)) {
      return 'Invalid currency';
    }
    
    // Validate theme
    if (!WorkspaceThemes.available.contains(settings.theme)) {
      return 'Invalid theme';
    }
    
    return null;
  }

  /// Validate logo URL
  static String? validateLogoUrl(String? logoUrl) {
    if (logoUrl == null || logoUrl.isEmpty) {
      return null; // Logo URL is optional
    }
    
    // Basic URL validation
    final urlPattern = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlPattern.hasMatch(logoUrl)) {
      return 'Invalid logo URL format';
    }
    
    return null;
  }

  /// Validate workspace type
  static String? validateWorkspaceType(WorkspaceType type) {
    if (type != WorkspaceType.personal && type != WorkspaceType.company) {
      return 'Invalid workspace type';
    }
    
    return null;
  }

  /// Validate complete workspace
  static List<String> validateWorkspace(Workspace workspace) {
    final errors = <String>[];
    
    // Validate name
    final nameError = validateWorkspaceName(workspace.name);
    if (nameError != null) {
      errors.add(nameError);
    }
    
    // Validate description
    final descriptionError = validateWorkspaceDescription(workspace.description);
    if (descriptionError != null) {
      errors.add(descriptionError);
    }
    
    // Validate type
    final typeError = validateWorkspaceType(workspace.type);
    if (typeError != null) {
      errors.add(typeError);
    }
    
    // Validate settings if present
    if (workspace.settings != null) {
      final settings = WorkspaceSettings.fromMap(workspace.settings!);
      final settingsError = validateWorkspaceSettings(settings);
      if (settingsError != null) {
        errors.add(settingsError);
      }
    }
    
    return errors;
  }

  /// Check if workspace name is available
  static bool isWorkspaceNameAvailable(String name, List<Workspace> existingWorkspaces) {
    return !existingWorkspaces.any((workspace) => 
        workspace.name.toLowerCase() == name.toLowerCase());
  }

  /// Sanitize workspace name
  static String sanitizeWorkspaceName(String name) {
    return name.trim().replaceAll(RegExp(r'[<>:"/\\|?*]'), '');
  }

  /// Generate workspace slug from name
  static String generateWorkspaceSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp('-+'), '-')
        .trim();
  }

  /// Validate workspace slug
  static String? validateWorkspaceSlug(String slug) {
    if (slug.isEmpty) {
      return 'Workspace slug cannot be empty';
    }
    
    if (slug.length < 2) {
      return 'Workspace slug must be at least 2 characters';
    }
    
    if (slug.length > 30) {
      return 'Workspace slug must be less than 30 characters';
    }
    
    // Check for valid slug pattern
    final slugPattern = RegExp(r'^[a-z0-9-]+$');
    if (!slugPattern.hasMatch(slug)) {
      return 'Workspace slug can only contain lowercase letters, numbers, and hyphens';
    }
    
    // Check for consecutive hyphens
    if (slug.contains('--')) {
      return 'Workspace slug cannot contain consecutive hyphens';
    }
    
    // Check for leading/trailing hyphens
    if (slug.startsWith('-') || slug.endsWith('-')) {
      return 'Workspace slug cannot start or end with a hyphen';
    }
    
    return null;
  }
}
