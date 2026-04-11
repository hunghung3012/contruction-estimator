import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/datasource/local/shared_prederences/storage.dart';

import '../../data/request/status_request.dart';

class ProjectStatus extends Equatable {
  final String? id;
  final String? name;
  final int? count;

  const ProjectStatus({this.id, this.name, this.count});

  factory ProjectStatus.fromJson(Map<String, dynamic> json) => ProjectStatus(
    id: json["id"],
    name: json["name"],
    count: json["projectCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "projectCount": count,
  };

  @override
  List<Object?> get props => [id, name, count];
}

extension ProjectStatusX on ProjectStatus {
  Color? get color {
    switch (id?.toLowerCase().trim()) {
      case 'lead':
        return Colors.pinkAccent;
      case 'draft':
        return Colors.amber;
      case 'bidding':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'in progress':
        return Colors.indigo;
      case 'completed':
        return Colors.green;
      case 'archived':
        return Colors.grey;
    }

    //get color from local storage
    if (id != null) {
      final storedColors = AppStorage.statusColors;
      if (storedColors.containsKey(id!)) {
        return Color(storedColors[id!]!);
      }

      //random color and save to local storage
      final newColor = _generateRandomColor();
      AppStorage.setStatusColor(id!, newColor.value);
      return newColor;
    }

    return null;
  }

  Color _generateRandomColor() {
    return Color(
      (Random().nextDouble() * 0xFFFFFF).toInt(),
    ).withValues(alpha: 1.0);
  }

  ProjectStatusRequest toRequest() {
    return ProjectStatusRequest(statusId: id);
  }
}
