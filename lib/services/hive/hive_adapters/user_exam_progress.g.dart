// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_exam_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserExamProgressHiveAdapter extends TypeAdapter<UserExamProgressHive> {
  @override
  final int typeId = 2;

  @override
  UserExamProgressHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserExamProgressHive(
      courseId: fields[0] as String?,
      examId: fields[1] as String?,
      attempts: (fields[2] as List?)?.cast<dynamic>(),
      completionStatus: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserExamProgressHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.courseId)
      ..writeByte(1)
      ..write(obj.examId)
      ..writeByte(2)
      ..write(obj.attempts)
      ..writeByte(3)
      ..write(obj.completionStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserExamProgressHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
