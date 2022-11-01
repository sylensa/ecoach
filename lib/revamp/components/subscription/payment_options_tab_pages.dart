
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThirdPartyPay extends StatelessWidget {
  const ThirdPartyPay({required this.onPressed, Key? key}) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12,
          ),
          child: Column(
            children: [
              Text(
                'Pay via VISA or Mobile Money',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 48,
                      child: Image.asset(
                        'assets/icons/subscriptions/visa.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 72,
                      height: 48,
                      child: Image.asset(
                        'assets/icons/subscriptions/momo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 112,
                      height: 48,
                      child: Image.asset(
                        'assets/icons/subscriptions/airtel_tigo.png',
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        AdeoFilledButton(
          label: 'Pay Now',
          onPressed: onPressed,
          color: Colors.white,
          background: kAdeoBlue,
          borderRadius: 4,
        ),
      ],
    );
  }
}

class WalletPay extends StatelessWidget {
  const WalletPay({
    Key? key,
    required this.amount,
    required this.onPressed,
  }) : super(key: key);

  final double amount;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 40,
          ),
          child: Column(
            children: [
              Text(
                'The amount of money in your wallet is',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: kAdeoWhiteAlpha50,
                ),
              ),
              SizedBox(height: 4),
              Text(
                money(amount),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Helvetica Rounded',
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        if (amount > 0)
          AdeoFilledButton(
            label: 'Pay Now',
            onPressed: onPressed,
            color: Colors.white,
            background: kAdeoBlue,
            borderRadius: 4,
          ),
      ],
    );
  }
}

class LinkPay extends StatelessWidget {
  const LinkPay({
    Key? key,
    required this.link,
    required this.onPressed,
  }) : super(key: key);

  final String link;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 40,
          ),
          child: Column(
            children: [
              Text(
                'Generate a payment link and use it to purchase a bundle',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
              if (link.length > 0)
                Column(
                  children: [
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.only(left: 12.0),
                      decoration: BoxDecoration(
                        color: kActiveOnDarkMode,
                        border: Border.all(
                          width: .5,
                          color: kActiveOnDarkMode,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 48.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                link,
                                style: TextStyle(
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: link,
                                ),
                              );
                            },
                            child: Text(
                              'Copy',
                              style: TextStyle(
                                color: Color(0xFF2589CE),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(height: 24),
        AdeoFilledButton(
          label: link.length > 0 ? 'Regenerate Link' : 'Generate Link',
          onPressed: onPressed,
          color: Colors.white,
          background: kAdeoBlue,
          borderRadius: 4,
        ),
      ],
    );
  }
}
