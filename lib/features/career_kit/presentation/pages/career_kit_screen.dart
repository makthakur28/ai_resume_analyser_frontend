import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/career_kit_bloc.dart';
import '../bloc/career_kit_event.dart';
import '../bloc/career_kit_state.dart';

class CareerKitScreen extends StatefulWidget {
  const CareerKitScreen({super.key});

  @override
  State<CareerKitScreen> createState() => _CareerKitScreenState();
}

class _CareerKitScreenState extends State<CareerKitScreen> {
  Uint8List? selectedFileBytes;
  String? selectedFileName;
  final roleController = TextEditingController();
  final companyController = TextEditingController();
  final toneController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        selectedFileBytes = result.files.single.bytes;
        selectedFileName = result.files.single.name;
      });
    }
  }

  void _generateKit() {
    if (selectedFileBytes == null || roleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PDF and enter a Target Role.')),
      );
      return;
    }
    context.read<CareerKitBloc>().add(GenerateKitEvent(
      fileBytes: selectedFileBytes!,
      fileName: selectedFileName!,
      targetRole: roleController.text,
      companyName: companyController.text,
      tone: toneController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Kit Generator'),
      ),
      body: BlocConsumer<CareerKitBloc, CareerKitState>(
        listener: (context, state) {
          if (state is CareerKitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is CareerKitLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.accent),
                  SizedBox(height: 16),
                  Text('AI is crafting your career materials...', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          if (state is CareerKitLoaded) {
            return _buildResults(state);
          }

          return _buildInputForm();
        },
      ),
    );
  }

  Widget _buildInputForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Target Your Application', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 24),
              InkWell(
                onTap: _pickFile,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 2, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.accentLight.withOpacity(0.3),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.upload_file, size: 48, color: AppColors.accent),
                      const SizedBox(height: 16),
                      Text(
                        selectedFileName ?? 'Upload Resume PDF',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Target Role (e.g. Senior Flutter Engineer)', hintText: 'Required'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'Company Name', hintText: 'Optional'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: toneController,
                decoration: const InputDecoration(labelText: 'Tone (e.g. FAANG, Startup, Professional)', hintText: 'Optional'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _generateKit,
                  child: const Text('Generate Application Kit'),
                ),
              ),
            ],
          ).animate().fade().slideY(begin: 0.1, end: 0),
        ),
      ),
    );
  }

  Widget _buildResults(CareerKitLoaded state) {
    final kit = state.kit;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultSection('Professional Summary', kit.professionalSummary),
          _buildResultSection('Cold Apply Email', kit.coldApplyEmail),
          _buildResultSection('LinkedIn Outreach', kit.linkedinMessage),
          _buildResultSection('Cover Letter', kit.genericCoverLetter),
          _buildResultSection('Job Pitch', kit.jobPitch),
          
          const SizedBox(height: 24),
          const Text('Subject Lines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...kit.subjectLines.map((s) => Text('• $s', style: const TextStyle(height: 1.5))).toList(),
          
          const SizedBox(height: 24),
          const Text('Key Strengths', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...kit.keyStrengths.map((s) => Text('• $s', style: const TextStyle(height: 1.5))).toList(),
          
          const SizedBox(height: 32),
          Center(
            child: OutlinedButton(
              onPressed: () {
                context.read<CareerKitBloc>().add(ResetCareerKitEvent());
              },
              child: const Text('Start Over'),
            ),
          )
        ],
      ).animate().fade().slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildResultSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('\$title copied to clipboard!'),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Copy'),
                style: TextButton.styleFrom(foregroundColor: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: SelectableText(
              content, 
              style: const TextStyle(fontSize: 15, height: 1.5, color: AppColors.textSecondary)
            ),
          ),
        ],
      ),
    );
  }
}
