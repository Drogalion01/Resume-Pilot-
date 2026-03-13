import re

with open('lib/features/settings/screens/settings_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace UI tile for 'Delete Account'
content = content.replace("title: 'Delete Account',", "title: 'Unsubscribe',")
content = content.replace("subtitle: 'Permanently delete your account and all data',", "subtitle: 'Cancel your premium service subscription',")

# We want to replace everything from oid _confirmDeleteAccount... to the end of that class.
pattern = r"void _confirmDeleteAccount\(BuildContext context, WidgetRef ref\) \{.*?\n  \}"

replacement = '''void _confirmDeleteAccount(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (_) {
            return AlertDialog(
              title: const Text('Unsubscribe'),
              content: const Text(
                'This will cancel your premium subscription. You will also be logged out. '
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
                    backgroundColor: Colors.red,
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
                      String subId = phone.startsWith('880') ? phone : '8801\';
                      if (subId.startsWith('8801880')) {
                          subId = phone; // Handle if double prepended
                      }
                      // actually it should probably just be tel:880xxxxxxxx
                      // The backend usually expects tel:8801xxxxxxx
                      String finalSubId = 'tel:\'; // bdapps_api handles prepending if missing
                      
                      final response = await http.post(
                        Uri.parse('https://www.flicksize.com/resumepilot/unsubscribe.php'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({'subscriberId': finalSubId}),
                      );
                      
                      if (response.statusCode >= 200 && response.statusCode < 300) {
                        // Unsubscribed successfully, log out locally
                        ref.read(authNotifierProvider.notifier).logout();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to unsubscribe. Server returned: \')),
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
            );
      }
    );
  }'''

content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open('lib/features/settings/screens/settings_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Done")
