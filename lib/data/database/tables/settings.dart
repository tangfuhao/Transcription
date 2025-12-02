import 'package:drift/drift.dart';

/// 應用設置表
class AppSettings extends Table {
  /// 設置 Key
  TextColumn get key => text()();

  /// 設置值
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

