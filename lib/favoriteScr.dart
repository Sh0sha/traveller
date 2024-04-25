

// страница избранного
import 'package:flutter/material.dart';
import 'package:traveller/detailElement.dart';

class FavScreen extends StatelessWidget {
  final List<dynamic> favPlaces;
  final Function(dynamic) switchFav;
  final Function(List<dynamic>) obnovaFav;

  FavScreen({required this.favPlaces, required this.switchFav, required this.obnovaFav});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
      ),
      body: ListView.builder(
        itemCount: favPlaces.length,
        itemBuilder: (context, index) {
          final place = favPlaces[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(place['image_url']), // Добавляем изображение места
              ),
              title: Text(
                place['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                place['description'],
                maxLines: 2, // Ограничиваем количество строк описания
                overflow: TextOverflow.ellipsis, // Обрезаем текст, если он не вмещается
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceDetailScr(place: place, switchFav: switchFav),
                  ),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  switchFav(place);
                  obnovaFav(favPlaces.where((item) => item != place).toList());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}