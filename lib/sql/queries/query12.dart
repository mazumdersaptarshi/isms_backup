String query12 = '''

WITH userCourses AS
(SELECT 
    u.user_id, 
    
    c.course_id,
    cc.content_jdoc->>'courseTitle' as course_title
FROM 
    users u
INNER JOIN 
    user_course_assignments uca ON u.user_id = uca.user_id
INNER JOIN 
    courses c ON uca.course_id = c.course_id
INNER JOIN 
    course_content cc ON c.course_id = cc.course_id
WHERE 
    u.user_id = {0}
AND cc.content_language = 'en')

SELECT jsonb_build_object('userId', uc.user_id,
						 'courseId', uc.course_id,
						  'courseTitle', uc.course_title
						 ) AS user_courses_json
						 
FROM userCourses uc



''';
