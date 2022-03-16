class UserDetail {
  int? id;
  int userId;
  String price;
  String date;

  UserDetail({this.id, required this.userId, required this.price, required this.date});

  int get getName {
    return userId;
  }

  String get getPrice {
    return price;
  }

  String get getDate {
    return date;
  }

  set setName(int userId) {
    this.userId = userId;
  }

  set setPrice(String price) {
    this.price = price;
  }

  set setDate(String date) {
    this.date = date;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{"price": price, "date": date, "user_id": userId};
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}
