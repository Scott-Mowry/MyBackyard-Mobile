class ContentRoutingArgument {
  String title, contentType,url;
  Function(bool)? isMerchantSetupDone;
  ContentRoutingArgument({required this.title,required this.contentType,required this.url,this.isMerchantSetupDone});
}
