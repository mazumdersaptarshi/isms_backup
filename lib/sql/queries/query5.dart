String query5 = '''
WITH UserSummaryData AS

(WITH LatestExamVersion AS (
    SELECT 
        exam_id,
        MAX(exam_version) AS latest_version
    FROM 
        user_exam_attempts
    
    GROUP BY 
        exam_id
),
UserPassedLatestVersion AS (
    SELECT 
        uea.user_id,
        uea.exam_id,
        (bool_or(uea.passed) AND count(*) > 0) AS passed_latest_version  
    FROM 
        user_exam_attempts uea
    JOIN 
        LatestExamVersion lev ON uea.exam_id = lev.exam_id AND uea.exam_version = lev.latest_version
    
    GROUP BY 
        uea.user_id, uea.exam_id
),
 
 
 ExamStatus AS (
    SELECT DISTINCT
        uea.user_id, 
        uea.course_id,
        uea.exam_id,
        uplv.passed_latest_version AS passed
    FROM 
        user_exam_attempts uea
    JOIN
        course_exam_relationships cer ON uea.exam_id = cer.exam_id
	 LEFT JOIN
        UserPassedLatestVersion uplv ON uea.user_id = uplv.user_id AND uea.exam_id = uplv.exam_id
),
AggregatedExamStatus AS (
    SELECT
        es.user_id,
        es.course_id,
        json_agg(
            json_build_object(
                'exam_id', es.exam_id, 
                'exam_title', ec.content_jdoc->>'examTitle',
                'passed', COALESCE(es.passed, false)
            )
        ) AS exams_status
    FROM 
        ExamStatus es
	INNER JOIN 
        exam_content ec ON es.exam_id = ec.exam_id
    GROUP BY
        es.user_id, es.course_id
),
CoursesProgress AS (
    SELECT
        ucp.user_id, 
        ucp.course_id,
		ucp.completed_sections,
        cc.content_jdoc->>'courseTitle' AS course_title,
        CASE 
            WHEN ucp.course_learning_completed_at IS NOT NULL THEN 'Completed'
            ELSE 'In Progress'
        END as learning_status,
        jsonb_path_query_array(cc.content_jdoc, '\$.courseSections[*].sectionId') AS course_sections
    FROM 
        user_course_progress ucp 
    JOIN 
        course_content cc ON ucp.course_id = cc.course_id
    WHERE cc.content_language = 'en'
),
PassedExamsCount AS (
     SELECT 
        uea.user_id, 
        uea.course_id,
		ARRAY_LENGTH(ARRAY_AGG(DISTINCT(uea.exam_id)), 1) AS passed_exams
        
    FROM 
        user_exam_attempts uea
    INNER JOIN 
        course_exam_relationships cer ON uea.exam_id = cer.exam_id
    INNER JOIN 
        exam_content ec ON uea.exam_id = ec.exam_id
    WHERE 
        uea.passed 
    GROUP BY 
        uea.user_id, uea.course_id
),
ExamsInCourse AS (
    SELECT 
        cer.course_id, 
        array_agg(cer.exam_id) AS exams_in_course 
    FROM 
        course_exam_relationships cer 
    GROUP BY cer.course_id
)
SELECT 
    cp.user_id, 
    cp.course_id, 
    cp.course_title, 
    cp.learning_status , 
	array_length(cp.completed_sections, 1)AS completed_sections,
    jsonb_array_length(cp.course_sections) AS sections_in_course,
	COALESCE(pec.passed_exams, 0) AS passed_exams_count,
	array_length(eic.exams_in_course, 1) AS exams_in_course,

    COALESCE(aes.exams_status, '[]') AS exams_details
FROM 
    CoursesProgress cp 
LEFT JOIN 
    AggregatedExamStatus aes ON cp.user_id = aes.user_id AND cp.course_id = aes.course_id
LEFT JOIN 
    PassedExamsCount pec ON cp.user_id = pec.user_id AND cp.course_id = pec.course_id
LEFT JOIN 
    ExamsInCourse eic ON cp.course_id = eic.course_id
WHERE 
    cp.user_id = {0})
SELECT json_build_object('user_id', usd.user_id, 
						  'course_id', usd.course_id, 
						  'course_title', usd.course_title, 
						  'learning_status', usd.learning_status, 
						  'completed_sections_count', usd.completed_sections, 
						  'sections_in_course', usd.sections_in_course, 
						  'passed_exams', usd.passed_exams_count, 
						  'exams_details', usd.exams_details,
						  'exams_in_course', usd.exams_in_course) as course_progress_json 
						  
FROM UserSummaryData usd

''';
