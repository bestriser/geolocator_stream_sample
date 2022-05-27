import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_stream_sample/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocator Stream Sample',
      builder: BotToastInit(),
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocator Stream Sample'),
      ),
      body: Center(
        child: FutureBuilder(
          future: Location.checkPermission(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (!snapshot.hasData) {
                return const Text("データが見つかりません");
              }
              if (snapshot.data == true) {
                return StreamBuilder(
                  stream: Location.streamCurrentPosition(),
                  builder:
                      (BuildContext context, AsyncSnapshot<Position> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      if (!snapshot.hasData) {
                        return const Text("データが見つかりません");
                      }
                      return Text('${snapshot.data}');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                );
              } else {
                return const Text('位置情報の取得が許可されていません');
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
