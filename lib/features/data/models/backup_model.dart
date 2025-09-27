
import 'package:authenticator/features/domain/entity/backup_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BackupModel extends BackupEntity {
  const BackupModel({
    required super.backup,
    required super.userId,
    super.updatedAt,
  });

  factory BackupModel.fromJson(Map<String, dynamic> json) {
    return BackupModel(
      backup: json['backup'] ?? false,
      userId: json['userId'] ?? '',
      updatedAt:
          json['updatedAt'] != null
              ? (json['updatedAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"backup": backup, "userId": userId, "updatedAt": updatedAt};
  }

  BackupEntity toEntity() =>
      BackupEntity(backup: backup, userId: userId, updatedAt: updatedAt);
}
