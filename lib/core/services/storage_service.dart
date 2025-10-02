import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();
  
  StorageService._();

  late SharedPreferences _prefs;
  late Box _userBox;
  late Box _settingsBox;
  late Box _tasksBox;
  late Box _reportsBox;

  // Initialize storage service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Initialize Hive boxes
    _userBox = await Hive.openBox('user_box');
    _settingsBox = await Hive.openBox('settings_box');
    _tasksBox = await Hive.openBox('tasks_box');
    _reportsBox = await Hive.openBox('reports_box');
  }

  // SharedPreferences methods
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Hive methods for user data
  Future<void> setUserData(String key, dynamic value) async {
    await _userBox.put(key, value);
  }

  T? getUserData<T>(String key) {
    return _userBox.get(key);
  }

  Future<void> removeUserData(String key) async {
    await _userBox.delete(key);
  }

  Future<void> clearUserData() async {
    await _userBox.clear();
  }

  // Hive methods for settings
  Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  T? getSetting<T>(String key) {
    return _settingsBox.get(key);
  }

  Future<void> removeSetting(String key) async {
    await _settingsBox.delete(key);
  }

  Future<void> clearSettings() async {
    await _settingsBox.clear();
  }

  // Hive methods for tasks
  Future<void> setTask(String key, dynamic value) async {
    await _tasksBox.put(key, value);
  }

  T? getTask<T>(String key) {
    return _tasksBox.get(key);
  }

  List<T> getAllTasks<T>() {
    return _tasksBox.values.cast<T>().toList();
  }

  Future<void> removeTask(String key) async {
    await _tasksBox.delete(key);
  }

  Future<void> clearTasks() async {
    await _tasksBox.clear();
  }

  // Hive methods for reports
  Future<void> setReport(String key, dynamic value) async {
    await _reportsBox.put(key, value);
  }

  T? getReport<T>(String key) {
    return _reportsBox.get(key);
  }

  List<T> getAllReports<T>() {
    return _reportsBox.values.cast<T>().toList();
  }

  Future<void> removeReport(String key) async {
    await _reportsBox.delete(key);
  }

  Future<void> clearReports() async {
    await _reportsBox.clear();
  }

  // Convenience methods for common data
  Future<void> setUserToken(String token) async {
    await setString('user_token', token);
  }

  String? getUserToken() {
    return getString('user_token');
  }

  Future<void> setUserId(String userId) async {
    await setString('user_id', userId);
  }

  String? getUserId() {
    return getString('user_id');
  }

  Future<void> setCompanyId(String companyId) async {
    await setString('company_id', companyId);
  }

  String? getCompanyId() {
    return getString('company_id');
  }

  Future<void> setDepartmentId(String departmentId) async {
    await setString('department_id', departmentId);
  }

  String? getDepartmentId() {
    return getString('department_id');
  }

  Future<void> setUserRole(String role) async {
    await setString('user_role', role);
  }

  String? getUserRole() {
    return getString('user_role');
  }

  Future<void> setThemeMode(String mode) async {
    await setString('theme_mode', mode);
  }

  String? getThemeMode() {
    return getString('theme_mode');
  }

  Future<void> setLanguage(String language) async {
    await setString('language', language);
  }

  String? getLanguage() {
    return getString('language');
  }

  Future<void> setIsFirstLaunch(bool isFirst) async {
    await setBool('is_first_launch', isFirst);
  }

  bool? getIsFirstLaunch() {
    return getBool('is_first_launch');
  }

  // Clear all data (logout)
  Future<void> clearAllData() async {
    await clear();
    await clearUserData();
    await clearSettings();
    await clearTasks();
    await clearReports();
  }

  // Get storage size
  Future<int> getStorageSize() async {
    int size = 0;
    
    // SharedPreferences size (approximate)
    final keys = _prefs.getKeys();
    for (final key in keys) {
      final value = _prefs.get(key);
      if (value is String) {
        size += key.length + value.length;
      }
    }
    
    // Hive boxes size
    size += _userBox.length;
    size += _settingsBox.length;
    size += _tasksBox.length;
    size += _reportsBox.length;
    
    return size;
  }

  // Check if storage is available
  bool get isStorageAvailable {
    return _prefs != null && _userBox.isOpen;
  }

  // Close all boxes
  Future<void> close() async {
    await _userBox.close();
    await _settingsBox.close();
    await _tasksBox.close();
    await _reportsBox.close();
  }
}
