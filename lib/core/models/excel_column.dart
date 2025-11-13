class ExcelColumn {
  final String displayName;
  final String key;
  final bool isDefaultColumn;

  const ExcelColumn({
    required this.displayName,
    required this.key,
    this.isDefaultColumn = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExcelColumn && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}
