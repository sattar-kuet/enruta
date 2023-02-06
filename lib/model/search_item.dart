class SearchItem {
  dynamic status;
  List<SearchData> data;

  SearchItem({this.status, this.data});

  SearchItem.fromJson(json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SearchData>[];
      json['data'].forEach((v) {
        data.add(new SearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchData {
  int shopId;
  dynamic discountOffer;
  dynamic discountCoupon;
  int shopStatus;
  int catId;
  int userId;
  String name;
  int vat;
  int deliveryCharge;
  bool favorite;
  String time;
  String logo;
  int totalReview;
  String rating;
  String address;
  String lat;
  String lng;

  SearchData(
      {this.shopId,
      this.discountOffer,
      this.discountCoupon,
      this.shopStatus,
      this.catId,
      this.userId,
      this.name,
      this.vat,
      this.deliveryCharge,
      this.favorite,
      this.time,
      this.logo,
      this.totalReview,
      this.rating,
      this.address,
      this.lat,
      this.lng});

  SearchData.fromJson(json) {
    shopId = json['shopId'];
    discountOffer = json['discountOffer'];
    discountCoupon = json['discountCoupon'];
    shopStatus = json['shopStatus'];
    catId = json['catId'];
    userId = json['userId'];
    name = json['name'];
    vat = json['vat'];
    deliveryCharge = json['delivery_charge'];
    favorite = json['favorite'];
    time = json['time'];
    logo = json['logo'];
    totalReview = json['totalReview'];
    rating = json['rating'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopId'] = this.shopId;
    data['discountOffer'] = this.discountOffer;
    data['discountCoupon'] = this.discountCoupon;
    data['shopStatus'] = this.shopStatus;
    data['catId'] = this.catId;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['vat'] = this.vat;
    data['delivery_charge'] = this.deliveryCharge;
    data['favorite'] = this.favorite;
    data['time'] = this.time;
    data['logo'] = this.logo;
    data['totalReview'] = this.totalReview;
    data['rating'] = this.rating;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
