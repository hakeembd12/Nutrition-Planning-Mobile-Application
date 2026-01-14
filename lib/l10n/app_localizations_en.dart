// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nutrition';

  @override
  String get appSubtitle => 'Your personal health companion';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get discover => 'Discover';

  @override
  String get stats => 'Stats';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get security => 'Security';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get dailyProgress => 'Daily Progress';

  @override
  String get calories => 'Calories';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Carbs';

  @override
  String get fats => 'Fats';

  @override
  String get yourMealPlans => 'Your Meal Plans';

  @override
  String get viewAll => 'View All';

  @override
  String get addPlan => 'Add Plan';

  @override
  String get addMeal => 'Add Meal';

  @override
  String get deleteMealPlan => 'Delete Meal Plan';

  @override
  String get deleteMealPlanConfirm =>
      'Are you sure you want to delete this meal plan? This action cannot be undone.';

  @override
  String get mealPlanDeletedSuccessfully => 'Meal plan deleted successfully';

  @override
  String get failedToDeleteMealPlan => 'Failed to delete meal plan';

  @override
  String get deleteMeal => 'Delete Meal';

  @override
  String get deleteMealConfirm => 'Are you sure you want to delete this meal?';

  @override
  String get mealDeletedSuccessfully => 'Meal deleted successfully';

  @override
  String get failedToDeleteMeal => 'Failed to delete meal';

  @override
  String get noMealsAddedYet => 'No meals added yet';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get noMealPlansYet => 'No Meal Plans Yet';

  @override
  String get startJourney =>
      'Start your nutrition journey by creating your first meal plan.';

  @override
  String get recipesAndInspiration => 'Recipes & Inspiration';

  @override
  String get exploreHealthyMeals =>
      'Explore healthy meals and nutrition tips.\nComing Soon!';

  @override
  String get detailedAnalytics =>
      'Detailed analytics of your eating habits.\nComing Soon!';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get signInToContinue => 'Sign in to continue to Nutrition Planner';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinNutritionPlanner =>
      'Join Nutrition Planner to track your meals';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get reEnterYourPassword => 'Re-enter your password';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get signUpFailed => 'Sign up failed';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snack => 'Snack';

  @override
  String get createMealPlan => 'Create Meal Plan';

  @override
  String get planName => 'Plan Name';

  @override
  String get descriptionOptional => 'Description (Optional)';

  @override
  String get dateRange => 'Date Range';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get mealPlanCreatedSuccessfully => 'Meal plan created successfully!';

  @override
  String get failedToCreateMealPlan => 'Failed to create meal plan';

  @override
  String get editMeal => 'Edit Meal';

  @override
  String get mealName => 'Meal Name';

  @override
  String get mealType => 'Meal Type';

  @override
  String get nutritionInformation => 'Nutrition Information';

  @override
  String get mealUpdatedSuccessfully => 'Meal updated successfully!';

  @override
  String get mealAddedSuccessfully => 'Meal added successfully!';

  @override
  String get failedToSaveMeal => 'Failed to save meal';

  @override
  String get updateMeal => 'Update Meal';

  @override
  String get forgotPasswordDescription =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get passwordResetEmailSent =>
      'Password reset email sent! Check your inbox.';

  @override
  String get failedToSendResetEmail => 'Failed to send reset email';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String mealsCount(int count) {
    return 'Meals ($count)';
  }
}
