import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/meal_plan_provider.dart';
import '../widgets/meal_plan_card.dart';
import 'meal_plan_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMealPlans();
    });
  }

  Future<void> _loadMealPlans() async {
    final authProvider = context.read<AuthProvider>();
    final mealPlanProvider = context.read<MealPlanProvider>();

    if (authProvider.user != null) {
      await mealPlanProvider.loadMealPlans(authProvider.user!.uid);

      if (mealPlanProvider.errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mealPlanProvider.errorMessage!),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _loadMealPlans,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final mealPlanProvider = context.watch<MealPlanProvider>();
    final user = authProvider.user;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadMealPlans,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(user?.name ?? 'User', l10n),
            _buildDailySummary(mealPlanProvider, l10n),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.yourMealPlans, style: AppTextStyles.h3),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        l10n.viewAll,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            mealPlanProvider.isLoading && mealPlanProvider.mealPlans.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : mealPlanProvider.mealPlans.isEmpty
                ? SliverToBoxAdapter(child: _buildEmptyState(l10n))
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final mealPlan = mealPlanProvider.mealPlans[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: MealPlanCard(
                            mealPlan: mealPlan,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MealPlanDetailsScreen(mealPlan: mealPlan),
                                ),
                              );
                            },
                          ),
                        );
                      }, childCount: mealPlanProvider.mealPlans.length),
                    ),
                  ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(String userName, AppLocalizations l10n) {
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? l10n.goodMorning
        : (now.hour < 17 ? l10n.goodAfternoon : l10n.goodEvening);

    return SliverAppBar(
      expandedHeight: 120,
      backgroundColor: AppColors.background,
      elevation: 0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(userName, style: AppTextStyles.h2),
            ],
          ),
        ),
      ),
      actions: [
        const SizedBox(width: 16), // Placeholder for spacing or other actions
      ],
    );
  }

  Widget _buildDailySummary(MealPlanProvider provider, AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.dailyProgress,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.insights_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(l10n.calories, '1,240', 'kcal'),
                  _buildDivider(),
                  _buildSummaryItem(l10n.protein, '85', 'g'),
                  _buildDivider(),
                  _buildSummaryItem(l10n.carbs, '140', 'g'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 22),
        ),
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: AppTextStyles.overline.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.noMealPlansYet, style: AppTextStyles.h3),
            const SizedBox(height: 12),
            Text(
              l10n.startJourney,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
