import 'package:get/get.dart';

class SubscribeController extends GetxController {
  var _paymentOption = 0.obs;
  var _selectedMomo = 0.obs;
  List<String> _momos = ['Mtn', 'AirtelTigo', 'Vodafone'];
  List<String> _durations = ['1 Month', '3 Months', '6 Months', '1 Year'];
  var _selectedDuration = "1 Year";

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  loadData() async {
    // var user = await getCurrentUser();
    // if (user != null) {
    //   setUser(user);
    // }
  }
}
