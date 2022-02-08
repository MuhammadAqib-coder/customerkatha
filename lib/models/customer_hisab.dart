import 'package:hive/hive.dart';

part 'customer_hisab.g.dart';

@HiveType(typeId: 0)
class CustomerHisab extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int? price;

  @HiveField(2)
  String date;

  CustomerHisab({required this.name, this.price, required this.date});
}
