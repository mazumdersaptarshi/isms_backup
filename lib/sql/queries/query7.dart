String query7 = '''

WITH users_courses_overview AS 
(With 
assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
),
assigned_exams AS (
	SELECT course_id,
			exam_id
	FROM course_exam_relationships
	WHERE enabled = true
	AND course_id
	IN (SELECT course_id FROM assigned_courses)
),
highest_exam_content_version AS (
	SELECT DISTINCT ON (exam_id)
	exam_id, content_version
	FROM exam_content
 ),
highest_exam_versions AS (
	SELECT DISTINCT ON (ev.exam_id)
			ev.exam_id,
			ev.content_version,
			ev.pass_mark,
			ev.estimated_completion_time
	FROM exam_versions ev
	WHERE exam_id IN (SELECT exam_id FROM assigned_exams)
	ORDER BY exam_id ASC, content_version DESC
),
user_score_details AS
(SELECT 
    uea.user_id, 
	u.given_name,
	u.family_name,
    uea.course_id, 
    uea.exam_id, 
	hev.content_version,
    AVG(uea.score) AS average_score, 
    MAX(uea.score) AS max_score, 
    MIN(uea.score) AS min_score, 
 	COUNT(uea.attempt_id) AS number_of_attempts, 
 	MAX(finished_at - started_at) AS max_duration,
  	MIN(finished_at - started_at) AS min_duration,
  	AVG(finished_at - started_at) AS avg_duration


FROM 
    user_exam_attempts uea

INNER JOIN users u ON uea.user_id = u.user_id
INNER JOIN highest_exam_versions hev
	ON (uea.exam_id = hev.exam_id AND uea.exam_version = hev.content_version AND hev.content_version IN (SELECT hecv.content_version FROM highest_exam_content_version hecv))
GROUP BY 
    uea.user_id, 
	u.given_name,
	u.family_name,
    uea.course_id, 
    uea.exam_id,
	hev.content_version
ORDER BY 
    uea.user_id
)

SELECT  usd.user_id, 
	usd.given_name,
	usd.family_name,
    usd.course_id, 
    usd.exam_id, 
	usd.content_version,
	usd.average_score,
	usd.max_score,
	usd.min_score,
	usd.number_of_attempts, 
	usd.max_duration,
	usd.min_duration,
	usd.avg_duration


FROM user_score_details usd
WHERE usd.exam_id = {0}
)

SELECT jsonb_build_object('userId', uco.user_id,
						 'givenName', uco.given_name,
						 'familyName', uco.family_name,
						  'courseId', uco.course_id,
						  'examId', uco.exam_id, 
						  'highestExamContentVersion', uco.content_version,
						  'avgScore', uco.average_score,
						  'maxScore', uco.max_score,
						  'minScore', uco.min_score,
						  'numberOfAttempts', uco.number_of_attempts,
						  'maxDuration', uco.max_duration,
						  'minDuration', uco.min_duration,
						  'avgDuration', uco.avg_duration		  
						 ) AS users_courses_overview_json
FROM users_courses_overview uco
''';
