enum BowType { none, recurve, compound }

extension BowTypeExtension on BowType {
  String get name {
    switch (this) {
      case BowType.none:
        return 'None';
      case BowType.recurve:
        return 'Recurve';
      case BowType.compound:
        return 'Compound';
      default:
        return 'None';
    }
  }
}
