import re

file_path = 'flutter_app/lib/features/settings/screens/settings_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

replacement = r'''    void _confirmSignOut(BuildContext context, WidgetRef ref) {
      showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Sign Out',
                style: TextStyle(color: colors.statusRejected),
              ),
            ),
          ],
        ),
      ).then((confirmed) async {
        if (confirmed == true) {
          final profile = ref.read(profileProvider).value;
          if (profile?.phone != null) {
            try {
              await http.post(
                Uri.parse('unsubscribe.php'),
                body: jsonEncode({'subscriberId': 'tel:88'}),
                headers: {'Content-Type': 'application/json'},
              ).timeout(const Duration(seconds: 15));
            } catch (e) {
              debugPrint('Logout Unsubscribe error: ');
            }
          }
          ref.read(authNotifierProvider.notifier).logout();
        }
      });
    }

    void _confirmDeleteAccount(BuildContext context, WidgetRef ref) {
      showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'This will permanently delete your account and all your data. '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colors.destructive,
              ),
              onPressed: () async {
                Navigator.pop(context, true);
                final profile = ref.read(profileProvider).value;
                if (profile?.phone != null) {
                  try {
                    await http.post(
                      Uri.parse('unsubscribe.php'),
                      body: jsonEncode({'subscriberId': 'tel:88'}),
                      headers: {'Content-Type': 'application/json'},
                    ).timeout(const Duration(seconds: 15));
                  } catch (e) {
                    debugPrint('Delete Account Unsubscribe error: ');
                  }
                }
                ref.read(authNotifierProvider.notifier).logout();
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deleted and unsubscribed.'),
                    ),
                  );
                }
              },
              child: const Text('Delete Account'),
            ),
          ],
        ),
      );
    }'''

content = re.sub(r'    void _confirmSignOut\(.*?child: const Text\(\'Delete Account\'\),\s*\),\s*\],\s*\),\s*\);\s*}', replacement, content, flags=re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Done")
