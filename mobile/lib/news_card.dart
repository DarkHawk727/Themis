import 'package:flutter/material.dart';
import 'data.dart';
import 'news_page.dart';

class NewsCard extends StatefulWidget {
  const NewsCard(this.news, {Key key }) : super(key: key);
  final News news;

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  initState() {
    getDarkStatus();
    super.initState();
  }

  getDarkStatus() async {
    await this.widget.news.getAvgColor();
    if(mounted)
    setState(() {});
  }

  isDark() {
    if(!this.widget.news.avgColor.containsKey('bottomThird')) return true;
    Color clr = this.widget.news.avgColor['bottomThird'];
    print(clr.blue);
    double avg = (clr.blue + clr.red + clr.green).toDouble();
    //print(avg);
    return avg < 50;
  }
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => NewsPage(this.widget.news)));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: NetworkImage(this.widget.news.image),
              fit: BoxFit.cover
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 5,
                blurRadius: 40
              )
            ]
          ),
          width: width - 55,
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container()),
                Text(this.widget.news.headline, style: Theme.of(context).textTheme.headline3.copyWith(color: isDark() ? Colors.white : Colors.black)) 
              ]
            ),
          ),
        ),
      ),
    );
  }
}