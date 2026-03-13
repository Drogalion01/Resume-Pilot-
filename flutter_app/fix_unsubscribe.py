import re

with open('lib/features/settings/screens/settings_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace UI tile for 'Delete Account'
content = content.replace("title: 'Delete Account',", "title: 'Unsubscribe',")
content = content.replace("subtitle: 'Permanently delete your account and all data',", "subtitle: 'Cancel your premium service subscription',")

# Replace _confirmDeleteAccount
new_func = '''  void _confirmDeleteAccount(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Unsubscribe'),
        content: const Text(
          'This will cancel your premium subscription. You will be logged out. '
          'To use this app again, you will need to subscribe again.\\n\\n'
          'Are you sure you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.theme.extension<AppColors>()?.destructive ?? Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context, true);
              
              final phone = ref.read(profileProvider).value?.phone;
              if (phone == null || phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cannot identify phone number to unsubscribe.')),
                );
                return;
              }

              try {
                final response = await http.post(
                  Uri.parse('\unsubscribe.php'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'subscriberId': 'tel:880\'}),
                );
                
                if (response.statusCode >= 200 && response.statusCode < 300) {
                  // Unsubscribed successfully, log out
                  ref.read(authNotifierProvider.notifier).logout();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to unsubscribe: \')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: \')),
                );
              }
            },
            child: const Text('Unsubscribe'),
          ),
        ],
      ),
    );
  }'''

content = re.sub(
    r'void _confirmDeleteAccount\(BuildContext context, WidgetRef ref\) \{.*?\}(?=\s*// ────)',
    new_func,
    content,
    flags=re.DOTALL
)

# Wait let's just do a simpler search & replace for the function
def_start = content.find('void _confirmDeleteAccount(BuildContext context, WidgetRef ref) {')
end_class = content.find('// --------', def_start)
if end_class == -1: # Encoding fallback
    end_class = content.find('// �', def_start)

if def_start != -1 and end_class != -1:
    content = content[:def_start] + new_func + '\n\n  ' + content[end_class:]

with open('lib/features/settings/screens/settings_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated Settings Screen!")
