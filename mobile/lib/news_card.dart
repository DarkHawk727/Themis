import 'package:flutter/material.dart';
import 'news_page.dart';

class NewsCard extends StatefulWidget {
  const NewsCard({ Key key }) : super(key: key);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => NewsPage()));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: NetworkImage('https://smartcdn.prod.postmedia.digital/nationalpost/wp-content/uploads/2021/06/Anthony-Rota-1-33.png?quality=90&strip=all&w=564&type=webp'),
              fit: BoxFit.cover
            ),
          ),
          width: width - 55,
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container()),
                Text('Car crash in Beverly Hills', style: Theme.of(context).textTheme.headline3) 
              ]
            ),
          ),
        ),
      ),
    );
  }
}