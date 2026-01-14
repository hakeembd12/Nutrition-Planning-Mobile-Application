import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../providers/meal_plan_provider.dart';
import '../models/meal_plan_model.dart';
import '../models/meal_model.dart';
import '../widgets/meal_card.dart';
import '../widgets/nutrition_summary.dart';
import 'add_meal_screen.dart';

class MealPlanDetailsScreen extends StatelessWidget {
  final MealPlanModel mealPlan;

  const MealPlanDetailsScreen({super.key, required this.mealPlan});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat.yMMMd(locale);
    final provider = context.watch<MealPlanProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, mealPlan.name, l10n, provider),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Plan info section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${dateFormat.format(mealPlan.startDate)} - ${dateFormat.format(mealPlan.endDate)}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (mealPlan.description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          mealPlan.description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Nutrition summary
                if (mealPlan.meals.isNotEmpty)
                  NutritionSummary(nutrition: mealPlan.totalNutrition),

                const SizedBox(height: 32),

                // Meals section header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.mealsCount(mealPlan.meals.length),
                      style: AppTextStyles.h3,
                    ),
                    TextButton.icon(
                      onPressed: () => _navigateToAddMeal(context),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(
                        l10n.add,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (mealPlan.meals.isEmpty) _buildEmptyMeals(l10n),
              ]),
            ),
          ),
          if (mealPlan.meals.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final meal = mealPlan.meals[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MealCard(
                      meal: meal,
                      onTap: () => _navigateToEditMeal(context, meal),
                      onDelete: () => _handleDeleteMeal(context, meal.id, l10n),
                    ),
                  );
                }, childCount: mealPlan.meals.length),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddMeal(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addMeal),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    String title,
    AppLocalizations l10n,
    MealPlanProvider provider,
  ) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      title: Text(title, style: AppTextStyles.h3),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
              onPressed: () {
                CustomDialog.show(
                  context: context,
                  title: l10n.deleteMealPlan,
                  message: l10n.deleteMealPlanConfirm,
                  type: DialogType.error,
                  primaryButtonLabel: l10n.delete,
                  onPrimaryAction: () async {
                    Navigator.pop(context); // Close dialog
                    final success = await provider.deleteMealPlan(mealPlan.id);
                    if (context.mounted) {
                      if (success) {
                        Navigator.pop(context); // Close details screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.mealPlanDeletedSuccessfully),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              provider.errorMessage ??
                                  l10n.failedToDeleteMealPlan,
                            ),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
                  secondaryButtonLabel: l10n.cancel,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyMeals(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.background, width: 2),
      ),
      child: Column(
        children: [
          Icon(
            Icons.restaurant_rounded,
            size: 48,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noMealsAddedYet,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddMeal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMealScreen(mealPlanId: mealPlan.id),
      ),
    );
  }

  void _navigateToEditMeal(BuildContext context, MealModel meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddMealScreen(mealPlanId: mealPlan.id, meal: meal),
      ),
    );
  }

  Future<void> _handleDeleteMeal(
    BuildContext context,
    String mealId,
    AppLocalizations l10n,
  ) async {
    CustomDialog.show(
      context: context,
      title: l10n.deleteMeal,
      message: l10n.deleteMealConfirm,
      type: DialogType.warning,
      primaryButtonLabel: l10n.delete,
      onPrimaryAction: () async {
        Navigator.pop(context);
        final provider = context.read<MealPlanProvider>();
        final success = await provider.deleteMeal(mealPlan.id, mealId);

        if (context.mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.mealDeletedSuccessfully),
                backgroundColor: AppColors.success,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.errorMessage ?? l10n.failedToDeleteMeal),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      },
      secondaryButtonLabel: l10n.cancel,
    );
  }
}
