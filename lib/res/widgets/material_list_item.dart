import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialListItem extends StatelessWidget {
  const MaterialListItem({
    super.key,
    required this.name,
    required this.quantiy,
    required this.showWhiteLine,
  });

  final String name;
  final int quantiy;
  final bool showWhiteLine;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                "${quantiy}x",
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        showWhiteLine
            ? Container(
                width: widthScreen,
                height: 1,
                color: Colors.white,
              )
            : const SizedBox(),
      ],
    );
  }
}
