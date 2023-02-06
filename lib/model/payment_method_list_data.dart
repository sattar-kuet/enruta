class PaymentMethodListData {
  PaymentMethodListData({
    this.imagePath = '',
    this.paymentTitle = '',
    this.paymentDetails = "",
  });
  String imagePath;
  String paymentTitle;
  String paymentDetails;

  static List<PaymentMethodListData> paymentMethodList =
      <PaymentMethodListData>[
    // PaymentMethodListData(
    //     imagePath: 'assets/icons/payPalIcon.png',
    //     paymentTitle: 'PayPal Email',
    //     paymentDetails: 'jahid.jaykar@gmail.com'),
    PaymentMethodListData(
        imagePath: 'assets/icons/cIcon.png',
        paymentTitle: 'Card Number',
        paymentDetails: 'xxxx xxxx xxxx 4444'),
    // PaymentMethodListData(
    //     imagePath: 'assets/icons/payoneerIcon.png',
    //     paymentTitle: 'Payoneer Email',
    //     paymentDetails: 'jahid.jaykar@gmail.com'),
    // PaymentMethodListData(
    //     imagePath: 'assets/icons/visaIcon.png',
    //     paymentTitle: 'Card Number',
    //     paymentDetails: 'xxxx xxxx xxxx 5647'),
  ];
}
