import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDownField<T> extends StatelessWidget {
  const DropDownField(
      {super.key,
      required this.value,
      required this.label,
      required this.widthScreen,
      required this.dropDownMenu,
      required this.onTap});

  final Widget dropDownMenu;
  final double widthScreen;
  final String value;
  final String label;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 35, right: 35),
      child: Container(
        width: widthScreen * 0.90,
        height: 100,
        decoration: const BoxDecoration(
          color: Color(0xFFEDEDED),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    label,
                    style: GoogleFonts.spaceGrotesk(
                        textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    )),
                  ),
                ),
                Container(
                  width: widthScreen * 0.75,
                  height: 2,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  color: const Color(0xFFEDEDED),
                  child: Row(
                    children: [
                      dropDownMenu,
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
