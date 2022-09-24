import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/revision_study_progress.dart';

class RevisionProgressController {
  // update or insert progress

  // add a new course revision if it hasn't being added
  createInitialCourseRevision(RevisionStudyProgress revision) async {
    RevisionStudyProgress? revisionStudyProgress =
        await StudyDB().getCurrentRevisionProgressByCourse(revision.courseId!);

    if (revisionStudyProgress == null) {
      await StudyDB().insertRevisionProgress(revision);
    }
  }

// create a function to update progress
  Future<void> updateInsertProgress(RevisionStudyProgress progress) async {
    RevisionStudyProgress? revisionStudyProgress =
        await StudyDB().getCurrentRevisionProgressByCourse(progress.courseId!);

    if (revisionStudyProgress == null) {
      StudyDB().insertRevisionProgress(progress);
    } else {
      RevisionStudyProgress updatedProgress = RevisionStudyProgress(
        id: revisionStudyProgress.id,
        courseId: progress.courseId,
        studyId: progress.studyId,
        topicId: progress.topicId,
        level: revisionStudyProgress.level! + 1,
        createdAt: revisionStudyProgress.createdAt,
        updatedAt: progress.updatedAt,
      );
      StudyDB().updateRevisionProgress(updatedProgress);
    }
  }
}
