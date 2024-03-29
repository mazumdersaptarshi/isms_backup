String query4 = '''
With UsersSummary AS
(WITH CompletedCourses AS (
    SELECT 
        ucp.user_id, 
        COUNT(ucp.course_id) AS courses_learning_completed_count
    FROM 
        public.user_course_progress ucp
    WHERE 
        ucp.course_learning_completed_at IS NOT NULL
    GROUP BY 
        ucp.user_id
),
AssignedCourses AS (
    SELECT 
        user_id, 
        COUNT(course_id) AS assigned_courses_count 
    FROM 
        public.user_course_assignments
    GROUP BY 
        user_id
), 
AverageScore AS (
    SELECT 
        uea.user_id, 
        AVG(uea.score) AS average_score 
    FROM 
        user_exam_attempts uea
    GROUP BY 
        uea.user_id
),
LatestExamVersion AS (
	SELECT ev.exam_id, MAX(content_version) AS latest_exam_version FROM exam_versions ev
	GROUP BY ev.exam_id
),
ExamsCompleted AS (
    SELECT 
        uea.user_id, 
        COUNT(DISTINCT uea.exam_id) AS number_of_exams_passed
    FROM 
        user_exam_attempts uea
    JOIN 
        public.user_course_assignments uca ON uea.user_id = uca.user_id
    JOIN 
        public.course_exam_relationships cer ON uca.course_id = cer.course_id AND uea.exam_id = cer.exam_id
    JOIN 
        LatestExamVersion lev ON uea.exam_id = lev.exam_id AND uea.exam_version = lev.latest_exam_version
    WHERE 
        uea.passed = true
    GROUP BY 
        uea.user_id
),
AllAssignedExams AS (
    SELECT 
        uca.user_id,
        COUNT(DISTINCT cer.exam_id) AS all_assigned_exams_count
    FROM 
        public.user_course_assignments uca
    JOIN 
        public.course_exam_relationships cer ON uca.course_id = cer.course_id
    GROUP BY 
        uca.user_id
)
SELECT  
    u.user_id,
    u.family_name,
    u.given_name,
    u.account_role,
    u.email,
    COALESCE(cc.courses_learning_completed_count, 0) AS courses_learning_completed_count,
    COALESCE(ac.assigned_courses_count, 0) AS assigned_courses_count,
    COALESCE(aae.all_assigned_exams_count, 0) AS all_assigned_exams_count,
    COALESCE(ec.number_of_exams_passed, 0) AS number_of_exams_passed,
    COALESCE(avs.average_score, 0) AS average_score,
    u.last_login
FROM 
    public.users u
    LEFT JOIN CompletedCourses cc ON u.user_id = cc.user_id
    LEFT JOIN AssignedCourses ac ON u.user_id = ac.user_id
    LEFT JOIN ExamsCompleted ec ON u.user_id = ec.user_id
    LEFT JOIN AllAssignedExams aae ON u.user_id = aae.user_id
    LEFT JOIN AverageScore avs ON u.user_id = avs.user_id
WHERE u.domain_id = 'domain01'
ORDER BY 
    u.user_id) 

SELECT jsonb_build_object('userId', us.user_id,
						 'familyName',us.family_name,
						 'givenName', us.given_name,
						  'accountRole', us.account_role,
						  'email', us.email, 
						  'coursesLearningCompleted', us.courses_learning_completed_count,
						  'assignedCourses', us.assigned_courses_count,
						  'assignedExams', us.all_assigned_exams_count,
						  'examsPassed', us.number_of_exams_passed,
						  'averageScore', us.average_score,
						  'lastLogin', us.last_login
						 ) AS users_summary_json
						 
FROM UsersSummary us
''';
