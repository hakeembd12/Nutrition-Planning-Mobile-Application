import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../providers/meal_plan_provider.dart';
import '../models/meal_model.dart';

class AddMealScreen extends StatefulWidget {
  final String mealPlanId;
  final MealModel? meal; // If provided, we're editing

  const AddMealScreen({super.key, required this.mealPlanId, this.meal});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();

  MealType _selectedType = MealType.breakfast;

  @override
  void initState() {
    super.initState();
    if (widget.meal != null) {
      _nameController.text = widget.meal!.name;
      _descriptionController.text = widget.meal!.description;
      _caloriesController.text = widget.meal!.nutrition.calories.toString();
      _proteinController.text = widget.meal!.nutrition.protein.toString();
      _carbsController.text = widget.meal!.nutrition.carbs.toString();
      _fatsController.text = widget.meal!.nutrition.fats.toString();
      _selectedType = widget.meal!.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  Future<void> _handleSave(AppLocalizations l10n) async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<MealPlanProvider>();

      final meal = MealModel(
        id: widget.meal?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        nutrition: NutritionInfo(
          calories: double.parse(_caloriesController.text),
          protein: double.parse(_proteinController.text),
          carbs: double.parse(_carbsController.text),
          fats: double.parse(_fatsController.text),
        ),
        createdAt: widget.meal?.createdAt ?? DateTime.now(),
      );

      bool success;
      if (widget.meal != null) {
        success = await provider.updateMeal(widget.mealPlanId, meal);
      } else {
        success = await provider.addMeal(widget.mealPlanId, meal);
      }

      if (!mounted) return;

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.meal != null
                  ? l10n.mealUpdatedSuccessfully
                  : l10n.mealAddedSuccessfully,
            ),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? l10n.failedToSaveMeal),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _getMealTypeDisplayName(MealType type, AppLocalizations l10n) {
    switch (type) {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.meal != null ? l10n.editMeal : l10n.addMeal,
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: l10n.mealName,
                hint: 'e.g., Grilled Chicken Salad',
                controller: _nameController,
                validator: (value) =>
                    Validators.required(value, fieldName: l10n.mealName),
              ),

              const SizedBox(height: 20),

              CustomTextField(
                label: l10n.descriptionOptional,
                hint: 'Add a description...',
                controller: _descriptionController,
                maxLines: 2,
              ),

              const SizedBox(height: 20),

              Text(l10n.mealType, style: AppTextStyles.label),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: MealType.values.map((type) {
                  final isSelected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(_getMealTypeDisplayName(type, l10n)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedType = type;
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    labelStyle: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              Text(l10n.nutritionInformation, style: AppTextStyles.h4),
              const SizedBox(height: 16),

              CustomTextField(
                label: l10n.calories,
                hint: '0',
                controller: _caloriesController,
                validator: Validators.positiveNumber,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.local_fire_department),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: '${l10n.protein} (g)',
                      hint: '0',
                      controller: _proteinController,
                      validator: Validators.positiveNumber,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: '${l10n.carbs} (g)',
                      hint: '0',
                      controller: _carbsController,
                      validator: Validators.positiveNumber,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: '${l10n.fats} (g)',
                hint: '0',
                controller: _fatsController,
                validator: Validators.positiveNumber,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 32),

              Consumer<MealPlanProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: widget.meal != null ? l10n.updateMeal : l10n.addMeal,
                    onPressed: () => _handleSave(l10n),
                    isLoading: provider.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
