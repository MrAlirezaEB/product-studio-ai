class Project {
  final String id;
  final String originalImagePath;
  final String? generatedImagePath;
  final String vibeName;
  final DateTime createdAt;

  const Project({
    required this.id,
    required this.originalImagePath,
    this.generatedImagePath,
    required this.vibeName,
    required this.createdAt,
  });

  Project copyWith({
    String? id,
    String? originalImagePath,
    String? generatedImagePath,
    String? vibeName,
    DateTime? createdAt,
  }) {
    return Project(
      id: id ?? this.id,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      generatedImagePath: generatedImagePath ?? this.generatedImagePath,
      vibeName: vibeName ?? this.vibeName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
