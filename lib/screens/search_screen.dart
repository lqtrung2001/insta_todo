import 'package:flutter/material.dart';
import 'package:insta_todo/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_todo/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user',
          ),
          onFieldSubmitted: (String _) {
            if (searchController.text.isNotEmpty) {
              setState(() {
                isShowUser = true;
              });
            } else {
              setState(() {
                isShowUser = false;
              });
            }
            print(_);
            print(isShowUser);
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=1200&quality=85&auto=format&fit=max&s=a52bbe202f57ac0f5ff7f47166906403'),
                        radius: 16,
                      ),
                      title: Text(
                        'username',
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              builder: (context, snapshot) {
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: 10,
                  itemBuilder: (context, index) => Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/800px-Image_created_with_a_mobile_phone.png',
                    fit: BoxFit.cover,
                  ),
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          600
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
