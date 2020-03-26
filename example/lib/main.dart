import 'package:flutter/material.dart';
import 'custom_container_example.dart';
import 'custom_param_example.dart';
import 'simple_example.dart';

void main() => runApp(MaterialApp(
  title: 'Named Routes Demo',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    '/': (context) => MainApp(),
    '/simple': (context) => SimpleExample(),
    '/custom_param': (context) => CustomParamExample(),
    '/custom_container': (context) => CustomContainerExample(),
  },
));

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Simple Calendar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/simple');
              },
              child: Text('Simple Exsample'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/custom_param');
              },
              child: Text('Custom Param Exsample'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/custom_container');
              },
              child: Text('Custom Container Exsample'),
            ),
          ],
        ),
      ),
    );
  }
}
