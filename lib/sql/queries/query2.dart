final String query2 = '''

WITH UserSummary AS 
(WITH CompletedCourses AS (
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
AverageScore AS (
	SELECT uea.user_id,  avg(uea.score) AS average_score FROM user_exam_attempts uea
		GROUP BY uea.user_id
	),

ExamsCompleted AS (
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
		LatestVersion AS (
			SELECT 
				exam_id, 
				MAX(content_version) as latest_version
			FROM 
				exam_versions
			GROUP BY 
				exam_id
		),
	
		PassedExams AS (
			SELECT 
				uea.user_id, 
				uea.exam_id,
				uea.exam_version,
				bool_or(uea.passed) AS passed -- This will be true if the user ever passed the exam
			FROM 
				user_exam_attempts uea
			INNER JOIN 
				LatestVersion lv ON uea.exam_id = lv.exam_id AND uea.exam_version = lv.latest_version
			GROUP BY 
				uea.user_id, uea.exam_id, uea.exam_version
		)
		SELECT 
			pe.user_id, 
			cc.courses_learning_completed_count,
			COUNT(pe.passed) as number_of_exams_passed
		FROM 
			PassedExams as pe JOIN CompletedCourses AS cc ON pe.user_id = cc.user_id
		WHERE pe.passed = true
		GROUP BY pe.user_id, cc.courses_learning_completed_count

		ORDER BY 
			user_id

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
    COALESCE(cc.courses_learning_completed_count, 0) AS courses_learning_completed_count,
    COALESCE(ac.assigned_courses_count, 0) AS assigned_courses_count,
    COALESCE(aae.all_assigned_exams_count, 0) AS all_assigned_exams_count, 
	 ec.number_of_exams_passed,
	 avs.average_score,
	u.last_login
FROM 
    AssignedCourses AS ac 
    LEFT JOIN CompletedCourses AS cc ON ac.user_id = cc.user_id
	LEFT JOIN AverageScore AS avs ON cc.user_id = avs.user_id
    FULL OUTER  JOIN ExamsCompleted AS ec ON ac.user_id = ec.user_id
    FULL OUTER  JOIN AllAssignedExams AS aae ON ac.user_id = aae.user_id
	FULL OUTER JOIN public.users as u ON aae.user_id = u.user_id
	
WHERE u.user_id = {0})

SELECT json_build_object('userId', us.user_id,
						'familyName', us.family_name,
						 'givenName', us.given_name,
						 'accountRole', us.account_role,
						 'email', us.email,
						 'coursesLearningCompleted', us.courses_learning_completed_count,
						 'assignedCourses', us.assigned_courses_count,
						 'assignedExams', us.all_assigned_exams_count,
						 'examsPassed', us.number_of_exams_passed,
						 'averageScore', us.average_score,
						 'lastLogin', us.last_login
						) AS user_summary_json
						
FROM UserSummary us
''';
