import 'package:flutter/material.dart';

class TutorialsView extends StatelessWidget {
  const TutorialsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorials'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const ExpansionTile(
                title: Text('What is fundamental analysis?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Fundamental analysis involves evaluating a cryptocurrency`s intrinsic value by examining related economic, financial, and other qualitative and quantitative factors. This includes analyzing the project`s whitepaper, the team behind the cryptocurrency, technology, market demand, regulatory environment, and overall market conditions. The goal is to determine if the cryptocurrency is undervalued or overvalued based on its fundamentals.',
                    ),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text('What is technical analysis?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Technical analysis involves analyzing statistical trends gathered from trading activity, such as price movement and volume. Unlike fundamental analysis, it does not consider the cryptocurrency`s intrinsic value but focuses on identifying patterns and trends that can indicate future price movements. Technical analysis uses various tools and indicators, such as moving averages, MACD, and Bollinger Bands, to predict future price behavior.',
                    ),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text('What are bearish and bullish markets?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'A bearish market is characterized by falling prices and a general sentiment that the market will continue to decline. Investors in a bearish market are typically pessimistic about the future performance of cryptocurrencies. \n A bullish market is characterized by rising prices and a general sentiment that the market will continue to rise. Investors in a bullish market are typically optimistic about the future performance of cryptocurrencies.',
                    ),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text('How do Japanese candles work?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Japanese candlesticks are a type of price chart used in technical analysis to display the high, low, open, and close prices of a cryptocurrency for a specific period. Each candlestick represents one period (e.g., one hour, one day) and consists of a body and wicks (shadows). The body represents the range between the open and close prices, while the wicks show the highest and lowest prices during the period. If the close price is higher than the open, the candlestick is typically colored green or white (indicating a bullish period). If the close price is lower than the open, it is colored red or black (indicating a bearish period).',
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('What are the most common chart patterns?'),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Some of the most common chart patterns used in technical analysis include: \n Head and Shoulders: A reversal pattern that signals a change in trend direction. \n Double Top and Double Bottom: Patterns that indicate potential reversals in uptrends and downtrends, respectively. \n Triangles (Ascending, Descending, and Symmetrical): Patterns that indicate potential continuation or reversal of a trend based on the direction of the breakout. \n Cup and Handle: A bullish continuation pattern that signals a potential upward movement following a consolidation period. \n Flags and Pennants: Short-term continuation patterns that indicate a brief consolidation before the trend continues in the same direction.',
                    ),
                  ),
                  Image.asset(
                    'assets/cheatsheet.jpg',
                    height: 200,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
