String query10 = '''
WITH usersBoxWhiskerData AS
(WITH latest_exam_versions AS (
    SELECT 
        exam_id,
        MAX(content_version) AS latest_version
    FROM 
        exam_versions
    GROUP BY 
        exam_id
),
user_latest_exam_scores AS (
    SELECT 
        uea.user_id, 
        u.given_name,
        u.family_name,
        uea.course_id, 
        uea.exam_id, 
        le.latest_version AS content_version,
        uea.score,
        uea.attempt_id,
        (finished_at - started_at) AS duration
    FROM 
        user_exam_attempts uea
    INNER JOIN 
        users u ON uea.user_id = u.user_id
    JOIN 
        latest_exam_versions le ON uea.exam_id = le.exam_id AND uea.exam_version = le.latest_version
    ORDER BY 
        uea.user_id, uea.exam_id, uea.attempt_id
),
score_stats AS (
    SELECT
        user_id,
        given_name,
        family_name,
        course_id,
        exam_id,
        content_version,
        ARRAY_AGG(score ORDER BY score) AS scores,
        COUNT(attempt_id) AS number_of_attempts
    FROM 
        user_latest_exam_scores
    GROUP BY 
        user_id, given_name, family_name, course_id, exam_id, content_version
)

SELECT 
    user_id, 
    given_name,
    family_name,
    course_id, 
    exam_id,
    content_version,
    scores,
    number_of_attempts   
FROM 
    score_stats
WHERE 
    exam_id = {0})
	
SELECT jsonb_build_object('userId', ubwd.user_id,
						 'givenName', ubwd.given_name,
						  'familyName', ubwd.family_name,
						  'courseId', ubwd.course_id, 
						  'examId', ubwd.exam_id,
						  'contentVersion', ubwd.content_version,
						  'scores', ubwd.scores,
						  'noOfAttempts', ubwd.number_of_attempts
						 ) AS user_box_whisker_json
FROM usersBoxWhiskerData ubwd

''';
