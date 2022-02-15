// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variable_value_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VariableValueAdapter extends TypeAdapter<VariableValue> {
  @override
  final int typeId = 2;

  @override
  VariableValue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VariableValue(
      name: fields[0] as String,
      total: fields[1] as int,
      advance: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, VariableValue obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.total)
      ..writeByte(2)
      ..write(obj.advance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariableValueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
