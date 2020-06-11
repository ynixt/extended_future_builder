import 'package:example/home/user.dart';
import 'package:extended_future_builder/extended_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:example/home/home_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeService = HomeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: ExtendedFutureBuilder<List<User>>(
        futureResponseBuilder: () => homeService.getUsers(),
        errorBuilder: (BuildContext context, error) {
          return Center(
            child: Text('An error has occurred. Tap to try again.'),
          );
        },
        successBuilder: (BuildContext context, List<User> users) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('id'),
                    ),
                    Expanded(
                      child: Text('name'),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (BuildContext context, int index) {
                        var user = users[index];
                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('${user.id}'),
                            ),
                            Expanded(
                              child: Text('${user.name}'),
                            ),
                          ],
                        );
                      }),
                ),
                Text('Thanks to https://jsonplaceholder.typicode.com'),
              ],
            ),
          );
        },
      ),
    );
  }
}
