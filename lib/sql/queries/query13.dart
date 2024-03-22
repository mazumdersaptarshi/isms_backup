String query13 = '''
WITH UserExamOveralResults AS 
(WITH assigned_courses AS (
    SELECT course_id
    FROM user_course_assignments
    WHERE user_id = {0} AND enabled = true
),
assigned_exams AS (
    SELECT cer.course_id, cer.exam_id
    FROM course_exam_relationships cer
    INNER JOIN assigned_courses ac ON cer.course_id = ac.course_id
    WHERE cer.enabled = true
),
latest_versions AS (
    SELECT exam_id, MAX(content_version) AS latest_version
    FROM exam_versions
    GROUP BY exam_id
),
user_attempts AS (
    SELECT 
        uea.exam_id, 
        uea.user_id, 
        bool_or(uea.passed AND ev.content_version = lv.latest_version) AS passed, 
        COUNT(uea.exam_id) FILTER (WHERE ev.content_version = lv.latest_version) AS attempts
    FROM 
        user_exam_attempts uea
    INNER JOIN 
        latest_versions lv ON uea.exam_id = lv.exam_id
    INNER JOIN 
        exam_versions ev ON uea.exam_id = ev.exam_id AND uea.exam_version = ev.content_version
    RIGHT JOIN 
        assigned_exams ae ON uea.exam_id = ae.exam_id AND uea.user_id = {0}
    GROUP BY 
        uea.exam_id, uea.user_id
),
exam_status_summary AS (
    SELECT 
        {0} AS user_id,
        100.0 * COUNT(*) FILTER (WHERE passed) / COUNT(*) AS passed_exams_percentage,
        100.0 * COUNT(*) FILTER (WHERE attempts > 0 AND NOT passed) / COUNT(*) AS failed_exams_percentage,
        100.0 * COUNT(*) FILTER (WHERE attempts = 0) / COUNT(*) AS not_started_exams_percentage,
        COUNT(*) AS total_assigned_exams
    FROM 
        user_attempts
)
SELECT 
    user_id, 
    passed_exams_percentage, 
    failed_exams_percentage, 
    not_started_exams_percentage
FROM 
    exam_status_summary
)

SELECT json_build_object('passed', ueor.passed_exams_percentage,
						'failed', ueor.failed_exams_percentage,
						 'notStarted',ueor.not_started_exams_percentage
						) AS user_exam_overall_results 
FROM UserExamOveralResults ueor
						

''';
