import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/meal_model.dart';

class MealCard extends StatelessWidget {
  final MealModel meal;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MealCard({super.key, required this.meal, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Meal type icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _getMealTypeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getMealTypeIcon(),
                    color: _getMealTypeColor(),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Meal info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              meal.name,
                              style: AppTextStyles.cardTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (onDelete != null)
                            IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: AppColors.textLight,
                              ),
                              onPressed: onDelete,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getMealTypeDisplayName(l10n),
                        style: AppTextStyles.overline.copyWith(
                          color: _getMealTypeColor(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildNutritionStat(
                            '${meal.nutrition.calories.toStringAsFixed(0)} kcal',
                            AppColors.calories,
                          ),
                          _buildDot(),
                          _buildNutritionStat(
                            '${meal.nutrition.protein.toStringAsFixed(0)}g P',
                            AppColors.protein,
                          ),
                          _buildDot(),
                          _buildNutritionStat(
                            '${meal.nutrition.carbs.toStringAsFixed(0)}g C',
                            AppColors.carbs,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMealTypeDisplayName(AppLocalizations l10n) {
    switch (meal.type) {
      case MealType.breakfast:
        return l10n.breakfast;
      case MealType.lunch:
        return l10n.lunch;
      case MealType.dinner:
        return l10n.dinner;
      case MealType.snack:
        return l10n.snack;
    }
  }

  Widget _buildDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 3,
        height: 3,
        decoration: const BoxDecoration(
          color: AppColors.textLight,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildNutritionStat(String text, Color color) {
    return Text(
      text,
      style: AppTextStyles.bodySmall.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  Color _getMealTypeColor() {
    switch (meal.type) {
      case MealType.breakfast:
        return Colors.orange;
      case MealType.lunch:
        return AppColors.primary;
      case MealType.dinner:
        return AppColors.secondary;
      case MealType.snack:
        return Colors.purple;
    }
  }

  IconData _getMealTypeIcon() {
    switch (meal.type) {
      case MealType.breakfast:
        return Icons.wb_sunny_rounded;
      case MealType.lunch:
        return Icons.restaurant_rounded;
      case MealType.dinner:
        return Icons.dinner_dining_rounded;
      case MealType.snack:
        return Icons.cookie_rounded;
    }
  }
}
