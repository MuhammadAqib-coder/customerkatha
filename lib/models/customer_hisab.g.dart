// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_hisab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerHisabAdapter extends TypeAdapter<CustomerHisab> {
  @override
  final int typeId = 0;

  @override
  CustomerHisab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerHisab(
      name: fields[0] as String,
      price: fields[1] as int,
      date: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerHisab obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerHisabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
