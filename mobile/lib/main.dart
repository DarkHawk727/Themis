import 'package:flutter/material.dart';
import 'news_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  Icon(Icons.search, size: 40)
                ],
              ),
            ),
            // Trending
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text("Trending", style: Theme.of(context).textTheme.headline2),
            ),
            //Filters
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 8),
              child: Container(
                height: 30,
                child: ListView(
                  padding: EdgeInsets.only(left: 15.0),
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                    'Elections',
                    'Federal',
                    'Environment',
                    'Debates'
                  ].map((e) => Container(
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
                      label: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(e),
                      ), 
                      onSelected: (_){}
                    ),
                  )).toList(),
                ),
              ),
            ),
            //News
            Expanded(
              flex: 1,
              child: PageView(
                scrollDirection: Axis.horizontal,
                //padding: EdgeInsets.only(left: 15.0),
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
    );
  }
}
