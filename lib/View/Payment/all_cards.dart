import 'dart:ui';

import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/View/Widget/Dialog/success_payment.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_card.dart';
import 'package:backyard/Component/custom_empty_data.dart';
import 'package:backyard/Component/custom_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_radio_tile.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Model/card_model.dart';
import 'package:backyard/Model/category_product_model.dart';
import 'package:backyard/Model/menu_model.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/Widget/counter.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import '../../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'card_tile.dart';

class PaymentMethod extends StatefulWidget {
  PaymentMethod({this.fromSettings = false});
  bool fromSettings = false;
  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: 'Payment Details',
        showAppBar: true,
        showBackButton: true,
        resizeBottomInset: false,
        bgImage: '',
        child: CustomPadding(
          horizontalPadding: 20,
          topPadding: 0,
          child: Consumer<HomeController>(builder: (context, val, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // cardsList(c: d.cards),
                // // Text('${d.cards.length}'),
                // // cardsList(c: d.cards),
                // SizedBox(height: 2.h,),
                GestureDetector(
                  onTap: () {
                    AppNavigation.navigateTo(AppRouteName.ADD_CARD_ROUTE);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        // color: MyColors().secondaryColor.withOpacity(.3),
                        image: DecorationImage(
                            image: AssetImage(ImagePath.dottedBorder),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.all(4.w) +
                        EdgeInsets.symmetric(vertical: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImagePath.card2,
                          scale: 2,
                          color: MyColors().primaryColor,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        MyText(
                          title: '  Add New Card',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: Slidable(
                          key: UniqueKey(),
                          endActionPane: ActionPane(
                            dragDismissible: false,
                            extentRatio: 0.16,
                            motion: ScrollMotion(),
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print('delete wala');
                                  // print('dedd ${d.cards[index].id}');
                                  // d.deleteCard(context,index: index, id:d.cards[index].id,onSuccess: (){});
                                },
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    margin: const EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                        // color:MyColors().blackLight,
                                        // borderRadius: BorderRadius.circular(10)
                                        // shape: BoxShape.circle,
                                        ),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      ImagePath.delete,
                                      scale: 2,
                                    )),
                              )
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // d.setCardDefault(context, onSuccess: (){},index: index, id: d.cards[index].id);
                            },
                            child: Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                    color: MyColors()
                                        .secondaryColor
                                        .withOpacity(.3),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: MyColors().secondaryColor,
                                    )),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      ImagePath.card,
                                      scale: 2,
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    MyText(title: '**** **** **** 2323'),
                                    // MyText(title: 'Visa Card:  ******9514',size: 15,),
                                    Spacer(),
                                    // CustomRadioTile(v: (c.isActive==1).obs,color: MyColors().visaColor,)
                                    CustomRadioTile(
                                      v: (index == 0),
                                      color: MyColors().whiteColor,
                                    )
                                  ],
                                )),
                          ),
                        ),
                      );
                    }),

                SizedBox(
                  height: 2.h,
                ),
                if (!widget.fromSettings) ...[
                  MyButton(
                      // width: 90.w,
                      title: 'Pay Now',
                      onTap: () {
                        final controller = context.read<HomeController>();
                        if (controller.cards?.isEmpty ?? false) {
                          CustomToast().showToast(message: 'Please add card');
                        } else {
                          onSubmit(context);
                        }
                      }),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ],
            );
          }),
        ));
  }

  Widget cardsList({required List<CardModel> c}) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: c.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Slidable(
              key: UniqueKey(),
              endActionPane: ActionPane(
                dragDismissible: false,
                extentRatio: 0.12,
                motion: ScrollMotion(),
                children: [
                  GestureDetector(
                    onTap: () {
                      if (c.length != 1) {
                        // HomeController.i.deleteCard(context,
                        //     index: index,
                        //     id: HomeController.i.cards[index].id ?? "",
                        //     onSuccess: () {});

                        // CustomToast().showToast('Success', 'Card deleted successfully', true);
                      }
                      // showDialog(
                      //     context: context,
                      //     barrierDismissible: false,
                      //     builder: (BuildContext context) {
                      //       return BackdropFilter(
                      //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      //         child: AlertDialog(
                      //           backgroundColor: Colors.transparent,
                      //           contentPadding: const EdgeInsets.all(0),
                      //           insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
                      //           content: DeleteCardDialog(title: 'Delete Card',
                      //             subTitle: 'Are you sure you want to delete this card details ?',
                      //             onYes: () {
                      //               cards.removeAt(index);
                      //               setState(() {});
                      //               CustomToast().showToast("Success", 'Card deleted successfully', false);
                      //             },),
                      //         ),
                      //       );
                      //     }
                      // );
                    },
                    child: Container(
                        padding: const EdgeInsets.all(3.0),
                        margin: const EdgeInsets.all(5.0),
                        alignment: Alignment.topCenter,
                        child: Icon(
                          Icons.delete_rounded,
                          color: MyColors().primaryColor2,
                        )
                        // Image.asset(ImagePath.delete,width: 5.w,color: Colors.red,)
                        ),
                  )
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  // HomeController.i.setCardDefault(context,
                  //     onSuccess: () {},
                  //     index: index,
                  //     id: HomeController.i.cards[index].id);
                },
                child: Container(
                  // width: 80.w,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                      color: MyColors().secondaryColor.withOpacity(.3),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: MyColors().secondaryColor,
                      )),
                  alignment: Alignment.center,
                  child: Row(children: [
                    Image.asset(
                      ImagePath.stripe,
                      scale: 2,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    MyText(title: c[index].last4 ?? ''),
                    Spacer(),
                    CustomRadioTile(
                      v: (0 == index),
                      color: MyColors().secondaryColor,
                    )
                  ]),
                ),
              ),
            ),
          );

          // CardTile(c: CardModel(),index: index,);
        });
  }

  Widget cardsList2({required List<CardModel> c}) {
    return Expanded(
      child: c.isEmpty
          ? CustomEmptyData(
              title: 'No Cards',
            )
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: c.length,
              itemBuilder: (context, index) {
                return CardTile(
                  c: c[index],
                  index: index,
                );
              }),
    );
  }

  onSubmit(context) {
    // HomeController.i.payForSession(context, onSuccess: () {
    //   successDialog();
    // });
  }

  successDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              content: SuccessPaymentDialog(),
            ),
          );
        });
  }
}
