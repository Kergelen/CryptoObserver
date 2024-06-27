import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/ohlc_data.dart';

class OHLCView extends StatefulWidget {
  final String coinSymbol;

  const OHLCView({super.key, required this.coinSymbol});

  @override
  State<OHLCView> createState() => _OHLCViewState();
}

class _OHLCViewState extends State<OHLCView> {
  final ApiService _apiService = ApiService();
  late Future<List<OHLCData>> _ohlcDataFuture;

  @override
  void initState() {
    super.initState();
    _ohlcDataFuture = _apiService.fetchOHLCData(widget.coinSymbol, 'minute');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OHLC Data for ${widget.coinSymbol}'),
      ),
      body: FutureBuilder<List<OHLCData>>(
        future: _ohlcDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final ohlcData = snapshot.data!;
            return ListView.builder(
              itemCount: ohlcData.length,
              itemBuilder: (context, index) {
                final data = ohlcData[index];
                return ListTile(
                  title: Text('Time: ${data.time}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Open: ${data.open}'),
                      Text('High: ${data.high}'),
                      Text('Low: ${data.low}'),
                      Text('Close: ${data.close}'),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
