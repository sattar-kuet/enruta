import 'dart:convert';

VoucherModel voucherModelFromJson(String str) => VoucherModel.fromJson(json.decode(str));

String voucherModelToJson(VoucherModel data) => json.encode(data.toJson());

class VoucherModel {
  VoucherModel({
    this.status,
    this.voucher,
  });

  int? status;
  Voucher? voucher;

  factory VoucherModel.fromJson(Map<String, dynamic> json) => VoucherModel(
        status: json["status"],
        voucher: Voucher.fromJson(json["voucher"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "voucher": voucher!.toJson(),
      };
}

class Voucher {
  Voucher({
    this.id,
    this.userId,
    this.code,
    this.status,
    this.validity,
    this.createdAt,
    this.updatedAt,
    this.discount,
    this.minOrder,
    this.title,
  });

  int? id;
  int? userId;
  String? code;
  int? status;
  DateTime? validity;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? discount;
  int? minOrder;
  String? title;

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json["id"],
        userId: json["user_id"],
        code: json["code"],
        status: json["status"],
        validity: DateTime.parse(json["validity"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        discount: json["discount"],
        minOrder: json["min_order"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "code": code,
        "status": status,
        "validity": validity!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "discount": discount,
        "min_order": minOrder,
        "title": title,
      };
}

class CouponModel {
  int? status;
  Coupon? offer;
  final String? statusText;

  CouponModel({
    this.status,
    this.offer,
    this.statusText,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'offer': offer?.toMap(),
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    final offer = map['offer'];
    return CouponModel(
      status: map['status'],
      statusText: map['status_text'],
      offer: (offer == null || offer is Iterable) ? null : Coupon.fromMap(map['offer']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) => CouponModel.fromMap(json.decode(source));
}

class Coupon {
  int? discount;
  int? type;
  DateTime? validity;

  // ignore: non_constant_identifier_names
  int? minimum_spent;

  Coupon({
    this.discount,
    this.type,
    this.validity,
    // ignore: non_constant_identifier_names
    this.minimum_spent,
  });

  Map<String, dynamic> toMap() {
    return {
      'discount': discount,
      'type': type,
      'validity': validity!.toIso8601String(),
      'minimum_spent': minimum_spent,
    };
  }

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      discount: map['discount'],
      type: map['type'],
      validity: DateTime.parse(map['validity']),
      minimum_spent: map['minimum_spent'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Coupon.fromJson(String source) => Coupon.fromMap(json.decode(source));
}
