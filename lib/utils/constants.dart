// enum DropdownSize { small, medium, large }
import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/models/active_package_model.dart';
import 'package:ecoach/models/agent_transaction.dart';
import 'package:ecoach/models/get_agent_code.dart';
import 'package:ecoach/models/group_chat_model.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/group_packages_model.dart';
import 'package:ecoach/models/group_test_model.dart';
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
var totalCommission;
List<AgentTransactionResponse> listDataResponse = [];
bool fetchDiagnosticTest = false;
List<GroupPackageData> listGroupPackageData = [];
List<ActivePackageData> listActivePackageData = [];
List<GroupListData> listGroupListData = [];
GroupManagementController groupManagementController = GroupManagementController();
String groupID = '';
String groupTestSource = '';
String groupTestBundle = '';
String groupTestCourse = '';
String groupTestType = '';
String groupTestId = '';
List<GroupTestData> listGroupTestData = [];
List<Messages> groupChatBetweenList = [];
List<Messages> chatBetweenListDate = [];
List<Messages> groupChatBetweenListDate = [];
List<GroupListData> myGroupList= [];

