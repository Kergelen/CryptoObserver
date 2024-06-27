import '../services/api_service.dart';

final apiService = ApiService();
List<String> supportedCoins = [];
List<String> supportedSymbols = [];

Future<void> loadSupportedCoins() async {
  supportedCoins = await apiService.fetchCoinList();
}

Future<void> loadSupportedSymbols() async {
  supportedSymbols = await apiService.fetchSymbolList();
}