class OHLCData {
  final int time;
  final double high;
  final double low;
  final double open;
  final double close;

  OHLCData({
    required this.time,
    required this.high,
    required this.low,
    required this.open,
    required this.close,
  });

  factory OHLCData.fromJson(Map<String, dynamic> json) {
    return OHLCData(
      time: json['time'],
      high: json['high'].toDouble(),
      low: json['low'].toDouble(),
      open: json['open'].toDouble(),
      close: json['close'].toDouble(),
    );
  }
}
