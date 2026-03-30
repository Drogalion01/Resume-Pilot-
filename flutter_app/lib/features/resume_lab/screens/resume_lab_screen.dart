import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../resume/screens/resume_versions_screen.dart';
import '../../resume/screens/resume_upload_screen.dart';

/// Resume Lab — Unified resume optimization hub.
///
/// Combines:
/// - Resume version management & comparison
/// - Upload & management tools
/// - Quick actions for optimization
class ResumeLab extends StatelessWidget {
  const ResumeLab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Resume Lab'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: colors.foreground,
          bottom: TabBar(
            labelColor: colors.primary,
            unselectedLabelColor: colors.foregroundTertiary,
            indicatorColor: colors.primary,
            tabs: const [
              Tab(text: 'Your Resumes'),
              Tab(text: 'Upload'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Tab 0: Resume Versions
            ResumeVersionsScreen(),
            
            // Tab 1: Upload
            ResumeUploadScreen(),
          ],
        ),
      ),
    );
  }
}
