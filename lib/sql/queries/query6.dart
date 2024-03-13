String query6 = '''
WITH UserExamAttempts AS
(SELECT * FROM user_exam_attempts
WHERE user_id = {0} AND course_id = {1} AND exam_id = {2})
SELECT json_build_object('attemptId', uea.attempt_id, 
						'userId', uea.user_id,
						 'courseId', uea.course_id,
						 'examId', uea.exam_id,
						 'examVersion', uea.exam_version, 
						 'passed', uea.passed, 
						 'score', uea.score, 
						 'startedAt', uea.started_at, 
						 'finishedAt', uea.finished_at,
						 'responses', uea.responses_jdoc
						) as exam_attempts_json
FROM UserExamAttempts uea
''';
