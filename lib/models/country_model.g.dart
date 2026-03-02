// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryModelAdapter extends TypeAdapter<CountryModel> {
  @override
  final int typeId = 3;

  @override
  CountryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountryModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      flagUrl: fields[2] as String?,
      mapUrl: fields[3] as String?,
      currency: fields[4] as String?,
      region: fields[5] as String?,
      capital: fields[6] as String?,
      description: fields[7] as String?,
      popularPlaces: (fields[8] as List?)?.cast<String>(),
      similarFlags: (fields[9] as List?)?.cast<String>(),
      createdAt: fields[10] as String?,
      updatedAt: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CountryModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.flagUrl)
      ..writeByte(3)
      ..write(obj.mapUrl)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.region)
      ..writeByte(6)
      ..write(obj.capital)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.popularPlaces)
      ..writeByte(9)
      ..write(obj.similarFlags)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
