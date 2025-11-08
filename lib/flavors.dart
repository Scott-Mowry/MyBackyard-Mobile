enum AppBuildFlavorEnum {
  STG('[Stg]Backyard', 'com.app.mybackyardusa1.stg', 'com.celect.mybackyardapp.stg', '-', '-'),
  PROD('Backyard', 'com.app.mybackyardusa1', 'com.celect.mybackyardapp', '-', '-');

  const AppBuildFlavorEnum(
    this.appTitle,
    this.androidBundleName,
    this.iOSBundleName,
    this.webDomainUrl,
    this.googleSignInClientId,
  );

  final String appTitle;
  final String androidBundleName;
  final String iOSBundleName;
  final String webDomainUrl;
  final String googleSignInClientId;
}

late final AppBuildFlavorEnum appBuildFlavor;

extension AppBuildFlavorEnumExtension on AppBuildFlavorEnum {
  bool get isStg => this == AppBuildFlavorEnum.STG;

  bool get isProd => this == AppBuildFlavorEnum.PROD;
}
