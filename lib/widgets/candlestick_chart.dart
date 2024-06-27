import 'package:flutter/material.dart';
import '../models/ohlc_data.dart';
import 'dart:ui' as ui;

class CandlestickChart extends StatefulWidget {
  final List<OHLCData> ohlcData;
  final double maxPrice;
  final double minPrice;
  final double width;
  final double height;

  const CandlestickChart({
    super.key,
    required this.ohlcData,
    required this.maxPrice,
    required this.minPrice,
    required this.width,
    required this.height,
  });

  @override
  CandlestickChartState createState() => CandlestickChartState();
}

class CandlestickChartState extends State<CandlestickChart> {
  List<Line> lines = [];
  Offset? start;
  Offset? end;
  bool drawing = false;
  bool erasing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        if (drawing) {
          setState(() {
            start = details.localPosition;
          });
        }
      },
      onPanUpdate: (details) {
        if (drawing) {
          setState(() {
            end = details.localPosition;
          });
        }
      },
      onPanEnd: (details) {
        if (drawing && start != null && end != null) {
          setState(() {
            lines.add(Line(start!, end!));
            start = null;
            end = null;
          });
        }
      },
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: CandlestickChartPainter(
          ohlcData: widget.ohlcData,
          maxPrice: widget.maxPrice,
          minPrice: widget.minPrice,
          width: widget.width,
          height: widget.height,
          lines: lines,
        ),
      ),
    );
  }

  void toggleDrawing() {
    setState(() {
      drawing = !drawing;
      erasing = false;
    });
  }

  void toggleErasing() {
    setState(() {
      erasing = !erasing;
      drawing = false;
    });
  }

  void clearLines() {
    setState(() {
      lines.clear();
    });
  }
}

class CandlestickChartPainter extends CustomPainter {
  final List<OHLCData> ohlcData;
  final double maxPrice;
  final double minPrice;
  final double width;
  final double height;
  final List<Line> lines;

  CandlestickChartPainter({
    required this.ohlcData,
    required this.maxPrice,
    required this.minPrice,
    required this.width,
    required this.height,
    required this.lines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final priceRange = maxPrice - minPrice;
    final candleWidth = (width * 0.6) / ohlcData.length; 
    final leftPadding = width * 0.2; 
    // ignore: unused_local_variable
    final rightPadding = width * 0.2; 
    final topPadding = height * 0.2; 
    final bottomPadding = height * 0.2; 

    // Draw price marks on the y-axis
    final priceMarkPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    // minimum 
    priceMarkPainter.text = TextSpan(
      text: '\$${minPrice.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black,
      ),
    );
    priceMarkPainter.layout();
    priceMarkPainter.paint(
      canvas,
      Offset(leftPadding - 70, height - bottomPadding),
    );

    // maximum
    priceMarkPainter.text = TextSpan(
      text: '\$${maxPrice.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black,
      ),
    );
    priceMarkPainter.layout();
    priceMarkPainter.paint(
      canvas,
      Offset(leftPadding - 70, topPadding),
    );

    // intermediate
    for (double price = minPrice + priceRange / 5; price < maxPrice; price += priceRange / 5) {
      priceMarkPainter.text = TextSpan(
        text: '\$${price.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      );
      priceMarkPainter.layout();
      priceMarkPainter.paint(
        canvas,
        Offset(leftPadding - 70, height - topPadding - (price - minPrice) * (height - topPadding - bottomPadding) / priceRange),
      );
    }

    for (int i = 0; i < ohlcData.length; i++) {
      final data = ohlcData[i];
      final x = leftPadding + i * candleWidth;
      final high = height - topPadding - ((data.high - minPrice) / priceRange) * (height - topPadding - bottomPadding);
      final low = height - topPadding - ((data.low - minPrice) / priceRange) * (height - topPadding - bottomPadding);
      final open = height - topPadding - ((data.open - minPrice) / priceRange) * (height - topPadding - bottomPadding);
      final close = height - topPadding - ((data.close - minPrice) / priceRange) * (height - topPadding - bottomPadding);

      paint.color = data.close >= data.open ? Colors.green : Colors.red;
      canvas.drawRect(Rect.fromLTRB(x, open, x + candleWidth, close), paint); // candle body

      final tailX = x + candleWidth / 2; // Center tail

      canvas.drawLine(Offset(tailX, high), Offset(tailX, open), paint); // upper tail
      canvas.drawLine(Offset(tailX, close), Offset(tailX, low), paint); // lower tail
    }

    // Draw lines
    for (final line in lines) {
      paint
        ..color = Colors.blue
        ..strokeWidth = 2.0;
      canvas.drawLine(line.start, line.end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Line {
  final Offset start;
  final Offset end;

  Line(this.start, this.end);
}
