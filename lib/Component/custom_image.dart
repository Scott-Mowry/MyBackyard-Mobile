import 'package:backyard/Service/api.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/loader.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/Utils/photo_view.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:sizer/sizer.dart';

class CustomImage extends StatelessWidget {
  CustomImage(
      {this.url,
      this.shape,
      this.fit,
      this.height,
      this.borderRadius,
      this.isProfile,
      this.width,
      this.border,
      this.radius,
      this.photoView = true});
  String? url;
  BoxFit? fit;
  BoxShape? shape;
  bool? isProfile;
  bool? border;
  double? width, height, radius;
  BorderRadius? borderRadius;
  bool photoView = true;

  @override
  Widget build(BuildContext context) {
    return url == null
        ? assetImage()
        : url == ""
            ? assetImage()
            : photoView == true
                ? GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PhotoViewScreen(
                                path: API.public_url + url!,
                              )));
                    },
                    child: networkImage())
                : networkImage();
  }

  assetImage() {
    return ClipRRect(
      borderRadius: //BorderRadius.circular(200),
          BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Image.asset(
        isProfile == true ? ImagePath.noUserImage : ImagePath.noImage,
        // child: Image.asset(isProfile==true? ImagePath.random4:ImagePath.noImage,
        fit: fit ?? BoxFit.cover,
        width: width ?? 30.w,
        height: height ?? 30.w,
      ),
    );
  }

  errorImage() {
    return Image.asset(
      ImagePath.error,
      scale: 3,
    );
  }

  networkImage() {
    return ExtendedImage.network(
      API.public_url + url!,
      width: width ?? 30.w,
      height: height ?? 30.w,
      fit: fit ?? BoxFit.cover,
      cache: true,

      border: (border ?? false)
          ? Border.all(color: MyColors().primaryColor, width: 2)
          : null,
      shape: shape ?? BoxShape.rectangle,
      borderRadius:
          borderRadius ?? BorderRadius.all(Radius.circular(radius ?? 0)),
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Loader();
          case LoadState.failed:
            return errorImage();
          case LoadState.completed:
            // TODO: Handle this case.
            break;
        }
        return null;
      },
      //cancelToken: cancellationToken,
    );
  }
}
