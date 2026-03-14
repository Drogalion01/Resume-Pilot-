import os
import re

files_to_fix = [
    r"lib\features\applications\widgets\application_states.dart",
    r"lib\features\dashboard\widgets\dashboard_states.dart",
    r"lib\features\resume\widgets\resume_states.dart",
    r"lib\shared\widgets\loading_skeletons.dart"
]

for file_path in files_to_fix:
    if not os.path.exists(file_path):
        continue
        
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    # Replace the import
    if "import 'package:shimmer/shimmer.dart';" in content:
        # We need to figure out the relative path. It's usually safe to use absolute "package:" or calculate relative.
        # But we can just use an absolute import for the app since it's cleaner:
        # Actually relative is better.
        rel_path = ""
        if "applications" in file_path or "dashboard" in file_path or "resume" in file_path:
            rel_path = "../../../shared/widgets/animations/premium_shimmer.dart"
        else: # shared/widgets/loading_skeletons.dart
            rel_path = "animations/premium_shimmer.dart"
            
        content = content.replace("import 'package:shimmer/shimmer.dart';", f"import '{rel_path}';")
        
    # Remove baseColor and highlightColor assignments if they are simple args
    content = re.sub(r'Shimmer\.fromColors\(\s*baseColor:[^,]+,\s*highlightColor:[^,]+,\s*child:(.*?)\)', r'PremiumShimmer(\n      child:\1)', content, flags=re.DOTALL)
    
    # Or just replace Shimmer.fromColors globally
    # What if baseColor and highlightColor exist on separate lines? Let's use regex that matches up to child:
    content = re.sub(r'Shimmer\.fromColors\(\s*baseColor:[^,]+,\s*highlightColor:[^,]+,\s*child:\s*', r'PremiumShimmer(\n      child: ', content)
    
    # Remove final base / final highlight local variables if they are unused (dart format / analyze will complain, but we'll do our best to remove them)
    content = re.sub(r'final base =.*?;\n\s*final highlight =.*?;\n', '', content)
    
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)
        
print("Shimmer swapped to PremiumShimmer!")
