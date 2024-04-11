import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  SalesData(this.year, this.sales);
  final int year;
  final double sales;
}

class Graphpivot extends StatefulWidget {
  List<dynamic> l;
  dynamic s;
  dynamic p;
  dynamic r1;
  dynamic r2;
  dynamic s1;
  dynamic s2;
  Graphpivot(this.l,this.s,this.p,this.r1,this.r2,this.s1,this.s2);
  @override
  _GraphpivotState createState() => _GraphpivotState();
}

class _GraphpivotState extends State<Graphpivot> {
  dynamic sl;
  List<SalesData> grp=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    setState(() {
      for(var i=0;i<widget.l.length;i++){
        grp.add(SalesData((i+1), widget.l[i]));
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white54,
      appBar: AppBar(
        title: Text('${widget.s} pivot graph'),

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0,50.0,0.0,0.0),
          child: Container(

            width: double.infinity,
            child:  SfCartesianChart(

              // Initialize category axis
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: NumericAxis(
                    title: AxisTitle(
                        text: '15 min interval graph.',
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold
                        )
                    ),

                ),
                primaryYAxis: NumericAxis(
                  maximum: widget.r2+1,
                    minimum: widget.s2-1,
                    title: AxisTitle(
                        text: 'close value',
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold
                        )
                    ),
                    plotBands: <PlotBand>[
                      PlotBand(

                          text: 'p',
                          textAngle: 0,
                          start: widget.p,
                          end: widget.p,
                          textStyle: TextStyle(color: Colors.orange, fontSize: 16),
                          borderColor: Colors.orange,
                          borderWidth: 2
                      ),
                      PlotBand(

                          text: 'r1',
                          textAngle: 0,
                          start: widget.r1,
                          end: widget.r1,
                          textStyle: TextStyle(color: Colors.green, fontSize: 16),
                          borderColor: Colors.green,
                          borderWidth: 2
                      ),
                      PlotBand(

                          text: 'r2',
                          textAngle: 0,
                          start: widget.r2,
                          end: widget.r2,
                          textStyle: TextStyle(color: Colors.green, fontSize: 16),
                          borderColor: Colors.green,
                          borderWidth: 2
                      ),
                      PlotBand(

                          text: 's1',
                          textAngle: 0,
                          start: widget.s1,
                          end: widget.s1,
                          textStyle: TextStyle(color: Colors.red, fontSize: 16),
                          borderColor: Colors.red,
                          borderWidth: 2
                      ),
                      PlotBand(

                          text: 's2',
                          textAngle: 0,
                          start: widget.s2,
                          end: widget.s2,
                          textStyle: TextStyle(color: Colors.red, fontSize: 16),
                          borderColor: Colors.red,
                          borderWidth: 2
                      ),

                    ]
                ),



                //primaryYAxis: CategoryAxis(name: 'close value'),
                series: <LineSeries<SalesData, int>>[

                  LineSeries<SalesData, int>(



                    // Bind data source
                      dataSource:  grp,
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales
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