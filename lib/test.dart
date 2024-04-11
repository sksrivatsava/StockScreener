import 'package:flutter/material.dart';
import 'package:stockmarket/info.dart';
import 'package:yahoofin/yahoofin.dart';
import 'package:yahoofin/src/models/stockChart.dart';
import 'package:yahoofin/src/models/stockQuote.dart';






void main() async{
  final yfin = YahooFin();
  StockInfo s=yfin.getStockInfo(ticker: 'tsla');
  StockQuote q=await yfin.getPrice(stockInfo: s);








}