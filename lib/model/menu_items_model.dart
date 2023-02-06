class MenuItemsModel {
  int status;
  dynamic shopid;
  String shopname;
  String shoplogo;
  String shopcover;
  int vat;
  int deliveryCharge;
  int shopCategory;
  String categoryName;
  List<Products> products;

  MenuItemsModel(
      {this.status,
        this.shopid,
        this.shopname,
        this.shoplogo,
        this.shopcover,
        this.vat,
        this.deliveryCharge,
        this.shopCategory,
        this.categoryName,
        this.products});

  MenuItemsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    shopid = json['shopid'];
    shopname = json['shopname'];
    shoplogo = json['shoplogo'];
    shopcover = json['shopcover'];
    vat = json['vat'];
    deliveryCharge = json['deliveryCharge'];
    shopCategory = json['shopCategory'];
    categoryName = json['categoryName'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['shopid'] = this.shopid;
    data['shopname'] = this.shopname;
    data['shoplogo'] = this.shoplogo;
    data['shopcover'] = this.shopcover;
    data['vat'] = this.vat;
    data['deliveryCharge'] = this.deliveryCharge;
    data['shopCategory'] = this.shopCategory;
    data['categoryName'] = this.categoryName;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int id;
  String title;
  String subTxt;
  dynamic price;
  List<String> logo;
  dynamic sizes;
  dynamic colors;

  Products(
      {this.id,
        this.title,
        this.subTxt,
        this.price,
        this.logo,
        this.sizes,
        this.colors});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTxt = json['subTxt'];
    price = json['price'];
    logo = json['logo'].cast<String>();
    sizes = json['sizes']!=null ? json['sizes'].cast<String>():json['sizes'] ;
    colors = json['colors']!=null ? json['colors'].cast<String>():json['colors'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subTxt'] = this.subTxt;
    data['price'] = this.price;
    data['logo'] = this.logo;
    data['sizes'] = this.sizes;
    data['colors'] = this.colors;
    return data;
  }
}
