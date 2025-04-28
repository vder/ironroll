import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionDice extends StatelessWidget {
  final int number;

  const ActionDice({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center, // center the text over the dice
      children: [
        SvgPicture.asset(
          'assets/dice-d6-grey.svg', // path to your SVG
          width: 45, // size of the dice
          height: 45,
        ),
        Positioned(
          top: 8,
          left: 12,
          child: Text(
            "$number",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // or white, depending on your dice
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.white.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
