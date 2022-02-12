// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_detail_list_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerDetailListHiveAdapter
    extends TypeAdapter<CustomerDetailListHive> {
  @override
  final int typeId = 1;

  @override
  CustomerDetailListHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerDetailListHive(
      price: fields[0] as int,
      date: fields[1] as String,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerDetailListHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.price)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerDetailListHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
