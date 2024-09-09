import 'package:flutter/material.dart';
import 'package:rpskindisease/mixin/responsive-layout-mixin.dart';

import '../../../utils/constants/dimensions.dart';

class InitialLayout extends StatelessWidget with ResponsiveLayoutMixin {
  const InitialLayout(
      {super.key,
      required this.body,
      this.bottomNavigationButton,
      this.onCloseButtonPressed,
      this.backgroundColor,
      this.isBackButtonDisable});

  final List<Widget> body;
  final Widget? bottomNavigationButton;
  final void Function()? onCloseButtonPressed;
  final Color? backgroundColor;
  final bool? isBackButtonDisable;

  @override
  Widget build(BuildContext context) =>
      // SafeArea(
      //       child:
      GestureDetector(
        onTap: () {},
        child: WillPopScope(
          onWillPop: () async {
            //TODO handle this will pop when backend is ready
            if (isBackButtonDisable ?? false) {
              // await AlertDialogUtil().showSuccessOrFailStateDialog(
              //     context: context,
              //     successOrFailState: SuccessOrFailState.fail,
              //     text:
              //         'Returning back may lead to the termination of the ongoing process. Are you sure you want to proceed?',
              //     onPrimaryButtonPressed: () {
              //       moveToScreen(context, RouteNames.getStartedScreen);
              //     });
              return false;
            } else {
              // await Future.delayed(Duration.zero);
              // if (!context.mounted) return false;
              // popScreen(context);
              return true;
            }
          },
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: getContentWidth(context),
                    height: getContentHeight(context),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // if (onCloseButtonPressed != null)
                        //   ScreenCloseButton(
                        //     onPressed: onCloseButtonPressed!,
                        //   ),
                        ...body,
                        const SizedBox(
                          height: Dimensions.emptyBottomHeight,
                        ),
                      ],
                    ),
                  ),
                ),
                // const AppLoadingIndicator(),
              ],
            ),
            bottomNavigationBar: bottomNavigationButton,
          ),
        ),
        // ),
      );
}
