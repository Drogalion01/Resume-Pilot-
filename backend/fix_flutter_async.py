import re

with open('flutter_app/lib/features/resume/providers/upload_provider.dart', 'r') as f:
    text = f.read()

replacement = '''
        if (_fileMode && picked != null) {
          result = await service.analyzeResume(
            fileBytes: picked.fileBytes,
            fileName: picked.fileName,
            targetRole: targetRole,
            companyName: companyName,
            jdText: jdText,
          );
        } else {
          if (_pastedText.trim().isEmpty) {
            state = const UploadError('Please provide file or pasted text.');
            return;
          }

          result = await service.analyzeResume(
            pastedText: _pastedText,
            targetRole: targetRole,
            companyName: companyName,
            jdText: jdText,
          );
        }

        // ====== NEW LONG POLLING LOOP ======
        while (result.status == 'processing') {
          await Future.delayed(const Duration(seconds: 2));
          result = await service.checkAnalysisStatus(result.id);
        }

        if (result.status == 'failed') {
           throw Exception('Backend analysis task failed unexpectedly.');
        }
        // ===================================

        ref.invalidateSelf(); // will be rebuilt with success
        state = UploadSuccess(analysis: result);
'''

# Find the block we want to replace
OLD_BLOCK = '''
        if (_fileMode && picked != null) {
          result = await service.analyzeResume(
            fileBytes: picked.fileBytes,
            fileName: picked.fileName,
            targetRole: targetRole,
            companyName: companyName,
            jdText: jdText,
          );
        } else {
          if (_pastedText.trim().isEmpty) {
            state = const UploadError('Please provide file or pasted text.');
            return;
          }

          result = await service.analyzeResume(
            pastedText: _pastedText,
            targetRole: targetRole,
            companyName: companyName,
            jdText: jdText,
          );
        }

        ref.invalidateSelf(); // will be rebuilt with success
        state = UploadSuccess(analysis: result);
'''

if OLD_BLOCK.strip() in text:
    new_text = text.replace(OLD_BLOCK.strip(), replacement.strip())
    with open('flutter_app/lib/features/resume/providers/upload_provider.dart', 'w') as f:
        f.write(new_text)
    print("Flutter provider updated.")
else:
    print("Could not find the block to replace!")

