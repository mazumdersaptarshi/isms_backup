// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_attempts.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAttemptsAdapter extends TypeAdapter<UserAttempts> {
  @override
  final int typeId = 3;

  @override
  UserAttempts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAttempts(
      attemptId: fields[0] as String?,
      startTime: fields[1] as String?,
      endTime: fields[2] as String?,
      completionStatus: fields[3] as String?,
      score: fields[4] as int?,
      responses: (fields[5] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserAttempts obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.attemptId)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.completionStatus)
      ..writeByte(4)
      ..write(obj.score)
      ..writeByte(5)
      ..write(obj.responses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAttemptsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
