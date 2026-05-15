class DiagnosisResult {
  final String diseaseName;
  final double confidence;
  final String imagePath;
  final DateTime dateTime;
  final String? about;
  final List<String>? organicTreatment;
  final List<String>? chemicalTreatment;

  DiagnosisResult({
    required this.diseaseName,
    required this.confidence,
    required this.imagePath,
    required this.dateTime,
    this.about,
    this.organicTreatment,
    this.chemicalTreatment,
  });
}
