import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'hive_service.dart';

class TermModel extends Equatable {
  final String id;
  final String title;
  final String markdownContent;

  const TermModel({
    required this.id,
    required this.title,
    required this.markdownContent,
  });

  @override
  List<Object?> get props => [id, title, markdownContent];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'markdownContent': markdownContent,
  };

  factory TermModel.fromJson(Map<String, dynamic> json) => TermModel(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    markdownContent: json['markdownContent'] as String? ?? '',
  );
}

@lazySingleton
class TermHiveRepository {
  final Box _box;

  TermHiveRepository() : _box = Hive.box(HiveService.termsBoxName);

  // ---------- Write ----------

  Future<void> save(TermModel term) async {
    await _box.put(term.id, jsonEncode(term.toJson()));
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> deleteAll() async {
    await _box.clear();
  }

  // ---------- Read ----------

  TermModel? getById(String id) {
    final raw = _box.get(id);
    if (raw == null) return null;
    return TermModel.fromJson(jsonDecode(raw as String));
  }

  List<TermModel> getAll() {
    return _box.values
        .whereType<String>()
        .map((raw) => TermModel.fromJson(jsonDecode(raw)))
        .toList();
  }
}
