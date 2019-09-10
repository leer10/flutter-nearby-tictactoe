class Player {
  String fancyName;
  String deviceID;
  bool isSelf;
  bool isHost;
  bool desireToSpectate;
  Player(
      {this.fancyName,
      this.deviceID,
      this.isSelf = false,
      this.isHost = false});
}
