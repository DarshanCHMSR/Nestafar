/// Validation utilities for forms and input fields
class ValidationUtils {
  /// Validates phone number format
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Check if it has 10 digits (US format)
    if (digitsOnly.length != 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    
    return null;
  }
  
  /// Validates customer name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    // Check if contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    
    return null;
  }
  
  /// Validates delivery address
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    
    if (value.length < 10) {
      return 'Please enter a complete address';
    }
    
    if (value.length > 200) {
      return 'Address must be less than 200 characters';
    }
    
    return null;
  }
  
  /// Validates landmark (optional field)
  static String? validateLandmark(String? value) {
    if (value != null && value.length > 100) {
      return 'Landmark must be less than 100 characters';
    }
    
    return null;
  }
  
  /// Validates delivery instructions (optional field)
  static String? validateDeliveryInstructions(String? value) {
    if (value != null && value.length > 250) {
      return 'Instructions must be less than 250 characters';
    }
    
    return null;
  }
}