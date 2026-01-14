import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal_plan_model.dart';
import '../models/meal_model.dart';

class MealPlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'meal_plans';

  Future<MealPlanModel> createMealPlan(MealPlanModel mealPlan) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(mealPlan.id)
          .set(mealPlan.toJson());
      return mealPlan;
    } catch (e) {
      throw 'Failed to create meal plan: $e';
    }
  }

  Future<List<MealPlanModel>> getMealPlans(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => MealPlanModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw 'Failed to fetch meal plans: $e';
    }
  }

  Future<MealPlanModel?> getMealPlan(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (doc.exists) {
        return MealPlanModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch meal plan: $e';
    }
  }

  Future<void> updateMealPlan(MealPlanModel mealPlan) async {
    try {
      final updatedPlan = mealPlan.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection(_collection)
          .doc(mealPlan.id)
          .update(updatedPlan.toJson());
    } catch (e) {
      throw 'Failed to update meal plan: $e';
    }
  }

  // Delete a meal plan
  Future<void> deleteMealPlan(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw 'Failed to delete meal plan: $e';
    }
  }

  // Add a meal to a meal plan
  Future<void> addMeal(String mealPlanId, MealModel meal) async {
    try {
      final mealPlan = await getMealPlan(mealPlanId);
      if (mealPlan == null) {
        throw 'Meal plan not found';
      }

      final updatedMeals = [...mealPlan.meals, meal];
      final updatedPlan = mealPlan.copyWith(
        meals: updatedMeals,
        updatedAt: DateTime.now(),
      );

      await updateMealPlan(updatedPlan);
    } catch (e) {
      throw 'Failed to add meal: $e';
    }
  }

  // Update a meal in a meal plan
  Future<void> updateMeal(String mealPlanId, MealModel updatedMeal) async {
    try {
      final mealPlan = await getMealPlan(mealPlanId);
      if (mealPlan == null) {
        throw 'Meal plan not found';
      }

      final updatedMeals = mealPlan.meals.map((meal) {
        return meal.id == updatedMeal.id ? updatedMeal : meal;
      }).toList();

      final updatedPlan = mealPlan.copyWith(
        meals: updatedMeals,
        updatedAt: DateTime.now(),
      );

      await updateMealPlan(updatedPlan);
    } catch (e) {
      throw 'Failed to update meal: $e';
    }
  }

  // Delete a meal from a meal plan
  Future<void> deleteMeal(String mealPlanId, String mealId) async {
    try {
      final mealPlan = await getMealPlan(mealPlanId);
      if (mealPlan == null) {
        throw 'Meal plan not found';
      }

      final updatedMeals = mealPlan.meals
          .where((meal) => meal.id != mealId)
          .toList();

      final updatedPlan = mealPlan.copyWith(
        meals: updatedMeals,
        updatedAt: DateTime.now(),
      );

      await updateMealPlan(updatedPlan);
    } catch (e) {
      throw 'Failed to delete meal: $e';
    }
  }

  // Stream of meal plans for real-time updates
  Stream<List<MealPlanModel>> streamMealPlans(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MealPlanModel.fromJson(doc.data()))
              .toList();
        });
  }
}
