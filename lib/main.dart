import 'package:flutter/material.dart';
import 'package:stockmarket/44DMA.dart';
import 'package:stockmarket/Graph.dart';
import 'package:stockmarket/avg5avg20diff.dart';
import 'package:stockmarket/openclosegap.dart';
import 'package:stockmarket/pivot%20points.dart';
import 'package:stockmarket/prediction.dart';

void main() {
  runApp(MaterialApp(
    title: 'Stock Screener',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Stock Screener'),
      ),
      body: Container(
        child: GridView.count(

            crossAxisCount: 2,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Card(
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10.0,
                    child: Center(
                      child: Text('5 DMA vs 20 DMA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),

                    ),
                  ),
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>avg3avg20diff()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Card(
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10.0,
                    child: Center(
                      child: Text('44 DMA',
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),

                    ),
                  ),
                  onTap: (){


                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Dma44()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Card(
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10.0,
                    child: Center(
                      child: Text('opengapvalue',
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),

                    ),
                  ),
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>openclosegap()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Card(
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10.0,
                    child: Center(
                      child: Text('pivot points',
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),

                    ),
                  ),
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>pivot()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Card(
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10.0,
                    child: Center(
                      child: Text('Prediction next 4 day value..',
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),

                    ),
                  ),
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>prediction()));
                  },
                ),
              ),

            ],

        ),
      ),
    );
  }
}

