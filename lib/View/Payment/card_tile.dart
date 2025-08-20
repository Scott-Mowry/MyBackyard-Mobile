import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:backyard/Component/custom_card.dart';
import 'package:backyard/Component/custom_radio_tile.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Model/card_model.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:sizer/sizer.dart';

class CardTile extends StatelessWidget {
  CardTile({super.key, required this.index, required this.c});
  int index;
  CardModel c;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                // HomeController.i.deleteCard(context,index: index, id:HomeController.i.cards[index].id??"",onSuccess: (){});
              },
              child: Container(
                  padding: const EdgeInsets.all(3.0),
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: MyColors().whiteColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    ImagePath.delete,
                    color: MyColors().errorColor,
                    width: 5.w,
                  )),
            )
          ],
        ),
        child: GestureDetector(
          onTap: () {
            // HomeController.i.setCardDefault(context, onSuccess: (){},index: index, id: HomeController.i.cards[index].id);
          },
          child: CustomCard(
              padding: EdgeInsets.all(3.w),
              child: Container(
                // width: 80.w,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      ImagePath.visa,
                      width: 8.w,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    MyText(title: '**** **** **** ${c.last4}'),
                    Spacer(),
                    CustomRadioTile(
                      v: (index == 0),
                      color: MyColors().visaColor,
                    )
                    // Obx(()=> CustomRadioTile(v: (true).obs,color: MyColors().visaColor,))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
