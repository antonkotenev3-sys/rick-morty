import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_morty_test_ex/character_model.dart';

class RickAndMorty extends StatefulWidget {
  const RickAndMorty({super.key});

  @override
  State<RickAndMorty> createState() => _RickAndMortyState();
}

class _RickAndMortyState extends State<RickAndMorty> {
  TextEditingController searchController = TextEditingController();
  List<CharacterModel> characters = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCharacters();
  }

  Future<void> getCharacters() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body)['results'];
      setState(() {
        characters = results
            .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });
      print(characters);
    }
    setState(() {
      isLoading = false;
    });

    // Simulate fetching characters
  }

  Future<void> searchCharacters(String name) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character/?name=$name'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body)['results'];
      setState(() {
        characters = results
            .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });
      print(characters);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rick and Morty'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      print('hello');
                      searchCharacters(searchController.text);
                    },
                    onFieldSubmitted: (value) {
                      searchCharacters(searchController.text);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    searchCharacters(searchController.text);
                  },
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    searchController.clear();
                    getCharacters();
                  },
                  icon: Icon(Icons.clear),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 4,
                          bottom: 4,
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text(characters[index].name),
                            subtitle: Text(characters[index].originModel.name),
                            leading: Image.network(characters[index].image),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
