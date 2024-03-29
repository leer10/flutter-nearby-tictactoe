import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';
import 'package:nearby_connections/nearby_connections.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select a Connection"),
        ),
        body: FutureBuilder(
            future: setupBox(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return WelcomePageBody();
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class WelcomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Hey ${Provider.of<GameState>(context).selfPlayer.fancyName}!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          //Text("Do you want to"),
          Container(
              child: Column(children: [
            Text("Android Nearby",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                padding: EdgeInsets.all(18),
                child: Text("OFFER A GAME", style: TextStyle(fontSize: 14)),
                onPressed: () {
                  Nearby().askLocationPermission();
                  print("Offer pressed");
                  Provider.of<GameState>(context).selfPlayer.isHost = true;
                  Provider.of<GameState>(context).initalizeServer();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/welcome/offer', (_) => false);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                padding: EdgeInsets.all(18),
                child: Text("JOIN A GAME", style: TextStyle(fontSize: 14)),
                onPressed: () {
                  Nearby().askLocationPermission();
                  print("Join pressed");
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/welcome/join', (_) => false);
                },
              ),
            )
          ])),
        ],
      ),
    );
  }
}
