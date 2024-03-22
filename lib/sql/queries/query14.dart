String query14 = '''
WITH domainCourses AS 
	(SELECT c.course_id, d.domain_id,
	cc.content_jdoc->>'courseTitle' AS course_title, cc.content_language
	FROM domain_course_assignments d JOIN courses c
	ON d.course_id = c.course_id
	JOIN course_content cc ON
	cc.course_id = c.course_id
	WHERE cc.content_language = 'en'
	AND domain_id = 'domain01')
	SELECT json_build_object('courseId', dc.course_id,
						   'domainId', dc.domain_id,
							'courseTitle', dc.course_title,
							'contentLanguage', dc.content_language
						   ) domain_courses_json
FROM domainCourses dc
''';
