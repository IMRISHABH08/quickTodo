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
