// enum DropdownSize { small, medium, large }
import 'package:ecoach/models/get_agent_code.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/question.dart';

enum ProgressIndicatorSize { small, large }
enum Sizes { small, medium, large }
enum ExamScore { CORRECTLY_ANSWERED, WRONGLY_ANSWERED, NOT_ATTEMPTED }
enum TestType { SPEED, KNOWLEDGE, UNTIMED, CUSTOMIZED, DIAGNOSTIC, NONE }
enum TestCategory { MOCK, EXAM, TOPIC, ESSAY, SAVED, BANK, NONE }
enum TestMode { LIVE, PRACTISE, COMPLETED, CONTINUE, NEW }
enum CardVariant { LIGHT, DARK }
enum TreadmillMode { TOPIC, MOCK, BANK }

double backgroundIllustrationHeight = 480.0;
// List savedQuestions = [2, 4, 3, 5];
List savedQuestions = [];
// List<Question>reviewQuestionsBack = [];
Question? question;
List<Question> reviewQuestionsBack = [];
List selectAnsweredQuestions = [];
List unSelectAnsweredQuestions = [];
List<Plan> futurePlanItem = [];
List<AgentData> listAgentData = [];
bool fetchDiagnosticTest = false;
