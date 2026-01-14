import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../../../core/providers/locale_provider.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final user = authProvider.user;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.profile, style: AppTextStyles.h3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? 'Loading...', style: AppTextStyles.h2),
            Text(
              user?.email ?? '',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 40),

            // Profile Options
            _buildOptionTile(
              icon: Icons.edit_outlined,
              title: l10n.editProfile,
              onTap: () {},
            ),
            _buildOptionTile(
              icon: Icons.language_rounded,
              title: l10n.language,
              subtitle: _getCurrentLanguageName(context, localeProvider),
              onTap: () => _showLanguageDialog(context, localeProvider),
            ),
            _buildOptionTile(
              icon: Icons.notifications_none_rounded,
              title: l10n.notifications,
              onTap: () {},
            ),
            _buildOptionTile(
              icon: Icons.security_rounded,
              title: l10n.security,
              onTap: () {},
            ),
            _buildOptionTile(
              icon: Icons.help_outline_rounded,
              title: l10n.helpCenter,
              onTap: () {},
            ),

            const SizedBox(height: 40),

            CustomButton(
              text: l10n.logout,
              onPressed: () {
                CustomDialog.show(
                  context: context,
                  title: l10n.logout,
                  message: l10n.logoutConfirmation,
                  type: DialogType.warning,
                  primaryButtonLabel: l10n.logout,
                  onPrimaryAction: () {
                    Navigator.pop(context);
                    authProvider.signOut();
                  },
                  secondaryButtonLabel: l10n.cancel,
                );
              },
              variant: ButtonVariant.outlined,
              borderColor: AppColors.error,
              textColor: AppColors.error,
              isLoading: authProvider.isBusy,
              icon: Icons.logout_rounded,
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentLanguageName(
    BuildContext context,
    LocaleProvider provider,
  ) {
    final locale = provider.locale ?? Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    if (locale.languageCode == 'ar') return l10n.arabic;
    return l10n.english;
  }

  void _showLanguageDialog(
    BuildContext context,
    LocaleProvider localeProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.language, style: AppTextStyles.h3),
              const SizedBox(height: 24),
              _buildLanguageTile(
                context,
                title: l10n.english,
                isSelected: localeProvider.locale?.languageCode != 'ar',
                onTap: () {
                  localeProvider.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _buildLanguageTile(
                context,
                title: l10n.arabic,
                isSelected: localeProvider.locale?.languageCode == 'ar',
                onTap: () {
                  localeProvider.setLocale(const Locale('ar'));
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textLight.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textLight,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
