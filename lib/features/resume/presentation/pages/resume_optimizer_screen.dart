import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/resume_bloc.dart';
import '../bloc/resume_event.dart';
import '../bloc/resume_state.dart';
import '../../data/models/resume_model.dart';
import '../../../../core/constants/env_config.dart';

class ResumeOptimizerScreen extends StatefulWidget {
  const ResumeOptimizerScreen({super.key});

  @override
  State<ResumeOptimizerScreen> createState() => _ResumeOptimizerScreenState();
}

class _ResumeOptimizerScreenState extends State<ResumeOptimizerScreen> with SingleTickerProviderStateMixin {
  Uint8List? selectedFileBytes;
  String? selectedFileName;
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

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

  void _optimize() {
    if (selectedFileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PDF resume to analyze and optimize.')),
      );
      return;
    }
    context.read<ResumeBloc>().add(OptimizeResumeEvent(
      fileBytes: selectedFileBytes!,
      fileName: selectedFileName!,
    ));
  }

  Future<void> _downloadPdf(String fileId) async {
    final url = Uri.parse('${EnvConfig.backendUrl}/api/v1/resume/download/$fileId');
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open download link')),
        );
      }
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATS Resume Analyser & Optimiser'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<ResumeBloc, ResumeState>(
        listener: (context, state) {
          if (state is ResumeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: const TextStyle(color: Colors.white)),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is ResumeOptimized) {
            // Re-initialize tab controller with 4 tabs when result is ready
            setState(() {
              _tabController = TabController(length: 4, vsync: this);
            });
          }
        },
        builder: (context, state) {
          if (state is ResumeLoading) {
            return _buildLoadingState();
          }

          if (state is ResumeOptimized) {
            return _buildResults(state);
          }

          return _buildInputForm();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.accent, strokeWidth: 5),
            const SizedBox(height: 32),
            const Text(
              'Analyzing & Optimizing Resume...',
              style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1500.ms, color: AppColors.accent),
            const SizedBox(height: 16),
            const Text(
              'We are running a comprehensive 2-stage pipeline:\n'
              '1. Deep diagnostic ATS scan of layout, keywords, & skills.\n'
              '2. Architectural rewrite of bullets using the STAR method & LaTeX PDF compilation.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, color: AppColors.accent, size: 20),
                  const SizedBox(width: 12),
                  const Text('This can take 10-15 seconds for deep analysis', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ).animate().fade().scale(begin: const Offset(0.95, 0.95)),
      ),
    );
  }

  Widget _buildInputForm() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.psychology, size: 72, color: AppColors.accent),
              const SizedBox(height: 24),
              const Text(
                'Elite ATS Resume Assistant',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              const Text(
                'Drop your resume PDF. Our AI automatically extracts text, runs a comprehensive industry diagnostic scan, rewrites your bullet points using action-oriented STAR patterns, and renders a stunning recruiter-grade PDF.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.6),
              ),
              const SizedBox(height: 48),
              
              // Custom Dotted Upload Card
              InkWell(
                onTap: _pickFile,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: selectedFileName != null ? AppColors.accent : AppColors.border, width: 2, style: BorderStyle.solid),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        selectedFileName != null ? Icons.picture_as_pdf : Icons.cloud_upload_outlined,
                        size: 64,
                        color: selectedFileName != null ? AppColors.accent : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        selectedFileName ?? 'Select your Resume PDF',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedFileName != null ? 'File selected successfully. Ready to analyze!' : 'Supports PDF format up to 10MB',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              
              if (selectedFileName != null) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.swap_horiz, size: 20),
                  label: const Text('Change Selected File'),
                ),
              ],
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _optimize,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Analyze & Optimize Resume', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ).animate().fade().slideY(begin: 0.05, end: 0, duration: 400.ms),
        ),
      ),
    );
  }

  Widget _buildResults(ResumeOptimized state) {
    final opt = state.result.optimization;
    final ana = state.result.analysis;

    if (_tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Premium Header Panel with Radial Score Badge
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: const Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Row(
                children: [
                  // Circular Score Widget
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          ana.atsScore >= 80 ? Colors.green : AppColors.accent,
                          ana.atsScore >= 80 ? Colors.teal : Colors.orange,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${ana.atsScore}',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          const Text(
                            'ATS SCORE',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ).animate().scale(delay: 150.ms, duration: 400.ms, curve: Curves.easeOutBack),
                  const SizedBox(width: 28),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Analysis & Optimization Complete',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'ATS Perfect',
                                style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Our AI parser has successfully rewritten your bullet points using the STAR methodology, analyzed missing technical keyphrases, and compiled a custom, recruiter-ready LaTeX PDF.',
                          style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Beautiful Custom Sliding Tab Bar
        Container(
          color: AppColors.surface,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.accent,
                indicatorWeight: 3,
                tabs: const [
                  Tab(icon: Icon(Icons.analytics_outlined), text: 'Diagnostics Scan'),
                  Tab(icon: Icon(Icons.picture_as_pdf_outlined), text: 'Optimized PDF'),
                  Tab(icon: Icon(Icons.lightbulb_outline), text: 'AI Recommendations'),
                  Tab(icon: Icon(Icons.school_outlined), text: 'Career Upgrades'),
                ],
              ),
            ),
          ),
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDiagnosticsTab(ana),
              _buildPdfTab(opt),
              _buildRecommendationsTab(ana),
              _buildUpgradesTab(ana),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnosticsTab(ResumeAnalysisModel ana) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ATS Diagnostic breakdown', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('A granular assessment of your original resume text.', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Strengths Column
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: AppColors.success, size: 24),
                                SizedBox(width: 10),
                                Text('Key Strengths', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.success)),
                              ],
                            ),
                            const Divider(height: 24),
                            ...ana.strengths.map((str) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.success),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(str, style: const TextStyle(fontSize: 14, height: 1.4))),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Weaknesses Column
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
                                SizedBox(width: 10),
                                Text('Identified Flaws', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                              ],
                            ),
                            const Divider(height: 24),
                            ...ana.weaknesses.map((weak) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.close, size: 14, color: Colors.orange),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(weak, style: const TextStyle(fontSize: 14, height: 1.4))),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              // Missing Skills Section
              const Text('Missing Keywords & Industry Terminology', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                'Recruiters filter candidates based on exact technical term matches. Adding these missing skills will drastically lift your response metrics.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ana.missingSkills.map((skill) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, size: 14, color: Colors.red),
                      const SizedBox(width: 6),
                      Text(skill, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                )).toList(),
              ),
            ],
          ).animate().fade().slideY(begin: 0.05, end: 0),
        ),
      ),
    );
  }

  Widget _buildPdfTab(ResumeOptimizationModel opt) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ATS Perfect LaTeX PDF', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Your optimized resume has been converted into a recruiter-ready PDF.', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              
              // PDF Preview Placeholder Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.picture_as_pdf, size: 80, color: AppColors.accent),
                    const SizedBox(height: 20),
                    const Text(
                      'Optimized_Resume.pdf',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Format: PDF (A4 Document) • Size: ~150 KB • Compiled using WeasyPrint',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _downloadPdf(opt.fileId),
                          icon: const Icon(Icons.download_rounded),
                          label: const Text('Download PDF Document', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final url = Uri.parse('${EnvConfig.backendUrl}/api/v1/resume/download/${opt.fileId}');
                            await launchUrl(url);
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Live PDF Preview'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              // Optimized Sections Info
              const Text('Optimized Resume Sections', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: opt.optimizedSections.map((sec) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                  ),
                  child: Text(sec, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                )).toList(),
              ),
              
              const SizedBox(height: 32),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    context.read<ResumeBloc>().add(ResetResumeEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Optimize Another Resume'),
                ),
              ),
            ],
          ).animate().fade().slideY(begin: 0.05, end: 0),
        ),
      ),
    );
  }

  Widget _buildRecommendationsTab(ResumeAnalysisModel ana) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AI Optimization recommendations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Specific rewrite instructions and guidelines to enhance technical impact.', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              
              // Professional Summary Rewrite Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_outline, color: AppColors.accent, size: 24),
                          const SizedBox(width: 12),
                          const Text('Improved Professional Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.copy, color: AppColors.accent),
                            onPressed: () => _copyToClipboard(ana.improvedProfessionalSummary, 'Summary'),
                            tooltip: 'Copy Summary',
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        ana.improvedProfessionalSummary,
                        style: const TextStyle(fontSize: 15, height: 1.6, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              // Suggestions List
              const Text('Actionable Suggestions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...ana.improvementSuggestions.map((sug) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppColors.accent, size: 22),
                    const SizedBox(width: 12),
                    Expanded(child: Text(sug, style: const TextStyle(fontSize: 14, height: 1.5))),
                  ],
                ),
              )).toList(),
            ],
          ).animate().fade().slideY(begin: 0.05, end: 0),
        ),
      ),
    );
  }

  Widget _buildUpgradesTab(ResumeAnalysisModel ana) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Portfolio & Skill Upgrades', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Strategic project recommendations and key tech skills to learn to level up.', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              
              // Skill badges
              const Text('Recommended Tech Stack Upgrade', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ana.recommendedTechStack.map((tech) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school, size: 14, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Text(tech, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                )).toList(),
              ),
              
              const SizedBox(height: 32),
              // Recommended projects list
              const Text('High-Impact Projects to Build', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                'Adding these projects to your resume will prove competence in your target technologies and demonstrate distributed systems scaling capability.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ...ana.recommendedProjects.map((proj) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.accent,
                      child: Icon(Icons.architecture, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            proj.split(':').first,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            proj.split(':').length > 1 ? proj.split(':').sublist(1).join(':').trim() : proj,
                            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ).animate().fade().slideY(begin: 0.05, end: 0),
        ),
      ),
    );
  }
}
