import 'package:flutter/material.dart';
import 'data.dart';
import 'news_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Gotham',
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          subtitle1: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          bodyText1: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          bodyText2: TextStyle(
            fontWeight: FontWeight.w200,
            color: Colors.black,
          ),
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  Animation<Offset> animation;
  Animation<double> scaleAnimation;
  AnimationController controller;

  @override
  void initState() {
    Data.addListener(update);
    controller = AnimationController(duration: const Duration(milliseconds: 180), vsync: this);
    animation = Tween<Offset>(begin: Offset(0.0, -0.13), end: Offset.zero).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ))..addListener(update);
    scaleAnimation = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  update() => {if(mounted) setState((){})};

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //App Bar
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Text('NewsByte', style: Theme.of(context).textTheme.headline1),
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () {
                          controller.forward();
                        },
                        child: Icon(Icons.search_rounded, size: 40)
                      )
                    ],
                  ),
                ),
                // Title & Filters
                SizeTransition(
                    sizeFactor: scaleAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text("Trending", style: Theme.of(context).textTheme.headline2),
                        ),
                        //Filters
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 8),
                          child: Container(
                            height: 22,
                            child: ListView(
                              padding: EdgeInsets.only(left: 15.0),
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              children: Data.availableTags.map((e) => Container(
                                padding: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 4,
                                      blurRadius: 40
                                    )
                                  ]
                                ),
                                child: FilterChip(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.only(bottom: 9, left: 10, right: 10),
                                  selected: Data.isSelected(e),
                                  label: Text(e, style: Theme.of(context).textTheme.bodyText2),
                                  onSelected: (s) => Data.tapTag(e, s)
                                ),
                              )).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
                //PUSH DOWN CONTAINER
                //Container(height: animation.value * height),
                //News
                Expanded(
                  flex: 1,
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      NewsCard(),
                      NewsCard(),
                      NewsCard()
                    ],
                  )
                )
              ],
            ),
          ),
          SlideTransition(
            position: animation,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50, bottom: 5),
                  color: Colors.white,
                  height: 110,
                  width: width,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          padding: EdgeInsets.only(left: 8),
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey
                          ),
                          child: TextField(
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16, color: Colors.white),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.only(top: 6),
                              border: InputBorder.none,
                              hintText: 'Search',
                              //hintStyle: TextStyle(color: Colors.white)
                            ),
                            onEditingComplete: () {
                              FocusManager.instance.primaryFocus.unfocus();
                            },
                          )
                        )
                      ),
                      MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          FocusManager.instance.primaryFocus.unfocus();
                          controller.reverse();
                        },
                        child: Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
                      )
                    ],
                  ),
              ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
