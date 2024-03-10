enum TranslationState { danger, normal, alert }

class TranslationCheckItem {
  const TranslationCheckItem(
      {this.title, this.info, this.pathImage, this.state});

  final String? title;
  final String? info;
  final String? pathImage;
  final TranslationState? state;

  static const listItemCheck = [
    TranslationCheckItem(
      title: 'Weight & Height',
      info: '149.7 lb - 172 cm',
      pathImage: 'assets/img/medical/weight.png',
      state: TranslationState.normal,
    ),
    TranslationCheckItem(
      title: 'Blood pressure',
      info: '130/90 mm',
      pathImage: 'assets/img/medical/arm.png',
      state: TranslationState.alert,
    ),
    TranslationCheckItem(
      title: 'Cholesterol',
      info: '200 mg/dl',
      pathImage: 'assets/img/medical/cholesterol.png',
      state: TranslationState.alert,
    ),
    TranslationCheckItem(
      title: 'Glucose',
      info: '200 mg/dl',
      pathImage: 'assets/img/medical/diabetes-test.png',
      state: TranslationState.danger,
    ),
    TranslationCheckItem(
      title: 'Lung health',
      info: '90 %',
      pathImage: 'assets/img/medical/lungs.png',
      state: TranslationState.normal,
    ),
    TranslationCheckItem(
      title: 'Stress',
      info: '40 %',
      pathImage: 'assets/img/medical/brain.png',
      state: TranslationState.alert,
    ),
  ];
}
