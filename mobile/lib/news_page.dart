
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'data.dart';

class NewsPage extends StatefulWidget {
  const NewsPage(this.news, { Key key }) : super(key: key);
  final News news;

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with SingleTickerProviderStateMixin{
  double bottomSheetHeight = 70;
  double bottomSheetMaxHeight = 380;
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
    double height = MediaQuery.of(context).size.height;
    double topMargin = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTapDown: (v) {
              if (v.globalPosition.dy < 400) animate(from: bottomSheetHeight, to: 70);
            },
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: (animation.value - 70) * 0.007, sigmaY: (animation.value - 70) * 0.007),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    height: topMargin,
                  ),
                  Container(
                    child: Image.network(this.widget.news.image),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: this.widget.news.avgColor['full'] ?? Colors.black12,
                          blurRadius: 50,
                          spreadRadius: 10,
                          offset: Offset(0.0, -35.0)
                        )
                      ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Text(this.widget.news.headline, style: Theme.of(context).textTheme.headline2),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(this.widget.news.content, style: Theme.of(context).textTheme.bodyText1),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      String _url = this.widget.news.articleUrl;
                      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                    },
                    child: Text('Read Full'),
                  ),
                  Container(height: 90)
                ],
              ),
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
                setState(() => bottomSheetHeight = height - v.globalPosition.dy);
              },
              onVerticalDragEnd: (v){
                setState(() => dragStatus = DragStatus.endedUp);
                if(-v.velocity.pixelsPerSecond.dy > 0 || bottomSheetHeight > 250) {
                  animate(from: bottomSheetHeight, to: bottomSheetMaxHeight);
                } else {
                  animate(from: bottomSheetHeight, to: 70);
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
                      color: Colors.black12,
                      spreadRadius: 5,
                      blurRadius: 40
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(height: 10),
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
                          Container(height: 25),
                          DataSlider('Political Leaning', 0.4, [Colors.blueAccent, Colors.redAccent]),
                          DataSlider('Subjectivity: ' + (
                            this.widget.news.subjectivity > 0.66 ? 'High' :
                            this.widget.news.subjectivity > 0.33 ? 'Normal' :
                            'Low'
                          ), this.widget.news.subjectivity, [Colors.greenAccent, Colors.redAccent]),
                          DataSlider('Sentiment: ' + (
                                this.widget.news.polarity < -0.33 ? 'Negative' :
                                this.widget.news.polarity > 0.33 ? 'Positive' :
                                'Neutral'
                          ), (this.widget.news.polarity + 1) / 2, [Colors.redAccent, Colors.greenAccent]
                          ),
                          DataSlider('Reading Score: ' + (
                            this.widget.news.readingLevel > 90 ? 'Very Easy' :
                            this.widget.news.readingLevel > 80 ? 'Easy' :
                            this.widget.news.readingLevel > 70 ? 'Fairly Easy' :
                            this.widget.news.readingLevel > 60 ? 'Standard' :
                            this.widget.news.readingLevel > 50 ? 'Fairly Difficult' :
                            this.widget.news.readingLevel > 30 ? 'Difficult' :
                            'Very Confusing'
                          ), (this.widget.news.readingLevel / 100), [Colors.redAccent, Colors.greenAccent]),
                          Container(height: 7),
                          Center(child: Text('Source: ' + this.widget.news.sources[0] ?? ''))
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

class DataSlider extends StatelessWidget {
  const DataSlider(this.title, this.value, this.colors, { Key key }) : super(key: key);
  final String title;
  final double value;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w400)),
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
                    colors: colors
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: (width - 58) * value),
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
        Container(height: 14),
      ],
    );
  }
}

enum DragStatus {
  started,
  endedDown,
  endedUp
}