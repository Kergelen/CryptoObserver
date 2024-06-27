import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin_data.dart';
import '../models/ohlc_data.dart';
import '../models/news_data.dart';

class ApiService {
  final String baseUrl = 'http://api.coincap.io/v2';
  final String baseUrlCandle = 'https://min-api.cryptocompare.com/data';
  final String apiKey = 'b9430e15d682dec8791d8fd8437b9b326d8de48cd0fa11d37ce9a2d34d00aa48';

  Future<List<String>> fetchCoinList() async {
    final url = Uri.parse('$baseUrl/assets');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return List<String>.from(data.map((coin) => coin['id']));
    } else {
      throw Exception('Failed to load coin list');
    }
  }

  Future<List<String>> fetchSymbolList() async {
    final url = Uri.parse('$baseUrl/assets');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return List<String>.from(data.map((coin) => coin['symbol']));
    } else {
      throw Exception('Failed to load coin list');
    }
  }

  Future<CoinData> getCoinData(String coinId) async {
    final url = Uri.parse('$baseUrl/assets/$coinId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return CoinData.fromJson(data);
    } else {
      throw Exception('Failed to load coin data');
    }
  }

Future<List<OHLCData>> fetchOHLCData(String coinSymbol, String interval) async {
  final url = Uri.parse('$baseUrlCandle/v2/histo$interval?fsym=$coinSymbol&tsym=USD&limit=60&api_key=$apiKey');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['Response'] == 'Success') {
      final List<dynamic> ohlcList = data['Data']['Data'];
      return ohlcList.map((json) => OHLCData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load OHLC data: ${data['Message']}');
    }
  } else {
    throw Exception('Failed to load OHLC data');
  }
}

Future<List<NewsData>> fetchHandpickedNews() async {
  const apiKeyNews = 'j4R3kK5Ootse28pT4qoyx2GQvBCldz5rGg8dYgo0z3g=';

  final response = await http.get(
    Uri.parse('https://openapiv1.coinstats.app/news/type/handpicked?limit=40'),
    headers: {
      'Accept': 'application/json',
      'X-API-KEY': apiKeyNews,
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> newsData = jsonDecode(response.body);
    return newsData.map((json) => NewsData.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch handpicked news. Error: ${response.statusCode}');
  }
}
}