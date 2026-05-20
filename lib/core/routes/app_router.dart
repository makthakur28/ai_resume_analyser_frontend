import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/career_kit/presentation/pages/career_kit_screen.dart';
import '../../features/career_kit/presentation/bloc/career_kit_bloc.dart';
import '../../features/resume/presentation/pages/resume_optimizer_screen.dart';
import '../../features/resume/presentation/bloc/resume_bloc.dart';
import '../../injection_container.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/optimizer',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ResumeBloc>(),
        child: const ResumeOptimizerScreen(),
      ),
    ),
    GoRoute(
      path: '/career-kit',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<CareerKitBloc>(),
        child: const CareerKitScreen(),
      ),
    ),
  ],
);
