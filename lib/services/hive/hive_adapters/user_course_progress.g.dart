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
      completionStatus: fields[1] as String?,
      currentSection: fields[2] as String?,
      completedSections: (fields[3] as List?)?.cast<dynamic>(),
      completedExams: (fields[4] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserCourseProgressHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.courseId)
      ..writeByte(1)
      ..write(obj.completionStatus)
      ..writeByte(2)
      ..write(obj.currentSection)
      ..writeByte(3)
      ..write(obj.completedSections)
      ..writeByte(4)
      ..write(obj.completedExams);
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
