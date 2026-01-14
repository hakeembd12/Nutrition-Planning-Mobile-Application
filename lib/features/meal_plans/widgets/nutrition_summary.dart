import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/meal_model.dart';

class NutritionSummary extends StatelessWidget {
  final NutritionInfo nutrition;

  const NutritionSummary({super.key, required this.nutrition});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Plan Nutrition', style: AppTextStyles.h4),
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: AppColors.textLight,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutritionCircle(
                'Calories',
                nutrition.calories.toStringAsFixed(0),
                'kcal',
                AppColors.calories,
              ),
              _buildNutritionCircle(
                'Protein',
                nutrition.protein.toStringAsFixed(0),
                'g',
                AppColors.protein,
              ),
              _buildNutritionCircle(
                'Carbs',
                nutrition.carbs.toStringAsFixed(0),
                'g',
                AppColors.carbs,
              ),
              _buildNutritionCircle(
                'Fats',
                nutrition.fats.toStringAsFixed(0),
                'g',
                AppColors.fats,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCircle(
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: 0.7, // Example progress
                strokeWidth: 6,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Column(
              children: [
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  unit,
                  style: AppTextStyles.overline.copyWith(
                    fontSize: 8,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: AppTextStyles.overline.copyWith(
            color: AppColors.textLight,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
