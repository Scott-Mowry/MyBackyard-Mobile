import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/app_bar_back_button.dart';
import 'package:backyard/core/view_model/base_view_model_container.dart';
import 'package:backyard/features/subscriptions/view/external_subscriptions_view_model.dart';
import 'package:backyard/features/subscriptions/view/widget/external_subscription_plan_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

@RoutePage()
class ExternalSubscriptionsView extends StatefulWidget {
  final ExternalSubscriptionsViewModel? viewModel;

  const ExternalSubscriptionsView({super.key, this.viewModel});

  @override
  State<ExternalSubscriptionsView> createState() => _ExternalSubscriptionsViewState();
}

class _ExternalSubscriptionsViewState extends State<ExternalSubscriptionsView> {
  late final _viewModel = widget.viewModel ?? getIt<ExternalSubscriptionsViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: AppBar(
        leading: AppBarBackButton(),
        title: Text(
          'Subscription plans',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),
        ),
        backgroundColor: CustomColors.white,
      ),
      body: BaseViewModelContainer(
        viewModel: _viewModel,
        child: Observer(
          builder: (context) {
            final subscriptionPlans = _viewModel.subscriptionPlans;
            final currentUser = _viewModel.currentUser;
            return PageView.builder(
              itemCount: subscriptionPlans.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: CustomSpacer.horizontal.md,
                    child: ExternalSubscriptionPlanTile(
                      subscriptionPlan: subscriptionPlans[index],
                      userSubscribedPlanId: currentUser?.subId,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  double cardWidth(int i, int length) {
    if (length % 2 == 0) {
      return 45.w;
    } else {
      if (i == length - 1) {
        return 93.w;
      } else {
        return 45.w;
      }
    }
  }
}
