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
      playerID: fields[1] as String?,
      username: fields[2] as String?,
      email: fields[3] as String?,
      country: fields[4] as String?,
      avatars: (fields[5] as List?)?.cast<String>(),
      borders: (fields[6] as List?)?.cast<String>(),
      backgrounds: (fields[7] as List?)?.cast<String>(),
      banners: (fields[8] as List?)?.cast<String>(),
      achievements: (fields[9] as List?)?.cast<String>(),
      trophy: fields[10] as int?,
      coin: fields[11] as int?,
      energy: fields[12] as int?,
      adventureCompletedList:
          (fields[13] as List?)?.cast<AdventureCompletedModel>(),
      challengeCompletedList:
          (fields[14] as List?)?.cast<ChallengeCompletedModel>(),
      friendIds: (fields[15] as List?)?.cast<String>(),
      hasPremium: fields[16] as bool?,
      updatedAt: fields[17] as DateTime?,
      syncedAt: fields[18] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playerID)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(5)
      ..write(obj.avatars)
      ..writeByte(6)
      ..write(obj.borders)
      ..writeByte(7)
      ..write(obj.backgrounds)
      ..writeByte(8)
      ..write(obj.banners)
      ..writeByte(9)
      ..write(obj.achievements)
      ..writeByte(10)
      ..write(obj.trophy)
      ..writeByte(11)
      ..write(obj.coin)
      ..writeByte(12)
      ..write(obj.energy)
      ..writeByte(13)
      ..write(obj.adventureCompletedList)
      ..writeByte(14)
      ..write(obj.challengeCompletedList)
      ..writeByte(15)
      ..write(obj.friendIds)
      ..writeByte(16)
      ..write(obj.hasPremium)
      ..writeByte(17)
      ..write(obj.updatedAt)
      ..writeByte(18)
      ..write(obj.syncedAt);
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
