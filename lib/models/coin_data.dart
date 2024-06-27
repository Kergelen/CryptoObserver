class CoinData {
  final String id;
  final String rank;
  final String symbol;
  final String name;
  final String supply;
  final String maxSupply;
  final String marketCapUsd;
  final String volumeUsd24Hr;
  final String priceUsd;
  final double changePercent24Hr;
  final String vwap24Hr;
  final String explorer;

  CoinData({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.supply,
    required this.maxSupply,
    required this.marketCapUsd,
    required this.volumeUsd24Hr,
    required this.priceUsd,
    required this.changePercent24Hr,
    required this.vwap24Hr,
    required this.explorer,
  });

  factory CoinData.fromJson(Map<String, dynamic> json) {
    return CoinData(
      id: json['id'] ?? 'N/A',
      rank: json['rank'] ?? 'N/A',
      symbol: json['symbol'] ?? 'N/A',
      name: json['name'] ?? 'N/A',
      supply: json['supply'] ?? 'N/A',
      maxSupply: json['maxSupply'] ?? 'N/A',
      marketCapUsd: json['marketCapUsd'] ?? 'N/A',
      volumeUsd24Hr: json['volumeUsd24Hr'] ?? 'N/A',
      priceUsd: json['priceUsd'] ?? 'N/A',
      changePercent24Hr: double.parse(json['changePercent24Hr'].toString()),
      vwap24Hr: json['vwap24Hr'] ?? 'N/A',
      explorer: json['explorer'] ?? 'N/A',
    );
  }
}