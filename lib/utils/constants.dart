// App theme colors
class AppColors {
  static const primary = 0xFF2563EB; // Blue
  static const secondary = 0xFF10B981; // Green
  static const accent = 0xFFF59E0B; // Amber
  static const background = 0xFFF9FAFB; // Light Gray
  static const surface = 0xFFFFFFFF; // White
  static const error = 0xFFEF4444; // Red
  static const success = 0xFF10B981; // Green
  static const warning = 0xFFF59E0B; // Amber
  static const info = 0xFF3B82F6; // Light Blue
  static const textPrimary = 0xFF111827; // Dark Gray
  static const textSecondary = 0xFF6B7280; // Gray
  static const border = 0xFFE5E7EB; // Light Border
}

// App strings
class AppStrings {
  // Authentication
  static const appTitle = 'PlaneSpott';
  static const appTagline = 'Capture the Skies';
  static const loginTitle = 'Login';
  static const signupTitle = 'Sign Up';
  static const loginEmail = 'Email';
  static const loginPassword = 'Password';
  static const loginButton = 'Login';
  static const signupButton = 'Sign Up';
  static const forgotPassword = 'Forgot Password?';
  static const noAccount = "Don't have an account?";
  static const haveAccount = 'Already have an account?';
  static const displayName = 'Display Name';

  // Sightings
  static const mySightings = 'My Sightings';
  static const addSighting = 'Add Sighting';
  static const editSighting = 'Edit Sighting';
  static const deleteSighting = 'Delete';
  static const confirmDelete = 'Are you sure you want to delete this sighting?';
  static const aircraftType = 'Aircraft Type';
  static const airline = 'Airline';
  static const flightNumber = 'Flight Number';
  static const notes = 'Notes';
  static const uploaded = 'Uploaded';
  static const noSightings = 'No sightings yet';
  static const addFirstSighting = 'Take your first airplane photo!';

  // Camera
  static const takePhoto = 'Take Photo';
  static const pickFromGallery = 'Pick from Gallery';
  static const retake = 'Retake';
  static const capturePhoto = 'Capture Photo';
  static const cameraError = 'Error accessing camera';

  // Location
  static const location = 'Location';
  static const currentLocation = 'Current Location';
  static const altitude = 'Altitude';
  static const speed = 'Speed';
  static const accuracy = 'Accuracy';
  static const enableLocation = 'Enable Location Services';
  static const locationDisabled = 'Location services are disabled';

  // Generic
  static const save = 'Save';
  static const cancel = 'Cancel';
  static const delete = 'Delete';
  static const edit = 'Edit';
  static const loading = 'Loading...';
  static const error = 'Error';
  static const success = 'Success';
  static const retry = 'Retry';
  static const logout = 'Logout';
  static const settings = 'Settings';
  static const profile = 'Profile';
  static const noInternet = 'No Internet Connection';
  static const tryAgain = 'Try Again';
  static const emptyField = 'This field cannot be empty';
}

// App sizing
class AppSizing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Border Radius
  static const double borderRadiusSm = 4.0;
  static const double borderRadiusMd = 8.0;
  static const double borderRadiusLg = 12.0;
  static const double borderRadiusXl = 16.0;

  // Icon sizes
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
}

// Durations
class AppDurations {
  static const shortDuration = Duration(milliseconds: 200);
  static const normalDuration = Duration(milliseconds: 300);
  static const longDuration = Duration(milliseconds: 500);
  static const veryLongDuration = Duration(milliseconds: 1000);
}

