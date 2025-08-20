class ScreenArguments {
  bool? fromEdit,
      fromOffer,
      fromHistory,
      fromSettings,
      isSupport,
      isFirebase,
      isMe,
      fromCompleteProfile;
  String? url;
  int? index;
  Map<String, dynamic>? args;

  ScreenArguments(
      {this.fromEdit,
      this.fromOffer,
      this.fromHistory,
      this.isSupport,
      this.fromSettings,
      this.url,
      this.index,
      this.args,
      this.isFirebase,
      showSellerProfileOnly,
      this.isMe,
      this.fromCompleteProfile});
}
