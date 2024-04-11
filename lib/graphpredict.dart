import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class Graphpredict extends StatefulWidget {
  List<dynamic> l;
  dynamic s;
  Graphpredict(this.l,this.s);
  @override
  _GraphpredictState createState() => _GraphpredictState();
}

class _GraphpredictState extends State<Graphpredict> {
  dynamic sl;
  List<SalesData> grp=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    setState(() {
      for(var i=0;i<widget.l.length;i++){
        grp.add(SalesData('t+'+(i).toString(), widget.l[i]));
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white54,
      appBar: AppBar(
        title: Text('${widget.s} next 4 day graph'),

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
                        text: 'days',
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold
                        )
                    )
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
                series: <LineSeries<SalesData, String>>[

                  LineSeries<SalesData, String>(



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