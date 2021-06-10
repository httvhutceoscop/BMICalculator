import 'dart:core';
import 'dart:math';

import 'package:BMICalculator/consts.dart';

class BMICalc {
  // https://www.nhs.uk/live-well/healthy-weight/bmi-calculator/
  // https://www.cdc.gov/healthyweight/bmi/widget/calculator.html
  String sex; // '1' - male, '2' - female
  double age;
  double agem;

  BMICalc(this.sex, this.age) {
    this.agem = this.age * 12; // Need to plus month
  }

  calcBMIAndPercMetric(double kgs, double meters) {
    var calcBMIObj = {
      'bmi': -1.0,
      'z_perc': -1,
      'overP95': null,
    };

    // bmi
    double bmi = kgs / (meters * meters);
    calcBMIObj['bmi'] = (bmi * 10.0).roundToDouble() / 10.0;

    BMI_AGE_REV.forEach((data) {
      double dataAgemos = double.parse(data['Agemos']);

      if (data['Sex'] == sex && (this.agem + 0.5 == dataAgemos)) {
        double L = double.parse(data['L']);
        double M = double.parse(data['M']);
        double S = double.parse(data['S']);

        // median
        calcBMIObj['M'] = M;

        // bmi_z calc
        double bmiZ = (pow(bmi / M, L) - 1) / (S * L);

        // percentile calc
        var zPercNotRounded = getZPercent(bmiZ) * 100;
        var zPerc = zPercNotRounded.round();
        calcBMIObj['z_perc'] = zPerc;

        // over 97
        if (zPercNotRounded > 97) {
          // data from bmiagerev table
          double p95 = double.parse(data['P95']);

          // calculate over perc
          double overP95 = (100 * bmi / p95).roundToDouble();

          calcBMIObj['overP95'] = overP95;
        }
        return calcBMIObj;
      }
    });

    return calcBMIObj;
  }

  calcMBIAndPercEnglish(double lbs, double inches) {
    return calcBMIAndPercMetric(lbs * 0.453592, inches * 0.0254);
  }

  double getZPercent(double z) {
    /*
      z == number of standard deviations from the mean

      if z is greater than 6.5 standard deviations from the mean the
      number of significant digits will be outside of a reasonable range
    */
    if (z < -6.5) {
      return 0.0;
    }

    if (z > 6.5) {
      return 1.0;
    }

    var factK = 1.0;
    var sum = 0.0;
    var term = 1.0;
    var k = 0;
    var loopStop = exp(-23);

    while (term.abs() > loopStop) {
      term =
          (((0.3989422804 * pow(-1, k) * pow(z, k)) / (2 * k + 1) / pow(2, k)) *
                  pow(z, k + 1)) /
              factK;
      sum += term;
      k++;
      factK *= k;
    }

    sum += 0.5;

    return sum;
  }

  String getFinalText(bmiCalcObj) {
    var bmi = bmiCalcObj['bmi'];
    var zPercentile = bmiCalcObj['z_perc'];
    var gender = sex == '1' ? 'boy' : 'girl';
    var bmiPercentile = getOrdinalIndicator(zPercentile);
    var domYears = age.toStringAsFixed(0);
    var bmiConclusion = getBMIConclusion(zPercentile);
    var bmiText = getBMIText(zPercentile);
    return 'Based on the height and weight entered, the BMI is $bmi, placing the BMI-for-age at $bmiPercentile percentile for $gender aged $domYears years. This child $bmiConclusion $bmiText';
  }

  String getBMIConclusion(int zPercentile) {
    if (zPercentile < 5) {
      return 'is underweight';
    } else if (5 <= zPercentile && zPercentile < 85) {
      return 'has healthy weight';
    } else if (85 <= zPercentile && zPercentile < 95) {
      return 'is overweight';
    } else if (zPercentile >= 95) {
      return 'has obesity';
    }
    return '';
  }

  String getBMIText(int zPercentile) {
    if (zPercentile < 5) {
      return " and should be seen by a healthcare provider for further assessment to determine possible causes of underweight";
    } else if (5 <= zPercentile && zPercentile < 85) {
      return "";
    } else if (85 <= zPercentile && zPercentile < 95) {
      return "";
    } else if (zPercentile >= 95) {
      var tempRetTxt = " and may have weight-related health problems. ";
      var tempGend = "He";
      if (sex == "2") {
        tempGend = "She";
      }
      tempRetTxt += tempGend;
      tempRetTxt +=
          " should be seen by a healthcare provider for further assessment";

      return tempRetTxt;
    }
    return '';
  }

  String getOrdinalIndicator(int zPercentile) {
    // ref: https://stackoverflow.com/questions/54254516/how-can-we-use-superscript-and-subscript-text-in-flutter-text-or-richtext
    // var z = double.parse(zPercentile).toStringAsFixed(0);
    switch (zPercentile) {
      case 0:
        return 'less than the 1\u02e2\u1d57 ';
        break;
      case 100:
        return 'greater than the 99\u1d57\u02b0 ';
        break;
      case 1:
        return 'the $zPercentile\u02e2\u1d57'; // st
        break;
      case 2:
        return 'the $zPercentile\u207f\u1d48'; // nd
        break;
      case 3:
        return 'the $zPercentile\u02b3\u1d48'; // rd
        break;
      default:
        return 'the $zPercentile\u1d57\u02b0'; // th
    }
  }

  String checkDataPotentialError(bmiCalcObj) {
    var ratio = bmiCalcObj['bmi'] / bmiCalcObj['M'];
    var isOver = bmiCalcObj['overP95'] != null && bmiCalcObj['overP95'] >= 150;
    if (ratio < 0.7 || isOver) {
      return '❗ This child or teenager has a BMI that is very far from the healthy weight range. Please check the accuracy of the information you entered. If the age, weight, and height values are correct, the following shows the calculated values for this child.';
    }
    return '';
  }
}
