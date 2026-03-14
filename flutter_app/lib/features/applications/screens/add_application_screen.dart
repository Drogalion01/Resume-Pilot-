import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/application.dart';
import '../providers/application_detail_provider.dart';
import '../widgets/status_badge.dart';

class AddApplicationScreen extends ConsumerStatefulWidget {
  const AddApplicationScreen({super.key});

  @override
  ConsumerState<AddApplicationScreen> createState() =>
      _AddApplicationScreenState();
}

class _AddApplicationScreenState extends ConsumerState<AddApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _companyCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _sourceCtrl = TextEditingController();
  final _recruiterCtrl = TextEditingController();

  ApplicationStatus _status = ApplicationStatus.saved;
  DateTime? _applicationDate;

  @override
  void dispose() {
    _companyCtrl.dispose();
    _roleCtrl.dispose();
    _locationCtrl.dispose();
    _sourceCtrl.dispose();
    _recruiterCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _applicationDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final body = ApplicationCreate(
      companyName: _companyCtrl.text.trim(),
      role: _roleCtrl.text.trim(),
      status: _status,
      applicationDate: _applicationDate,
      location:
          _locationCtrl.text.trim().isEmpty ? null : _locationCtrl.text.trim(),
      source: _sourceCtrl.text.trim().isEmpty ? null : _sourceCtrl.text.trim(),
      recruiterName: _recruiterCtrl.text.trim().isEmpty
          ? null
          : _recruiterCtrl.text.trim(),
    );

    final notifier = ref.read(addApplicationProvider.notifier);
    final result = await notifier.submit(body);
    if (!mounted) return;
    if (result != null) {
      context.pop();
      context.push(AppRoutes.applicationDetail(result.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final formState = ref.watch(addApplicationProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration:
                  BoxDecoration(gradient: AppGradients.heroBackground(colors)),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  // ── AppBar ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pageH, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close_rounded,
                              color: colors.foreground, size: 22),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Add Application',
                          style: AppTextStyles.headline
                              .copyWith(color: colors.foreground),
                        ),
                      ],
                    ),
                  ),

                  // ── Form ─────────────────────────────────────────────────
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.surfacePrimary,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadii.xl2)),
                        boxShadow: AppShadows.elevated(brightness),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadii.xl2)),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.pageH, vertical: 24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Required fields
                                TextFormField(
                                  controller: _companyCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Company *',
                                    hintText: 'e.g. Google',
                                    prefixIcon: Icon(Icons.business_outlined),
                                  ),
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                          ? 'Required'
                                          : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _roleCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Role *',
                                    hintText: 'e.g. Software Engineer',
                                    prefixIcon: Icon(Icons.work_outline),
                                  ),
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                          ? 'Required'
                                          : null,
                                ),
                                const SizedBox(height: 20),

                                // Status picker
                                Text(
                                  'Status',
                                  style: AppTextStyles.title
                                      .copyWith(color: colors.foreground),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: ApplicationStatus.values.map((s) {
                                    final active = _status == s;
                                    final fg = s.foreground(colors);
                                    final bg = s.background(colors);
                                    return GestureDetector(
                                      onTap: () => setState(() => _status = s),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 150),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: active ? fg : bg,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color:
                                                active ? fg : fg.withAlpha(60),
                                          ),
                                        ),
                                        child: Text(
                                          s.displayName,
                                          style: AppTextStyles.micro.copyWith(
                                            color: active ? Colors.white : fg,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),

                                const SizedBox(height: 20),

                                // Optional fields
                                Text(
                                  'Details (Optional)',
                                  style: AppTextStyles.title
                                      .copyWith(color: colors.foreground),
                                ),
                                const SizedBox(height: 12),
                                _OptField(
                                    ctrl: _locationCtrl,
                                    label: 'Location',
                                    hint: 'e.g. Remote / New York, NY',
                                    icon: Icons.location_on_outlined),
                                const SizedBox(height: 10),
                                _OptField(
                                    ctrl: _sourceCtrl,
                                    label: 'Source',
                                    hint: 'e.g. LinkedIn, Referral',
                                    icon: Icons.link_rounded),
                                const SizedBox(height: 10),
                                _OptField(
                                    ctrl: _recruiterCtrl,
                                    label: 'Recruiter Name',
                                    hint: 'e.g. Jane Smith',
                                    icon: Icons.person_outline),
                                const SizedBox(height: 10),

                                // Date picker
                                OutlinedButton.icon(
                                  onPressed: _pickDate,
                                  icon: const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 16),
                                  label: Text(
                                    _applicationDate != null
                                        ? 'Applied: ${DateFormat('MMM d, yyyy').format(_applicationDate!)}'
                                        : 'Set Application Date',
                                  ),
                                ),

                                if (formState.errorMessage != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colors.statusRejectedBg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      formState.errorMessage!,
                                      style: AppTextStyles.caption.copyWith(
                                          color: colors.statusRejected),
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 24),

                                FilledButton(
                                  onPressed:
                                      formState.isLoading ? null : _submit,
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size.fromHeight(
                                        AppSpacing.buttonH),
                                  ),
                                  child: formState.isLoading
                                      ? const SizedBox.square(
                                          dimension: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.white))
                                      : const Text('Add Application'),
                                ),

                                const SizedBox(
                                    height: AppSpacing.bottomNavH +
                                        AppSpacing.cardPad),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptField extends StatelessWidget {
  const _OptField({
    required this.ctrl,
    required this.label,
    required this.hint,
    required this.icon,
  });

  final TextEditingController ctrl;
  final String label;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      );
}
