
import '../language/language.dart';

class StoreModel {
  late int id;
  late LanguageModel name;
  late String userId;
  late String storeImage;
  late String commercialRegister;
  late String latLangLink;
  late String phoneStoreOwner;
  late String phoneStore;
  late String startWorkHours;
  late String endWorkHours;
  late LanguageModel storeAddress;
  late String description;
  late String hasStar;
  late int storeNumber;
  List<Banners> banners = [];

  StoreModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.storeImage,
    required this.commercialRegister,
    required this.latLangLink,
    required this.phoneStoreOwner,
    required this.phoneStore,
    required this.startWorkHours,
    required this.endWorkHours,
    required this.storeAddress,
    required this.description,
    required this.storeNumber,
    required this.hasStar,
  });

  StoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null
        ? LanguageModel(en: '', ar: '')
        : LanguageModel.fromJSON(json['name']);
    userId = json['user_id'];
    storeImage = json['store_image'];
    commercialRegister = json['commercial_register'];
    latLangLink = json['lat_lang_link'] ?? '';
    phoneStoreOwner = json['phone_store_owner'];
    phoneStore = json['phone_store'];
    startWorkHours = json['start_work_hours'];
    endWorkHours = json['end_work_hours'];
    storeAddress = json['store_address'] == null
        ? LanguageModel(en: '', ar: '')
        : LanguageModel.fromJSON(json['store_address']);
    description = json['description'] ?? '';
    storeNumber = int.parse(json['store_number']);
    hasStar = json['star_store'];
    if (json['banners'] != []) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners.add(Banners.fromJson(v));
      });
    }
  }
}

class Banners {
  late int id;
  late String storeModelId;
  late String fileName;

  Banners({
    required this.id,
    required this.storeModelId,
    required this.fileName,
  });

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeModelId = json['store_model_id'];
    fileName = json['file_name'];
  }
}

class StoreCategory {
  late int id;
  late LanguageModel name;
  late String image;

  StoreCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  StoreCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null
        ? LanguageModel(en: '', ar: '')
        : LanguageModel.fromJSON(json['name']);
    image = json['image'];
  }
}
