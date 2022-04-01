import 'package:ecoach/controllers/autopilot_controller.dart';

class AutopilotSelectorService {
  static final AutopilotSelectorService _instance =
      AutopilotSelectorService._internal();

  factory AutopilotSelectorService() => _instance;

  AutopilotSelectorService._internal() {
    _selectedTopic = 0;
    _topicId = '';
    _controllers = [];
  }

  late int _selectedTopic;
  late dynamic _topicId;
  late List<AutopilotController> _controllers;

  //short getter for my variable
  int get selectedTopic => _selectedTopic;
  //List<AutopilotController> get controllers => _controllers;

  //short setter for my variable
  set selectedTopic(int value) => selectedTopic = value;
  // set controllers(AutopilotController controller) => controller.add(controller);

  void incrementSelectedTopic() => _selectedTopic++;

  int get topicId => _topicId;

  //short setter for my variable
  set topicId(dynamic value) => topicId = value;
}
