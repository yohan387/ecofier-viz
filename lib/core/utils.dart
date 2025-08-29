String? phoneNumberValidator(p0) {
  if (p0 == null || p0.isEmpty) {
    return 'Le numéro de téléphone est requis';
  }

  if (p0.length != 10) {
    return '10 chiffres max';
  }
  return null;
}
