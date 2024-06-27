import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../models/coin_data.dart';
import '../models/ohlc_data.dart';
import '../models/news_data.dart';
import '../utils/constants.dart';
import '../widgets/candlestick_chart.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ApiService _apiService = ApiService();
  String _selectedCoin = supportedCoins.isNotEmpty ? supportedCoins.first : '';
  String _selectedSymbol = supportedSymbols.isNotEmpty ? supportedSymbols.first : '';
  late Future<CoinData> _coinDataFuture;
  late Future<List<OHLCData>> _ohlcDataFuture;
  late Future<List<NewsData>> _newsDataFuture;
  String _selectedInterval = 'minute';
  Timer? _timer;

  final GlobalKey<CandlestickChartState> _chartKey = GlobalKey<CandlestickChartState>();

  @override
  void initState() {
    super.initState();
    _updateSymbolAndFetchData();
    _startTimer();
    _newsDataFuture = _apiService.fetchHandpickedNews();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _updateSymbolAndFetchData();
      });
    });
  }

  void _onCoinChanged(String? newCoin) {
    setState(() {
      _selectedCoin = newCoin!;
      _updateSymbolAndFetchData();
    });
  }

  void _onIntervalChanged(String? newInterval) {
    setState(() {
      _selectedInterval = newInterval!;
      _ohlcDataFuture = _apiService.fetchOHLCData(_selectedSymbol, _selectedInterval);
    });
  }

  void _updateSymbolAndFetchData() {
    int selectedIndex = supportedCoins.indexOf(_selectedCoin);
    if (selectedIndex != -1) {
      _selectedSymbol = supportedSymbols[selectedIndex];
      _coinDataFuture = _apiService.getCoinData(_selectedCoin);
      _ohlcDataFuture = _apiService.fetchOHLCData(_selectedSymbol, _selectedInterval);
    }
  }

  void _toggleDrawing() {
    _chartKey.currentState?.toggleDrawing();
  }

  // ignore: unused_element
  void _toggleErasing() {
    _chartKey.currentState?.toggleErasing();
  }

  void _clearLines() {
    _chartKey.currentState?.clearLines();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crypto Analysis'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Analysis'),
              Tab(text: 'News'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                DropdownButton<String>(
                  value: _selectedCoin,
                  onChanged: _onCoinChanged,
                  items: supportedCoins
                      .map((coin) => DropdownMenuItem(
                            value: coin,
                            child: Text(coin),
                          ))
                      .toList(),
                ),
                DropdownButton<String>(
                  value: _selectedInterval,
                  onChanged: _onIntervalChanged,
                  items: ['minute', 'hour', 'day']
                      .map((interval) => DropdownMenuItem(
                            value: interval,
                            child: Text(interval),
                          ))
                      .toList(),
                ),
                Expanded(
                  child: FutureBuilder<List<OHLCData>>(
                    future: _ohlcDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final ohlcData = snapshot.data!;
                        final maxPrice = ohlcData.map((data) => data.high).reduce(max);
                        final minPrice = ohlcData.map((data) => data.low).reduce(min);
                        return CandlestickChart(
                          key: _chartKey,
                          ohlcData: ohlcData,
                          maxPrice: maxPrice,
                          minPrice: minPrice,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _toggleDrawing,
                      child: const Text('Line'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _clearLines,
                      child: const Text('Eraser'),
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder<CoinData>(
                    future: _coinDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data.name} (${data.symbol})',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text('Rank: ${data.rank}'),
                                Text('Price: \$${data.priceUsd}'),
                                Text('Supply: ${data.supply}'),
                                Text('Max Supply: ${data.maxSupply}'),
                                Text('Market Cap: \$${data.marketCapUsd}'),
                                Text('24h Volume: \$${data.volumeUsd24Hr}'),
                                Text('24h Change: ${data.changePercent24Hr}%'),
                                Text('24h VWAP: \$${data.vwap24Hr}'),
                                Text('Explorer: ${data.explorer}'),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
            FutureBuilder<List<NewsData>>(
              future: _newsDataFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final newsList = snapshot.data!;
                  return ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final news = newsList[index];
                      return ListTile(
                        leading: Image.network(news.imgUrl ?? ''),
                        title: Text(news.title ?? ''),
                        subtitle: Text(news.source ?? ''),
                        onTap: () async {
                          final url = Uri.parse(news.link ?? '');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
