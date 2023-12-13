// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_course_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCourseprogressHiveAdapter
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
      courseName: fields[1] as String?,
      completionStatus: fields[2] as String?,
      currentSectionId: fields[3] as String?,
      sectionProgressList: (fields[4] as List?)?.cast<dynamic>(),
      attempts: (fields[5] as List?)?.cast<dynamic>(),
      scores: (fields[6] as List?)?.cast<dynamic>(),
      currentSection: (fields[7] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserCourseProgressHive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.courseId)
      ..writeByte(1)
      ..write(obj.courseName)
      ..writeByte(2)
      ..write(obj.completionStatus)
      ..writeByte(3)
      ..write(obj.currentSectionId)
      ..writeByte(4)
      ..write(obj.sectionProgressList)
      ..writeByte(5)
      ..write(obj.attempts)
      ..writeByte(6)
      ..write(obj.scores)
      ..writeByte(7)
      ..write(obj.currentSection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCourseprogressHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
