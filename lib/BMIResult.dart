import 'dart:math';
import 'package:BMICalculator/consts.dart';
import 'package:BMICalculator/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layouts/flutter_layouts.dart';

class BMIResult extends StatelessWidget {
  final double height;
  final double weight;
  final double age;
  final String genre;
  const BMIResult({
    Key key,
    @required this.height,
    @required this.weight,
    @required this.age,
    @required this.genre,
  }) : super(key: key);

  String _getBMIText(double bmi) {
    String bmiText = 'normal';
    bmi = double.parse((bmi).toStringAsFixed(1));
    if (bmi < 18.5) {
      bmiText = 'underweight';
    } else if (18.5 <= bmi && bmi <= 24.9) {
      bmiText = 'normal';
    } else if (25.0 <= bmi && bmi <= 29.9) {
      bmiText = 'overweight';
    } else if (bmi > 30.0) {
      bmiText = 'obesity';
    }

    return bmiText;
  }

  bool _isAdult(double age) {
    return age > 20 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Result'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    double bmi = weight / pow(height / 100, 2);
    var bmiCalc = BMICalc(genre, age);
    var bmiCalcObj = bmiCalc.calcBMIAndPercMetric(weight, height / 100);
    var imgSrc = genre == '1'
        ? './images/male-symbol.png'
        : './images/female-symbol.png';

    return Footer(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("GENRE: "),
                              Image.asset(imgSrc, width: 22, height: 22),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'AGE: ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: age.toStringAsFixed(0),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                TextSpan(text: ' ages '),
                                TextSpan(
                                  text: _isAdult(age)
                                      ? '($ADULT)'
                                      : '($CHILDREN)',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'HEIGHT: ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: '$height',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    )),
                                TextSpan(text: ' cm'),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'WEIGHT: ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: '$weight',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    )),
                                TextSpan(text: ' kg'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Text(
                        "Body Mass Index",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Text(
                        bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: RichText(
                        text: _isAdult(age)
                            ? TextSpan(
                                text: 'This is considered ',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: _getBMIText(bmi),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            : TextSpan(
                                text: bmiCalc.getFinalText(bmiCalcObj),
                                style: TextStyle(color: Colors.black),
                              ),
                      ),
                    ),
                    Container(
                      child: _isAdult(age)
                          ? _buildAdultBMICategories()
                          : _buildChildBMICategories(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      footer: _buildFooter(context),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.all(10),
        color: Colors.deepOrange,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "CALCULATE AGAIN",
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildAdultBMICategories() {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'BMI for $ADULT (ages > 20)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
        ),
        Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              decoration: const BoxDecoration(
                color: Colors.cyan,
              ),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'BMI range - kg/m²',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Underweight'),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('<18.5'),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Normal weight'),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('18.5–24.9'),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Overweight'),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('25–29.9'),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Obesity'),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('BMI of 30 or greater'),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildChildBMICategories() {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'BMI for $CHILDREN (2 < ages < 20)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
        ),
        Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              decoration: const BoxDecoration(
                color: Colors.cyan,
              ),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'BMI range - kg/m²',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Underweight'),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('< 5%'),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Healthy weight'),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('5% - 85%'),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Overweight'),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('85% - 95%'),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Obesity'),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('>= 95%'),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
