import 'package:flutter/material.dart';
import 'package:maymysound/utils/appColors.dart';

import 'appTestStyle.dart';

class Constant {



  /// not used this file
  // // Dynamic Text Widget
  // static Widget normal(
  //   String text, {
  //   double fontSize = 14,
  //   Color color = Colors.black,
  //   FontWeight fontWeight = FontWeight.normal,
  //   TextAlign textAlign = TextAlign.start,
  //   int? maxLines,
  //   TextOverflow overflow = TextOverflow.ellipsis,
  // }) {
  //   return Text(
  //     text,
  //     textAlign: textAlign,
  //     maxLines: maxLines,
  //     overflow: overflow,
  //     style: TextStyle(
  //       fontSize: fontSize,
  //       color: color,
  //       fontWeight: fontWeight,
  //     ),
  //   );
  // }
  //
  // // Example for a heading
  // static Widget heading(
  //   String text, {
  //   double fontSize = 18,
  //   Color color = Colors.black,
  //   FontWeight fontWeight = FontWeight.bold,
  //   TextAlign textAlign = TextAlign.start,
  // }) {
  //   return Text(
  //     text,
  //     textAlign: textAlign,
  //     style: TextStyle(
  //       fontSize: fontSize,
  //       color: color,
  //       fontWeight: fontWeight,
  //     ),
  //   );
  // }

  // Dynamic UI Widget
  static Widget sampleApiListTile({name, country, id, employeeCount}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.gradientBtn,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: ListTile(
        title: Text("${name}name" ?? "N/A"),
        subtitle: Text(country ?? "N/A"),
        leading: id != null ? Text(id.toString()) : null,
        trailing: employeeCount != null ? Text(employeeCount.toString()) : null,

      ),
    );
  }

  // static Widget btnLinearGradient({name}){
  //   return Container(
  //     height: 52,width: double.infinity,
  //     decoration: const BoxDecoration(
  //       gradient: AppColors.gradientPrimary,
  //       borderRadius: BorderRadius.all(Radius.circular(96)),
  //       ),
  //     child: Center(
  //       child: Text(name ?? "N/A", style: AppTextStyles.medium18),
  //     ),
  //   );
  // }


  static Widget btnLinearGradient({
    required String name,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 52,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.gradientBtn,
        borderRadius: BorderRadius.all(Radius.circular(96)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(96),
          onTap: onTap,
          child: Center(
            child: Text(
              name,
              style: AppTextStyles.medium18.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

}
