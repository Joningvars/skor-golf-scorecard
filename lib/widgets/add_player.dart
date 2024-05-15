// import 'package:flutter/material.dart';
// import 'package:score_card/models/course.dart';
// import 'package:score_card/models/player.dart';
// import 'package:score_card/pages/add_player_screen.dart';

// class AddPlayer extends StatefulWidget {
//   final List<Player>? players;
//   final void Function(Player) onAddPlayer;
//   GolfCourse course;

//   AddPlayer({
//     Key? key,
//     this.players,
//     required this.onAddPlayer,
//     required this.course,
//   }) : super(key: key);

//   @override
//   _AddPlayerState createState() => _AddPlayerState();
// }

// class _AddPlayerState extends State<AddPlayer> {
//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool hasPlayers = widget.players != null && widget.players!.isNotEmpty;

//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => AddPlayerScreen(
//                     course: widget.course,
//                     onAddPlayer: ,
//                   )),
//         );
//       },
//       child: Container(
//         height: 65,
//         width: 65,
//         decoration: BoxDecoration(
//           color: const Color(0XFF3270A2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: hasPlayers
//               ? Text(
//                   _controller.text.toUpperCase(),
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 )
//               : Icon(
//                   Icons.add,
//                   color: Colors.white,
//                 ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
