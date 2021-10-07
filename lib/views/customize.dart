import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/pin_input.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Customize extends StatefulWidget {
  const Customize({Key? key}) : super(key: key);

  @override
  _CustomizeState createState() => _CustomizeState();
}

class _CustomizeState extends State<Customize> {
  double containerHeight = 480.0;
  final CarouselController controller = CarouselController();
  int currentSliderIndex = 0;
  String numberOfQuestions = '';
  String duration = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoTaupe,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 20.0),
              Container(
                height: containerHeight,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      left: -36.0,
                      right: -36.0,
                      child: Container(
                        height: containerHeight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/deep_pool_orange_accent.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: containerHeight,
                      child: CarouselSlider(
                        items: [
                          CarouselItem(
                            label: 'Questions',
                            onChanged: (v) {
                              setState(() {
                                numberOfQuestions = v.split('').reversed.join('');
                              });
                              print(numberOfQuestions);
                            },
                          ),
                          CarouselItem(
                            isDuration: true,
                            shouldFocus: currentSliderIndex == 1,
                            label: 'Time',
                            onChanged: (v) {
                              setState(() {
                                duration = v.split('').reversed.join('');
                              });
                              print(duration);
                            },
                          )
                        ],
                        carouselController: controller,
                        options: CarouselOptions(
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentSliderIndex = index;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 44.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentSliderIndex == 1)
                          Row(
                            children: [
                              AdeoOutlinedButton(
                                label: 'Previous',
                                onPressed: () {
                                  controller.previousPage();
                                },
                              ),
                              SizedBox(width: 8.0)
                            ],
                          ),
                        AdeoOutlinedButton(
                          ignoring: currentSliderIndex == 0
                              ? numberOfQuestions.length == 0
                              : duration.length == 0,
                          label: 'Next',
                          onPressed: () {
                            if (currentSliderIndex == 0)
                              controller.nextPage();
                            else {
                              // ignore: todo
                              // TODO: Quaye, this is where you navigate to wherever you wish to
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 56.0),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CarouselItem extends StatefulWidget {
  final String label;
  final onChanged;
  final bool isDuration;
  final bool shouldFocus;

  CarouselItem({
    required this.label,
    this.onChanged,
    this.isDuration = false,
    this.shouldFocus = false,
  });

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem> {
  String leftText = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                color: kDefaultBlack,
                fontSize: 44.0,
              ),
            ),
            Text(
              'Enter your preferred number',
              style: TextStyle(
                color: kDefaultBlack,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: widget.isDuration ? 120.0 : 180.0,
                    child: PinInput(
                      autoFocus: widget.isDuration && widget.shouldFocus,
                      length: widget.isDuration ? 2 : 3,
                      onChanged: widget.isDuration
                          ? (v) {
                              setState(() {
                                leftText = v;
                              });
                            }
                          : widget.onChanged,
                    ),
                  ),
                  if (widget.isDuration)
                    Row(
                      children: [
                        Text(':', style: kPinInputTextStyle),
                        Container(
                          width: 120.0,
                          child: PinInput(
                            autoFocus: leftText.length == 2,
                            length: 2,
                            onChanged: (v) {
                              widget.onChanged('$leftText:$v');
                            },
                          ),
                        )
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
