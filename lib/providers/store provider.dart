// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../models/language/language.dart';
import '../models/store/category.dart';
import '../models/store/comment.dart';
import '../models/store/favourite product.dart';
import '../models/store/product.dart';
import '../models/store/store.dart';
import '../modules/play_store/play store.dart';
import '../network/cash_helper.dart';
import '../shared/Components.dart';

class StoreProvider with ChangeNotifier {
  bool isLoading = false;
  var picker = ImagePicker();
  File? storeImage;
  File? paperStoreFile;
  List<File> productImage = [];
  List<File> storeBanners = [];
  List<StoreModel> stores = [];
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];
  List<ProductModel> categoriesProducts = [];
  List<FavouriteModel> favourites = [];
  List<ProductComment> productComment = [];
  List productSize = [];
  List productColors = [];
  int selectedCategoryID = 0;
  TextEditingController search = TextEditingController();
  double ratingBar = 0.0;
  List<StoreCategory> storeCategories = [];

  Future<void> getStoreCategory() async {
    storeCategories = [];
    isLoading = true;
    var token = CacheHelper.getData(key: 'token') ?? '';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('GET',
        Uri.parse('https://iffsma-2030.com/public/api/v1/store/descriptions'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((element) {
        storeCategories.add(StoreCategory.fromJson(element));
      });
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  void pickStoreBannersImages() async {
    storeBanners = [];
    await picker.pickMultiImage().then((value) {
      if (value.length < 9) {
        for (var element in value) {
          storeBanners.add(File(element.path));
        }
        notifyListeners();
      } else {
        storeBanners = [];
        notifyListeners();
      }
    });
    if (storeBanners.isNotEmpty) {
      showToast(text: 'تم إختيار الصور', state: ToastStates.SUCCESS);
    } else {
      showToast(
          text: 'يجب اختيار عدد من الصور أقل من 9', state: ToastStates.ERROR);
    }
  }

  void searchAboutStore() {
    bool language = CacheHelper.getData(key: 'language') ?? false;
    List<StoreModel> searchStores = [];
    searchStores = stores.where((element) {
      String searchItem;
      if (language) {
        searchItem = element.name.en.toLowerCase();
      } else {
        searchItem = element.name.ar.toLowerCase();
      }
      return searchItem.contains(search.text.toLowerCase());
    }).toList();
    stores = [];
    stores = searchStores;
    notifyListeners();
  }

  void editProductSize(String size) {
    if (productSize.contains(size)) {
      productSize.remove(size);
    } else {
      productSize.add(size);
    }
    notifyListeners();
  }

  void editProductColors(String color) {
    if (productColors.contains(color)) {
      productColors.remove(color);
    } else {
      productColors.add(color);
    }
    notifyListeners();
  }

  void setCategoryID(value) {
    categories.any((element) {
      if (element.name == value) {
        selectedCategoryID = element.id;
        return true;
      }
      return false;
    });
    notifyListeners();
  }

  String getCategoryID() {
    bool language = CacheHelper.getData(key: 'language') ?? false;
    String name = '';
    categories.any((element) {
      if (element.id == selectedCategoryID) {
        if (language) {
          name = element.name.en;
        } else {
          name = element.name.ar;
        }
        return true;
      }
      return false;
    });
    return name;
  }

  void pickProductImages() async {
    productImage = [];
    await picker.pickMultiImage().then((value) {
      if (value.length <= 3) {
        for (var element in value) {
          productImage.add(File(element.path));
        }
        notifyListeners();
      } else {
        productImage = [];
        notifyListeners();
      }
    });
    if (productImage.isNotEmpty) {
      showToast(text: 'تم إختيار الصور', state: ToastStates.SUCCESS);
    } else {
      showToast(
          text: 'يجب اختيار عدد من الصور أقل من 4', state: ToastStates.ERROR);
    }
  }

  void pickStoreImage() async {
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      storeImage = File(pickedImageFile.path);
      notifyListeners();
    }
    if (storeImage != null) {
      showToast(
          text: 'تم إختيار صورة المتجر بنجاح', state: ToastStates.SUCCESS);
    }
  }

  void pickPaperStoreFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      paperStoreFile = File(result.files.first.path.toString());
      showToast(
          text: 'تم إختيار ملف السجل التجارى بنجاح',
          state: ToastStates.SUCCESS);
    }
    notifyListeners();
  }

  Future<void> createStore(
    String nameAR,
    String nameEN,
    String description,
    String addressAR,
    String addressEN,
    String link,
    String ownerPhone,
    String storePhone,
    String startDate,
    String endDate,
    BuildContext context,
  ) async {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    if (storeImage == null || paperStoreFile == null) {
      showToast(
          text: 'يجب إختيار صورة المتجر و ملف السجل التجارى للمتجر',
          state: ToastStates.ERROR);
    } else {
      isLoading = true;
      notifyListeners();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://iffsma-2030.com/public/api/v1/add/store'));
      request.fields.addAll({
        'name_ar': nameAR,
        'name_en': nameEN,
        'lat_lang_link': link,
        'phone_store_owner': ownerPhone,
        'phone_store': storePhone,
        'start_work_hours': startDate,
        'end_work_hours': endDate,
        'user_id': id.toString(),
        'store_address_en': addressEN,
        'store_address_ar': addressAR,
        'description': description,
      });
      request.files.add(await http.MultipartFile.fromPath(
          'commercial_register', paperStoreFile!.path));
      request.files.add(
          await http.MultipartFile.fromPath('store_image', storeImage!.path));
      if (storeBanners.isNotEmpty) {
        for (var element in storeBanners) {
          request.files.add(await http.MultipartFile.fromPath(
              'store_banners[]', element.path));
        }
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      final decodedData = json.decode(data);
      if (response.statusCode == 200) {
        showToast(
            text: 'تم إنشاء المتجر إنتظر القبول من المسئول',
            state: ToastStates.SUCCESS);
        paperStoreFile = null;
        storeImage = null;
        isLoading = false;
        navigatePop(context);
        notifyListeners();
      } else {
        showToast(text: decodedData['message'], state: ToastStates.ERROR);
        paperStoreFile = null;
        storeImage = null;
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void updateStoreData(
    String nameAR,
    String nameEN,
    String storeID,
    String description,
    String addressAR,
    String addressEN,
    String link,
    String ownerPhone,
    String storePhone,
    String startDate,
    String endDate,
    String categoryID,
    int bannerLength,
    BuildContext context,
  ) async {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/store/update'));
    request.fields.addAll({
      'store_id': storeID,
      'user_id': id.toString(),
      'name_ar': nameAR,
      'name_en': nameEN,
      'lat_lang_link': link,
      'phone_store_owner': ownerPhone,
      'phone_store': storePhone,
      'start_work_hours': startDate,
      'end_work_hours': endDate,
      'store_address_ar': addressAR,
      'store_address_en': addressEN,
      'description': description,
    });
    if (storeImage != null) {
      request.files.add(
          await http.MultipartFile.fromPath('store_image', storeImage!.path));
    }
    if (storeBanners.isNotEmpty && (bannerLength + storeBanners.length < 9)) {
      for (var element in storeBanners) {
        request.files.add(
            await http.MultipartFile.fromPath('store_banners[]', element.path));
      }
    }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      if (storeBanners.isNotEmpty &&
          (bannerLength + storeBanners.length >= 9)) {
        showToast(
            text: 'عدد صور الاعلانات يجب ان يكون اقل من 9',
            state: ToastStates.ERROR);
      } else {
        showToast(text: 'تم التعديل بنجاح', state: ToastStates.SUCCESS);
      }
      storeImage = null;
      isLoading = false;
      storeBanners = [];
      navigateAndFinish(context, PlayStore(categoryID, description));
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
      storeImage = null;
      isLoading = false;
      storeBanners = [];
      notifyListeners();
    }
  }

  void getStores(String categoryID) async {
    stores = [];
    var token = CacheHelper.getData(key: 'token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/get/stores/$categoryID'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((element) {
        stores.add(StoreModel.fromJson(element));
      });
      stores.sort((a, b) => a.storeNumber.compareTo(b.storeNumber));
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> addCategoriesInStore(
    String categoryNameAR,
    String categoryNameEN,
    String storeID,
  ) async {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/add/category'));
    request.fields.addAll({
      'name_ar': categoryNameAR,
      'name_en': categoryNameEN,
      'store_model_id': storeID,
      'user_id': id.toString(),
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: 'تم إنشاء التصنيف', state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> createProduct(
    String storeID,
    String name,
    String description,
    String price,
    String discount,
    String videoProduct,
    BuildContext context,
  ) async {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    if (productImage.isEmpty) {
      showToast(
          text: 'يجب اختيار عدد من الصور أقل من 4', state: ToastStates.ERROR);
    } else if (productSize.isEmpty) {
      showToast(text: 'يجب اختيار أحجام المنتج', state: ToastStates.ERROR);
    } else if (productColors.isEmpty) {
      showToast(text: 'يجب اختيار ألوان المنتج', state: ToastStates.ERROR);
    } else if (selectedCategoryID == -1) {
      showToast(text: 'يجب تحديد تصنيف المنتج', state: ToastStates.ERROR);
    } else {
      isLoading = true;
      notifyListeners();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/create/products/store'),
      );
      request.fields.addAll({
        'name': name,
        'description': description,
        'price': price,
        'store_category_id': selectedCategoryID.toString(),
        'store_id': storeID,
        'user_id': id.toString(),
        'colors[]': productColors.toString(),
        'sizes[]': productSize.toString(),
        'discount': discount,
        'video_link': videoProduct,
      });
      for (var element in productImage) {
        request.files
            .add(await http.MultipartFile.fromPath('images[]', element.path));
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      final decodedData = json.decode(data);
      if (response.statusCode == 200) {
        showToast(text: 'تم إنشاء المنتج', state: ToastStates.SUCCESS);
        isLoading = false;
        selectedCategoryID = -1;
        notifyListeners();
      } else {
        showToast(text: decodedData['message'], state: ToastStates.ERROR);
        isLoading = false;
        selectedCategoryID = -1;
        notifyListeners();
      }
    }
  }

  void getStoreCategories(String storeID, bool addAll) async {
    categories = [];
    if (addAll) {
      categories.add(CategoryModel(
          id: 0, name: LanguageModel(en: 'All', ar: 'الكل'), storeID: storeID));
    }
    var token = CacheHelper.getData(key: 'token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('GET',
        Uri.parse('https://iffsma-2030.com/public/api/v1/store/categories'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((element) {
        if (element['store_model_id'] == storeID) {
          categories.add(CategoryModel.fromJson(element));
        }
      });
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  void getProducts(int storeID) async {
    products = [];
    categoriesProducts = [];
    var token = CacheHelper.getData(key: 'token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/category/products/$storeID'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((element) {
        products.add(ProductModel.fromJson(element));
      });
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  void getProductsByCategoryID(int index) {
    selectedCategoryID = index;
    List<ProductModel> searchProducts = [];
    searchProducts = products.where((element) {
      var searchItem = selectedCategoryID.toString();
      return searchItem == element.storeCategoryId;
    }).toList();
    categoriesProducts = [];
    categoriesProducts = searchProducts;
    notifyListeners();
  }

  Future<void> deleteCategory(String categoryID) async {
    var token = CacheHelper.getData(key: 'token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/delete/category/$categoryID'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: 'تم حذف التصنيف بنجاح', state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> addProductToFavourite(String productID) async {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/add/fav'));
    request.fields.addAll({
      'user_id': id.toString(),
      'product_id': productID,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: 'تمت الإضافة إلى المفضلة', state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> deleteProductFromFavourite(String productID) async {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/delete/product/fav?user_id=$id&product_id=$productID'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: 'تم الحذف من المفضلة', state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  void getProductFavourite() async {
    favourites = [];
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    isLoading = true;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/user/get/fav?user_id=$id'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data']?.forEach((element) {
        favourites.add(FavouriteModel.fromJson(element));
      });
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String storeID, String productID) async {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/delete/product/cart?id=$productID&user_id=$id&store_id=$storeID'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: 'تم الحذف بنجاح', state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> addProductComment(
    String productID,
    String comment,
  ) async {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://iffsma-2030.com/public/api/v1/user/add/rating'));
    request.fields.addAll({
      'user_id': id.toString(),
      'product_id': productID,
      'rate': ratingBar.toString(),
      'comment': comment,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: 'تم التعليق بنجاح', state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  void changeRating(double value) {
    ratingBar = value;
    notifyListeners();
  }

  Future<void> getProductComments(String productID) async {
    productComment = [];
    var token = CacheHelper.getData(key: 'token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest(
        'GET',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/product/comments/$productID'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      decodedData['data'].forEach((element) {
        productComment.add(ProductComment.fromJson(element));
      });
      notifyListeners();
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> deleteBanners(
    String storeId,
    String bannerId,
  ) async {
    var token = CacheHelper.getData(key: 'token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://iffsma-2030.com/public/api/v1/delete/banner?banner_id=$bannerId&store_id=$storeId'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: 'تم الحذف بنجاح', state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }
}
