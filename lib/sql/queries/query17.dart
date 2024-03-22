String query17 = '''

WITH userCourseAssignments AS 
(SELECT * FROM public.user_course_assignments
WHERE user_id = {0}
ORDER BY completion_deadline)

SELECT json_build_object('userId', uca.user_id,
						'courseId', uca.course_id,
						 'enabled', uca.enabled,
						 'completionDeadline', uca.completion_deadline,
						 'trackingStart', uca.completion_tracking_period_start,
						 'recurringInterval', uca.recurring_completion_required_interval,
						 'lastModified', uca.row_modified_at
						) AS user_course_assignments_json
FROM userCourseAssignments uca
''';
