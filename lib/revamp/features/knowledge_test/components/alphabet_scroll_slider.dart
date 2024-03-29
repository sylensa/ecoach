import 'package:ecoach/revamp/features/knowledge_test/controllers/knowledge_test_controller.dart';
import 'package:flutter/material.dart';

class AlphabetScrollSlider extends StatefulWidget {
  const AlphabetScrollSlider({
    Key? key,
    required this.callback,
    required this.alphabets,
    this.initialSelectedAlphabet = "P",
  }) : super(key: key);
  final Function(String initialSelectedAlphabet, int index, bool isValueChanged)
      callback;
  final String initialSelectedAlphabet;
  final List<String> alphabets;

  @override
  State<AlphabetScrollSlider> createState() => _AlphabetScrollSliderState();
}

class _AlphabetScrollSliderState extends State<AlphabetScrollSlider> {
  late List<String> alphaScrollSliderLabels;
  late double selectedAlphaScrollValue;
  late double max;
  late int divisions;
  late bool isSelectedAlphabet;
  late bool isValueChanged;
  late int index;
  late String label;

  double min = 0;

  @override
  void initState() {
    super.initState();
    alphaScrollSliderLabels = widget.alphabets;
    selectedAlphaScrollValue = alphaScrollSliderLabels
        .indexOf(widget.initialSelectedAlphabet)
        .toDouble();
    max = alphaScrollSliderLabels.length - 1;
    divisions = alphaScrollSliderLabels.length - 1;
    isValueChanged = false;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // height: 60,
      // width: double.maxFinite,
      aspectRatio: 19/3.1,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            left: 20,
            right: 20,
            child: Container(
              margin: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...alphaScrollSliderLabels.map((alphabetLabel) {
                    label = alphabetLabel;
                    index = alphaScrollSliderLabels.indexOf(alphabetLabel);
                    bool isLastAlphabet = index == max;
                    isSelectedAlphabet = selectedAlphaScrollValue == index;
                    if (selectedAlphaScrollValue == index) {
                      widget.callback(label, index, isValueChanged);
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                        right: isLastAlphabet ? 0 : 12,
                      ),
                      child: Text(
                        alphabetLabel,
                        style: TextStyle(
                          fontSize: isSelectedAlphabet ? 20 : 14,
                          color: Color(0xFF0367B4)
                              .withOpacity(isSelectedAlphabet ? 1 : 0.8),
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
                onChangeStart: ((value) {
                  isValueChanged = false;
                  // setState(() {});
                }),
                onChangeEnd: ((newValue) {
                  isValueChanged = true;
                  setState(() {});
                }),
                onChanged: (newValue) {
                  selectedAlphaScrollValue = newValue.roundToDouble();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
