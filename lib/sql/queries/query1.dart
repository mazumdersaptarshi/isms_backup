final String query1 = '''
WITH CompletedCourses AS (
    SELECT 
        ucp.user_id, 
        array_length(array_agg(ucp.course_id), 1) AS courses_learning_completed_count
    FROM 
        public.user_course_progress AS ucp
    WHERE 
        ucp.course_learning_completed_at IS NOT NULL
    GROUP BY 
        ucp.user_id
),

AssignedCourses AS (
    SELECT 
        user_id, 
        array_agg(course_id) AS assigned_courses,
        array_length(array_agg(course_id), 1) AS assigned_courses_count 
    FROM 
        public.user_course_assignments
    GROUP BY 
        user_id
), 

ExamsCompleted AS (
	SELECT 
        uea.user_id, 
        COUNT(uea.exam_id) AS exams_attempted_count, 
        SUM(CASE WHEN uea.passed THEN 1 ELSE 0 END) AS passed_exams_count, 
		AVG(uea.score) AS average_score 
    FROM 
        public.user_exam_attempts AS uea
    GROUP BY 
        uea.user_id
),
AllAssignedExams AS (
    SELECT 
        ac.user_id,
        array_length(array_agg(cer.exam_id), 1) AS all_assigned_exams_count
    FROM 
        public.user_course_assignments AS uca
    JOIN 
        public.course_exam_relationships AS cer ON uca.course_id = cer.course_id
    JOIN 
        AssignedCourses AS ac ON uca.user_id = ac.user_id
    GROUP BY 
        ac.user_id
)

SELECT  
	u.user_id,
	u.family_name,
	u.given_name,
	u.account_role,
	u.email,
    COALESCE(cc.courses_learning_completed_count, 0) AS courses_learning_percent,
    COALESCE(ac.assigned_courses_count, 0) AS assigned_courses_count,
    COALESCE(ec.passed_exams_count, 0) AS passed_exams_count,
    COALESCE(aae.all_assigned_exams_count, 0) AS all_assigned_exams_count, 
	COALESCE(ec.average_score, 0)AS average_score, 
	u.last_login
FROM 
    AssignedCourses AS ac 
    LEFT JOIN CompletedCourses AS cc ON ac.user_id = cc.user_id
    LEFT JOIN ExamsCompleted AS ec ON ac.user_id = ec.user_id
    LEFT JOIN AllAssignedExams AS aae ON ac.user_id = aae.user_id
	FULL OUTER JOIN public.users as u ON aae.user_id = u.user_id
ORDER BY 
    ac.user_id;

''';
