import 'dart:convert';

UserArr userFromJson(String str) => UserArr.fromJson(json.decode(str));

String userToJson(UserArr data) => json.encode(data.toJson());

class UserArr {
  UserArr({
    this.id,
    this.name,
    this.email,
    this.permissions,
    this.isActivated,
    this.activatedAt,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.surname,
    this.deletedAt,
    this.lastSeen,
    this.isGuest,
    this.isSuperuser,
    this.phone,
    this.company,
    this.streetAddr,
    this.city,
    this.zip,
    this.stateId,
    this.countryId,
    this.mobile,
    this.roleId,
    this.cityId,
    this.areaId,
    this.manager,
    this.places,
    this.gender,
    this.driver,
    this.office,
    this.language,
    this.devicetoken,
  });

  int id;
  String name;
  String email;
  dynamic permissions;
  bool isActivated;
  DateTime activatedAt;
  DateTime lastLogin;
  DateTime createdAt;
  DateTime updatedAt;
  String username;
  dynamic surname;
  dynamic deletedAt;
  dynamic lastSeen;
  int isGuest;
  int isSuperuser;
  dynamic phone;
  dynamic company;
  dynamic streetAddr;
  dynamic city;
  dynamic zip;
  dynamic stateId;
  dynamic countryId;
  dynamic mobile;
  int roleId;
  dynamic cityId;
  dynamic areaId;
  dynamic manager;
  dynamic places;
  dynamic gender;
  dynamic driver;
  dynamic office;
  dynamic language;
  dynamic devicetoken;

  factory UserArr.fromJson(Map<String, dynamic> json) => UserArr(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        permissions: json["permissions"],
        isActivated: json["is_activated"],
        activatedAt: DateTime.parse(json["activated_at"]),
        lastLogin: DateTime.parse(json["last_login"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        username: json["username"],
        surname: json["surname"],
        deletedAt: json["deleted_at"],
        lastSeen: json["last_seen"],
        isGuest: json["is_guest"],
        isSuperuser: json["is_superuser"],
        phone: json["phone"],
        company: json["company"],
        streetAddr: json["street_addr"],
        city: json["city"],
        zip: json["zip"],
        stateId: json["state_id"],
        countryId: json["country_id"],
        mobile: json["mobile"],
        roleId: json["role_id"],
        cityId: json["city_id"],
        areaId: json["area_id"],
        manager: json["manager"],
        places: json["places"],
        gender: json["gender"],
        driver: json["driver"],
        office: json["office"],
        language: json["language"],
        devicetoken: json["devicetoken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "permissions": permissions,
        "is_activated": isActivated,
        "activated_at": activatedAt.toIso8601String(),
        "last_login": lastLogin.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "username": username,
        "surname": surname,
        "deleted_at": deletedAt,
        "last_seen": lastSeen,
        "is_guest": isGuest,
        "is_superuser": isSuperuser,
        "phone": phone,
        "company": company,
        "street_addr": streetAddr,
        "city": city,
        "zip": zip,
        "state_id": stateId,
        "country_id": countryId,
        "mobile": mobile,
        "role_id": roleId,
        "city_id": cityId,
        "area_id": areaId,
        "manager": manager,
        "places": places,
        "gender": gender,
        "driver": driver,
        "office": office,
        "language": language,
        "devicetoken": devicetoken,
      };
}
