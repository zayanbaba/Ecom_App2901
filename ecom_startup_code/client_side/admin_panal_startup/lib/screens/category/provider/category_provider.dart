import 'dart:developer';
import 'dart:io';
import '../../../models/api_response.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../utility/snack_bar_helper.dart';

class CategoryProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addCategoryFormKey = GlobalKey<FormState>();
  TextEditingController categoryNameCtrl = TextEditingController();
  Category? categoryForUpdate;


  File? selectedImage;
  XFile? imgXFile;


  CategoryProvider(this._dataProvider);



  addCategory() async {
    try {
      if (selectedImage == null) {
        SnackBarHelper.showErrorSnackBar('Please choose an image!');
        return; // stop the program execution
      }

      Map<String, dynamic> formDataMap = {
        'name': categoryNameCtrl.text,
        'image': 'no_data', // image path will be added from server side
      };

      final FormData form = await createFormData(imgXFile: imgXFile, formData: formDataMap);

      final response = await service.addItem(
        endpointUrl: 'categories',
        itemData: form,
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);

        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllCategory();
          log('Category added');
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to add category: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}'
        );
      }


    } catch (e) {
      print("Error: $e");
      SnackBarHelper.showErrorSnackBar('An Error Occurred: $e');
      rethrow;
    }
  }

  updateCategory() async {
    try {
      // Prepare form data map
      Map<String, dynamic> formDataMap = {
        'name': categoryNameCtrl.text,
        'image': categoryForUpdate?.image ?? '',
      };

      // Create form data with optional image file
      final FormData form = await createFormData(
        imgXFile: imgXFile,
        formData: formDataMap,
      );

      // Send update request
      final response = await service.updateItem(
        endpointUrl: 'categories',
        itemData: form,
        itemId: categoryForUpdate?.sId ?? '',
      );

      // Handle response
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('Category updated');
          _dataProvider.getAllCategory();
        } else {
          SnackBarHelper.showErrorSnackBar(
            'Failed to update category: ${apiResponse.message}',
          );
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
          'Error: ${response.body?['message'] ?? response.statusText}',
        );
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow; // 必要なら上位に投げる
    }
  }

  submitCategory() async {
    if (categoryForUpdate != null) {
      await updateCategory();
    } else {
      await addCategory();
    }
  }

  deleteCategory(Category category) async {
    try {
      // API 呼び出し
      Response response = await service.deleteItem(
        endpointUrl: 'categories',
        itemId: category.sId ?? '',
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);

        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Category Deleted Successfully');
          _dataProvider.getAllCategory();
        } else {
          SnackBarHelper.showErrorSnackBar(
            'Failed to delete category: ${apiResponse.message}',
          );
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
          'Error: ${response.body?['message'] ?? response.statusText}',
        );
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow;
    }
  }





  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      imgXFile = image;
      notifyListeners();
    }
  }




  //? to create form data for sending image with body
  Future<FormData> createFormData({required XFile? imgXFile, required Map<String, dynamic> formData}) async {
    if (imgXFile != null) {
      MultipartFile multipartFile;
      if (kIsWeb) {
        String fileName = imgXFile.name;
        Uint8List byteImg = await imgXFile.readAsBytes();
        multipartFile = MultipartFile(byteImg, filename: fileName);
      } else {
        String fileName = imgXFile.path.split('/').last;
        multipartFile = MultipartFile(imgXFile.path, filename: fileName);
      }
      formData['img'] = multipartFile;
    }
    final FormData form = FormData(formData);
    return form;
  }

  //? set data for update on editing
  setDataForUpdateCategory(Category? category) {
    if (category != null) {
      clearFields();
      categoryForUpdate = category;
      categoryNameCtrl.text = category.name ?? '';
    } else {
      clearFields();
    }
  }

  //? to clear text field and images after adding or update category
  clearFields() {
    categoryNameCtrl.clear();
    selectedImage = null;
    imgXFile = null;
    categoryForUpdate = null;
  }
}
