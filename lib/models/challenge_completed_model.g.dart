// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_completed_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChallengeCompletedModelAdapter
    extends TypeAdapter<ChallengeCompletedModel> {
  @override
  final int typeId = 1;

  @override
  ChallengeCompletedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChallengeCompletedModel(
      mode: fields[0] as String?,
      complete: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChallengeCompletedModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.mode)
      ..writeByte(1)
      ..write(obj.complete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeCompletedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
