class RatingListData {
  RatingListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.rating = 3,
    this.date = "10 jun, 2020",
  });

  String imagePath;
  String titleTxt;
  String subTxt;
  double rating;
  String date;

  static List<RatingListData> ratingList = <RatingListData>[
    RatingListData(
      imagePath: 'assets/icons/persono.png',
      titleTxt: 'Jonathon',
      subTxt:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      rating: 5,
      date: "10 jun, 2020",
    ),
    RatingListData(
      imagePath: 'assets/icons/persont.png',
      titleTxt: 'Jahid Jaykar',
      subTxt:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      rating: 5,
      date: "10 jun, 2020",
    ),
    RatingListData(
      imagePath: 'assets/icons/persono.png',
      titleTxt: 'Jonathon',
      subTxt:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      rating: 5,
      date: "10 jun, 2020",
    ),
    RatingListData(
      imagePath: 'assets/icons/persont.png',
      titleTxt: 'Jahid Jaykar',
      subTxt:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      rating: 5,
      date: "10 jun, 2020",
    ),
    RatingListData(
      imagePath: 'assets/icons/persono.png',
      titleTxt: 'Jonathon',
      subTxt:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      rating: 5,
      date: "10 jun, 2020",
    ),
  ];
}
