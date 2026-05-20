import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 64.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Career Accelerator',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                  color: AppColors.primary,
                ),
              ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 12),
              const Text(
                'Generate highly optimized application materials in seconds.',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                  letterSpacing: -0.2,
                ),
              ).animate().fade(delay: 100.ms, duration: 400.ms),
              const SizedBox(height: 64),
              
              // Grid of actions
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildActionCard(
                    context,
                    title: 'Resume Optimizer',
                    description: 'Transform your PDF into an ATS-friendly, premium software engineering resume.',
                    icon: Icons.document_scanner_outlined,
                    onTap: () {
                      context.push('/optimizer');
                    },
                  ),
                  _buildActionCard(
                    context,
                    title: 'Application Kit Generator',
                    description: 'Instantly generate cover letters, cold emails, and recruiter LinkedIn pitches.',
                    icon: Icons.mark_email_read_outlined,
                    onTap: () {
                      context.push('/career-kit');
                    },
                  ),
                  _buildActionCard(
                    context,
                    title: 'Resume Analysis',
                    description: 'Get deep insights, ATS scoring, and technical gap analysis.',
                    icon: Icons.analytics_outlined,
                    onTap: () {},
                  ),
                ],
              ).animate().fade(delay: 200.ms, duration: 500.ms).slideY(begin: 0.05, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required String title, required String description, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      hoverColor: AppColors.background,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 20,
              offset: Offset(0, 8),
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
