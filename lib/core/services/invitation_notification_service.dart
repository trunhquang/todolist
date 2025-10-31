import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/services/firebase_database_service_enhanced.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/invitations/domain/entities/invitation.dart';

/// Service to handle invitation notifications and pending invitations
class InvitationNotificationService {
  static InvitationNotificationService? _instance;
  static InvitationNotificationService get instance => _instance ??= InvitationNotificationService._();
  
  InvitationNotificationService._();

  /// Get pending invitations for current user (excluding revoked and accepted)
  Future<List<Invitation>> getPendingInvitationsForCurrentUser() async {
    try {
      final databaseService = Get.find<FirebaseDatabaseServiceEnhanced>();
      
      // Get current user's email
      final userEmail = await _getCurrentUserEmail();
      if (userEmail == null) return [];
      
      // Get all invitations for this email
      final allInvitationsData = await databaseService.getPendingInvitationsForUser(userEmail);
      
      // Convert to Invitation entities and filter out revoked/accepted
      final pendingInvitations = <Invitation>[];
      for (final invitationData in allInvitationsData) {
        try {
          final invitation = Invitation.fromMap(invitationData);
          
          // Only include invitations that are not revoked and isWaiting
          if (!invitation.isRevoked && invitation.isWaiting) {
            pendingInvitations.add(invitation);
          }
        } catch (e) {
          debugPrint('$e');
          continue;
        }
      }
      
      return pendingInvitations;
    } catch (e) {
      debugPrint('$e');
      return [];
    }
  }

  /// Get current user email
  Future<String?> _getCurrentUserEmail() async {
    try {
      final authController = Get.find<AuthController>();
      final user = authController.currentUser;
      return user?.email;
    } catch (e) {
      return null;
    }
  }
}
