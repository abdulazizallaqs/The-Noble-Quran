import 'dart:convert';

enum PlanType { reading, memorizing }

class PlanModel {
  final String id;
  final PlanType type;
  final String targetSurahName;
  final int targetSurahIndex; // 0-113
  final String note;
  bool isCompleted;

  PlanModel({
    required this.id,
    required this.type,
    required this.targetSurahName,
    required this.targetSurahIndex,
    required this.note,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'targetSurahName': targetSurahName,
      'targetSurahIndex': targetSurahIndex,
      'note': note,
      'isCompleted': isCompleted,
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      id: map['id'],
      type: PlanType.values[map['type']],
      targetSurahName: map['targetSurahName'],
      targetSurahIndex: map['targetSurahIndex'],
      note: map['note'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanModel.fromJson(String source) =>
      PlanModel.fromMap(json.decode(source));
}
