import 'package:http/http.dart' as http;
import 'dart:convert';


// главное окно и бовокая менюха
import 'package:flutter/material.dart';
import 'package:traveller/detailElement.dart';
import 'package:traveller/favoriteScr.dart';

class TravelGuide extends StatefulWidget {
  @override
  _TravelGuideState createState() => _TravelGuideState();
}

class _TravelGuideState extends State<TravelGuide> {
  late Future<List<dynamic>> _placesFuture;
  String _selectedCity = 'Москва'; // Изначально выбран город
  List<dynamic> _favoritePlaces = [];
  String _selectedCategory = ''; // изначальная катег

  @override
  void initState() {
    super.initState();
    _placesFuture = fetchPlaces();
  }

  Future<List<dynamic>> fetchPlaces() async {
    final response = await http.get(
        Uri.parse(
            'https://uvlfpiijmtcpjdunxiwg.supabase.co/rest/v1/places?select=*'),
        headers: {
          'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV2bGZwaWlqbXRjcGpkdW54aXdnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4OTY1MzMsImV4cCI6MjAyOTQ3MjUzM30.xlpxQBJhQhBHBoHeke-hE7CRamMYNmHXGz1dudDp25I',
        });

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('ПУСТО');
    }
  }



  void updateFavorites(List<dynamic> updatedFavorites) { // функци обновления кнопки ибранного
    setState(() {
      _favoritePlaces = updatedFavorites;
    });
  }
  void toggleFavorite(dynamic place) {    // функиця добаления в избранное
    setState(() {
      if (_favoritePlaces.contains(place)) {
        _favoritePlaces.remove(place);
      } else {
        _favoritePlaces.add(place);
      }
    });
  }



  List<dynamic> filterPlaceCity(List<dynamic> places, String city) {
    return places.where((place) => place['city'] == city).toList();
  }

  List<dynamic> filterPlaceCateg(List<dynamic> places, String category) {
    if (category.isEmpty) {
      return places;
    }
    return places.where((place) => place['category'] == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        elevation: 1,
        title: Text('Travelers guide'),

        actions: [ // справа чё - избранное кнопка
          IconButton(
            icon: Icon(Icons.grade_sharp,color: Colors.yellow[700],size: 30,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavScreen(
                    favPlaces: _favoritePlaces,
                    switchFav: toggleFavorite,
                    obnovaFav: updateFavorites, // Передача функции обратного вызова
                  ),
                ),
              );
            },
          ),
        ],
      ),


      // боковая менюха
      drawer: Drawer(
        backgroundColor: Colors.blue[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54.withOpacity(0.3), // Цвет тени
                    spreadRadius: 5,   // Радиус распространения тени
                    blurRadius: 10, // Радиус размытия тени
                    offset: Offset(0, 8),   // Смещение тени по горизонтали и вертикали
                  ),
                ],
              ),
              child: Text(
                "Текущий город:\n$_selectedCity",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    height: 2,
                    fontWeight: FontWeight.w400
                ),
              ),

            ),


            ListTile(
              title: Text('Москва',style: TextStyle( fontSize: 20,height: 3, fontWeight: FontWeight.w300),),
              onTap: () {
                setState(() {
                  _selectedCity = 'Москва';
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text('Санкт-Петербург',style: TextStyle( fontSize: 20,height: 3, fontWeight: FontWeight.w300),),
              onTap: () {
                setState(() {
                  _selectedCity = 'Санкт-Петербург';
                  Navigator.pop(context);
                });
              },
            ),
          ],


        ),
      ),


      // основная бади
      body: FutureBuilder<List<dynamic>>(  // пользовательский интерфейс, который зависит от результата выполнения асинхронной операции
        future: _placesFuture,      // результат выполнения которой будет использоваться для построения  интерфейса
        builder: (context, snapshot) {          //  снапшот - текущее состояние асинхронной операции которая отслеживается FutureBuilder
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());      // индикато р загрузки
          } else if (snapshot.hasError) {
            return Center(child: Text('Oshibka: ${snapshot.error}'));
          } else {
            final places = snapshot.data!;
            final filteredPlaces = filterPlaceCity(places, _selectedCity);
            final categoryFilteredList =
            filterPlaceCateg(filteredPlaces, _selectedCategory);
            return Column(
              children: [
                DropdownButton<String>(   // фильтр
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: <String>['', 'Музей', 'Событие', 'Достопримечательность', 'Место']
                      .map<DropdownMenuItem<String>>((String value) {     // фильтр категории
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                // расширенная часть главной страницы для мест
                Expanded(
                  child: ListView.builder(
                    itemCount: categoryFilteredList.length,   // с учётом фильтра категори
                    itemBuilder: (context, index) {
                      final place = categoryFilteredList[index];
                      final isFavorite = _favoritePlaces.contains(place);

                      return ListTile(

                        leading: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0), // Здесь устанавливается радиус для создания круглой формы
                          ),
                          margin: EdgeInsets.all(0),
                          color: Colors.blue,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.network(
                              place['image_url'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover, // Режим заполнения изображения
                            ),),
                        ),


                        title: Text(place['name']),
                        subtitle: Text(
                          place['description'],
                          maxLines: 2,
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis, // Обрезать текст с добавлением многоточия
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,    // избранное или не избр
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () => toggleFavorite(place),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceDetailScr(place: place, switchFav: toggleFavorite),

                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

