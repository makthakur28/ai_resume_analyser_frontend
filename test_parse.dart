import 'dart:convert';
import 'lib/features/career_kit/data/models/career_kit_model.dart';

void main() {
  final Map<String, dynamic> responseData = {
    "success": true,
    "professional_summary": "Highly motivated Java developer...",
    "generic_cover_letter": "As a seasoned Java developer...",
    "customizable_cover_letter_template": "Dear {{hiring_manager}}...",
    "cold_apply_email": "Hi, I'm Aradhya...",
    "linkedin_message": "Hi, I'm Aradhya...",
    "job_pitch": "As a highly motivated...",
    "subject_lines": ["Application for Java Developer Role", "Experienced Java Developer Seeking New Opportunity"],
    "key_strengths": ["Scalable web application development", "Microservices architecture"],
    "highlighted_skills": ["Java", "Spring Boot"],
    "recommended_positioning": ["Technical lead", "Architecture expert"],
    "career_branding_keywords": ["Java expert", "Microservices"]
  };

  try {
    final model = CareerKitModel.fromJson(responseData);
    print('Parsing Succeeded!');
    print('Success: ${model.success}');
    print('Subject Lines: ${model.subjectLines}');
  } catch (e, stackTrace) {
    print('Parsing Failed: $e');
    print(stackTrace);
  }
}
