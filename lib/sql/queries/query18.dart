String query18 = '''

 INSERT INTO user_course_assignments (
        user_id, 
        course_id, 
        enabled, 
        completion_deadline, 
        completion_tracking_period_start, 
        recurring_completion_required_interval
    ) VALUES 
    {0}
    ON CONFLICT (user_id, course_id) DO UPDATE 
    SET 
        enabled = EXCLUDED.enabled,
        completion_deadline = EXCLUDED.completion_deadline,
        completion_tracking_period_start = EXCLUDED.completion_tracking_period_start,
        recurring_completion_required_interval = EXCLUDED.recurring_completion_required_interval;
''';
