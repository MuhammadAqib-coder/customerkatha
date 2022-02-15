import 'package:hive/hive.dart';

part 'customer_detail_list_hive.g.dart';

@HiveType(typeId: 1)
class CustomerDetailListHive extends HiveObject {
  @HiveField(0)
  String price;
  @HiveField(1)
  String date;
  @HiveField(2)
  String name;

  CustomerDetailListHive({required this.price, required this.date, required this.name});
}
