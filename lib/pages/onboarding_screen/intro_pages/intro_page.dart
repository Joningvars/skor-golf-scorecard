import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo-smaller.png'),
          const SizedBox(
            height: 70,
          ),
          const Text(
            'Takk fyrir að sækja Skor! Skor er hannað með einfaldleika í huga. Við viljum að þú getir einbeitt þér að því sem skiptir máli - að njóta golfsins. Með Skor getur þú auðveldlega skráð höggin þín og deilt árangri með vinum.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200),
          )
        ],
      ),
    );
  }
}
