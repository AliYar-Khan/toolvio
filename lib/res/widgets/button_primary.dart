import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary(
      {super.key,
      required this.screenWidth,
      required this.onTap,
      required this.text,
      required this.image,
      required this.mainAxisAlignment,
      required this.color,
      required this.loading});

  final double screenWidth;
  final void Function()? onTap;
  final String text;
  final ImageProvider<Object>? image;
  final MainAxisAlignment mainAxisAlignment;
  final Color color;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        width: screenWidth * 0.8,
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: (mainAxisAlignment == MainAxisAlignment.spaceBetween)
                    ? 15
                    : 0,
              ),
              child: !loading
                  ? Text(
                      text,
                      style: GoogleFonts.spaceGrotesk(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : const CupertinoActivityIndicator(
                      color: Colors.white,
                    ),
            ),
            image != null
                ? Padding(
                    padding: EdgeInsets.only(
                      right: (mainAxisAlignment ==
                              MainAxisAlignment.spaceBetween)
                          ? text == AppLocalizations.of(context)!.todayTasks ||
                                  text ==
                                      AppLocalizations.of(context)!
                                          .yesterdayTasks
                              ? 25
                              : 15
                          : 0,
                    ),
                    child: Image(
                      image: image ?? const AssetImage("assets/icons/logo"),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
