import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minigames/main.dart';
import 'package:minigames/classes/NearbyClasses.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:minigames/proto/serializablePlayer.pb.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OfferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => OffersState(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Player Search"),
            actions: <Widget>[
              _searchButton(),
              _stopButton(),
              IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.pushNamed(context, '/lobby');
                  }),
              IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    Provider.of<GameState>(context)
                        .client
                        .publish("requestPlayerList", "");
                  })
            ],
          ),
          body: OfferPageBody()),
    );
  }
}

class _searchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
        icon: Icon(Icons.search),
        onPressed: () async {
          try {
            bool a = await Nearby().startAdvertising(
              Provider.of<GameState>(context).selfPlayer.fancyName,
              Strategy.P2P_STAR,
              onConnectionInitiated: (String id, ConnectionInfo info) {
                // Called whenever a discoverer requests connection
                print("$id found with ${info.endpointName}");
                connectionRequestPrompt(id, info, context);
              },
              onConnectionResult: (String id, Status status) {
                print("Connection result! Connection with $id was $status");
                switch (status) {
                  case Status.CONNECTED:
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Connection with device $id ${Provider.of<GameState>(context).PlayerList.firstWhere((player) => player.deviceID == id).fancyName} made!")));
                    Provider.of<GameState>(context).connectWithClient(id);
                    break;
                  case Status.REJECTED:
                    Navigator.popUntil(
                        context, ModalRoute.withName('/welcome/offer'));
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("$id refused to connect with you!")));
                    Provider.of<GameState>(context)
                        .removePlayerbyID(deviceID: id);
                    break;
                  case Status.ERROR:
                    Navigator.popUntil(
                        context, ModalRoute.withName('/welcome/offer'));
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Error with $id!")));
                    Provider.of<GameState>(context)
                        .removePlayerbyID(deviceID: id);
                    break;
                }
                // Called when connection is accepted/rejected
              },
              onDisconnected: (String id) {
                // Callled whenever a discoverer disconnects from advertiser
              },
            );
            //print("start advertising");
            Provider.of<OffersState>(context).searchingChange(true);
          } catch (exception) {
            // platform exceptions like unable to start bluetooth or
            // insufficient permissions
            print(exception);
          }
        });
  }
}

class _stopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () async {
          await Nearby().stopAdvertising();
          Provider.of<OffersState>(context).searchingChange(false);
        });
  }
}

class OffersState with ChangeNotifier {
  bool isSearching = false;
  void searchingChange(bool state) {
    isSearching = state;
    notifyListeners();
  }
}

class OfferPageBody extends StatefulWidget {
  @override
  _OfferPageBodyState createState() => _OfferPageBodyState();
}

class _OfferPageBodyState extends State<OfferPageBody> {
  _OfferPageBodyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        if (Provider.of<OffersState>(context).isSearching == true) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Searching for players", textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          Divider()
        ] else ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Not searching", textAlign: TextAlign.center),
          ),
          Divider()
        ],
        Expanded(
          child: WatchBoxBuilder(
              box: Hive.box('players'),
              builder: (context, box) {
                return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (BuildContext context, int index) {
                      SerializablePlayer playerInstance =
                          SerializablePlayer.fromBuffer(box.getAt(index));
                      return ListTile(
                        title: Text(playerInstance.fancyName),
                        subtitle: Text(playerInstance.id),
                      );
                    });
              }),
        )
      ]),
    );
  }
}

void connectionRequestPrompt(
    String id, ConnectionInfo info, BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${info.endpointName} wants in!",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                          color: Colors.red,
                          child: Text("REJECT"),
                          onPressed: () async {
                            Navigator.pop(context);
                            try {
                              await Nearby().rejectConnection(id);
                            } catch (exception) {
                              print(exception);
                            }
                          }),
                      RaisedButton(
                          color: Colors.green,
                          child: Text("ACCEPT"),
                          onPressed: () {
                            Provider.of<GameState>(context).addPlayer(
                                deviceID: id,
                                fancyName: info.endpointName,
                                isHost: false);
                            Navigator.pop(context);
                            Nearby().acceptConnection(
                              id,
                              onPayLoadRecieved: (endid, payload) {
                                print(endid +
                                    ": " +
                                    String.fromCharCodes(payload.bytes));
                                NearbyStream(endid).receive(payload.bytes);
                              },
                            );
                          }),
                    ])
              ]),
        );
      });
}
