// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PremiumModelAdapter extends TypeAdapter<PremiumModel> {
  @override
  final int typeId = 5;

  @override
  PremiumModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PremiumModel(
      isPremium: fields[0] as bool,
      expireDate: fields[1] as DateTime?,
      purchaseToken: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PremiumModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isPremium)
      ..writeByte(1)
      ..write(obj.expireDate)
      ..writeByte(2)
      ..write(obj.purchaseToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PremiumModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
