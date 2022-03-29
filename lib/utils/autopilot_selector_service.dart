import 'package:ecoach/controllers/autopilot_controller.dart';

class AutopilotSelectorService {
  static final AutopilotSelectorService _instance =
      AutopilotSelectorService._internal();

  factory AutopilotSelectorService() => _instance;

  AutopilotSelectorService._internal() {
    _selectedTopic = 0;
    _topicId = '';
  }

  late int _selectedTopic;
  late dynamic _topicId;

  //short getter for my variable
  int get selectedTopic => _selectedTopic;

  //short setter for my variable
  set selectedTopic(int value) => selectedTopic = value;

  void incrementSelectedTopic() => _selectedTopic++;

  int get topicId => _topicId;

  //short setter for my variable
  set topicId(dynamic value) => topicId = value;
}
