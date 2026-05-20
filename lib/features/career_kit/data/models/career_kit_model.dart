class CareerKitModel {
  final bool success;
  final String professionalSummary;
  final String genericCoverLetter;
  final String customizableCoverLetterTemplate;
  final String coldApplyEmail;
  final String linkedinMessage;
  final String jobPitch;
  final List<String> subjectLines;
  final List<String> keyStrengths;
  final List<String> highlightedSkills;

  CareerKitModel({
    required this.success,
    required this.professionalSummary,
    required this.genericCoverLetter,
    required this.customizableCoverLetterTemplate,
    required this.coldApplyEmail,
    required this.linkedinMessage,
    required this.jobPitch,
    required this.subjectLines,
    required this.keyStrengths,
    required this.highlightedSkills,
  });

  factory CareerKitModel.fromJson(Map<String, dynamic> json) {
    return CareerKitModel(
      success: json['success'] ?? false,
      professionalSummary: json['professional_summary'] ?? '',
      genericCoverLetter: json['generic_cover_letter'] ?? '',
      customizableCoverLetterTemplate: json['customizable_cover_letter_template'] ?? '',
      coldApplyEmail: json['cold_apply_email'] ?? '',
      linkedinMessage: json['linkedin_message'] ?? '',
      jobPitch: json['job_pitch'] ?? '',
      subjectLines: List<String>.from(json['subject_lines'] ?? []),
      keyStrengths: List<String>.from(json['key_strengths'] ?? []),
      highlightedSkills: List<String>.from(json['highlighted_skills'] ?? []),
    );
  }
}
