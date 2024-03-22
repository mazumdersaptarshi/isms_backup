String query8 = '''

With courses_list AS
(SELECT c.course_id, cc.content_jdoc->>'courseTitle' AS course_title, cc.content_language

FROM courses c JOIN course_content cc ON c.course_id = cc.course_id
WHERE cc.content_language = 'en')

SELECT jsonb_build_object('courseId', cl.course_id,
						 'courseTitle', cl.course_title,
						  'contentLanguage', cl.content_language
						 ) AS courses_list_json
FROM courses_list AS cl




''';
