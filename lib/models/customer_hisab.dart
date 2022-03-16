import 'package:hive/hive.dart';

part 'customer_hisab.g.dart';

@HiveType(typeId: 0)
class CustomerHisab extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;


  CustomerHisab({required this.name, required this.description, state});
}
