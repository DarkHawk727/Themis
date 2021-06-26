import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({ Key key }) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with SingleTickerProviderStateMixin{
  double bottomSheetHeight = 100;
  double bottomSheetMaxHeight = 750;
  Animation<double> animation;
  AnimationController controller;
  Tween<double> _tween;
  DragStatus dragStatus = DragStatus.endedDown;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 85), vsync: this);
    _tween = Tween<double>(begin: bottomSheetHeight, end: bottomSheetMaxHeight);
    animation = _tween.animate(controller)            
      ..addListener(() => setState(() => bottomSheetHeight = animation.value));     
    super.initState();
  }

  animate({double from, double to}) {
    setState(() { 
      if(animation.status == AnimationStatus.completed) {
        _tween.end = from;
        _tween.begin = to;
        controller.reverse();
      } else {
         _tween.end = to;
        _tween.begin = from;
        controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Image.network('https://smartcdn.prod.postmedia.digital/nationalpost/wp-content/uploads/2021/06/Anthony-Rota-1-33.png?quality=90&strip=all&w=564&type=webp'),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Text('Car crash in Beverly Hills', style: Theme.of(context).textTheme.headline2),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('OTTAWA – The Speaker of the House of Commons says he intends to ask the federal court to strike down the Trudeau government’s attempt to have a judge block parliamentarians from receiving documents regarding the firing of two scientists at Canada’s top laboratory.', style: Theme.of(context).textTheme.bodyText1),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onVerticalDragStart: (v) {
                if(v.localPosition.dy < 50) setState(() => dragStatus = DragStatus.started);
              },
              onVerticalDragUpdate: (v){
                if(dragStatus == DragStatus.started)
                setState(() => bottomSheetHeight = 870 - v.globalPosition.dy);
              },
              onVerticalDragEnd: (v){
                setState(() => dragStatus = DragStatus.endedUp);
                if(-v.velocity.pixelsPerSecond.dy > 0 || bottomSheetHeight > 600) {
                  animate(from: bottomSheetHeight, to: bottomSheetMaxHeight);
                } else {
                  animate(from: bottomSheetHeight, to: 100);
                }
              },
              child: Container(
                width: width,
                height: bottomSheetHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 5,
                      blurRadius: 40
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(height: 8),
                    Container(
                      height: 4,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.black38,
                      ),
                    ),
                    Container(height: 20),
                    Expanded(
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(left: 25, right: 25),
                        children: [
                          Text('Subjectivity', style: Theme.of(context).textTheme.subtitle1),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: width,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.black,
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.greenAccent,
                                        Colors.redAccent,
                                      ]
                                    )
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: (width - 58) * 0.8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 8,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(height: 8),
                          Text('Polarity', style: Theme.of(context).textTheme.subtitle1),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: width,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.black,
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.greenAccent,
                                        Colors.redAccent,
                                      ]
                                    )
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: (width - 58) * 0.3),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 8,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

enum DragStatus {
  started,
  endedDown,
  endedUp
}