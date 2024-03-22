String query9 = '''

WITH highest_exam_content_version AS 
(
	SELECT DISTINCT ON (exam_id)
		exam_id, content_version
	FROM exam_content
	ORDER BY exam_id, content_version DESC
), 
exams_list AS 
(
	SELECT 
		cer.course_id, 
		e.exam_id, 
		ec.content_jdoc->>'examTitle' AS exam_title, 
		ec.content_version 
	FROM 
		course_exam_relationships cer 
	JOIN 
		exams e ON cer.exam_id = e.exam_id
	JOIN 
		exam_content ec ON e.exam_id = ec.exam_id
	INNER JOIN 
		highest_exam_content_version hcev ON ec.exam_id = hcev.exam_id AND ec.content_version = hcev.content_version
	WHERE cer.course_id = {0} 
)

SELECT 
	jsonb_build_object(
		'courseId', exams_list.course_id,
		'examId', exams_list.exam_id,
		'examTitle', exams_list.exam_title,
		'contentVersion', exams_list.content_version
	) AS exams_list_json
FROM 
	exams_list;
''';
