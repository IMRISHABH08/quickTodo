String? validatePhoneNumber(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return 'PHONE NUMBER CANT EMPTY';
  } else if (value.length > 10) {
    return 'PLEASE ENTER VALID NUMBER';
  } else {
    return null;
  }
}

String? validatePassword(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return 'PASSWORD CANT EMPTY';
  } else if (value.length <= 5) {
    return 'PLEASE KEEP LENGTH MORE THAN 5';
  } else {
    return null;
  }
}

String? validateTitle(String? value) {
  if (value == null) {
    return null;
  }

  if (value.isEmpty) {
    return 'TITLE CANT BE EMPTY';
  } else {
    return null;
  }
}

String? validateDesc(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    //return 'DESCRITION CANT BE EMPTY';
  } else {
    return null;
  }
}
