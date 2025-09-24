import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String itemName;
  final String? warningMessage;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String confirmButtonText;
  final String cancelButtonText;
  final Color? confirmButtonColor;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.itemName,
    required this.onConfirm,
    this.warningMessage,
    this.onCancel,
    this.confirmButtonText = 'Delete',
    this.cancelButtonText = 'Cancel',
    this.confirmButtonColor = Colors.red,
  });

  /// Shows a delete confirmation dialog for categories
  static Future<void> showCategoryDeleteDialog({
    required BuildContext context,
    required String categoryName,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          title: 'Delete Category',
          itemName: categoryName,
          warningMessage:
              'This action cannot be undone. Tasks associated with this category will prevent deletion.',
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      },
    );
  }

  /// Shows a generic delete confirmation dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String itemName,
    required VoidCallback onConfirm,
    String? warningMessage,
    VoidCallback? onCancel,
    String confirmButtonText = 'Delete',
    String cancelButtonText = 'Cancel',
    Color? confirmButtonColor = Colors.red,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          title: title,
          itemName: itemName,
          warningMessage: warningMessage,
          onConfirm: onConfirm,
          onCancel: onCancel,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
          confirmButtonColor: confirmButtonColor,
        );
      },
    );
  }

  /// Shows a delete confirmation dialog for notes
  static Future<void> showNoteDeleteDialog({
    required BuildContext context,
    required String noteTitle,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          title: 'Delete Note',
          itemName: noteTitle.isNotEmpty ? noteTitle : 'Untitled Note',
          warningMessage:
              'This will delete the note permanently. You cannot undo this action.',
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      },
    );
  }

  /// Shows a delete confirmation dialog for all notes
  static Future<void> showDeleteAllNotesDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          title: 'Delete All Notes',
          itemName: 'all notes',
          warningMessage:
              'This will delete all notes permanently. You cannot undo this action.',
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.red.shade400,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Main message
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: 'Are you sure you want to delete '),
                  TextSpan(
                    text: '"$itemName"',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),

            // Warning message
            if (warningMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        warningMessage!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade800,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCancel?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      cancelButtonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmButtonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      confirmButtonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
