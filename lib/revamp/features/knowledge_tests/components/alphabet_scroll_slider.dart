import 'package:ecoach/revamp/features/knowledge_tests/controllers/knowledge_test_controller.dart';
import 'package:flutter/material.dart';

class AlphabetScrollSlider extends StatefulWidget {
  const AlphabetScrollSlider(
      {Key? key, required this.callback, this.selectedAlphabet = "P"})
      : super(key: key);
  final Function(String selectedAlphabet) callback;
  final String selectedAlphabet;

  @override
  State<AlphabetScrollSlider> createState() => _AlphabetScrollSliderState();
}

class _AlphabetScrollSliderState extends State<AlphabetScrollSlider> {
  List<String> alphaScrollSliderLabels = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  late double selectedAlphaScrollValue;
  late double max;
  late int divisions;

  double min = 0;

  @override
  void initState() {
    super.initState();
    selectedAlphaScrollValue =
        alphaScrollSliderLabels.indexOf(widget.selectedAlphabet).toDouble();
    max = alphaScrollSliderLabels.length - 1;
    divisions = alphaScrollSliderLabels.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.maxFinite,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            left: 20,
            right: 20,
            child: Container(
              margin: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...alphaScrollSliderLabels.map((alphabetLabel) {
                    int index = alphaScrollSliderLabels.indexOf(alphabetLabel);

                    bool isLastAlphabet = index == max;
                    bool isSelectedAlphabet = selectedAlphaScrollValue == index;

                    if (isSelectedAlphabet) {
                      widget.callback(alphabetLabel);
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        right: isLastAlphabet ? 0 : 0,
                      ),
                      child: Text(
                        alphabetLabel,
                        style: TextStyle(
                          fontSize: isSelectedAlphabet ? 16 : 10,
                          color: Color(0xFF0367B4).withOpacity(
                            isSelectedAlphabet ? 1 : 0.4,
                          ),
                          fontWeight: isSelectedAlphabet
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Color(0xFF0367B4),
                inactiveTrackColor: Color(0xFF0367B4),
                inactiveTickMarkColor: Colors.transparent,
                activeTickMarkColor: Colors.transparent,
                overlayColor: Colors.transparent,
                thumbColor: Color(0xFF0367B4),
                thumbShape: CustomSliderThumbCircle(
                  thumbRadius: 10,
                  max: selectedAlphaScrollValue.toInt(),
                  elevation: 4.0,
                ),
                trackHeight: 10,
              ),
              child: Slider(
                value: selectedAlphaScrollValue,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: (value) {
                  setState(() {
                    selectedAlphaScrollValue = value.roundToDouble();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
