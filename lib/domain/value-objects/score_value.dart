class ScoreValue {
  String value;

  ScoreValue._({required this.value});

  static ScoreValue fromValue(String value) {
    RegExp exp = RegExp(r'^([XM]|\d)+$');
    String scoreValue = exp.hasMatch(value) ? value : 'M';

    RegExp digitExp = RegExp(r"^\d+$");
    if (!digitExp.hasMatch(scoreValue)) {
      return ScoreValue._(value: scoreValue);
    }

    int number = int.parse(value);
    if (number < 6) {
      scoreValue = 'M';
    }

    if (number > 10) {
      scoreValue = 'X';
    }

    return ScoreValue._(value: scoreValue);
  }

  @override
  String toString() {
    return value;
  }

  int get number {
    if (value == 'X') {
      return 11;
    }

    if (value == 'M') {
      return 0;
    }
    return int.parse(value);
  }
}
