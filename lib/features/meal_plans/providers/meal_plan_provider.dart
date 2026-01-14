import 'package:flutter/material.dart';
import '../models/meal_plan_model.dart';
import '../models/meal_model.dart';
import '../services/meal_plan_service.dart';

class MealPlanProvider extends ChangeNotifier {
  final MealPlanService _service = MealPlanService();

  List<MealPlanModel> _mealPlans = [];
  MealPlanModel? _selectedMealPlan;
  bool _isLoading = false;
  String? _errorMessage;

  List<MealPlanModel> get mealPlans => _mealPlans;
  MealPlanModel? get selectedMealPlan => _selectedMealPlan;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load meal plans for a user
  Future<void> loadMealPlans(String userId) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      _mealPlans = await _service.getMealPlans(userId);
      // Sort locally to ensure consistency without requiring a composite index
      _mealPlans.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Create a new meal plan
  Future<bool> createMealPlan(MealPlanModel mealPlan) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final newPlan = await _service.createMealPlan(mealPlan);
      _mealPlans.insert(0, newPlan);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update a meal plan
  Future<bool> updateMealPlan(MealPlanModel mealPlan) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await _service.updateMealPlan(mealPlan);

      final index = _mealPlans.indexWhere((p) => p.id == mealPlan.id);
      if (index != -1) {
        _mealPlans[index] = mealPlan;
      }

      if (_selectedMealPlan?.id == mealPlan.id) {
        _selectedMealPlan = mealPlan;
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete a meal plan
  Future<bool> deleteMealPlan(String id) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await _service.deleteMealPlan(id);
      _mealPlans.removeWhere((plan) => plan.id == id);

      if (_selectedMealPlan?.id == id) {
        _selectedMealPlan = null;
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Add a meal to a meal plan
  Future<bool> addMeal(String mealPlanId, MealModel meal) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await _service.addMeal(mealPlanId, meal);

      // Refresh the meal plan
      final updatedPlan = await _service.getMealPlan(mealPlanId);
      if (updatedPlan != null) {
        final index = _mealPlans.indexWhere((p) => p.id == mealPlanId);
        if (index != -1) {
          _mealPlans[index] = updatedPlan;
        }

        if (_selectedMealPlan?.id == mealPlanId) {
          _selectedMealPlan = updatedPlan;
        }
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update a meal
  Future<bool> updateMeal(String mealPlanId, MealModel meal) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await _service.updateMeal(mealPlanId, meal);

      // Refresh the meal plan
      final updatedPlan = await _service.getMealPlan(mealPlanId);
      if (updatedPlan != null) {
        final index = _mealPlans.indexWhere((p) => p.id == mealPlanId);
        if (index != -1) {
          _mealPlans[index] = updatedPlan;
        }

        if (_selectedMealPlan?.id == mealPlanId) {
          _selectedMealPlan = updatedPlan;
        }
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete a meal
  Future<bool> deleteMeal(String mealPlanId, String mealId) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await _service.deleteMeal(mealPlanId, mealId);

      // Refresh the meal plan
      final updatedPlan = await _service.getMealPlan(mealPlanId);
      if (updatedPlan != null) {
        final index = _mealPlans.indexWhere((p) => p.id == mealPlanId);
        if (index != -1) {
          _mealPlans[index] = updatedPlan;
        }

        if (_selectedMealPlan?.id == mealPlanId) {
          _selectedMealPlan = updatedPlan;
        }
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Select a meal plan
  void selectMealPlan(MealPlanModel? mealPlan) {
    _selectedMealPlan = mealPlan;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
