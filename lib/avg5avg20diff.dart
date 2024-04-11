import 'package:flutter/material.dart';
import 'package:stockmarket/Graph.dart';
import 'package:stockmarket/loading.dart';

import 'package:yahoofin/yahoofin.dart';
import 'package:yahoofin/src/models/stockChart.dart';
import 'package:yahoofin/src/models/stockQuote.dart';
import 'package:yahoofin/src/models/yahoo_exception.dart';

import 'info.dart';

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
  dynamic pricechange;
  dynamic avg5;
  dynamic avg20;
  dynamic diffp;
  dynamic l20=[];

  comp(this.compname, this.close, this.pricechange, this.avg5, this.avg20,
      this.diffp,this.l20);
}

class avg3avg20diff extends StatefulWidget {
  @override
  _avg3avg20diffState createState() => _avg3avg20diffState();
}

class _avg3avg20diffState extends State<avg3avg20diff> {
  // dynamic
  List<comp> sl = [];
  dynamic sortopl = [0, 0, 0, 0, 0];
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
  double average(List<double> nums) {
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

        // StockChart s3=await hist.getChartQuotes(period: StockRange.minRange);
        // print(s.chartQuotes.close);
        // print(s1.chartQuotes.close);
        dynamic close = s1.chartQuotes.close.sublist(19, 20)[0];
        dynamic avg5 = average(s1.chartQuotes.close.sublist(15, 20));
        dynamic avg20 = average(s1.chartQuotes.close);
        dynamic compname = prlist[i];
        var n=s1.chartQuotes.close.length;
         dynamic pc=((s1.chartQuotes.close[n-1]-s1.chartQuotes.close[n-2])/s1.chartQuotes.close[n-2])*100;
        dynamic diffp = ((avg5 - avg20) / avg20) * 100;
        setState(() {
          sl.add(new comp(compname, close, pc, avg5, avg20, diffp,s1.chartQuotes.close));
          sl.sort((b, a) => a.diffp.compareTo(b.diffp));
        });
      } catch (e) {
        setState(() {
          error = "error: ${e.toString()}";
        });
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
      appBar: AppBar(title: Text('5 DMA vs 20 DMA')),
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
                              sortopl = [0, 0, 0, 0, 0];
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
                      sortopl = [0, 0, 0, 0, 0];
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
                        'Close${sortopl[0] == 1 ? '⬆' : sortopl[0] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                              if (sortopl[0] == 0) {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[0] = 1;
                                  sl.sort((b, a) => a.close.compareTo(b.close));
                                });
                              } else if (sortopl[0] == 1) {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[0] = -1;
                                  sl.sort((a, b) => a.close.compareTo(b.close));
                                });
                              } else {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
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
                        'diff(avg5-avg20)${sortopl[1] == 1 ? '⬆' : sortopl[1] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                              if (sortopl[1] == 0) {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[1] = 1;
                                  sl.sort((b, a) => a.diffp.compareTo(b.diffp));
                                });
                              } else if (sortopl[1] == 1) {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[1] = -1;
                                  sl.sort((a, b) => a.diffp.compareTo(b.diffp));
                                });
                              } else {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[1] = 1;
                                  sl.sort((b, a) => a.diffp.compareTo(b.diffp));
                                });
                              }
                            }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        'price change${sortopl[2] == 1 ? '⬆' : sortopl[2] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                              if (sortopl[2] == 0) {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[2] = 1;
                                  sl.sort((b, a) =>
                                      a.pricechange.compareTo(b.pricechange));
                                });
                              } else if (sortopl[2] == 1) {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[2] = -1;
                                  sl.sort((a, b) =>
                                      a.pricechange.compareTo(b.pricechange));
                                });
                              } else {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[2] = 1;
                                  sl.sort((b, a) =>
                                      a.pricechange.compareTo(b.pricechange));
                                });
                              }
                            }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        'avg5${sortopl[3] == 1 ? '⬆' : sortopl[3] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                              if (sortopl[3] == 0) {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[3] = 1;
                                  sl.sort((b, a) => a.avg5.compareTo(b.avg5));
                                });
                              } else if (sortopl[3] == 1) {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[3] = -1;
                                  sl.sort((a, b) => a.avg5.compareTo(b.avg5));
                                });
                              } else {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[3] = 1;
                                  sl.sort((b, a) => a.avg5.compareTo(b.avg5));
                                });
                              }
                            }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        'avg20${sortopl[4] == 1 ? '⬆' : sortopl[4] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                              if (sortopl[4] == 0) {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[4] = 1;
                                  sl.sort((b, a) => a.avg20.compareTo(b.avg20));
                                });
                              } else if (sortopl[4] == 1) {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[4] = -1;
                                  sl.sort((a, b) => a.avg20.compareTo(b.avg20));
                                });
                              } else {
                                setState(() {
                                  sortopl = [0, 0, 0, 0, 0];
                                  sortopl[4] = 1;
                                  sl.sort((b, a) => a.avg20.compareTo(b.avg20));
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
                              color: sl[index].diffp > 5
                                  ? Colors.green
                                  : sl[index].diffp > 0
                                      ? Colors.orangeAccent
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
                                            '${sl[index].diffp.toStringAsFixed(2)}%')),
                                    Expanded(
                                        child: Text(
                                            '${sl[index].pricechange.toStringAsFixed(2)}%')),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                        child: Text(
                                            '${sl[index].avg5.toStringAsFixed(2)}')),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                        child: Text(
                                            '${sl[index].avg20.toStringAsFixed(2)}')),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>GraphScreen(sl[index].l20,sl[index].compname)));
                            },
                          );
                        }))
          ],
        ),
      ),
    );
  }
}
