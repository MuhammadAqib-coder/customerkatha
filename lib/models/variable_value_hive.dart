import 'package:hive/hive.dart';

part 'variable_value_hive.g.dart';

@HiveType(typeId: 2)
class VariableValue extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  int total;
  @HiveField(2)
  int advance;

  VariableValue({required this.name, required this.total, required this.advance});
}
