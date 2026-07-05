import 'dart:html' as html;
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicRoom(),
    );
  }
}

class MusicRoom extends StatefulWidget {
  const MusicRoom({super.key});
  @override
  State<MusicRoom> createState() => _MusicRoomState();
}

class _MusicRoomState extends State<MusicRoom> {
  final searchCtrl = TextEditingController();
  List songs = [];

  late YoutubePlayerController ytController;
  late IO.Socket socket;

  String roomId = "";
  Timer? syncTimer;

  String getRoomFromUrl() {
    final uri = Uri.parse(html.window.location.href);
    return uri.queryParameters['room'] ?? "";
  }

  String generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return String.fromCharCodes(
      Iterable.generate(5, (_) => chars.codeUnitAt(rand.nextInt(chars.length))),
    );
  }

  @override
  void initState() {
    super.initState();

    roomId = getRoomFromUrl();
    if (roomId.isEmpty) {
      roomId = generateRoomCode();
      html.window.history.pushState(null, '', '/?room=$roomId');
    }

    ytController = YoutubePlayerController(
      params: const YoutubePlayerParams(showControls: true),
    );

    socket = IO.io(
      'https://ghochu.onrender.com',
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.onConnect((_) => socket.emit("join_room", roomId));

    socket.on("sync_play", (data) {
      ytController.loadVideoById(videoId: data['videoId']);
      ytController.playVideo();
    });

    socket.on("sync_pause", (_) => ytController.pauseVideo());

    socket.on("room_state", (data) {
      ytController.loadVideoById(videoId: data['videoId']);
      ytController.seekTo(seconds: data['timestamp'].toDouble());
      if (data['isPlaying']) ytController.playVideo();
    });

    socket.on("sync_time", (data) async {
      final other = data['timestamp'];
      final current = (await ytController.currentTime).floor();
      if ((current - other).abs() > 1) {
        ytController.seekTo(seconds: other.toDouble());
      }
    });

    syncTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (await ytController.playerState == PlayerState.playing) {
        final pos = (await ytController.currentTime).floor();
        socket.emit("time_update", {"roomId": roomId, "timestamp": pos});
      }
    });
  }

  Future searchSongs(String q) async {
    final res =
        await http.get(Uri.parse("https://ghochu.onrender.com/search?q=$q"));
    setState(() => songs = jsonDecode(res.body));
  }

  void playSong(String id) {
    socket.emit("play_song", {"roomId": roomId, "videoId": id, "timestamp": 0});
  }

  @override
  void dispose() {
    syncTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🎬 Local Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // 🌫 Soft Blur + Dark Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: Colors.black.withOpacity(0.35),
              ),
            ),
          ),

          // 🎵 App UI
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Sync Music Room",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Room Code: $roomId",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: searchCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search song",
                      hintStyle: const TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: searchSongs,
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (c, i) {
                      final s = songs[i];
                      return ListTile(
                        leading: Image.network(s['thumbnail']),
                        title: Text(
                          s['title'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () => playSong(s['videoId']),
                      );
                    },
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: SizedBox(
                    height: 300,
                    child: YoutubePlayer(controller: ytController),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}