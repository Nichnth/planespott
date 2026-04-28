class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // Display name validation
  static String? validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Display name cannot be empty';
    }

    if (value.length < 2) {
      return 'Display name must be at least 2 characters';
    }

    if (value.length > 50) {
      return 'Display name must be less than 50 characters';
    }

    return null;
  }

  // Aircraft type validation
  static String? validateAircraftType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Aircraft type cannot be empty';
    }

    if (value.length < 2) {
      return 'Aircraft type must be at least 2 characters';
    }

    return null;
  }

  // Airline validation
  static String? validateAirline(String? value) {
    if (value == null || value.isEmpty) {
      return 'Airline cannot be empty';
    }

    if (value.length < 2) {
      return 'Airline must be at least 2 characters';
    }

    return null;
  }

  // Notes validation (optional but max length)
  static String? validateNotes(String? value) {
    if (value != null && value.length > 500) {
      return 'Notes must be less than 500 characters';
    }

    return null;
  }

  // Flight number validation (optional)
  static String? validateFlightNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    if (value.length > 10) {
      return 'Flight number must be less than 10 characters';
    }

    return null;
  }
}

