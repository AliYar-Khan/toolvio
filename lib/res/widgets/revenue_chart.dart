import 'package:toolivo/view_model/invoicing_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toolivo/models/chart_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toolivo/res/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({
    super.key,
    required this.screenWidth,
    required this.data,
    required this.showDropDown,
    required this.invoiceBy,
  });

  final double screenWidth;
  final List<ChartData> data;
  final bool showDropDown;
  final String invoiceBy;

  @override
  Widget build(BuildContext context) {
    InvoicingViewModel invoicingViewModel =
        Provider.of<InvoicingViewModel>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.81,
            height: 241,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.statistics,
                            style: GoogleFonts.spaceGrotesk(
                              textStyle: const TextStyle(
                                color: Color(0xFF9A9A9A),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.revenueByCustomers,
                            style: GoogleFonts.spaceGrotesk(
                              textStyle: const TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              invoicingViewModel.toggleFilterDropDownOpen();
                            },
                            child: Container(
                              width: 80,
                              // height: 30,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEDF9FF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.5),
                                ),
                              ),
                              child: Center(
                                child: !showDropDown
                                    ? Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            invoiceBy.capitalize(),
                                            style: GoogleFonts.spaceGrotesk(
                                              textStyle: const TextStyle(
                                                color: Color(0xFF000000),
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          Image.asset(
                                            'assets/icons/dropdown_icon.png',
                                            // width: 147,
                                            // height: 112,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              invoicingViewModel.filterHomeData(
                                                  AppLocalizations.of(context)!
                                                      .monthly);
                                              invoicingViewModel
                                                  .toggleFilterDropDownOpen();
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .monthly
                                                  .capitalize(),
                                              style: GoogleFonts.spaceGrotesk(
                                                textStyle: TextStyle(
                                                  color: invoiceBy ==
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .month
                                                      ? Colors.grey[500]
                                                      : const Color(0xFF000000),
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              invoicingViewModel.filterHomeData(
                                                  AppLocalizations.of(context)!
                                                      .weekly);
                                              invoicingViewModel
                                                  .toggleFilterDropDownOpen();
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .weekly
                                                  .capitalize(),
                                              style: GoogleFonts.spaceGrotesk(
                                                textStyle: TextStyle(
                                                  color: invoiceBy ==
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .week
                                                      ? Colors.grey[500]
                                                      : const Color(0xFF000000),
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.70,
                          height: 170,
                          child: SfCartesianChart(
                            primaryXAxis: const CategoryAxis(),
                            primaryYAxis: NumericAxis(
                                minimum: 0,
                                maximum: data.isNotEmpty
                                    ? data
                                            .map((chartData) => chartData.y)
                                            .reduce((a, b) => a > b ? a : b) +
                                        150
                                    : 40,
                                interval: 10),
                            series: <CartesianSeries<ChartData, String>>[
                              ColumnSeries<ChartData, String>(
                                dataSource: data,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.image,
                                  image: AssetImage(
                                    'assets/icons/chart_marker.png',
                                  ),
                                ),
                                name: 'Gold',
                                width: 0.1,
                                color: const Color(0xFFBDEBFF),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
