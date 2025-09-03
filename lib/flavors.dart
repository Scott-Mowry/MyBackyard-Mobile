enum Flavor {
  stg,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.stg:
        return '[Stg]Backyard';
      case Flavor.prod:
        return 'Backyard';
    }
  }

}
