import 'package:flutter/material.dart';
import 'package:scidart/numdart.dart';
import 'package:stockmarket/Graph.dart';
import 'package:stockmarket/loading.dart';

import 'package:yahoofin/yahoofin.dart';
import 'package:yahoofin/src/models/stockChart.dart';
import 'package:yahoofin/src/models/stockQuote.dart';
import 'package:yahoofin/src/models/yahoo_exception.dart';

import 'graphopen.dart';
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
  dynamic pclose;
  dynamic open;
  dynamic close;
  dynamic diffp;
  dynamic diffp2;
  dynamic closel;
  dynamic openl;
  dynamic lowl;
  dynamic highl;
  dynamic x;




  comp(this.compname,this.pclose,this.open,this.close,this.diffp,this.diffp2,this.x,this.closel,this.highl,this.lowl,this.openl);
}

class openclosegap extends StatefulWidget {
  @override
  _openclosegapState createState() => _openclosegapState();
}

class _openclosegapState extends State<openclosegap> {
  // dynamic
  List<comp> sl = [];
  dynamic sortopl = [0, 0, 0, 0];
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
        StockChart s1 = await hist.getChartQuotes(period: StockRange.twoDay);
        StockChart st2=await hist.getChartQuotes(period: StockRange.twoDay,interval: StockInterval.fifteenMinute);
        // print(prlist[i]);
        // print(s1.chartQuotes.close);

        dynamic pclose=s1.chartQuotes.close[0];
        dynamic open=s1.chartQuotes.open[1];
        dynamic close=s1.chartQuotes.close[1];
        dynamic diffp=(open-pclose)/pclose*100;
        dynamic diffp2=(close-open)/open*100;
        dynamic x=diffp+diffp2+(diffp*diffp2)/100;
        // dynamic li=[];
        //
        // List s2=List.from(s1.chartQuotes.close.reversed);
        //
        // for(var j=0;j<10;j++){
        //   // print('${s2.sublist(j,j+44)} ${s2.sublist(j,j+44).length}');
        //   li.add(average(s2.sublist(j,j+44)));
        // }
        // print(li);
        //
        //
        //
        // dynamic pc=((s2[0]-s2[1])/s2[1])*100;
        // dynamic diffp=((s2[0]-li[0])/li[0]);


        setState(() {
          sl.add(new comp(prlist[i],pclose,open,close,diffp,diffp2,x,st2.chartQuotes.close,st2.chartQuotes.high,st2.chartQuotes.low,st2.chartQuotes.open));

        });
      } catch (e) {
        setState(() {
          error = "error: ${e.toString()}";
        });
        print(e);
      }
    }

    List<comp> gl=[];
    List<comp> ol=[];
    List<comp> rl=[];

    for(var i=0;i<sl.length;i++){
      if(sl[i].diffp>0 && sl[i].diffp2>0){
        gl.add(sl[i]);
      }
      else if(sl[i].diffp>0){
        ol.add(sl[i]);
      }
      else{
        rl.add(sl[i]);
      }
    }

    gl.sort((b, a) => a.diffp.compareTo(b.diffp));
    ol.sort((b, a) => a.diffp.compareTo(b.diffp));
    rl.sort((b, a) => a.diffp.compareTo(b.diffp));

    setState(() {
      sl=gl+ol+rl;
    });


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
      appBar: AppBar(title: Text('open gap value')),
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
                        sortopl = [0, 0, 0, 0];
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
                      sortopl = [0, 0, 0, 0];
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
                        'previous Close${sortopl[0] == 1 ? '⬆' : sortopl[0] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[0] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[0] = 1;
                            sl.sort((b, a) => a.pclose.compareTo(b.pclose));
                          });
                        } else if (sortopl[0] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[0] = -1;
                            sl.sort((a, b) => a.pclose.compareTo(b.pclose));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[0] = 1;
                            sl.sort((b, a) => a.pclose.compareTo(b.pclose));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        'today open${sortopl[1] == 1 ? '⬆' : sortopl[1] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[1] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[1] = 1;
                            sl.sort((b, a) => a.open.compareTo(b.open));
                          });
                        } else if (sortopl[1] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[1] = -1;
                            sl.sort((a, b) => a.open.compareTo(b.open));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[1] = 1;
                            sl.sort((b, a) => a.open.compareTo(b.open));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        'presentclose${sortopl[2] == 1 ? '⬆' : sortopl[2] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[2] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[2] = 1;
                            sl.sort((b, a) =>
                                a.close.compareTo(b.close));
                          });
                        } else if (sortopl[2] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[2] = -1;
                            sl.sort((a, b) =>
                                a.close.compareTo(b.close));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[2] = 1;
                            sl.sort((b, a) =>
                                a.close.compareTo(b.close));
                          });
                        }
                      }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        'diffp (open-pclose)/pclose${sortopl[3] == 1 ? '⬆' : sortopl[3] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[3] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[3] = 1;
                            sl.sort((b, a) => a.diffp.compareTo(b.diffp));
                          });
                        } else if (sortopl[3] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[3] = -1;
                            sl.sort((a, b) => a.diffp.compareTo(b.diffp));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[3] = 1;
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
                          color: sl[index].diffp>0 && sl[index].diffp2>0
                              ? Colors.green
                              : sl[index].diffp>0
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
                                        '${sl[index].pclose.toStringAsFixed(2)}')),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].open.toStringAsFixed(2)}')),
                                Expanded(
                                    child: Text(
                                        '${sl[index].close.toStringAsFixed(2)}')),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(
                                        '${sl[index].diffp.toStringAsFixed(2)}')),
                                SizedBox(
                                  width: 5.0,
                                ),

                                SizedBox(
                                  width: 5.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>Graphopen(List.from(sl[index].closel),sl[index].highl,sl[index].lowl,sl[index].openl,sl[index].compname)));
                        },
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
