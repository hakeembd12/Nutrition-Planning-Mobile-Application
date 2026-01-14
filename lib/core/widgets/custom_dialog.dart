import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'custom_button.dart';

enum DialogType { info, warning, error, success }

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryButtonLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryButtonLabel;
  final VoidCallback? onSecondaryAction;
  final DialogType type;
  final IconData? icon;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    this.primaryButtonLabel,
    this.onPrimaryAction,
    this.secondaryButtonLabel,
    this.onSecondaryAction,
    this.type = DialogType.info,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    final themeColor = _getThemeColor();
    final iconData = icon ?? _getDefaultIcon();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: themeColor, size: 32),
          ),
          const SizedBox(height: 20),
          Text(title, style: AppTextStyles.h3, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              if (secondaryButtonLabel != null)
                Expanded(
                  child: CustomButton(
                    text: secondaryButtonLabel!,
                    onPressed:
                        onSecondaryAction ?? () => Navigator.pop(context),
                    variant: ButtonVariant.text,
                    textColor: AppColors.textSecondary,
                  ),
                ),
              if (secondaryButtonLabel != null && primaryButtonLabel != null)
                const SizedBox(width: 12),
              if (primaryButtonLabel != null)
                Expanded(
                  child: CustomButton(
                    text: primaryButtonLabel!,
                    onPressed: onPrimaryAction ?? () => Navigator.pop(context),
                    backgroundColor: themeColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getThemeColor() {
    switch (type) {
      case DialogType.info:
        return AppColors.primary;
      case DialogType.warning:
        return AppColors.warning;
      case DialogType.error:
        return AppColors.error;
      case DialogType.success:
        return AppColors.success;
    }
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case DialogType.info:
        return Icons.info_outline_rounded;
      case DialogType.warning:
        return Icons.warning_amber_rounded;
      case DialogType.error:
        return Icons.error_outline_rounded;
      case DialogType.success:
        return Icons.check_circle_outline_rounded;
    }
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    String? primaryButtonLabel,
    VoidCallback? onPrimaryAction,
    String? secondaryButtonLabel,
    VoidCallback? onSecondaryAction,
    DialogType type = DialogType.info,
    IconData? icon,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        primaryButtonLabel: primaryButtonLabel,
        onPrimaryAction: onPrimaryAction,
        secondaryButtonLabel: secondaryButtonLabel,
        onSecondaryAction: onSecondaryAction,
        type: type,
        icon: icon,
      ),
    );
  }
}
