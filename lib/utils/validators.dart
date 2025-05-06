String? validateContact(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your contact number';
  }
  if (!RegExp(r'^9[0-9]{9}$').hasMatch(value)) {
    return 'Invalid contact number';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  // Add more password validation rules here if needed
  return null;
}

String? validateConfirmPassword(String? value, String? password) {
  if (value == null || value.isEmpty) {
    return 'Please enter your confirm password';
  }

  if (value != password) {
    return 'Passwords do not match';
  }

  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    // Email is optional, so no error if it's empty
    return "Please enter your email";
  }

  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Invalid email format';
  }

  return null;
}

String? validateFullName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your full name';
  }

  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
    return 'Full name should only contain alphabets';
  }

  return null;
}

//not empty field
String? validateNotEmpty(String? value, String fieldName) {
  if (value == null || value.isEmpty) {
    return 'Please enter your $fieldName';
  }
  return null;
}
