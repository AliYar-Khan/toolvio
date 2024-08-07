import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContainedTextFieldWithButton extends StatelessWidget {
  const ContainedTextFieldWithButton({
    super.key,
    required this.widthScreen,
    required this.title,
    required this.maxLines,
    required this.hintText,
    required this.c1,
    required this.c2,
    required this.onTap,
  });

  final double widthScreen;
  final String title;
  final int maxLines;
  final String hintText;
  final TextEditingController c1;
  final TextEditingController c2;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 35, right: 35),
      child: Container(
        height: maxLines > 1 ? 150 : 80,
        decoration: const BoxDecoration(
          color: Color(0xFFEDEDED),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                        textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    )),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: widthScreen * 0.75,
                  height: 2,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: (widthScreen * 0.80) / 2,
                  height: maxLines > 1 ? 90 : 40,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.only(left: 5),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: TextField(
                    controller: c1,
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: GoogleFonts.spaceGrotesk(
                        textStyle: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: (widthScreen * 0.80) / 4,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.only(left: 5, bottom: 5),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: TextField(
                    controller: c2,
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          hintText == AppLocalizations.of(context)!.materials
                              ? AppLocalizations.of(context)!.quantity
                              : '',
                      hintStyle: GoogleFonts.spaceGrotesk(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    width: 35,
                    height: 35,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00B3FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      "+",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
