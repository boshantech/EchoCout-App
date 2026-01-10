import '../../../../core/mock/mock_data.dart';
import '../../../../core/mock/mock_delays.dart';

/// Fake Home Repository
abstract class HomeRepository {
  Future<List<Map<String, dynamic>>> getWasteCategories();
  Future<List<Map<String, dynamic>>> getWasteItems({String category});
  Future<double> calculatePrice(String category, double quantity);
}

class FakeHomeRepository implements HomeRepository {
  @override
  Future<List<Map<String, dynamic>>> getWasteCategories() async {
    await Future.delayed(MockDelays.dataFetchDelay);
    return MockData.wasteCategories.map((cat) => {'name': cat, 'id': cat}).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getWasteItems({String category = 'All'}) async {
    await Future.delayed(MockDelays.dataFetchDelay);
    
    if (category == 'All') {
      return MockData.wasteItems;
    }
    
    return MockData.wasteItems
        .where((item) => item['category'] == category)
        .toList();
  }

  @override
  Future<double> calculatePrice(String category, double quantity) async {
    await Future.delayed(MockDelays.imageProcessDelay);
    
    final basePrice = MockData.estimatedPrices[category] ?? 0.0;
    return basePrice * quantity;
  }
}
