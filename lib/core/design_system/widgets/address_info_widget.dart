import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/available_maps_bottom_sheet.dart';
import 'package:backyard/core/design_system/widgets/custom_bottom_sheet.dart';
import 'package:backyard/core/helper/snackbar_helper.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';

class AddressInfoWidget extends StatelessWidget {
  final String address;
  final double fontSize;
  final int maxLines;

  const AddressInfoWidget({super.key, required this.address, this.fontSize = 14, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    if (address.isEmpty) return SizedBox.shrink();
    return Row(
      children: [
        Image.asset(ImagePath.location, color: CustomColors.primaryGreenColor, height: 18, fit: BoxFit.fitHeight),
        Flexible(
          child: Padding(
            padding: CustomSpacer.left.xs,
            child: Text(
              address,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: fontSize, color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: CustomSpacer.left.xs,
          child: InkWell(
            onTap: () => showAddressOnMap(context),
            child: Icon(Icons.open_in_new, size: 18, color: CustomColors.grey),
          ),
        ),
      ],
    );
  }

  Future<void> showAddressOnMap(BuildContext context) async {
    final locations = await locationFromAddress(address);
    if (locations.isEmpty) {
      return showSnackbar(context: context, content: 'Could not find coordinates for this address.');
    }

    final availableMaps = await MapLauncher.installedMaps;
    return showCustomBottomSheet(
      maxHeightFactor: 0.5,
      context: context,
      routeName: 'AvailableMapsBottomSheetRoute',
      child: AvailableMapsBottomSheet(
        availableMaps: availableMaps,
        address: address,
        coords: Coords(locations.first.latitude, locations.first.longitude),
      ),
    );
  }
}
