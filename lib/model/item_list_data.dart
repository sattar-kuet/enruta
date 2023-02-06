class ItemListData {
  ItemListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.dist = 1.8,
    this.reviews = 123,
    this.rating = 3.5,
    this.favorite = false,
  });
  String imagePath;
  String titleTxt;
  String subTxt;
  double dist;
  double rating;
  int reviews;
  bool favorite;

  static List<ItemListData> itemList = <ItemListData>[
    ItemListData(
      imagePath: 'assets/icons/fresh.png',
      titleTxt: '35-40 min',
      subTxt: "Veestro Healthy",
      dist: 2.0,
      reviews: 80,
      rating: 5,
      favorite: true,
    ),
    ItemListData(
      imagePath: 'assets/icons/imagest.png',
      titleTxt: '35-41 min',
      subTxt: 'Veestro Healthy',
      dist: 4.0,
      reviews: 74,
      rating: 2.5,
      favorite: true,
    ),
    ItemListData(
      imagePath: 'assets/icons/mg.png',
      titleTxt: '35-42 min',
      subTxt: 'Veestro Healthy',
      dist: 3.0,
      reviews: 62,
      rating: 3.5,
      favorite: true,
    ),
    ItemListData(
      imagePath: 'assets/icons/fresh.png',
      titleTxt: '35-43 min',
      subTxt: 'Veestro Healthy',
      dist: 7.0,
      reviews: 90,
      rating: 4.5,
      favorite: true,
    ),
    ItemListData(
      imagePath: 'assets/icons/mg.png',
      titleTxt: '35-44 min',
      subTxt: 'Veestro Healthy',
      dist: 2.0,
      reviews: 240,
      rating: 4.5,
      favorite: true,
    ),
  ];
}
