import 'package:flutter/material.dart';
import 'package:stockmarket/Graph.dart';
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
  dynamic close;
  dynamic pricechange;
  dynamic diffp;
  dynamic l54=[];
  dynamic l542=[];
  dynamic avg44;


  comp(this.compname, this.close, this.pricechange, this.diffp, this.l54,this.l542,
    this.avg44);
}

class Dma44 extends StatefulWidget {
  @override
  _Dma44State createState() => _Dma44State();
}

class _Dma44State extends State<Dma44> {
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
        StockChart s1 = await hist.getChartQuotes(period: StockRange.fivefourday);
        // StockChart ss1=await hist.getChartQuotes(period: StockRange.oneDay);
        // print(prlist[i]);
        // print(ss1.chartQuotes.close);
        // print(prlist[i]);
        // print(s1.chartQuotes.close);
        dynamic li=[];

        List s2=s1.chartQuotes.close;//List.from(s1.chartQuotes.close.reversed);
        // li.add(average(s2.sublist(0,44)));
        var mul=(2/45);
        var pema=average(s2.sublist(0,44));
        for(var j=44;j<54;j++){
          // print('${s2.sublist(j,j+44)} ${s2.sublist(j,j+44).length}');
          var ema=(s2[j]-pema)*mul+pema;
          pema=ema;
          li.add(ema);
        }
        dynamic li2=[];


        li=List.from(li.reversed);
        // print(li);
        s2=List.from(s1.chartQuotes.close.reversed);



        for(var j=0;j<10;j++){
          // print('${s2.sublist(j,j+44)} ${s2.sublist(j,j+44).length}');
          li2.add(average(s2.sublist(j,j+44)));
        }

        dynamic pc=((s2[0]-s2[1])/s2[1])*100;
        dynamic diffp=((s2[0]-li[0])/li[0]);


        setState(() {
          sl.add(new comp(prlist[i],s2[0],pc,diffp,li,li2,li[0]));
          sl.sort((a, b) => a.diffp.compareTo(b.diffp));
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
      appBar: AppBar(title: Text('44 DMA')),
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
                        'Close${sortopl[0] == 1 ? '⬆' : sortopl[0] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[0] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[0] = 1;
                            sl.sort((b, a) => a.close.compareTo(b.close));
                          });
                        } else if (sortopl[0] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[0] = -1;
                            sl.sort((a, b) => a.close.compareTo(b.close));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
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
                        'diff(close-avg44)${sortopl[1] == 1 ? '⬆' : sortopl[1] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[1] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[1] = 1;
                            sl.sort((b, a) => a.diffp.compareTo(b.diffp));
                          });
                        } else if (sortopl[1] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[1] = -1;
                            sl.sort((a, b) => a.diffp.compareTo(b.diffp));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
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
                            sortopl = [0, 0, 0, 0];
                            sortopl[2] = 1;
                            sl.sort((b, a) =>
                                a.pricechange.compareTo(b.pricechange));
                          });
                        } else if (sortopl[2] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[2] = -1;
                            sl.sort((a, b) =>
                                a.pricechange.compareTo(b.pricechange));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
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
                        'avg44(EMA)${sortopl[3] == 1 ? '⬆' : sortopl[3] == -1 ? '⬇' : ""}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: enable
                          ? () {
                        if (sortopl[3] == 0) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[3] = 1;
                            sl.sort((b, a) => a.avg44.compareTo(b.avg44));
                          });
                        } else if (sortopl[3] == 1) {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[3] = -1;
                            sl.sort((a, b) => a.avg44.compareTo(b.avg44));
                          });
                        } else {
                          setState(() {
                            sortopl = [0, 0, 0, 0];
                            sortopl[3] = 1;
                            sl.sort((b, a) => a.avg44.compareTo(b.avg44));
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
                          color: sl[index].diffp.abs() < 0.1
                              ? Colors.green
                              : sl[index].diffp.abs() < 0.5
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
                                        '${sl[index].avg44.toStringAsFixed(2)}')),
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
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>GraphScreen1(List.from(sl[index].l54.reversed),List.from(sl[index].l542.reversed),sl[index].compname)));
                        },
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
