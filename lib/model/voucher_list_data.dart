class VoucherListData {
  VoucherListData({
    this.imagePath = '',
    this.title = '',
    this.subTitle = "",
    this.date = "",
    this.price = "",
    this.miniprice = "",
  });

  String imagePath;
  String title;
  String subTitle;
  String date;
  String price;
  String miniprice;

  static List<VoucherListData> voucherList = <VoucherListData>[
    VoucherListData(
        imagePath: 'assets/icons/salad.png',
        title: 'Good to see you again',
        subTitle: "wbPyiEm",
        date: "Valid until 01.09.2020",
        price: "2257",
        miniprice: "120"),
  ];
}
