import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async {
    var data = await http
        .get("http://www.json-generator.com/api/json/get/bYKKPeXRcO?indent=2");
    var jsonData = json.decode(data.body);

    List<User> users = new List();

    for (var us in jsonData) {
      User user = User(us["index"], us["name"], us["about"], us["picture"],
          us["company"], us["email"]);

      users.add(user);
    }
    print("users items is ${users.length}");

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot == null) {
              return Center(
                child: Center(
                  child: Text("loading-------"),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index].name),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data[index].picture +
                                snapshot.data[index].index.toString() +
                                ".jpg"),
                      ),
                      subtitle: Text(snapshot.data[index].email),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    DetailsPage(snapshot.data[index])));
                      },
                    );
                  });
            }
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class User {
  final int index;
  final String name;
  final String about;
  final String picture;
  final String company;
  final String email;

  User(this.index, this.name, this.about, this.picture, this.company,
      this.email);
}

class DetailsPage extends StatelessWidget {
  final User user;

  DetailsPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Container(
        child: Center(
          child: Text(this.user.about),
        ),
      ),
    );
  }
}
