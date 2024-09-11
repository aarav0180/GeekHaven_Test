// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool status;
  String message;
  int timestamp;
  Data data;

  Welcome({
    required this.status,
    required this.message,
    required this.timestamp,
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    status: json["status"],
    message: json["message"],
    timestamp: json["timestamp"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "timestamp": timestamp,
    "data": data.toJson(),
  };
}

class Data {
  String totalRecords;
  int totalPages;
  List<Datum> data;

  Data({
    required this.totalRecords,
    required this.totalPages,
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalRecords: json["totalRecords"],
    totalPages: json["totalPages"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalRecords": totalRecords,
    "totalPages": totalPages,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String heroImgUrl;
  int heroImgRawHeight;
  int heroImgRawWidth;
  String squareImgUrl;
  int squareImgRawLength;
  int locationId;
  String name;
  double averageRating;
  int userReviewCount;
  CurrentOpenStatusCategory currentOpenStatusCategory;
  CurrentOpenStatusText currentOpenStatusText;
  List<String> establishmentTypeAndCuisineTags;
  PriceTag priceTag;
  Offers offers;
  bool hasMenu;
  String? menuUrl;
  bool isDifferentGeo;
  ParentGeoName parentGeoName;
  String distanceTo;
  ReviewSnippets reviewSnippets;
  dynamic awardInfo;
  bool isLocalChefItem;
  bool isPremium;
  bool isStoryboardPublished;

  Datum({
    required this.heroImgUrl,
    required this.heroImgRawHeight,
    required this.heroImgRawWidth,
    required this.squareImgUrl,
    required this.squareImgRawLength,
    required this.locationId,
    required this.name,
    required this.averageRating,
    required this.userReviewCount,
    required this.currentOpenStatusCategory,
    required this.currentOpenStatusText,
    required this.establishmentTypeAndCuisineTags,
    required this.priceTag,
    required this.offers,
    required this.hasMenu,
    required this.menuUrl,
    required this.isDifferentGeo,
    required this.parentGeoName,
    required this.distanceTo,
    required this.reviewSnippets,
    required this.awardInfo,
    required this.isLocalChefItem,
    required this.isPremium,
    required this.isStoryboardPublished,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    heroImgUrl: json["heroImgUrl"],
    heroImgRawHeight: json["heroImgRawHeight"],
    heroImgRawWidth: json["heroImgRawWidth"],
    squareImgUrl: json["squareImgUrl"],
    squareImgRawLength: json["squareImgRawLength"],
    locationId: json["locationId"],
    name: json["name"],
    averageRating: json["averageRating"]?.toDouble(),
    userReviewCount: json["userReviewCount"],
    currentOpenStatusCategory: currentOpenStatusCategoryValues.map[json["currentOpenStatusCategory"]]!,
    currentOpenStatusText: currentOpenStatusTextValues.map[json["currentOpenStatusText"]]!,
    establishmentTypeAndCuisineTags: List<String>.from(json["establishmentTypeAndCuisineTags"].map((x) => x)),
    priceTag: priceTagValues.map[json["priceTag"]]!,
    offers: Offers.fromJson(json["offers"]),
    hasMenu: json["hasMenu"],
    menuUrl: json["menuUrl"],
    isDifferentGeo: json["isDifferentGeo"],
    parentGeoName: parentGeoNameValues.map[json["parentGeoName"]]!,
    distanceTo: json["distanceTo"],
    reviewSnippets: ReviewSnippets.fromJson(json["reviewSnippets"]),
    awardInfo: json["awardInfo"],
    isLocalChefItem: json["isLocalChefItem"],
    isPremium: json["isPremium"],
    isStoryboardPublished: json["isStoryboardPublished"],
  );

  Map<String, dynamic> toJson() => {
    "heroImgUrl": heroImgUrl,
    "heroImgRawHeight": heroImgRawHeight,
    "heroImgRawWidth": heroImgRawWidth,
    "squareImgUrl": squareImgUrl,
    "squareImgRawLength": squareImgRawLength,
    "locationId": locationId,
    "name": name,
    "averageRating": averageRating,
    "userReviewCount": userReviewCount,
    "currentOpenStatusCategory": currentOpenStatusCategoryValues.reverse[currentOpenStatusCategory],
    "currentOpenStatusText": currentOpenStatusTextValues.reverse[currentOpenStatusText],
    "establishmentTypeAndCuisineTags": List<dynamic>.from(establishmentTypeAndCuisineTags.map((x) => x)),
    "priceTag": priceTagValues.reverse[priceTag],
    "offers": offers.toJson(),
    "hasMenu": hasMenu,
    "menuUrl": menuUrl,
    "isDifferentGeo": isDifferentGeo,
    "parentGeoName": parentGeoNameValues.reverse[parentGeoName],
    "distanceTo": distanceTo,
    "reviewSnippets": reviewSnippets.toJson(),
    "awardInfo": awardInfo,
    "isLocalChefItem": isLocalChefItem,
    "isPremium": isPremium,
    "isStoryboardPublished": isStoryboardPublished,
  };
}

enum CurrentOpenStatusCategory {
  CLOSED,
  CLOSING,
  EMPTY,
  OPEN
}

final currentOpenStatusCategoryValues = EnumValues({
  "CLOSED": CurrentOpenStatusCategory.CLOSED,
  "CLOSING": CurrentOpenStatusCategory.CLOSING,
  "": CurrentOpenStatusCategory.EMPTY,
  "OPEN": CurrentOpenStatusCategory.OPEN
});

enum CurrentOpenStatusText {
  CLOSED_NOW,
  CLOSES_IN_6_MIN,
  CLOSES_IN_7_MIN,
  EMPTY,
  OPEN_NOW
}

final currentOpenStatusTextValues = EnumValues({
  "Closed Now": CurrentOpenStatusText.CLOSED_NOW,
  "Closes in 6 min": CurrentOpenStatusText.CLOSES_IN_6_MIN,
  "Closes in 7 min": CurrentOpenStatusText.CLOSES_IN_7_MIN,
  "": CurrentOpenStatusText.EMPTY,
  "Open Now": CurrentOpenStatusText.OPEN_NOW
});

class Offers {
  dynamic slot1Offer;
  dynamic slot2Offer;

  Offers({
    required this.slot1Offer,
    required this.slot2Offer,
  });

  factory Offers.fromJson(Map<String, dynamic> json) => Offers(
    slot1Offer: json["slot1Offer"],
    slot2Offer: json["slot2Offer"],
  );

  Map<String, dynamic> toJson() => {
    "slot1Offer": slot1Offer,
    "slot2Offer": slot2Offer,
  };
}

enum ParentGeoName {
  MUMBAI
}

final parentGeoNameValues = EnumValues({
  "Mumbai": ParentGeoName.MUMBAI
});

enum PriceTag {
  EMPTY,
  PRICE_TAG
}

final priceTagValues = EnumValues({
  "\u0024\u0024\u0024\u0024": PriceTag.EMPTY,
  "\u0024\u0024 - \u0024\u0024\u0024": PriceTag.PRICE_TAG
});

class ReviewSnippets {
  List<ReviewSnippetsList> reviewSnippetsList;

  ReviewSnippets({
    required this.reviewSnippetsList,
  });

  factory ReviewSnippets.fromJson(Map<String, dynamic> json) => ReviewSnippets(
    reviewSnippetsList: List<ReviewSnippetsList>.from(json["reviewSnippetsList"].map((x) => ReviewSnippetsList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "reviewSnippetsList": List<dynamic>.from(reviewSnippetsList.map((x) => x.toJson())),
  };
}

class ReviewSnippetsList {
  String reviewText;
  String reviewUrl;

  ReviewSnippetsList({
    required this.reviewText,
    required this.reviewUrl,
  });

  factory ReviewSnippetsList.fromJson(Map<String, dynamic> json) => ReviewSnippetsList(
    reviewText: json["reviewText"],
    reviewUrl: json["reviewUrl"],
  );

  Map<String, dynamic> toJson() => {
    "reviewText": reviewText,
    "reviewUrl": reviewUrl,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
