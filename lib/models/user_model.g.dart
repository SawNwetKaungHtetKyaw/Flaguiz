// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String?,
      username: fields[1] as String?,
      email: fields[2] as String?,
      country: fields[3] as String?,
      avatars: (fields[4] as List?)?.cast<String>(),
      borders: (fields[5] as List?)?.cast<String>(),
      backgrounds: (fields[6] as List?)?.cast<String>(),
      banners: (fields[7] as List?)?.cast<String>(),
      achievements: (fields[8] as List?)?.cast<String>(),
      trophy: fields[9] as int?,
      coin: fields[10] as int?,
      energy: fields[11] as int?,
      adventureCompletedList:
          (fields[12] as List?)?.cast<AdventureCompletedModel>(),
      challengeCompletedList:
          (fields[13] as List?)?.cast<ChallengeCompletedModel>(),
      friendIds: (fields[14] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.country)
      ..writeByte(4)
      ..write(obj.avatars)
      ..writeByte(5)
      ..write(obj.borders)
      ..writeByte(6)
      ..write(obj.backgrounds)
      ..writeByte(7)
      ..write(obj.banners)
      ..writeByte(8)
      ..write(obj.achievements)
      ..writeByte(9)
      ..write(obj.trophy)
      ..writeByte(10)
      ..write(obj.coin)
      ..writeByte(11)
      ..write(obj.energy)
      ..writeByte(12)
      ..write(obj.adventureCompletedList)
      ..writeByte(13)
      ..write(obj.challengeCompletedList)
      ..writeByte(14)
      ..write(obj.friendIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
