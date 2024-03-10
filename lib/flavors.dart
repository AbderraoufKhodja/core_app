enum Flavor {
  swappers,
  fibali,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.swappers:
        return 'Swappers';
      case Flavor.fibali:
        return 'Fibali';
      default:
        return 'title';
    }
  }

}
