import '../../models/api_response.dart';
import '../../models/coupon.dart';
import '../../models/my_notification.dart';
import '../../models/order.dart';
import '../../models/poster.dart';
import '../../models/product.dart';
import '../../models/variant_type.dart';
import '../../services/http_services.dart';
import '../../utility/snack_bar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import '../../../models/category.dart';
import '../../models/brand.dart';
import '../../models/sub_category.dart';
import '../../models/variant.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];

  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Brand> _allBrands = [];
  List<Brand> _filteredBrands = [];
  List<Brand> get brands => _filteredBrands;

  List<VariantType> _allVariantTypes = [];
  List<VariantType> _filteredVariantTypes = [];
  List<VariantType> get variantTypes => _filteredVariantTypes;

  List<Variant> _allVariants = [];
  List<Variant> _filteredVariants = [];
  List<Variant> get variants => _filteredVariants;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> get products => _filteredProducts;

  List<Coupon> _allCoupons = [];
  List<Coupon> _filteredCoupons = [];
  List<Coupon> get coupons => _filteredCoupons;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];
  List<Poster> get posters => _filteredPosters;

  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  List<Order> get orders => _filteredOrders;

  List<MyNotification> _allNotifications = [];
  List<MyNotification> _filteredNotifications = [];
  List<MyNotification> get notifications => _filteredNotifications;

  DataProvider() {
    getAllProduct();
    getAllCategory();
    getAllSubCategory();
    getAllBrands();
    getAllVariantType();
    getAllVariant();
    getAllPosters();
    getAllCoupons();
  }


  Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'categories');
      if (response.isOk) {
      ApiResponse<List<Category>> apiResponse= ApiResponse<List<Category>>.fromJson(
        response.body,
            (json) => (json as List).map((item) => Category.fromJson(item)).toList(),
      ); // ApiResponse.fromJson
      _allCategories=apiResponse.data ?? [];
      _filteredCategories = List.from(_allCategories); // Initialize filtered list with all data
      notifyListeners();
      if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredCategories;
  }
  //
   void filterCategories (String keyword) {
    if (keyword.isEmpty) {
      _filteredCategories =List.from(_allCategories);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredCategories = _allCategories.where((category) {
        return (category.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

   getAllSubCategory({bool showSnack = false}) async {
    try {
      final response = await service.getItems(endpointUrl: 'subCategories');

      if (response.isOk) {
        ApiResponse<List<SubCategory>> apiResponse =
        ApiResponse<List<SubCategory>>.fromJson(
          response.body,
              (json) => (json as List)
              .map((item) => SubCategory.fromJson(item))
              .toList(),
        );

        _allSubCategories = apiResponse.data ?? [];
        _filteredSubCategories = List.from(_allSubCategories);

        notifyListeners();

        if (showSnack) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }

        return _filteredSubCategories;
      } else {
        if (showSnack) {
          SnackBarHelper.showErrorSnackBar(
            'Error: ${response.body?['message'] ?? response.statusText}',
          );
        }
        return [];
      }
    } catch (e) {
      if (showSnack) {
        SnackBarHelper.showErrorSnackBar(e.toString());
      }
      rethrow;
    }
  }

   void filterSubCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredSubCategories = List.from(_allSubCategories);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredSubCategories = _allSubCategories.where((subcategory) {
        return (subcategory.name ?? '')
            .toLowerCase()
            .contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }


   getAllBrands({bool showSnack = false}) async {
    try {
      final response = await service.getItems(endpointUrl: 'brands');

      if (response.isOk) {
        ApiResponse<List<Brand>> apiResponse = ApiResponse<List<Brand>>.fromJson(
          response.body,
              (json) => (json as List).map((item) => Brand.fromJson(item)).toList(),
        );

        _allBrands = apiResponse.data ?? [];
        _filteredBrands = List.from(_allBrands); // Initialize filtered list with all data
        notifyListeners();

        if (showSnack) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message ?? 'Brands fetched successfully');
        }
      }
    } catch (e) {
      if (showSnack) {
        SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      }
      rethrow;
    }

    return _filteredBrands;
  }


   void filterBrands(String keyword) {
    if (keyword.isEmpty) {
      _filteredBrands = List.from(_allBrands);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredBrands = _allBrands.where((brand) {
        return (brand.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }


   getAllVariantType({bool showSnack = false}) async {
    try {
      final response = await service.getItems(endpointUrl: 'variantTypes');

      if (response.isOk) {
        ApiResponse<List<VariantType>> apiResponse = ApiResponse<List<VariantType>>.fromJson(
          response.body,
              (json) => (json as List).map((item) => VariantType.fromJson(item)).toList(),
        );

        _allVariantTypes = apiResponse.data ?? [];
        _filteredVariantTypes = List.from(_allVariantTypes); // Initialize filtered list with all data
        notifyListeners();

        if (showSnack) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message ?? 'Variant Types fetched successfully');
        }

        return _filteredVariantTypes;
      }
    } catch (e) {
      if (showSnack) {
        SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      }
      rethrow;
    }

    return _filteredVariantTypes;
  }

   filterVariantTypes(String keyword) {
    if (keyword.isEmpty) {
      _filteredVariantTypes = List.from(_allVariantTypes);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredVariantTypes = _allVariantTypes.where((variantType) {
        return (variantType.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

   getAllVariant({bool showSnack = false}) async {
    try {
      final response = await service.getItems(endpointUrl: 'variants');

      if (response.isOk) {
        final apiResponse = ApiResponse<List<Variant>>.fromJson(
          response.body,
              (json) => (json as List).map((item) => Variant.fromJson(item)).toList(),
        );

        _allVariants = apiResponse.data ?? [];
        _filteredVariants = List.from(_allVariants); // Initialize filtered list with all data
        notifyListeners();

        if (showSnack) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message ?? 'Variants fetched successfully');
        }

        return _filteredVariants;
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }

    return _filteredVariants;
  }


   filterVariants(String keyword) {
    if (keyword.isEmpty) {
      _filteredVariants = List.from(_allVariants);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredVariants = _allVariants.where((variant) {
        return (variant.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }


   Future<void> getAllProduct({bool showSnack = false}) async {
    try {
      // Fetch response
      Response response = await service.getItems(endpointUrl: 'products');

      // Parse API response
      ApiResponse<List<Product>> apiResponse = ApiResponse<List<Product>>.fromJson(
        response.body,
            (json) => (json as List).map((item) => Product.fromJson(item)).toList(),
      );

      // Update product lists
      _allProducts = apiResponse.data ?? [];
      _filteredProducts = List.from(_allProducts); // Initialize with original data

      // Notify listeners
      notifyListeners();

      // Show success message if requested
      if (showSnack)
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);

    } catch (e) {
      // Show error message if requested
      if (showSnack)SnackBarHelper.showErrorSnackBar(e.toString());

      // Re-throw for higher-level handling

    }
  }


   void filterProducts(String keyword) {
    if (keyword.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      final lowerKeyword = keyword.toLowerCase();

      _filteredProducts = _allProducts.where((product) {
        final productNameContainsKeyword = (product.name ?? "").toLowerCase().contains(lowerKeyword);

        final categoryNameContainsKeyword =
            product.proSubCategoryId?.name?.toLowerCase().contains(lowerKeyword) ?? false;

        final subCategoryNameContainsKeyword =
            product.proSubCategoryId?.name?.toLowerCase().contains(lowerKeyword) ?? false;

        // ✅ Add more conditions if needed
        return productNameContainsKeyword || categoryNameContainsKeyword || subCategoryNameContainsKeyword;
      }).toList();

    }
    notifyListeners();
  }



  Future<List<Coupon>> getAllCoupons({bool showSnack = false}) async {
    try {
      // Call API
      Response response = await service.getItems(endpointUrl: 'couponCodes');

      if (response.isOk) {
        // Parse API response
        ApiResponse<List<Coupon>> apiResponse = ApiResponse<List<Coupon>>.fromJson(
          response.body,
              (json) => (json as List).map((item) => Coupon.fromJson(item)).toList(),
        );

        // Update state
        _allCoupons = apiResponse.data ?? [];
        _filteredCoupons = List.from(_allCoupons);
        notifyListeners();

        // Show success message if needed
        if (showSnack) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
      } else {
        if (showSnack) {
          SnackBarHelper.showErrorSnackBar("Failed to load coupons");
        }
      }
    } catch (e) {
      if (showSnack) {
        SnackBarHelper.showErrorSnackBar(e.toString());
      }
      rethrow;
    }

    return _filteredCoupons;
  }



  void filterCoupons(String keyword) {
    if (keyword.isEmpty) {
      _filteredCoupons = List.from(_allCoupons);
    } else {
      final lowerKeyword = keyword.toLowerCase();

      _filteredCoupons = _allCoupons.where((coupon) {
        return (coupon.couponCode ?? "")
            .toLowerCase()
            .contains(lowerKeyword);
      }).toList();
    }

    notifyListeners();
  }



  Future<List<Poster>> getAllPosters({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'posters');

      if (response.isOk) {
        ApiResponse<List<Poster>> apiResponse =
        ApiResponse<List<Poster>>.fromJson(
          response.body,
              (json) =>
              (json as List).map((item) => Poster.fromJson(item)).toList(),
        );

        _allPosters = apiResponse.data ?? [];
        _filteredPosters = List.from(_allPosters);

        notifyListeners();

        if (showSnack) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
      } else {
        if (showSnack) {
          SnackBarHelper.showErrorSnackBar(
            'Error: ${response.body?['message'] ?? response.statusText}',
          );
        }
      }
    } catch (e) {
      if (showSnack) {
        SnackBarHelper.showErrorSnackBar(e.toString());
      }
      rethrow;
    }

    return _filteredPosters;
  }



  void filterPosters(String keyword) {
    if (keyword.isEmpty) {
      _filteredPosters = List.from(_allPosters);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredPosters = _allPosters.where((poster) {
        return (poster.posterName ?? "").toLowerCase().contains(lowerKeyword);
      }).toList();
    }

    notifyListeners();
  }



  //TODO: should complete getAllNotifications


  //TODO: should complete filterNotifications


  //TODO: should complete getAllOrders


  //TODO: should complete filterOrders




  //TODO: should complete calculateOrdersWithStatus


  void filterProductsByQuantity(String productQntType) {
    if (productQntType == 'All Product') {
      _filteredProducts = List.from(_allProducts);
    } else if (productQntType == 'Out of Stock') {
      _filteredProducts = _allProducts.where((product) {
        // Filter products with quantity equal to 0 (out of stock)
        return product.quantity != null && product.quantity == 0;
      }).toList();
    } else if (productQntType == 'Limited Stock') {
      _filteredProducts = _allProducts.where((product) {
        // Filter products with quantity equal to 1 (limited stock)
        return product.quantity != null && product.quantity == 1;
      }).toList();
    } else if (productQntType == 'Other Stock') {
      _filteredProducts = _allProducts.where((product) {
        // Filter products with quantity not equal to 0 or 1 (other stock)
        return product.quantity != null &&
            product.quantity != 0 &&
            product.quantity != 1;
      }).toList();
    } else {
      _filteredProducts = List.from(_allProducts);
    }

    notifyListeners();
  }



  int calculateProductWithQuantity({int? quantity}) {
    int totalProduct = 0;

    // If quantity is null, return total products
    if (quantity == null) {
      totalProduct = _allProducts.length;
    } else {
      for (Product product in _allProducts) {
        if (product.quantity != null && product.quantity == quantity) {
          totalProduct += 1; // Increment the count if quantity matches
        }
      }
    }

    return totalProduct;
  }



}
