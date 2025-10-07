class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    // Check for at least one uppercase letter
    if (!value.contains(RegExp('[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    // Check for at least one lowercase letter
    if (!value.contains(RegExp('[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    // Check for at least one digit
    if (!value.contains(RegExp('[0-9]'))) {
      return 'Password must contain at least one digit';
    }
    
    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  // Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Name validation
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    return null;
  }

  // Company name validation
  static String? companyName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company name is required';
    }
    
    if (value.length < 2) {
      return 'Company name must be at least 2 characters long';
    }
    
    if (value.length > 100) {
      return 'Company name must be less than 100 characters';
    }
    
    return null;
  }

  // Department name validation
  static String? departmentName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Department name is required';
    }
    
    if (value.length < 2) {
      return 'Department name must be at least 2 characters long';
    }
    
    if (value.length > 50) {
      return 'Department name must be less than 50 characters';
    }
    
    return null;
  }

  // Task title validation
  static String? taskTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Task title is required';
    }
    
    if (value.isEmpty) {
      return 'Task title must be at least 1 character long';
    }
    
    if (value.length > 100) {
      return 'Task title must be less than 100 characters';
    }
    
    return null;
  }

  // Task description validation
  static String? taskDescription(String? value) {
    if (value != null && value.length > 500) {
      return 'Task description must be less than 500 characters';
    }
    
    return null;
  }

  // Phone number validation
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone number is optional
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length < 10) {
      return 'Please enter a valid phone number';
    }
    
    if (digitsOnly.length > 15) {
      return 'Phone number is too long';
    }
    
    return null;
  }

  // URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  // Date validation
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }
    
    try {
      DateTime.parse(value);
      return null;
    } on FormatException {
      return 'Please enter a valid date';
    }
  }

  // Future date validation
  static String? futureDate(String? value) {
    final dateError = date(value);
    if (dateError != null) {
      return dateError;
    }
    
    final selectedDate = DateTime.parse(value!);
    final now = DateTime.now();
    
    if (selectedDate.isBefore(now)) {
      return 'Date must be in the future';
    }
    
    return null;
  }

  // Past date validation
  static String? pastDate(String? value) {
    final dateError = date(value);
    if (dateError != null) {
      return dateError;
    }
    
    final selectedDate = DateTime.parse(value!);
    final now = DateTime.now();
    
    if (selectedDate.isAfter(now)) {
      return 'Date must be in the past';
    }
    
    return null;
  }

  // Number validation
  static String? number(String? value, {int? min, int? max}) {
    if (value == null || value.isEmpty) {
      return 'Number is required';
    }
    
    final number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    
    if (min != null && number < min) {
      return 'Number must be at least $min';
    }
    
    if (max != null && number > max) {
      return 'Number must be at most $max';
    }
    
    return null;
  }

  // Positive number validation
  static String? positiveNumber(String? value) {
    return number(value, min: 1);
  }

  // Percentage validation
  static String? percentage(String? value) {
    return number(value, min: 0, max: 100);
  }
}
