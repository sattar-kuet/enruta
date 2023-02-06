class LocationListData {
  LocationListData({
    this.locationType = '',
    this.locationTitle = '',
    this.locationDetails = "",
  });
  String locationType;
  String locationTitle;
  String locationDetails;

  static List<LocationListData> locationList = <LocationListData>[
    LocationListData(
        locationType: '1',
        locationTitle: 'Current Location',
        locationDetails: 'Gulshan Avinew, Dhaka'),
    LocationListData(
        locationType: '2',
        locationTitle: 'Home',
        locationDetails: 'House-21, Road-21, Merul Badda, Dhaka-1212'),
    LocationListData(
        locationType: '3',
        locationTitle: 'Office',
        locationDetails: 'Navana Yusuf Infinity. 16 Mohakhali C/A, Dhaka-1212'),
    LocationListData(
        locationType: '4',
        locationTitle: 'Coffee Shop ',
        locationDetails: 'Gulshan link road, Dhaka'),
    LocationListData(
        locationType: '4',
        locationTitle: 'Favorite Shopping Center',
        locationDetails: 'Jumuna Future Park, Bashundhara, Dhaka'),
  ];
}
