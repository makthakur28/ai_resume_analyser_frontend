class EnvConfig {
  static const String backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'https://ai-resume-analyser-backend-cfrr.onrender.com',
  );
}
