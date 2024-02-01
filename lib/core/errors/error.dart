class GeneralError implements Exception {
  final String message; // user
  final StackTrace? stackTrace; // developer

  GeneralError(this.message, [this.stackTrace]);
}
