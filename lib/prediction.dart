import 'package:flutter/material.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:scidart/numdart.dart';
import 'package:stockmarket/Graph.dart';
import 'package:stockmarket/graphpredict.dart';
import 'package:stockmarket/loading.dart';

import 'package:yahoofin/yahoofin.dart';
import 'package:yahoofin/src/models/stockChart.dart';
import 'package:yahoofin/src/models/stockQuote.dart';
import 'package:yahoofin/src/models/yahoo_exception.dart';

import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_dataframe/src/data_frame/data_frame_impl.dart';
import 'dart:io';

import 'info.dart';
import 'linearregression.dart';

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    color: Colors.black,
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "LoadCompleted..",
      style: TextStyle(color: Colors.white),
    ),

    backgroundColor: Colors.lightBlue,
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class comp {
  String compname;
  dynamic close;
  dynamic close2;
  dynamic close3;
  dynamic close4;
  dynamic close5;
  dynamic avg;
  dynamic diffp;


  comp(this.compname,this.close,this.close2,this.close3,this.close4,this.close5,this.avg,this.diffp);
}

class prediction extends StatefulWidget {
  @override
  _predictionState createState() => _predictionState();
}

class _predictionState extends State<prediction> {
  // dynamic
  List<comp> sl = [];
  dynamic sortopl = [0, 0, 0, 0,0,0];
  dynamic listop = "nifty psubank";
  dynamic debug = "not there";
  dynamic error = "";

  dynamic enable=false;
  final dict={
    'nifty psubank':niftypsubank,
    'nifty it':niftyitList,
    'nifty auto':niftyauto,
    'nifty bank':niftybank,
    'nifty 50':nifty50,
    'next nifty 50':nextnifty50,
    'nifty consumer durable':niftyconsumerdurable,
    'nifty finance':niftyfinance,
    'nifty financialservices25_50':niftyfinancialservices25_50,
    'nifty fmcg':niftyfmcg,
    'nifty healthcare':niftyhealthcare,
    'nifty media':niftymedia,
    'nifty metal':niftymetal,
    'nifty oil gaslist':niftyoilgaslist,
    'nifty pharma':niftypharmalist,
    'nifty reality':niftyrealty,
    'all':nifty50+nextnifty50,

  };
  dynamic dpl=[];
  dynamic prlist = niftypsubank;
  double average(List<dynamic> nums) {
    double sum = 0;
    int c = 0;
    for (var i = 0; i < nums.length; i++) {
      if (nums[i] == null) {
        sum = sum + 0;
      } else {
        sum = sum + nums[i];
        c = c + 1;
      }
    }
    return sum / c;
  }

  void getdata() async {
    final yfin = YahooFin();
    setState(() {
      enable=false;
    });



    for (var i = 0; i < prlist.length; i++) {
      setState(() {
        debug = "there ${prlist.length}";
      });
      try {
        StockHistory hist = yfin.initStockHistory(ticker: prlist[i] + ".NS");
        // StockInfo stock = yfin.getStockInfo(ticker: prlist[i] + ".NS");
        //StockQuote st = await yfin.getPriceChange(stockInfo: stock);
        //dynamic pc =  st.regularMarketChangePercent;

        // StockChart s=await hist.getChartQuotes(period: StockRange.fiveDay);
        StockChart s1 = await hist.getChartQuotes(period: StockRange.twentyday);
        //print(prlist[i]);
        //print(s1.chartQuotes.close.length);
        List<double> x=[];//[1,2,3,4,5,6];
        List<double> y=[];//[1,2,3,4,5,6];
        var c=0;
        for(var j=0;j<s1.chartQuotes.close.length;j++){
            if(s1.chartQuotes.close[j]==null){
              continue;
            }
            x.add((j).toDouble());
            y.add(s1.chartQuotes.close[j]);
            c=c+1;
          }
        Array x1=Array(x);
        Array y1=Array(y);

        var n=c;
        var m_x=mean(x1);
        var m_y=mean(y1);
        var SS_xy = arraySum(y1*x1) - n*m_y*m_x;
        var SS_xx = arraySum(x1*x1) - n*m_x*m_x;


        var b_1 = SS_xy / SS_xx;
        var b_0 = m_y - b_1*m_x;
        print(prlist[i]);
        dynamic close=List.from(s1.chartQuotes.close.reversed)[0];
        dynamic close2=b_1*(c+1)+b_0;
        dynamic close3=b_1*(c+2)+b_0;
        dynamic close4=b_1*(c+3)+b_0;
        dynamic close5=b_1*(c+4)+b_0;
        dynamic avg=average([close,close2,close3,close4,close5]);

        setState(() {
          sl.add(new comp(prlist[i], close, close2, close3, close4, close5,avg,(avg-close)/close));
          sl.sort((b,a)=>a.diffp.compareTo(b.diffp));
        });
        //dynamic close1=b_1*(c+1)+b_0;

        // print(x*x);

        // List<double> x=[];//[1,2,3,4,5,6];
        // List<double> y1=[];//[1,2,3,4,5,6];
        // var lr = LinReg.init(10000,0.01);
        // var c=0;
        // for(var j=0;j<s1.chartQuotes.close.length;j++){
        //   if(s1.chartQuotes.close[j]==null){
        //     continue;
        //   }
        //   x.add((j).toDouble());
        //   y.add(s1.chartQuotes.close[j]);
        //   c=c+1;
        // }
        // // print(x);
        // // print(y);
        // lr.fit(x, y, 10);
        // print(prlist[i]);
        // // print(lr.a);
        // print(lr.a*(c+1)+lr.b);





      } catch (e) {
        setState(() {
          error = "error: ${e.toString()}";
        });
        print(e);
      }
    }

    showAlertDialog(context);
    setState(() {
      enable=true;
    });
    // for (var i = 0; i < prlist.length; i++) {
    //   print(
    //       '${sl[i].compname} ${sl[i].close} ${sl[i].avg5} ${sl[i].avg20} ${sl[i].diffp}');
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      dpl=dict.keys;
    });
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('predicting next 4 days ...')),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                enable
                    ? SizedBox()
                    : Expanded(
                    child: Image.asset(
                      'assets/loading-buffering.gif',
                      width: 10.0,
                      height: 10.0,
                    )),
                enable
                    ? Expanded(
                  child: RaisedButton(
                    child: Text('Refresh'),
                    onPressed: () async {
                      setState(() {
                        sl = [];
                        sortopl = [0, 0, 0, 0,0,0];
                      });
                      getdata();
                    },
                  ),
                )
                    : Expanded(
                    child: Text(
                      'No.of records: ${sl.length}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SizedBox(width: 50.0,),
                DropdownButton<String>(
                  value: listop,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: enable?(String newValue) {
                    setState(() {
                      listop = newValue;
                      sl = [];
                      sortopl = [0, 0, 0, 0,0,0];
                      prlist=dict[newValue];
                    });
                    getdata();
                  }:null,
                  items: dpl
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Card(
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        'Comp',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        'today${sortopl[0] == 1 ? '⬆' : sortopl[0] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[0] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[0] = 1;
                            sl.sort((b, a) => a.close.compareTo(b.close));
                          });
                        } else if (sortopl[0] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[0] = -1;
                            sl.sort((a, b) => a.close.compareTo(b.close));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[0] = 1;
                            sl.sort((b, a) => a.close.compareTo(b.close));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        't+1${sortopl[1] == 1 ? '⬆' : sortopl[1] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[1] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[1] = 1;
                            sl.sort((b, a) => a.close2.compareTo(b.close2));
                          });
                        } else if (sortopl[1] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[1] = -1;
                            sl.sort((a, b) => a.close2.compareTo(b.close2));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[1] = 1;
                            sl.sort((b, a) => a.close2.compareTo(b.close2));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        't+2${sortopl[2] == 1 ? '⬆' : sortopl[2] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[2] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[2] = 1;
                            sl.sort((b, a) =>
                                a.close3.compareTo(b.close3));
                          });
                        } else if (sortopl[2] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[2] = -1;
                            sl.sort((a, b) =>
                                a.close3.compareTo(b.close3));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[2] = 1;
                            sl.sort((b, a) =>
                                a.close3.compareTo(b.close3));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        't+3${sortopl[3] == 1 ? '⬆' : sortopl[3] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[3] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[3] = 1;
                            sl.sort((b, a) => a.close4.compareTo(b.close4));
                          });
                        } else if (sortopl[3] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[3] = -1;
                            sl.sort((a, b) => a.close4.compareTo(b.close4));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[3] = 1;
                            sl.sort((b, a) => a.close4.compareTo(b.close4));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        't+4${sortopl[4] == 1 ? '⬆' : sortopl[4] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[4] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[4] = 1;
                            sl.sort((b, a) => a.close5.compareTo(b.close5));
                          });
                        } else if (sortopl[4] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[4] = -1;
                            sl.sort((a, b) => a.close5.compareTo(b.close5));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[4] = 1;
                            sl.sort((b, a) => a.close5.compareTo(b.close5));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        'avg${sortopl[5] == 1 ? '⬆' : sortopl[5] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[5] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[4] = 1;
                            sl.sort((b, a) => a.avg.compareTo(b.avg));
                          });
                        } else if (sortopl[5] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[4] = -1;
                            sl.sort((a, b) => a.avg.compareTo(b.avg));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0,0,0];
                            sortopl[5] = 1;
                            sl.sort((b, a) => a.avg.compareTo(b.avg));
                          });
                        }
                      }
                          : null,
                    ),
                  ),

                ],
              ),
            ),
            sl.isEmpty
                ? loading()
                : Expanded(
                child: ListView.builder(
                    itemCount: sl.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Card(
                          color: sl[index].diffp > 0
                              ? Colors.green
                              // : sl[index].diffp > 0
                              // ? Colors.orangeAccent
                              : Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text('${sl[index].compname}')),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].close.toStringAsFixed(2)}')),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].close2.toStringAsFixed(2)}')),
                                Expanded(
                                    child: Text(
                                        '${sl[index].close3.toStringAsFixed(2)}')),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].close4.toStringAsFixed(2)}')),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].close5.toStringAsFixed(2)}')),

                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].avg.toStringAsFixed(2)}')),
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>Graphpredict([sl[index].close,sl[index].close2,sl[index].close3,sl[index].close4,sl[index].close5],sl[index].compname)));
                        },
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
