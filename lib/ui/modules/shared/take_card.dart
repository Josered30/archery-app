import 'package:flutter/material.dart';

class TakeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function() onTap;

  const TakeCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle cardTitleStyle = TextStyle(color: Colors.grey[900], fontSize: 16);
    TextStyle cardTextStyle = TextStyle(color: Colors.grey[800], fontSize: 14);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: cardTitleStyle,
                ),
                Text(
                  subtitle,
                  style: cardTextStyle,
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  'assets/target.png',
                  width: 50,
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
