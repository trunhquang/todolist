import 'package:todolist/core/constants/app_strings.dart';

/// Abstraction for sending emails (e.g., invitations)
abstract class EmailService {
  Future<bool> sendInvitationEmail({
    required String toEmail,
    required String workspaceId,
    required String invitedByUserId,
    required String invitationId,
    String? subject,
    String? body,
  });
}

/// Default no-op implementation placeholder
/// In production, implement via Firebase Functions / external provider.
class EmailServiceImpl implements EmailService {
  @override
  Future<bool> sendInvitationEmail({
    required String toEmail,
    required String workspaceId,
    required String invitedByUserId,
    required String invitationId,
    String? subject,
    String? body,
  }) async {
    // TODO: Integrate real email provider. This is a safe no-op returning success.
    // All user-facing text pulled from AppStrings.I.
    final _ = <String, String?>{
      'subject': subject ?? AppStrings.I.invitationEmailSubject,
      'body': body ?? AppStrings.I.invitationEmailBody,
    };
    return true;
  }
}


