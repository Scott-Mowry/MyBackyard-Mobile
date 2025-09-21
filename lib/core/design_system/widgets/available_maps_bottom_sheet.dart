import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_radius.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';

class AvailableMapsBottomSheet extends StatelessWidget {
  final List<AvailableMap> availableMaps;
  final String address;
  final Coords coords;

  const AvailableMapsBottomSheet({super.key, required this.availableMaps, required this.address, required this.coords});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: CustomSpacer.horizontal.md,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: CustomSpacer.top.xs + EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width / 3),
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.4),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
          Padding(
            padding: CustomSpacer.top.md + CustomSpacer.bottom.xmd,
            child: Text(
              'Choose an app to open this address',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
            ),
          ),
          ...availableMaps.map((el) {
            return InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CustomRadius.s)),
              onTap: () => el.showDirections(destination: coords, destinationTitle: address),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(color: CustomColors.lightGreyColor, thickness: 0.2, height: 0),
                  Padding(
                    padding: CustomSpacer.top.md,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(CustomRadius.xs),
                              child: SvgPicture.asset(el.icon, width: 36),
                            ),
                            Padding(
                              padding: CustomSpacer.left.md,
                              child: Text(
                                el.mapName,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.keyboard_arrow_right_outlined, color: CustomColors.grey.withValues(alpha: 0.5)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: CustomSpacer.vertical.lg.vertical),
        ],
      ),
    );
  }
}
