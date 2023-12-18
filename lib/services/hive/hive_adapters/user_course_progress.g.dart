// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_course_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCourseProgressHiveAdapter
    extends TypeAdapter<UserCourseProgressHive> {
  @override
  final int typeId = 1;

  @override
  UserCourseProgressHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCourseProgressHive(
      courseId: fields[0] as String?,
      courseTitle: fields[1] as String?,
      startStatus: fields[8] as String?,
      completionStatus: fields[2] as String?,
      currentSectionId: fields[3] as String?,
      sections: (fields[4] as Map?)?.cast<dynamic, dynamic>(),
      attempts: (fields[5] as List?)?.cast<dynamic>(),
      scores: (fields[6] as List?)?.cast<dynamic>(),
      currentSection: (fields[7] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserCourseProgressHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.courseId)
      ..writeByte(1)
      ..write(obj.courseTitle)
      ..writeByte(2)
      ..write(obj.completionStatus)
      ..writeByte(3)
      ..write(obj.currentSectionId)
      ..writeByte(4)
      ..write(obj.sections)
      ..writeByte(5)
      ..write(obj.attempts)
      ..writeByte(6)
      ..write(obj.scores)
      ..writeByte(7)
      ..write(obj.currentSection)
      ..writeByte(8)
      ..write(obj.startStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCourseProgressHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
