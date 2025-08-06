import 'package:openfoodfacts/openfoodfacts.dart';

class OpenFoodFactsService {
  Future<Map<String, dynamic>?> getProduct() async {
    var barcode = '80177173';
    // var barcode = '0048151623426';

    OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'Kapil Singh');

    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage.ENGLISH,
      fields: [ProductField.ALL],
      version: ProductQueryVersion.v3,
    );
    final ProductResultV3 result = await OpenFoodAPIClient.getProductV3(configuration);

    if (result.status == ProductResultV3.statusSuccess) {
      return result.product?.toJson();
    } else {
      throw Exception('product not found, please insert data for $barcode');
    }
  }

  // ingredients_text
  // nutriments
  // nova_group
}
