
// страница элемента
import 'package:flutter/material.dart';

class PlaceDetailScr extends StatefulWidget {
  final dynamic place;
  final Function(dynamic) switchFav;

  PlaceDetailScr({
    required this.place,
    required this.switchFav,
  });

  @override
  _PlaceDetailScrState createState() => _PlaceDetailScrState();
}

class _PlaceDetailScrState extends State<PlaceDetailScr> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text(widget.place['name'], style: TextStyle(fontWeight: FontWeight.w300),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  widget.place['image_url'],
                  width: double.infinity, //растягиваем на всю ширину
                  height: 400,
                  fit: BoxFit.cover,
                ),
                Positioned( // позиция иконки избр
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: _isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                    color: Colors.red[700],
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      widget.switchFav(widget.place);
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.place['name'],
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${widget.place['description']}',textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Рейтинг: ${widget.place['rating']}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
