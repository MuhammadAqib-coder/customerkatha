class VaraibleState {
  int? id;
  int userId;
  int total;
  int advance;

  VaraibleState(
      {this.id, required this.userId, required this.total, required this.advance});

  int get getName {
    return userId;
  }

  int get getTotal {
    return total;
  }

  int get getAdvance {
    return advance;
  }

  set setName(int userId) {
    this.userId = userId;
  }

  set setTotal(int total) {
    this.total = total;
  }

  set setAdvance(int advance) {
    this.advance = advance;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "user_id": userId,
      "total": total,
      'advance': advance
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
