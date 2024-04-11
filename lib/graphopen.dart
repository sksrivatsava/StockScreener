import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  SalesData(this.year,this.close,this.high,this.low,this.open);
  final int year;
  final double high;
  final double low;
  final double open;
  final double close;
}

class Graphopen extends StatefulWidget {
  List<dynamic> close;
  List<dynamic> high;
  List<dynamic> low;
  List<dynamic> open;
  dynamic s;
  Graphopen(this.close,this.high,this.low,this.open,this.s);
  @override
  _GraphopenState createState() => _GraphopenState();
}

class _GraphopenState extends State<Graphopen> {
  dynamic sl;
  List<SalesData> grp=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    setState(() {
      for(var i=0;i<widget.close.length;i++){
        grp.add(SalesData((i+1), widget.close[i],widget.high[i],widget.low[i],widget.open[i]));
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white54,
      appBar: AppBar(
        title: Text('${widget.s} 15 min graph'),

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0,50.0,0.0,0.0),
          child: Container(

            width: double.infinity,
            child:  SfCartesianChart(

              // Initialize category axis
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: CategoryAxis(
                    title: AxisTitle(
                        text: '2 day graph',
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold
                        )
                    ),
                    plotBands: <PlotBand>[
                      PlotBand(


                          textAngle: 0,
                          start: 24,
                          end: 24,
                          textStyle: TextStyle(color: Colors.orange, fontSize: 16),
                          borderColor: Colors.orange,
                          borderWidth: 2
                      ),
                    ]
                ),
                primaryYAxis: NumericAxis(
                    title: AxisTitle(
                        text: 'close value',
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold
                        )
                    )
                ),



                //primaryYAxis: CategoryAxis(name: 'close value'),
                series: <ChartSeries>[
                  // Renders CandleSeries
                  CandleSeries<SalesData, int>(
                    dataSource: grp,
                    xValueMapper: (SalesData sales, _) => sales.year,
                    lowValueMapper: (SalesData sales, _) => sales.low,
                    highValueMapper: (SalesData sales, _) => sales.high,
                    openValueMapper: (SalesData sales, _) => sales.open,
                    closeValueMapper: (SalesData sales, _) => sales.close,

                  )
                ]
            ),
            // child: LineChart(
            //
            //   LineChartData(
            //
            //     axisTitleData: FlAxisTitleData(
            //       bottomTitle: AxisTitle(titleText: 'Days',showTitle: true,textStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
            //       leftTitle: AxisTitle(titleText: 'close value',showTitle: true,textStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black))
            //
            //
            //     ),
            //
            //     borderData: FlBorderData(show: true),
            //     lineBarsData: [
            //       LineChartBarData(
            //           spots: grp
            //       )
            //     ]
            // ),
            //   swapAnimationCurve: Curves.linear,
            //   swapAnimationDuration: Duration(seconds: 3),
            // ),
          ),
        ),
      ),
    );
  }
}