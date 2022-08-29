import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/treadmill/treadmill_question_count.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/mode_selector.dart';
import 'package:flutter/material.dart';

class TreadmillBankMenu extends StatefulWidget {
  TreadmillBankMenu({
    this.banks = const [],
    required this.controller,
  });

  final TreadmillController controller;
  final List<TestNameAndCount> banks;

  @override
  State<TreadmillBankMenu> createState() => _TreadmillBankMenuState();
}

class _TreadmillBankMenuState extends State<TreadmillBankMenu> {
  late dynamic bank;
  late TreadmillController controller;

  @override
  void initState() {
    bank = '';
    controller = widget.controller;
    super.initState();
  }

  handleSelection(newBank) {
    setState(() {
      if (bank == newBank.id)
        bank = '';
      else {
        bank = newBank.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(height: 70),
            Text(
              'Select Your Bank',
              textAlign: TextAlign.center,
              style: kIntroitScreenHeadingStyle(
                color: kAdeoLightTeal,
              ).copyWith(
                fontSize: 25,
              ),
            ),
            SizedBox(height: 33),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      for (int i = 0; i < widget.banks.length; i++)
                        SubModeSelector(
                          id: widget.banks[i].id!,
                          numberOfQuestions: widget.banks[i].totalCount,
                          label: widget.banks[i].name,
                          isSelected:
                              bank != '' && bank.id == widget.banks[i].id!,
                          isUnselected:
                              bank != '' && bank.id != widget.banks[i].id!,
                          selectedBorderColor: kAdeoLightTeal,
                          onTap: (id) => {handleSelection(widget.banks[i])},
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (bank != '')
              Column(
                children: [
                  AdeoFilledButton(
                    label: 'Next',
                    background: kAdeoLightTeal,
                    size: Sizes.large,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TreadmillQuestionCount(
                              bankId: bank,
                              bankName: bank.name,
                              count: bank.totalCount,
                              controller: controller,
                              mode: TreadmillMode.BANK,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 53),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
