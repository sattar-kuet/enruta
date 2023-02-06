class ReviewListData {
  ReviewListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.qty = "5",
    this.price = "123",
  });

  String imagePath;
  String titleTxt;
  String subTxt;
  String qty;
  String price;

  static List<ReviewListData> reviewList = <ReviewListData>[
    ReviewListData(
      imagePath: 'assets/icons/salad.png',
      titleTxt: 'Brussel Sprouts  Tahini',
      subTxt:
          'it is a long established fact that a reader will be distracted by the readable content of a page when',
      qty: "9",
      price: "57",
    ),
    ReviewListData(
      imagePath: 'assets/icons/salad(2).png',
      titleTxt: 'Brussel Sprouts  Tahini',
      subTxt:
          'it is a long established fact that a reader will be distracted by the readable content of a page when...',
      qty: "3",
      price: "57",
    ),
    ReviewListData(
      imagePath: 'assets/icons/salad.png',
      titleTxt: 'Brussel Sprouts  Tahini',
      subTxt:
          'it is a long established fact that a reader will be distracted by the readable content of a page when,..',
      qty: "55",
      price: "57",
    ),
    ReviewListData(
      imagePath: 'assets/icons/salad(2).png',
      titleTxt: 'Brussel Sprouts  Tahini',
      subTxt:
          'it is a long established fact that a reader will be distracted by the readable content of a page when',
      qty: "5",
      price: "57",
    ),
    ReviewListData(
      imagePath: 'assets/icons/salad.png',
      titleTxt: 'Brussel Sprouts  Tahini',
      subTxt:
          'it is a long established fact that a reader will be distracted by the readable content of a page when',
      qty: "990",
      price: "57",
    ),
  ];
}
