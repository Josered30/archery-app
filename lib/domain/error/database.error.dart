class DatabaseError implements Exception {
  String cause;
  DatabaseError(this.cause);

  @override
  String toString() {
    return cause;
  }
}
