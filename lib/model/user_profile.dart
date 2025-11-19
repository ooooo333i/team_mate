class UserProfile {
  final int studentId;
  final String name;
  final String major;
  final int grade;
  final List<String> techStack;
  final String applicationField;
  final String simpleInfo;
  final String contactInfo;
  final String additionalInfo;
  final bool visibility;

  UserProfile({
    required this.studentId,
    required this.name,
    required this.major,
    required this.grade,
    required this.techStack,
    required this.applicationField,
    required this.simpleInfo,
    required this.contactInfo,
    required this.additionalInfo,
    required this.visibility,
  });

  Map<String, dynamic> toJson() {
    return {
      "studentId": studentId,
      "name": name,
      "major": major,
      "grade": grade,
      "techStack": techStack,
      "applicationField": applicationField,
      "simpleInfo": simpleInfo,
      "contactInfo": contactInfo,
      "additionalInfo": additionalInfo,
      "visibility": visibility,
    };
  }
}