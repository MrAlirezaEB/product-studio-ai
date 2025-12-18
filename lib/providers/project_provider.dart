import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';

class ProjectNotifier extends Notifier<List<Project>> {
  @override
  List<Project> build() => [];

  void addProject(Project project) {
    state = [project, ...state];
  }

  void updateProject(Project updatedProject) {
    state = [
      for (final project in state)
        if (project.id == updatedProject.id) updatedProject else project,
    ];
  }

  void deleteProject(String projectId) {
    state = state.where((project) => project.id != projectId).toList();
  }
}

final projectProvider = NotifierProvider<ProjectNotifier, List<Project>>(
  ProjectNotifier.new,
);
