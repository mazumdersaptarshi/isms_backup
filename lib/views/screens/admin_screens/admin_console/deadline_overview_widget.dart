import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeadlineOverviewWidget extends StatelessWidget {
  DeadlineOverviewWidget(
      {super.key,
      required this.day,
      required this.year,
      required this.month,
      required this.courseTitle,
      required this.usersCompliance});

  String day;
  String year;
  String month;
  String usersCompliance;
  String courseTitle;

  @override
  Widget build(BuildContext context) {
    return HoverableSectionContainer(
      cardColor: ThemeConfig.secondaryCardColor,
      onHover: (bool) {},
      child: Row(
        children: [
          Container(
            width: 50,
            height: 80,
            decoration: BoxDecoration(
              color: ThemeConfig.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$month',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      '$day',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      '$year',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            // color: Colors.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$courseTitle',
                  style: TextStyle(fontWeight: FontWeight.bold, color: ThemeConfig.primaryTextColor),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      '${usersCompliance} ',
                      style: TextStyle(color: ThemeConfig.secondaryTextColor),
                    ),
                    Text(
                      AppLocalizations.of(context)!.usersInCompliance,
                      style: TextStyle(
                        color: ThemeConfig.primaryTextColor,
                      ),
                    ),
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    // margin: EdgeInsets.zero,
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.seeWhoNeedsToCompleteRequirements,
                        style: TextStyle(
                          color: ThemeConfig.secondaryTextColor,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: ThemeConfig.secondaryTextColor,
                        size: 16,
                      )
                    ],
                  ),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
