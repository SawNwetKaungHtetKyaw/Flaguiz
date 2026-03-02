// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adventure_completed_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdventureCompletedModelAdapter
    extends TypeAdapter<AdventureCompletedModel> {
  @override
  final int typeId = 2;

  @override
  AdventureCompletedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdventureCompletedModel(
      levelId: fields[0] as String?,
      life: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AdventureCompletedModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.levelId)
      ..writeByte(1)
      ..write(obj.life);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdventureCompletedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
