String query11 = '''

WITH ExamOverallResults AS
(WITH 
  latest_exam_versions AS (
    SELECT 
        ev.exam_id,
        MAX(ec.content_version) AS latest_version
    FROM 
        exam_versions ev INNER JOIN exam_content ec ON ev.content_version = ec.content_version
	  WHERE
        ev.exam_id = {0}
    GROUP BY 
        ev.exam_id
),
 ExamOutcomes AS (
    SELECT
        uea.exam_id,
        uea.user_id,
        bool_or(uea.passed) AS passed
    FROM
        user_exam_attempts uea
    WHERE
        uea.exam_id = {0} AND uea.exam_version = (SELECT lev.latest_version FROM latest_exam_versions lev)
    GROUP BY
        uea.exam_id, uea.user_id
),
TotalUsers AS (
    SELECT
        COUNT(*) AS total_users
    FROM
        users
),
OutcomeCounts AS (
    SELECT
        (SELECT COUNT(*) FROM ExamOutcomes WHERE passed = TRUE) AS passed,
        (SELECT COUNT(*) FROM ExamOutcomes WHERE passed = FALSE) AS failed,
        (SELECT total_users FROM TotalUsers) - (SELECT COUNT(*) FROM ExamOutcomes) AS not_attempted
),
OutcomePercentages AS (
    SELECT
        passed::decimal / total_users * 100 AS percentage_passed,
        failed::decimal / total_users * 100 AS percentage_failed,
        not_attempted::decimal / total_users * 100 AS percentage_not_attempted
    FROM
        OutcomeCounts, TotalUsers
)
SELECT * FROM OutcomePercentages)

SELECT jsonb_build_object('passed', eor.percentage_passed,
						 'failed', eor.percentage_failed,
						  'not_started', eor.percentage_not_attempted
						 ) AS exam_overall_results_json
FROM ExamOverallResults eor

''';
