import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContainedTextField extends StatelessWidget {
  const ContainedTextField(
      {super.key,
      required this.controller,
      required this.widthScreen,
      required this.title,
      required this.maxLines,
      required this.onPress,
      required this.value});
  final TextEditingController? controller;
  final double widthScreen;
  final String title;
  final int maxLines;
  final void Function()? onPress;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 35, right: 35),
      child: Container(
        width: widthScreen * 0.90,
        height: maxLines > 1 ? 150 : 75,
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
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: widthScreen * 0.75,
                  height: 2,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                ),
              ],
            ),
            InkWell(
              onTap: onPress,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: widthScreen * 0.75,
                    height: maxLines > 1 ? 90 : 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    child: title !=
                                AppLocalizations.of(context)!
                                    .plannedStarttime &&
                            title !=
                                AppLocalizations.of(context)!.plannedEndtime &&
                            title !=
                                AppLocalizations.of(context)!.plannedDuration
                        ? TextField(
                            controller: controller,
                            maxLines: maxLines,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5.0),
                            ),
                          )
                        : Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  value,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.spaceGrotesk(
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
