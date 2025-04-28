import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChallengeDice extends StatelessWidget {
  final int number;
  final bool isHit;

  const ChallengeDice({super.key, required this.number, this.isHit = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center, // center the text over the dice
        children: [
          SvgPicture.asset(
            'assets/dice-d10-grey.svg', // path to your SVG
            width: 60, // size of the dice
            height: 60,
          ),
          Positioned(
            top: 7,
            child: Text(
              "$number",
              style: TextStyle(
                fontSize: 16,
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
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(
              (isHit)
                  ? 'assets/answer-yes.svg'
                  : 'assets/answer-no.svg', // path to your SVG
              width: 35, // size of the hit icon
              height: 35,
            ),
          ),
        ],
      ),
    );
  }
}
