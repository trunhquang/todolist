# Backup Security: Encryption, Checksum, Retention/Auto-Cleanup - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Backup Security** feature. Currently, this feature is **MISSING** - Not implemented. Backup security should include: file encryption (mã hóa file backup), checksum signing (ký checksum), retention policy (retention), and auto-cleanup (auto-cleanup).

## Prerequisites
- User must be logged in
- User must have Account Holder or Admin role
- Workspace must exist
- Backup feature should be implemented (or test cases should document expected behavior)
- OneDrive authentication should be configured
- Backup feature UI should be accessible

---

## Test Case 1: Backup File Encryption - File is Encrypted

**Objective**: Verify that backup files are encrypted before being uploaded to OneDrive.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has:
  - At least 1 task
  - At least 1 project
  - Configured workspace settings
- Backup feature is implemented
- Encryption feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create backup:
   - **If NOT implemented**: Encryption is not performed (this is expected - feature missing)
   - **If implemented**: 
     - Ensure all scope options are checked
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed
     - Note the backup file name

3. Verify backup file is encrypted:
   - Download backup file from OneDrive
   - **If NOT implemented**: File is not encrypted (this is expected - feature missing)
   - **If implemented**: 
     - Verify file cannot be read as plain text:
       - Try to open file in text editor
       - File should appear as encrypted (binary/encoded data)
       - File should not contain readable JSON
     - Verify file has encryption indicator:
       - File extension may indicate encryption (e.g., `.enc`, `.aes`)
       - OR file metadata indicates encryption
       - OR file header contains encryption information

4. Verify encryption is applied:
   - Check backup process logs (if available):
     - Log should indicate encryption is being applied
     - Log should show encryption algorithm used (e.g., AES-256)
     - Log should show encryption key generation
   - Verify encryption doesn't break backup:
     - Backup completes successfully
     - Backup file is uploaded to OneDrive
     - Backup file can be downloaded

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Backup file encryption is NOT implemented (missing)
- ✅ **When implemented**: Backup files are encrypted before upload
- ✅ Encrypted files cannot be read as plain text
- ✅ Encryption algorithm is secure (e.g., AES-256)
- ✅ Encryption doesn't break backup process
- ✅ Backup file can be decrypted during restore

---

## Test Case 2: Backup File Decryption - Encrypted File Can Be Decrypted

**Objective**: Verify that encrypted backup files can be decrypted during restore.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Encrypted backup file exists in OneDrive (created in Test Case 1)
- Restore feature is implemented
- Decryption feature is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Select encrypted backup file:
   - **If NOT implemented**: Decryption is not performed (this is expected - feature missing)
   - **If implemented**: 
     - View list of backup files
     - Verify encrypted backup file is shown (may have encryption indicator)
     - Select encrypted backup file
     - Verify backup file details are shown

3. Restore encrypted backup:
   - Tap on "Restore" button
   - Verify permission check passes
   - Confirm restore in confirmation dialog
   - Verify decryption process:
     - System attempts to decrypt backup file
     - Decryption key is retrieved (from secure storage or user input)
     - Decryption completes successfully
   - Wait for restore to complete
   - Verify success message is displayed

4. Verify decryption works correctly:
   - Verify decrypted data is valid:
     - Workspace settings are restored correctly
     - Projects are restored correctly
     - Tasks are restored correctly
   - Verify decryption errors are handled:
     - If decryption fails (wrong key, corrupted file), error message is displayed
     - Restore process doesn't proceed if decryption fails

5. Verify decryption security:
   - Decryption key is not logged or exposed
   - Decryption process is secure
   - Decrypted data is not stored insecurely

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Backup file decryption is NOT implemented (missing)
- ✅ **When implemented**: Encrypted backup files can be decrypted during restore
- ✅ Decryption works correctly
- ✅ Decrypted data is valid
- ✅ Decryption errors are handled gracefully
- ✅ Decryption process is secure

---

## Test Case 3: Backup File Checksum - Checksum is Calculated and Signed

**Objective**: Verify that backup files have checksum calculated and signed to ensure integrity.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has:
  - At least 1 task
  - At least 1 project
- Backup feature is implemented
- Checksum feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create backup:
   - **If NOT implemented**: Checksum is not calculated (this is expected - feature missing)
   - **If implemented**: 
     - Ensure all scope options are checked
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed
     - Note the backup file name

3. Verify checksum is calculated:
   - Check backup process logs (if available):
     - Log should indicate checksum is being calculated
     - Log should show checksum algorithm used (e.g., SHA-256, MD5)
     - Log should show checksum value
   - Verify checksum is stored:
     - Checksum is stored with backup file metadata
     - OR Checksum is stored in separate checksum file
     - OR Checksum is included in backup file header

4. Verify checksum is signed:
   - **If NOT implemented**: Checksum signing is not performed (this is expected - feature missing)
   - **If implemented**: 
     - Verify checksum is digitally signed:
       - Checksum signature is created
       - Signature is stored with backup file
       - Signature can be verified
     - Verify signature algorithm:
       - Signature algorithm is secure (e.g., RSA, ECDSA)
       - Signature key is securely stored

5. Verify checksum metadata:
   - Download backup file from OneDrive
   - Check backup file metadata (if available):
     - Checksum value is present
     - Checksum algorithm is specified
     - Signature is present (if signing is implemented)
   - Verify checksum can be verified:
     - Recalculate checksum of downloaded file
     - Compare with stored checksum
     - Checksums should match

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Backup file checksum is NOT implemented (missing)
- ✅ **When implemented**: Backup files have checksum calculated
- ✅ Checksum algorithm is secure (e.g., SHA-256)
- ✅ Checksum is stored with backup file
- ✅ Checksum can be verified
- ✅ Checksum is signed (if signing is implemented)

---

## Test Case 4: Backup File Integrity Verification - Checksum Verification During Restore

**Objective**: Verify that backup file integrity is verified using checksum during restore.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Backup file exists in OneDrive with checksum
- Restore feature is implemented
- Checksum verification is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Select backup file:
   - **If NOT implemented**: Checksum verification is not performed (this is expected - feature missing)
   - **If implemented**: 
     - View list of backup files
     - Select backup file with checksum
     - Verify backup file details show checksum information

3. Start restore process:
   - Tap on "Restore" button
   - Verify permission check passes
   - Confirm restore in confirmation dialog
   - Verify checksum verification:
     - System downloads backup file
     - System calculates checksum of downloaded file
     - System retrieves stored checksum
     - System compares calculated checksum with stored checksum

4. Verify checksum verification results:
   - **If checksums match**:
     - Verification passes
     - Restore process continues
     - Restore completes successfully
   - **If checksums don't match**:
     - Verification fails
     - Error message is displayed: "Backup file integrity check failed" or similar
     - Restore process is stopped
     - No data is restored

5. Test with corrupted backup file:
   - Manually corrupt backup file (if possible) or simulate corruption
   - Attempt to restore corrupted backup
   - Verify checksum verification detects corruption:
     - Checksum verification fails
     - Error message is displayed
     - Restore is prevented

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Checksum verification is NOT implemented (missing)
- ✅ **When implemented**: Backup file integrity is verified using checksum
- ✅ Checksum verification is performed before restore
- ✅ Corrupted backup files are detected
- ✅ Restore is prevented if checksum verification fails
- ✅ Error messages are clear and actionable

---

## Test Case 5: Backup Retention Policy - Old Backups are Retained According to Policy

**Objective**: Verify that backup retention policy is applied correctly, retaining backups for specified period.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Backup retention policy is configured (e.g., retain backups for 90 days)
- Multiple backup files exist in OneDrive with different dates:
  - Backup 1: 100 days ago (should be deleted)
  - Backup 2: 50 days ago (should be retained)
  - Backup 3: 10 days ago (should be retained)
- Retention policy feature is implemented
- User is on the backup/export screen or settings

**Steps**:
1. Navigate to backup settings or backup screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup Settings" option
   - Verify backup screen is displayed

2. View retention policy settings:
   - **If NOT implemented**: Retention policy is not configured (this is expected - feature missing)
   - **If implemented**: 
     - Navigate to "Retention Policy" or "Backup Settings"
     - Verify retention policy is displayed:
       - Retention period (e.g., 90 days, 1 year)
       - Retention policy type (e.g., keep all, keep latest N, keep by date)
       - Auto-cleanup enabled/disabled

3. Verify retention policy is applied:
   - Check list of backup files
   - Verify backups are retained according to policy:
     - Backups older than retention period are marked for deletion
     - OR Backups older than retention period are not shown
     - OR Backups older than retention period are shown but marked as "expired"
   - Verify backups within retention period are retained:
     - Backups within retention period are shown
     - Backups within retention period are accessible

4. Verify retention policy configuration:
   - Check if retention policy can be configured:
     - Retention period can be changed
     - Retention policy type can be selected
     - Auto-cleanup can be enabled/disabled
   - Verify retention policy is saved:
     - Changes to retention policy are saved
     - Retention policy is applied immediately or on next cleanup

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Backup retention policy is NOT implemented (missing)
- ✅ **When implemented**: Backup retention policy is applied correctly
- ✅ Backups are retained according to policy
- ✅ Retention policy is configurable
- ✅ Retention policy is saved and applied

---

## Test Case 6: Backup Auto-Cleanup - Old Backups are Automatically Deleted

**Objective**: Verify that old backups are automatically deleted according to retention policy.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Backup retention policy is configured (e.g., retain backups for 90 days)
- Auto-cleanup is enabled
- Multiple backup files exist in OneDrive:
  - Backup 1: 100 days ago (should be deleted)
  - Backup 2: 50 days ago (should be retained)
  - Backup 3: 10 days ago (should be retained)
- Auto-cleanup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Verify auto-cleanup is enabled:
   - **If NOT implemented**: Auto-cleanup is not available (this is expected - feature missing)
   - **If implemented**: 
     - Check backup settings
     - Verify "Auto-cleanup" is enabled
     - Verify retention period is configured

3. Trigger auto-cleanup (if manual trigger is available):
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Tap on "Run Cleanup" or "Cleanup Now" button (if available)
     - OR Wait for scheduled auto-cleanup to run
     - Verify cleanup process:
       - System identifies backups older than retention period
       - System deletes old backups
       - Cleanup process completes

4. Verify old backups are deleted:
   - Check list of backup files
   - Verify backups older than retention period are deleted:
     - Backup 1 (100 days ago) is no longer in the list
     - OR Backup 1 is marked as "deleted"
   - Verify backups within retention period are retained:
     - Backup 2 (50 days ago) is still in the list
     - Backup 3 (10 days ago) is still in the list

5. Verify cleanup is logged:
   - Check audit log or cleanup log (if available):
     - Cleanup operation is logged
     - Log shows which backups were deleted
     - Log shows cleanup date/time
     - Log shows retention policy used

6. Verify cleanup doesn't delete all backups:
   - Verify at least one backup is always retained (if policy requires)
   - Verify latest backup is always retained (if policy requires)
   - Verify cleanup doesn't delete backups that should be retained

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Backup auto-cleanup is NOT implemented (missing)
- ✅ **When implemented**: Old backups are automatically deleted
- ✅ Auto-cleanup respects retention policy
- ✅ Backups within retention period are retained
- ✅ Cleanup is logged
- ✅ Cleanup doesn't delete all backups

---

## Test Case 7: Backup Retention Policy - Keep Latest N Backups

**Objective**: Verify that retention policy "Keep Latest N Backups" works correctly.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Retention policy is configured to "Keep Latest 5 Backups"
- 10 backup files exist in OneDrive (with different dates)
- Retention policy feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Configure retention policy:
   - **If NOT implemented**: Retention policy is not available (this is expected - feature missing)
   - **If implemented**: 
     - Navigate to "Retention Policy" or "Backup Settings"
     - Select "Keep Latest N Backups" policy type
     - Set N = 5
     - Save retention policy

3. Verify retention policy is applied:
   - Check list of backup files
   - Verify only latest 5 backups are shown/retained:
     - 5 most recent backups are shown
     - 5 oldest backups are not shown (or marked for deletion)
   - Verify backups are sorted by date (most recent first)

4. Create new backup:
   - Create a new backup
   - Verify retention policy is applied:
     - New backup is added to the list
     - Oldest backup (6th backup) is deleted
     - Only latest 5 backups are retained

5. Verify policy is enforced:
   - Attempt to delete one of the retained backups manually
   - Verify system prevents deletion if it would violate retention policy
   - OR Verify system allows deletion but maintains minimum N backups

**Expected Results**:
- ⚠️ **CURRENT STATUS**: "Keep Latest N Backups" policy is NOT implemented (missing)
- ✅ **When implemented**: Only latest N backups are retained
- ✅ Retention policy is applied correctly
- ✅ Policy is enforced when new backups are created
- ✅ Minimum number of backups is maintained

---

## Test Case 8: Backup Retention Policy - Keep by Date Range

**Objective**: Verify that retention policy "Keep by Date Range" works correctly.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Retention policy is configured to "Keep Backups for 90 Days"
- Multiple backup files exist in OneDrive:
  - Backup 1: 100 days ago (should be deleted)
  - Backup 2: 80 days ago (should be retained)
  - Backup 3: 50 days ago (should be retained)
  - Backup 4: 10 days ago (should be retained)
- Retention policy feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Configure retention policy:
   - **If NOT implemented**: Retention policy is not available (this is expected - feature missing)
   - **If implemented**: 
     - Navigate to "Retention Policy" or "Backup Settings"
     - Select "Keep by Date Range" policy type
     - Set retention period = 90 days
     - Save retention policy

3. Verify retention policy is applied:
   - Check list of backup files
   - Verify backups older than 90 days are deleted/marked for deletion:
     - Backup 1 (100 days ago) is not shown or marked for deletion
   - Verify backups within 90 days are retained:
     - Backup 2 (80 days ago) is shown
     - Backup 3 (50 days ago) is shown
     - Backup 4 (10 days ago) is shown

4. Wait for auto-cleanup or trigger cleanup:
   - Wait for scheduled auto-cleanup
   - OR Trigger manual cleanup
   - Verify old backups are deleted:
     - Backup 1 is deleted
     - Other backups are retained

5. Verify date calculation:
   - Verify retention period is calculated from backup date
   - Verify backups are correctly identified as expired or not expired
   - Verify timezone is handled correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: "Keep by Date Range" policy is NOT implemented (missing)
- ✅ **When implemented**: Backups are retained based on date range
- ✅ Backups older than retention period are deleted
- ✅ Backups within retention period are retained
- ✅ Date calculation is accurate
- ✅ Timezone is handled correctly

---

## Test Case 9: Backup Security - Encryption Key Management

**Objective**: Verify that encryption keys are managed securely.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Backup encryption is implemented
- Encryption key management is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create backup with encryption:
   - **If NOT implemented**: Encryption key management is not available (this is expected - feature missing)
   - **If implemented**: 
     - Create a backup
     - Verify encryption key is generated:
       - Key is generated securely (using secure random)
       - Key is not logged or exposed
       - Key is stored securely (in secure storage or keychain)

3. Verify encryption key storage:
   - Check where encryption key is stored:
     - Key is stored in secure storage (e.g., Keychain, SecureStorage)
     - Key is not stored in plain text
     - Key is not accessible to other apps
   - Verify key is associated with backup:
     - Key is linked to backup file
     - Key can be retrieved for decryption

4. Verify key recovery (if implemented):
   - Test key recovery mechanism:
     - If key is lost, recovery process is available
     - OR Warning is shown if key cannot be recovered
   - Verify key backup (if implemented):
     - Encryption key can be backed up securely
     - Key backup is encrypted
     - Key backup can be restored

5. Verify key rotation (if implemented):
   - Test key rotation:
     - Old backups use old key
     - New backups use new key
     - Both keys are stored securely
   - Verify key rotation doesn't break old backups:
     - Old backups can still be decrypted with old key
     - New backups use new key

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Encryption key management is NOT implemented (missing)
- ✅ **When implemented**: Encryption keys are managed securely
- ✅ Keys are generated securely
- ✅ Keys are stored securely
- ✅ Keys are not exposed or logged
- ✅ Key recovery/backup works (if implemented)
- ✅ Key rotation works (if implemented)

---

## Test Case 10: Backup Security - Checksum Signature Verification

**Objective**: Verify that checksum signatures can be verified to ensure backup file authenticity.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Backup file exists in OneDrive with checksum signature
- Checksum signing is implemented
- Signature verification is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Select backup file with signature:
   - **If NOT implemented**: Signature verification is not performed (this is expected - feature missing)
   - **If implemented**: 
     - View list of backup files
     - Select backup file with checksum signature
     - Verify backup file details show signature information

3. Start restore process:
   - Tap on "Restore" button
   - Verify permission check passes
   - Confirm restore in confirmation dialog
   - Verify signature verification:
     - System retrieves checksum signature
     - System verifies signature using public key
     - System verifies signature matches checksum

4. Verify signature verification results:
   - **If signature is valid**:
     - Verification passes
     - Restore process continues
     - Restore completes successfully
   - **If signature is invalid**:
     - Verification fails
     - Error message is displayed: "Backup file signature verification failed" or similar
     - Restore process is stopped
     - No data is restored

5. Test with tampered backup file:
   - Manually tamper with backup file (if possible) or simulate tampering
   - Attempt to restore tampered backup
   - Verify signature verification detects tampering:
     - Signature verification fails
     - Error message is displayed
     - Restore is prevented

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Checksum signature verification is NOT implemented (missing)
- ✅ **When implemented**: Checksum signatures can be verified
- ✅ Signature verification is performed before restore
- ✅ Tampered backup files are detected
- ✅ Restore is prevented if signature verification fails
- ✅ Error messages are clear and actionable

---

## Summary

### Current Status: ⛔ MISSING
All backup security features are currently **NOT IMPLEMENTED**. No encryption, checksum signing, retention policy, or auto-cleanup functionality exists.

### What Needs to Be Implemented:
1. ✅ Backup file encryption (AES-256 or similar)
2. ✅ Backup file decryption during restore
3. ✅ Checksum calculation (SHA-256 or similar)
4. ✅ Checksum signing (RSA, ECDSA, or similar)
5. ✅ Checksum verification during restore
6. ✅ Retention policy configuration
7. ✅ Retention policy types (keep latest N, keep by date range)
8. ✅ Auto-cleanup functionality
9. ✅ Encryption key management
10. ✅ Signature verification

### Test Execution Notes:
- All test cases should be executed after implementation
- Test cases marked as "Missing Feature" should be updated once implemented
- Focus on security and data integrity
- Test with various scenarios (encryption, checksum, retention)
- Verify security measures don't break backup/restore functionality

### Security Considerations:
- **Critical**: Encryption and checksum are essential for backup security
- Encryption keys must be stored securely
- Checksum signatures must be verified
- Retention policy must be enforced
- Auto-cleanup must be safe and logged
- Security measures should not break backup/restore functionality

