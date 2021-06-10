import 'package:BMICalculator/BMIResult.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layouts/flutter_layouts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        backgroundColor: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'BMI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _add = 'add';
  double _age = 25.0;
  double _height = 172.0; // cm
  double _weight = 60.0; // kg
  String _genre = '1'; // '1': Male, '2': Female
  var textStyle = TextStyle(color: Colors.white, fontSize: 16.0);
  var numberStyle = TextStyle(color: Colors.white, fontSize: 36.0);
  var eleColor = Color.fromRGBO(12, 19, 27, 1);
  var eleBorderRadius = BorderRadius.all(Radius.circular(8));
  var _weightController = TextEditingController();
  var _heightController = TextEditingController();

  void _updateHeight({String operation = ''}) {
    if (_height <= 80 && operation == '') {
      return null;
    }
    setState(() {
      operation == _add ? _height++ : _height--;
    });
    _heightController.text = _height.toStringAsFixed(1);
  }

  void _updateWeight({String operation = ''}) {
    if (_weight <= 10 && operation == '') {
      return null;
    }
    setState(() {
      operation == _add ? _weight++ : _weight--;
    });
    _weightController.text = _weight.toStringAsFixed(1);
  }

  void _goToCalculateBMI() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return BMIResult(
          height: _height,
          weight: _weight,
          age: _age,
          genre: _genre,
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    print('1. initState');
    _weightController.text = _weight.toStringAsFixed(1);
    _heightController.text = _height.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Footer(
      body: ListView(
        children: [
          _buildGenreLayout(),
          _buildSlide(),
          _buildAgeWeight(),
        ],
      ),
      footer: _buildFooter(),
    );
  }

  Widget _buildGenreLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: eleColor,
              border: Border.all(
                  color: Color.fromRGBO(53, 145, 177, 1),
                  width: _genre == '1' ? 3 : 0),
            ),
            height: 150,
            margin: EdgeInsets.all(10),
            child: FlatButton(
              padding: EdgeInsets.all(15),
              onPressed: () => setState(() => _genre = '1'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    './images/male-symbol.png',
                    width: 80,
                    height: 80,
                  ),
                  Text(
                    "MALE",
                    style: textStyle.merge(TextStyle(
                        color: _genre == '1'
                            ? Color.fromRGBO(53, 145, 177, 1)
                            : null)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: eleColor,
              border:
                  Border.all(color: Colors.pink, width: _genre == '2' ? 3 : 0),
            ),
            height: 150,
            margin: EdgeInsets.all(10),
            child: FlatButton(
              padding: EdgeInsets.all(15),
              onPressed: () => setState(() => _genre = '2'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    './images/female-symbol.png',
                    width: 80,
                    height: 80,
                  ),
                  Text(
                    "FEMALE",
                    style: textStyle.merge(
                        TextStyle(color: _genre == '2' ? Colors.pink : null)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlide() {
    return ElementWrapper(
      childWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('AGE', style: textStyle),
          Text(_age.toStringAsFixed(0), style: numberStyle),
          Slider(
            value: _age,
            onChanged: (newHeight) => {
              setState(() => _age = newHeight.roundToDouble()),
            },
            min: 2,
            max: 120,
            label: '$_height',
            activeColor: Colors.deepOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildAgeWeight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: ElementWrapper(
            childWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("HEIGHT", style: textStyle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Container(
                      width: 94.0,
                      child: TextFormField(
                        controller: _heightController,
                        style: numberStyle,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0.0),
                          isDense: true,
                        ),
                        onChanged: (value) {
                          String roundUpDouble =
                              double.parse(value).toStringAsFixed(1);
                          setState(
                            () => {
                              _height = double.parse(roundUpDouble),
                            },
                          );
                        },
                      ),
                    ),
                    Text('cm', style: textStyle),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () => _updateHeight(),
                        color: Colors.deepOrange,
                        child:
                            Icon(Icons.remove, size: 24, color: Colors.white),
                        shape: CircleBorder(),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () => _updateHeight(operation: _add),
                        color: Colors.deepOrange,
                        textColor: Colors.black,
                        child: Icon(Icons.add, size: 24, color: Colors.white),
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ElementWrapper(
            childWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("WEIGHT", style: textStyle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Container(
                      width: 79.0,
                      child: TextFormField(
                        controller: _weightController,
                        // initialValue: "$_weight",
                        style: numberStyle,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0.0),
                          isDense: true,
                        ),
                        onChanged: (value) {
                          String roundUpDouble =
                              double.parse(value).toStringAsFixed(1);
                          setState(
                            () => {
                              _weight = double.parse(roundUpDouble),
                            },
                          );
                        },
                      ),
                    ),
                    Text('kg', style: textStyle),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () => _updateWeight(),
                        color: Colors.deepOrange,
                        child:
                            Icon(Icons.remove, size: 24, color: Colors.white),
                        shape: CircleBorder(),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () => _updateWeight(operation: _add),
                        color: Colors.deepOrange,
                        textColor: Colors.black,
                        child: Icon(Icons.add, size: 24, color: Colors.white),
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.all(10.0),
        color: Colors.deepOrange,
        onPressed: _goToCalculateBMI,
        child: Text("CALCULATE BMI", style: textStyle),
      ),
    );
  }
}

class ElementWrapper extends StatelessWidget {
  final Widget childWidget;
  const ElementWrapper({Key key, this.childWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color.fromRGBO(12, 19, 27, 1),
        border: Border.all(width: 3),
      ),
      height: 150,
      margin: EdgeInsets.all(10),
      child: childWidget,
    );
  }
}
