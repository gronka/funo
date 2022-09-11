class ToDoException implements Exception {
  String cause;
  ToDoException(this.cause);
}

class ImpossibleException implements Exception {
  String cause;
  ImpossibleException(this.cause);
}
