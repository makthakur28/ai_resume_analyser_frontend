class ResumeOptimizationModel {
  final bool success;
  final String fileId;
  final String downloadUrl;
  final String previewUrl;
  final int atsScore;
  final List<String> optimizedSections;
  final List<String> recommendations;

  ResumeOptimizationModel({
    required this.success,
    required this.fileId,
    required this.downloadUrl,
    required this.previewUrl,
    required this.atsScore,
    required this.optimizedSections,
    required this.recommendations,
  });

  factory ResumeOptimizationModel.fromJson(Map<String, dynamic> json) {
    return ResumeOptimizationModel(
      success: json['success'] ?? false,
      fileId: json['file_id'] ?? '',
      downloadUrl: json['download_url'] ?? '',
      previewUrl: json['preview_url'] ?? '',
      atsScore: json['ats_score'] ?? 0,
      optimizedSections: List<String>.from(json['optimized_sections'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }
}

class ResumeAnalysisModel {
  final int atsScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> missingSkills;
  final List<String> improvementSuggestions;
  final String improvedProfessionalSummary;
  final List<String> recommendedProjects;
  final List<String> recommendedTechStack;

  ResumeAnalysisModel({
    required this.atsScore,
    required this.strengths,
    required this.weaknesses,
    required this.missingSkills,
    required this.improvementSuggestions,
    required this.improvedProfessionalSummary,
    required this.recommendedProjects,
    required this.recommendedTechStack,
  });

  factory ResumeAnalysisModel.fromJson(Map<String, dynamic> json) {
    return ResumeAnalysisModel(
      atsScore: json['ats_score'] ?? 0,
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      missingSkills: List<String>.from(json['missing_skills'] ?? []),
      improvementSuggestions: List<String>.from(json['improvement_suggestions'] ?? []),
      improvedProfessionalSummary: json['improved_professional_summary'] ?? '',
      recommendedProjects: List<String>.from(json['recommended_projects'] ?? []),
      recommendedTechStack: List<String>.from(json['recommended_tech_stack'] ?? []),
    );
  }
}

class ResumeResultModel {
  final ResumeOptimizationModel optimization;
  final ResumeAnalysisModel analysis;

  ResumeResultModel({
    required this.optimization,
    required this.analysis,
  });
}
