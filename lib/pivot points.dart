import 'package:flutter/material.dart';
import 'package:stockmarket/Graph.dart';
import 'package:stockmarket/Graphpivot.dart';
import 'package:stockmarket/loading.dart';

import 'package:yahoofin/yahoofin.dart';
import 'package:yahoofin/src/models/stockChart.dart';
import 'package:yahoofin/src/models/stockQuote.dart';
import 'package:yahoofin/src/models/yahoo_exception.dart';

import 'Graph1.dart';
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
  dynamic pivot;
  dynamic r1;
  dynamic r2;
  dynamic s1;
  dynamic s2;
  dynamic close;
  dynamic diffp;
  dynamic list15;
  dynamic line;



  comp(this.compname,this.pivot,this.r1,this.r2,this.s1,this.s2,this.close,this.diffp,this.list15,this.line);
}

class pivot extends StatefulWidget {
  @override
  _pivotState createState() => _pivotState();
}

class _pivotState extends State<pivot> {
  // dynamic
  List<comp> sl = [];
  // dynamic [0,0,0,0,0,0,0]=[0,0,0,0,0,0,0,0];
  dynamic sortopl = [0,0,0,0,0,0,0,0];
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
        StockChart st1 = await hist.getChartQuotes(period: StockRange.twoDay);
        StockChart st2=await hist.getChartQuotes(period: StockRange.oneDay,interval: StockInterval.fifteenMinute);

        dynamic high=st1.chartQuotes.high[0];
        dynamic low=st1.chartQuotes.low[0];
        dynamic close=st1.chartQuotes.close[0];

        dynamic p=(high+low+close)/3;
        dynamic r1=(p*2)-low;
        dynamic r2=p+(high-low);
        dynamic s1=(p*2)-high;
        dynamic s2=p-(high-low);
        dynamic closep=st1.chartQuotes.close[1];

        dynamic diffp;

        var px=(closep-p)/p*100;
        var r1x=(closep-r1)/r1*100;
        var r2x=(closep-r2)/r2*100;
        var s1x=(closep-s1)/s1*100;
        var s2x=(close-s2)/s2*100;

        var templ=[['p',px.abs()],['r1',r1x.abs()],['r2',r2x.abs()],['s1',s1x.abs()],['s2',s2x.abs()]];

        templ.sort((a,b)=>a[1].compareTo(b[1]));
        var line;
        var ch=true;
        for(var k=0;k<templ.length;k++){

          if(templ[k][1]<=0.5){
            diffp=templ[k][1];
            line=templ[k][0];
            ch=false;
            break;

          }
        }

        if(ch){
          diffp=templ[0][1];
          line=templ[0][0];

        }












        setState(() {
          sl.add(new comp(prlist[i],p,r1,r2,s1,s2,closep,diffp,st2.chartQuotes.close,line));
          sl.sort((a,b) => a.diffp.compareTo(b.diffp));
        });
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
      appBar: AppBar(title: Text('pivot points')),
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
                        sortopl = [0,0,0,0,0,0,0];
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
                      sortopl = [0,0,0,0,0,0,0];
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
                        'pivot${sortopl[0] == 1 ? '⬆' : sortopl[0] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[0] == 0) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[0] = 1;
                            sl.sort((b, a) => a.pivot.compareTo(b.pivot));
                          });
                        } else if (sortopl[0] == 1) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[0] = -1;
                            sl.sort((a, b) => a.pivot.compareTo(b.pivot));
                          });
                        } else {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[0] = 1;
                            sl.sort((b, a) => a.pivot.compareTo(b.pivot));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        'r1${sortopl[1] == 1 ? '⬆' : sortopl[1] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[1] == 0) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[1] = 1;
                            sl.sort((b, a) => a.r1.compareTo(b.r1));
                          });
                        } else if (sortopl[1] == 1) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[1] = -1;
                            sl.sort((a, b) => a.r1.compareTo(b.r1));
                          });
                        } else {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[1] = 1;
                            sl.sort((b, a) => a.r1.compareTo(b.r1));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        'r2${sortopl[2] == 1 ? '⬆' : sortopl[2] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[2] == 0) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[2] = 1;
                            sl.sort((b, a) =>
                                a.r2.compareTo(b.r2));
                          });
                        } else if (sortopl[2] == 1) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[2] = -1;
                            sl.sort((a, b) =>
                                a.r2.compareTo(b.r2));
                          });
                        } else {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[2] = 1;
                            sl.sort((b, a) =>
                                a.r2.compareTo(b.r2));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        's1${sortopl[3] == 1 ? '⬆' : sortopl[3] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[3] == 0) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[3] = 1;
                            sl.sort((b, a) => a.s1.compareTo(b.s1));
                          });
                        } else if (sortopl[3] == 1) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[3] = -1;
                            sl.sort((a, b) => a.s1.compareTo(b.s1));
                          });
                        } else {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[3] = 1;
                            sl.sort((b, a) => a.s1.compareTo(b.s1));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        's2${sortopl[4] == 1 ? '⬆' : sortopl[4] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[4] == 0) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[4] = 1;
                            sl.sort((b, a) => a.s2.compareTo(b.s2));
                          });
                        } else if (sortopl[4] == 1) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[4] = -1;
                            sl.sort((a, b) => a.s2.compareTo(b.s2));
                          });
                        } else {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[4] = 1;
                            sl.sort((b, a) => a.s2.compareTo(b.s2));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        'closep${sortopl[5] == 1 ? '⬆' : sortopl[5] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[5] == 0) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[5] = 1;
                            sl.sort((b, a) => a.close.compareTo(b.close));
                          });
                        } else if (sortopl[5] == 1) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[5] = -1;
                            sl.sort((a, b) => a.close.compareTo(b.close));
                          });
                        } else {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[5] = 1;
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
                        'diff${sortopl[6] == 1 ? '⬆' : sortopl[6] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[6] == 0) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[6] = 1;
                            sl.sort((b, a) => a.diffp.compareTo(b.diffp));
                          });
                        } else if (sortopl[6] == 1) {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[6] = -1;
                            sl.sort((a, b) => a.diffp.compareTo(b.diffp));
                          });
                        } else {
                          setState(() {
                            sortopl = [0,0,0,0,0,0,0];
                            sortopl[6] = 1;
                            sl.sort((b, a) => a.diffp.compareTo(b.diffp));
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
                          color: sl[index].diffp < 0.5
                              ? Colors.green
                              : sl[index].diffp==0
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
                                        '${sl[index].pivot.toStringAsFixed(1)}')),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].r1.toStringAsFixed(1)}')),
                                Expanded(
                                    child: Text(
                                        '${sl[index].r2.toStringAsFixed(1)}')),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].s1.toStringAsFixed(1)}')),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].s2.toStringAsFixed(1)}')),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].close.toStringAsFixed(1)}')),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].diffp.toStringAsFixed(1)}(${sl[index].line})')),
                                SizedBox(
                                  width: 5.0,
                                ),

                                // SizedBox(
                                //   width: 5.0,
                                // ),
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>Graphpivot(sl[index].list15,sl[index].compname,sl[index].pivot,sl[index].r1,sl[index].r2,sl[index].s1,sl[index].s2)));
                        },
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
