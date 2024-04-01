-- Data inserts
INSERT INTO domains (domain_id, company_name, primary_admin_given_name, primary_admin_family_name, primary_admin_email, primary_admin_other_contact_details, secondary_admin_given_name, secondary_admin_family_name, secondary_admin_email, secondary_admin_other_contact_details) VALUES ('d1', 'Company 1', '', '', '', '', '', '', '', '');
INSERT INTO users (user_id, domain_id, account_role, given_name, family_name, email) VALUES ('u1', 'd1', 'admin', 'Given', 'Family', 'admin@a.a');
INSERT INTO user_settings (user_id, preferred_language, app_theme) VALUES ('u1', 'en', 'light');

INSERT INTO courses (course_id) VALUES ('c1');
INSERT INTO courses (course_id) VALUES ('c2');
INSERT INTO course_versions (course_id, content_version) VALUES ('c1', 1.0::real);
INSERT INTO course_versions (course_id, content_version) VALUES ('c2', 1.0::real);
INSERT INTO course_content (course_id, content_version, content_language, content_jdoc) VALUES ('c1', 1.0::real, 'en', '{ "courseTitle": "Test Course 1", "courseSummary": "Test Course 1 summary", "courseDescription": "Test Course 1 description", "courseSections": [ { "sectionId": "section1", "sectionTitle": "Section 1", "sectionSummary": "Section 1 summary", "sectionElements": [ { "elementId": "html1", "elementType": "html", "elementTitle": "Static HTML 1", "elementContent": "<html><body><p>HTML 1<br>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.<br><b>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.</b><br><s>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.</s><br>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.<br> IT LOOKS LIKE WE CANNOT SET FONT SIZE IN HTML HERE</p></body></html>" }, { "elementId": "question1", "elementType": "question", "elementTitle": "Multiple choice question with single answer selection", "elementContent": [ { "questionId": "ssq1", "questionType": "singleSelectionQuestion", "questionText": "Section 1 Question", "questionAnswers": [ { "answerId": "ssq1a1", "answerText": "Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. ", "answerCorrect": false, "answerExplanation": "Explanation 1" }, { "answerId": "ssq1a2", "answerText": "Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. ", "answerCorrect": true, "answerExplanation": "Explanation 2" }, { "answerId": "ssq1a3", "answerText": "Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. ", "answerCorrect": false, "answerExplanation": "Explanation 3" } ] } ] } ] }, { "sectionId": "section2", "sectionTitle": "Section 2", "sectionSummary": "Section 2 summary", "sectionElements": [ { "elementId": "question2", "elementType": "question", "elementTitle": "Multiple choice question with multiple answer selection", "elementContent": [ { "questionId": "msq1", "questionType": "multipleSelectionQuestion", "questionText": "Section 2 Question", "questionAnswers": [ { "answerId": "msq1a1", "answerText": "A1", "answerCorrect": true, "answerExplanation": "Explanation 1" }, { "answerId": "msq1a2", "answerText": "A2", "answerCorrect": false, "answerExplanation": "Explanation 2" }, { "answerId": "msq1a3", "answerText": "A3", "answerCorrect": false, "answerExplanation": "Explanation 3" }, { "answerId": "msq1a4", "answerText": "A4", "answerCorrect": true, "answerExplanation": "Explanation 4" } ] } ] } ] }, { "sectionId": "section3", "sectionTitle": "Section 3", "sectionSummary": "Section 3 summary", "sectionElements": [ { "elementId": "html2", "elementType": "html", "elementTitle": "Static HTML 2", "elementContent": "<html><body><p>HTML 1<br>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.<br><b>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.</b><br><s>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.</s><br>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.<br> IT LOOKS LIKE WE CANNOT SET FONT SIZE IN HTML HERE</p></body></html>" }, { "elementId": "flipcards1", "elementType": "flipCard", "elementTitle": "FlipCards", "elementContent": [ { "flipCardId": "fc1", "flipCardFront": "Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. ", "flipCardBack": "Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. " }, { "flipCardId": "fc2", "flipCardFront": "Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. ", "flipCardBack": "Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. " }, { "flipCardId": "fc3", "flipCardFront": "Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. ", "flipCardBack": "Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. " } ] } ] } ] }');
INSERT INTO course_content (course_id, content_version, content_language, content_jdoc) VALUES ('c2', 1.0::real, 'en', '{ "courseTitle": "Test Course 2", "courseSummary": "Test Course 2 summary", "courseDescription": "Test Course 2 description", "courseSections": [ { "sectionId": "section1", "sectionTitle": "Section 1", "sectionSummary": "Section 1 summary", "sectionElements": [ { "elementId": "html1", "elementType": "html", "elementTitle": "Static HTML 1", "elementContent": "<html><body><p>HTML 1<br>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.<br><b>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.</b><br><s>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.</s><br>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.<br> IT LOOKS LIKE WE CANNOT SET FONT SIZE IN HTML HERE</p></body></html>" }, { "elementId": "question1", "elementType": "question", "elementTitle": "Multiple choice question with single answer selection", "elementContent": [ { "questionId": "ssq1", "questionType": "singleSelectionQuestion", "questionText": "Section 1 Question", "questionAnswers": [ { "answerId": "ssq1a1", "answerText": "Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. Answer 1. ", "answerCorrect": false, "answerExplanation": "Explanation 1" }, { "answerId": "ssq1a2", "answerText": "Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. Answer 2. ", "answerCorrect": true, "answerExplanation": "Explanation 2" }, { "answerId": "ssq1a3", "answerText": "Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. Answer 3. ", "answerCorrect": false, "answerExplanation": "Explanation 3" } ] } ] } ] }, { "sectionId": "section2", "sectionTitle": "Section 2", "sectionSummary": "Section 2 summary", "sectionElements": [ { "elementId": "question2", "elementType": "question", "elementTitle": "Multiple choice question with multiple answer selection", "elementContent": [ { "questionId": "msq1", "questionType": "multipleSelectionQuestion", "questionText": "Section 2 Question", "questionAnswers": [ { "answerId": "msq1a1", "answerText": "A1", "answerCorrect": true, "answerExplanation": "Explanation 1" }, { "answerId": "msq1a2", "answerText": "A2", "answerCorrect": false, "answerExplanation": "Explanation 2" }, { "answerId": "msq1a3", "answerText": "A3", "answerCorrect": false, "answerExplanation": "Explanation 3" }, { "answerId": "msq1a4", "answerText": "A4", "answerCorrect": true, "answerExplanation": "Explanation 4" } ] } ] } ] }, { "sectionId": "section3", "sectionTitle": "Section 3", "sectionSummary": "Section 3 summary", "sectionElements": [ { "elementId": "html2", "elementType": "html", "elementTitle": "Static HTML 2", "elementContent": "<html><body><p>HTML 1<br>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.<br><b>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.</b><br><s>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.</s><br>This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.This is question part in HTML.<br> IT LOOKS LIKE WE CANNOT SET FONT SIZE IN HTML HERE</p></body></html>" }, { "elementId": "flipcards1", "elementType": "flipCard", "elementTitle": "FlipCards", "elementContent": [ { "flipCardId": "fc1", "flipCardFront": "Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. ", "flipCardBack": "Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. " }, { "flipCardId": "fc2", "flipCardFront": "Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. ", "flipCardBack": "Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. " }, { "flipCardId": "fc3", "flipCardFront": "Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. Front 3. ", "flipCardBack": "Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. Back 3. " } ] } ] } ] }');

INSERT INTO exams (exam_id) VALUES ('e1');
INSERT INTO exams (exam_id) VALUES ('e2');
INSERT INTO exams (exam_id) VALUES ('e3');
INSERT INTO exams (exam_id) VALUES ('e4');
INSERT INTO exam_versions (exam_id, content_version, pass_mark, estimated_completion_time) VALUES ('e1', 1.0::real, 2, '25 minutes'::interval);
INSERT INTO exam_versions (exam_id, content_version, pass_mark, estimated_completion_time) VALUES ('e2', 1.0::real, 3, '1 hour 5 minutes'::interval);
INSERT INTO exam_versions (exam_id, content_version, pass_mark, estimated_completion_time) VALUES ('e3', 1.0::real, 7, '55 minutes'::interval);
INSERT INTO exam_versions (exam_id, content_version, pass_mark, estimated_completion_time) VALUES ('e4', 1.0::real, 7, '55 minutes'::interval);
INSERT INTO exam_content (exam_id, content_version, content_language, content_jdoc) VALUES ('e1', 1.0::real, 'en', '{ "examTitle": "Test Exam 1", "examSummary": "Test Exam 1 summary", "examDescription": "Test Exam 1 description", "examSections": [ { "sectionId": "section1", "sectionTitle": "Section 1", "sectionSummary": "Section 1 summary", "sectionElements": [ { "elementId": "question1", "elementType": "question", "elementTitle": "Multiple choice question with single answer selection", "elementContent": [ { "questionId": "ssq1", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq1a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq1a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq1a3", "answerText": "A3", "answerCorrect": false } ] } ] }, { "elementId": "question2", "elementType": "question", "elementTitle": "Multiple choice question with multiple answer selection", "elementContent": [ { "questionId": "msq1", "questionType": "multipleSelectionQuestion", "questionText": "MSQ", "questionAnswers": [ { "answerId": "msq1a1", "answerText": "A1", "answerCorrect": true }, { "answerId": "msq1a2", "answerText": "A2", "answerCorrect": false }, { "answerId": "msq1a3", "answerText": "A3", "answerCorrect": false }, { "answerId": "msq1a4", "answerText": "A4", "answerCorrect": true } ] } ] }, { "elementId": "questiongroup1", "elementType": "question", "elementTitle": "Multiple questions", "elementContent": [ { "questionId": "ssq2", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq2a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq2a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq2a3", "answerText": "A3", "answerCorrect": false } ] }, { "questionId": "msq2", "questionType": "multipleSelectionQuestion", "questionText": "MSQ", "questionAnswers": [ { "answerId": "msq2a1", "answerText": "A1", "answerCorrect": true }, { "answerId": "msq2a2", "answerText": "A2", "answerCorrect": false }, { "answerId": "msq2a3", "answerText": "A3", "answerCorrect": false }, { "answerId": "msq2a4", "answerText": "A4", "answerCorrect": true } ] } ] } ] }, { "sectionId": "section2", "sectionTitle": "Section 2", "sectionSummary": "Section 2 summary", "sectionElements": [ { "elementId": "questionaaaaaaaa", "elementType": "question", "elementTitle": "Multiple choice question with single answer selection", "elementContent": [ { "questionId": "ssq3", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq3a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq3a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq3a3", "answerText": "A3", "answerCorrect": false } ] } ] } ] } ] }');
INSERT INTO exam_content (exam_id, content_version, content_language, content_jdoc) VALUES ('e2', 1.0::real, 'en', '{ "examTitle": "Test Exam 2", "examSummary": "Test Exam 2 summary", "examDescription": "Test Exam 2 description", "examSections": [ { "sectionId": "section1", "sectionTitle": "Section 1", "sectionSummary": "Section 1 summary", "sectionElements": [ { "elementId": "question1", "elementType": "question", "elementTitle": "Multiple choice question with single answer selection", "elementContent": [ { "questionId": "ssq1", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq1a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq1a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq1a3", "answerText": "A3", "answerCorrect": false } ] } ] }, { "elementId": "question2", "elementType": "question", "elementTitle": "Multiple choice question with multiple answer selection", "elementContent": [ { "questionId": "msq1", "questionType": "multipleSelectionQuestion", "questionText": "MSQ", "questionAnswers": [ { "answerId": "msq1a1", "answerText": "A1", "answerCorrect": true }, { "answerId": "msq1a2", "answerText": "A2", "answerCorrect": false }, { "answerId": "msq1a3", "answerText": "A3", "answerCorrect": false }, { "answerId": "msq1a4", "answerText": "A4", "answerCorrect": true } ] } ] }, { "elementId": "questiongroup1", "elementType": "question", "elementTitle": "Multiple questions", "elementContent": [ { "questionId": "ssq2", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq2a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq2a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq2a3", "answerText": "A3", "answerCorrect": false } ] }, { "questionId": "msq2", "questionType": "multipleSelectionQuestion", "questionText": "MSQ", "questionAnswers": [ { "answerId": "msq2a1", "answerText": "A1", "answerCorrect": true }, { "answerId": "msq2a2", "answerText": "A2", "answerCorrect": false }, { "answerId": "msq2a3", "answerText": "A3", "answerCorrect": false }, { "answerId": "msq2a4", "answerText": "A4", "answerCorrect": true } ] } ] } ] }, { "sectionId": "section2", "sectionTitle": "Section 2", "sectionSummary": "Section 2 summary", "sectionElements": [ { "elementId": "questionaaaaaaaa", "elementType": "question", "elementTitle": "Multiple choice question with single answer selection", "elementContent": [ { "questionId": "ssq3", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq3a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq3a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq3a3", "answerText": "A3", "answerCorrect": false } ] } ] } ] } ] }');
INSERT INTO exam_content (exam_id, content_version, content_language, content_jdoc) VALUES ('e3', 1.0::real, 'en', '{ "examTitle": "Test Exam 3", "examSummary": "Test Exam 3 summary", "examDescription": "Test Exam 3 description", "examSections": [ { "sectionId": "section1", "sectionTitle": "Section 1", "sectionSummary": "Section 1 summary", "sectionElements": [ { "elementId": "question1", "elementType": "question", "elementTitle": "Multiple choice question with single answer selection", "elementContent": [ { "questionId": "ssq1", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq1a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq1a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq1a3", "answerText": "A3", "answerCorrect": false } ] } ] }, { "elementId": "question2", "elementType": "question", "elementTitle": "Multiple choice question with multiple answer selection", "elementContent": [ { "questionId": "msq1", "questionType": "multipleSelectionQuestion", "questionText": "MSQ", "questionAnswers": [ { "answerId": "msq1a1", "answerText": "A1", "answerCorrect": true }, { "answerId": "msq1a2", "answerText": "A2", "answerCorrect": false }, { "answerId": "msq1a3", "answerText": "A3", "answerCorrect": false }, { "answerId": "msq1a4", "answerText": "A4", "answerCorrect": true } ] } ] }, { "elementId": "questiongroup1", "elementType": "question", "elementTitle": "Multiple questions", "elementContent": [ { "questionId": "ssq2", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq2a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq2a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq2a3", "answerText": "A3", "answerCorrect": false } ] }, { "questionId": "msq2", "questionType": "multipleSelectionQuestion", "questionText": "MSQ", "questionAnswers": [ { "answerId": "msq2a1", "answerText": "A1", "answerCorrect": true }, { "answerId": "msq2a2", "answerText": "A2", "answerCorrect": false }, { "answerId": "msq2a3", "answerText": "A3", "answerCorrect": false }, { "answerId": "msq2a4", "answerText": "A4", "answerCorrect": true } ] } ] } ] }, { "sectionId": "section2", "sectionTitle": "Section 2", "sectionSummary": "Section 2 summary", "sectionElements": [ { "elementId": "questionaaaaaaaa", "elementType": "question", "elementTitle": "Multiple choice question with single answer selection", "elementContent": [ { "questionId": "ssq3", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq3a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq3a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq3a3", "answerText": "A3", "answerCorrect": false } ] } ] } ] } ] }');
INSERT INTO exam_content (exam_id, content_version, content_language, content_jdoc) VALUES ('e4', 1.0::real, 'en', '{ "examTitle": "Test Exam 3", "examSummary": "Test Exam 3 summary", "examDescription": "Test Exam 3 description", "examSections": [ { "sectionId": "section1", "sectionTitle": "Section 1", "sectionSummary": "Section 1 summary", "sectionElements": [ { "elementId": "question1", "elementType": "question", "elementTitle": "Multiple choice question with single answer selection", "elementContent": [ { "questionId": "ssq1", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq1a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq1a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq1a3", "answerText": "A3", "answerCorrect": false } ] } ] }, { "elementId": "question2", "elementType": "question", "elementTitle": "Multiple choice question with multiple answer selection", "elementContent": [ { "questionId": "msq1", "questionType": "multipleSelectionQuestion", "questionText": "MSQ", "questionAnswers": [ { "answerId": "msq1a1", "answerText": "A1", "answerCorrect": true }, { "answerId": "msq1a2", "answerText": "A2", "answerCorrect": false }, { "answerId": "msq1a3", "answerText": "A3", "answerCorrect": false }, { "answerId": "msq1a4", "answerText": "A4", "answerCorrect": true } ] } ] }, { "elementId": "questiongroup1", "elementType": "question", "elementTitle": "Multiple questions", "elementContent": [ { "questionId": "ssq2", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq2a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq2a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq2a3", "answerText": "A3", "answerCorrect": false } ] }, { "questionId": "msq2", "questionType": "multipleSelectionQuestion", "questionText": "MSQ", "questionAnswers": [ { "answerId": "msq2a1", "answerText": "A1", "answerCorrect": true }, { "answerId": "msq2a2", "answerText": "A2", "answerCorrect": false }, { "answerId": "msq2a3", "answerText": "A3", "answerCorrect": false }, { "answerId": "msq2a4", "answerText": "A4", "answerCorrect": true } ] } ] } ] }, { "sectionId": "section2", "sectionTitle": "Section 2", "sectionSummary": "Section 2 summary", "sectionElements": [ { "elementId": "questionaaaaaaaa", "elementType": "question", "elementTitle": "Multiple choice question with single answer selection", "elementContent": [ { "questionId": "ssq3", "questionType": "singleSelectionQuestion", "questionText": "SSQ", "questionAnswers": [ { "answerId": "ssq3a1", "answerText": "A1", "answerCorrect": false }, { "answerId": "ssq3a2", "answerText": "A2", "answerCorrect": true }, { "answerId": "ssq3a3", "answerText": "A3", "answerCorrect": false } ] } ] } ] } ] }');

INSERT INTO course_exam_relationships (course_id, exam_id) VALUES ('c1', 'e1');
INSERT INTO course_exam_relationships (course_id, exam_id) VALUES ('c1', 'e2');
INSERT INTO course_exam_relationships (course_id, exam_id) VALUES ('c1', 'e3');
INSERT INTO course_exam_relationships (course_id, exam_id) VALUES ('c1', 'e4');

INSERT INTO user_course_assignments (user_id, course_id, completion_deadline, completion_tracking_period_start) VALUES ('u1', 'c1', '2024-12-31 23:59:59+09', '2024-01-01 00:00:00+09');
INSERT INTO user_course_assignments (user_id, course_id, completion_deadline, completion_tracking_period_start) VALUES ('u1', 'c2', '2024-12-31 23:59:59+09', '2024-01-01 00:00:00+09');
INSERT INTO user_course_assignments (user_id, course_id, completion_deadline, completion_tracking_period_start) VALUES ('u1', 'c3', '2024-12-31 23:59:59+09', '2024-01-01 00:00:00+09');
INSERT INTO user_course_progress (user_id, course_id, course_learning_version, course_learning_completed_at, completed_sections) VALUES ('u1', 'c1', 1.0::real, '2024-02-29 12:00:00+09', ARRAY['section1', 'section2', 'section3']);
INSERT INTO user_course_progress (user_id, course_id, course_learning_version) VALUES ('u1', 'c2', 1.0::real);
INSERT INTO user_exam_attempts (user_id, course_id, exam_id, exam_version, passed, score, started_at, finished_at, responses_jdoc) VALUES ('u1', 'c1', 'e1', 1.0::real, false, 0, '2024-02-29 12:01:00+09', '2024-02-29 12:15:00+09', '{"ssq1": "ssq1a1", "msq1": ["msq1a2"], "ssq2": "ssq2a3", "msq2": ["msq2a1", "msq2a3", "msq2a4"], "ssq3": "ssq3a3"}');
INSERT INTO user_exam_attempts (user_id, course_id, exam_id, exam_version, passed, score, started_at, finished_at, responses_jdoc) VALUES ('u1', 'c1', 'e1', 1.0::real, true, 5, '2024-02-29 12:30:00+09', '2024-02-29 13:00:00+09', '{"ssq1": "ssq1a2", "msq1": ["msq1a1", "msq1a4"], "ssq2": "ssq2a2", "msq2": ["msq2a1", "msq2a4"], "ssq3": "ssq3a2"}');


-- Queries
-- All assigned courses for a given user
SELECT uca.course_id FROM user_course_assignments uca WHERE enabled = true AND uca.user_id = 'u1';

-- Highest existing content version for a given course
SELECT MAX(cv.content_version) FROM course_versions cv WHERE cv.course_id = 'c1';

-- Metadata for all sections for all courses assigned to a given user
-- Table
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), highest_course_versions AS (
	SELECT DISTINCT ON (course_id)
			course_id,
			content_version
	FROM course_versions
	WHERE course_id IN (SELECT course_id FROM assigned_courses)
	ORDER BY course_id ASC, content_version DESC
), course_sections AS (
	SELECT cc.course_id,
			cc.content_version,
			json_build_object(
				'sectionId', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionId'::jsonpath),
				'sectionTitle', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionTitle'::jsonpath),
				'sectionSummary', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionSummary'::jsonpath)
			) AS section_metadata
	FROM course_content cc
	INNER JOIN highest_course_versions hcv
	ON (cc.course_id = hcv.course_id AND cc.content_version = hcv.content_version)
	WHERE cc.content_language = (SELECT preferred_language FROM user_preferred_language)
)
SELECT course_id,
		content_version,
		json_agg(section_metadata ORDER BY course_id ASC) AS course_sections
	FROM course_sections
	GROUP BY course_id, content_version
	ORDER BY course_id ASC;

-- JSON
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), highest_course_versions AS (
	SELECT DISTINCT ON (course_id)
			course_id,
			content_version
	FROM course_versions
	WHERE course_id IN (SELECT course_id FROM assigned_courses)
	ORDER BY course_id ASC, content_version DESC
), course_details AS (
	SELECT cc.course_id,
			cc.content_version,
			json_build_object(
				'sectionId', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionId'::jsonpath),
				'sectionTitle', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionTitle'::jsonpath),
				'sectionSummary', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionSummary'::jsonpath)
			) AS section_metadata
	FROM course_content cc
	INNER JOIN highest_course_versions hcv
	ON (cc.course_id = hcv.course_id AND cc.content_version = hcv.content_version)
	WHERE cc.content_language = (SELECT preferred_language FROM user_preferred_language)
)
SELECT json_build_object(
		'courseId', course_id,
		'courseVersion', content_version,
		'courseSections', json_agg(section_metadata ORDER BY course_id ASC)
	)
	FROM course_details
	GROUP BY course_id, content_version
	ORDER BY course_id ASC;

-- Completed sections for all courses assigned to a given user
WITH assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), highest_course_versions AS (
	SELECT DISTINCT ON (course_id)
			course_id,
			content_version
	FROM course_versions
	WHERE course_id IN (SELECT course_id FROM assigned_courses)
	ORDER BY course_id ASC, content_version DESC
)
SELECT hcv.course_id,
		hcv.content_version,
		ucp.course_learning_completed_at,
		ucp.completed_sections
	FROM highest_course_versions hcv
	LEFT JOIN user_course_progress ucp
	ON (hcv.course_id = ucp.course_id AND hcv.content_version = ucp.course_learning_version)
	ORDER BY hcv.course_id ASC;

-- Metadata for all sections plus section completion for all courses assigned to a given user
-- Table
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), highest_course_versions AS (
	SELECT DISTINCT ON (course_id)
			course_id,
			content_version	FROM course_versions
	WHERE course_id IN (SELECT course_id FROM assigned_courses)
	ORDER BY course_id ASC, content_version DESC
), section_completion AS (
	SELECT hcv.course_id,
			hcv.content_version,
			ucp.completed_sections
	FROM highest_course_versions hcv
	LEFT JOIN user_course_progress ucp
	ON (hcv.course_id = ucp.course_id AND hcv.content_version = ucp.course_learning_version)
), course_sections AS (
	SELECT cc.course_id,
			cc.content_version,
			jsonb_build_object(
				'sectionId', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionId'::jsonpath),
				'sectionTitle', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionTitle'::jsonpath),
				'sectionSummary', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionSummary'::jsonpath)
			) AS section_metadata
	FROM course_content cc
	INNER JOIN highest_course_versions hcv
	ON (cc.course_id = hcv.course_id AND cc.content_version = hcv.content_version)
	WHERE cc.content_language = (SELECT preferred_language FROM user_preferred_language)
), course_sections_and_completion AS (
	SELECT cc.course_id,
			cc.content_version,
			jsonb_set(cc.section_metadata, '{sectionCompleted}', to_jsonb(COALESCE((SELECT cc.section_metadata->>'sectionId' = ANY(sc.completed_sections)), false))) AS section_details
	FROM course_sections cc
	LEFT JOIN section_completion sc
	ON (cc.course_id = sc.course_id AND cc.content_version = sc.content_version)
	GROUP BY cc.course_id,
			cc.content_version,
			cc.section_metadata,
			sc.completed_sections
)
SELECT course_id,
		content_version,
		json_agg(section_details ORDER BY course_id ASC) AS course_sections
	FROM course_sections_and_completion
	GROUP BY course_id, content_version
	ORDER BY course_id ASC;

-- JSON
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), highest_course_versions AS (
	SELECT DISTINCT ON (course_id)
			course_id,
			content_version	FROM course_versions
	WHERE course_id IN (SELECT course_id FROM assigned_courses)
	ORDER BY course_id ASC, content_version DESC
), section_completion AS (
	SELECT hcv.course_id,
			hcv.content_version,
			ucp.completed_sections
	FROM highest_course_versions hcv
	LEFT JOIN user_course_progress ucp
	ON (hcv.course_id = ucp.course_id AND hcv.content_version = ucp.course_learning_version)
), course_sections AS (
	SELECT cc.course_id,
			cc.content_version,
			jsonb_build_object(
				'sectionId', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionId'::jsonpath),
				'sectionTitle', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionTitle'::jsonpath),
				'sectionSummary', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionSummary'::jsonpath)
			) AS section_metadata
	FROM course_content cc
	INNER JOIN highest_course_versions hcv
	ON (cc.course_id = hcv.course_id AND cc.content_version = hcv.content_version)
	WHERE cc.content_language = (SELECT preferred_language FROM user_preferred_language)
), course_sections_and_completion AS (
	SELECT cc.course_id,
			cc.content_version,
			jsonb_set(cc.section_metadata, '{sectionCompleted}', to_jsonb(COALESCE((SELECT cc.section_metadata->>'sectionId' = ANY(sc.completed_sections)), false))) AS section_details
	FROM course_sections cc
	LEFT JOIN section_completion sc
	ON (cc.course_id = sc.course_id AND cc.content_version = sc.content_version)
	GROUP BY cc.course_id,
			cc.content_version,
			cc.section_metadata,
			sc.completed_sections
)
SELECT json_build_object(
		'courseId', course_id,
		'courseVersion', content_version,
		'courseSections', json_agg(section_details ORDER BY course_id ASC)
	)
	FROM course_sections_and_completion
	GROUP BY course_id, content_version
	ORDER BY course_id ASC;

-- Course content once 'Start course' clicked from course list
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), highest_course_version AS (
	SELECT MAX(cv.content_version) AS content_version
	FROM course_versions cv
	WHERE cv.course_id = 'c1'
)
SELECT cc.content_jdoc
	FROM course_content cc
	WHERE cc.course_id = 'c1'
	AND cc.content_version = (SELECT content_version FROM highest_course_version)
	AND cc.content_language = (SELECT preferred_language FROM user_preferred_language);

-- Course content with completed sections
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), highest_course_version AS (
	SELECT MAX(cv.content_version) AS content_version
	FROM course_versions cv
	WHERE cv.course_id = 'c1'
), course_content AS (
SELECT course_id,
        content_version,
        content_jdoc
	FROM course_content
	WHERE course_id = 'c1'
    AND course_id IN (SELECT course_id FROM assigned_courses)
	AND content_version = (SELECT content_version FROM highest_course_version)
	AND content_language = (SELECT preferred_language FROM user_preferred_language)
), course_section_completion AS (
SELECT course_id,
        course_learning_version,
        completed_sections
    FROM user_course_progress
	WHERE course_id = 'c1'
    AND course_learning_version = (SELECT content_version FROM highest_course_version)
    AND user_id = 'u1'
)
SELECT jsonb_build_object(
            'courseContent', cc.content_jdoc,
            'courseCompletedSections', csc.completed_sections
        )
    FROM course_content cc
    LEFT JOIN course_section_completion csc
	ON (cc.course_id = csc.course_id AND cc.content_version = csc.course_learning_version);

-- All exams for assigned courses for a given user
WITH assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
)
SELECT cer.exam_id
	FROM course_exam_relationships cer
	WHERE enabled = true
	AND cer.course_id IN (SELECT course_id FROM assigned_courses);

-- All exams for a given course
SELECT ce.exam_id FROM course_exam_relationships ce WHERE enabled = true AND ce.course_id = 'c1';

-- Highest content version for all exams for all courses assigned to a given user
WITH assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), assigned_exams AS (
	SELECT exam_id
	FROM course_exam_relationships
	WHERE enabled = true
	AND course_id IN (SELECT course_id FROM assigned_courses)
)
SELECT DISTINCT ON (ev.exam_id)
		ev.exam_id,
		ev.content_version
	FROM exam_versions ev
	WHERE ev.exam_id IN (SELECT exam_id FROM assigned_exams)
	ORDER BY ev.exam_id ASC, ev.content_version DESC;

-- Top-level JSON metadata with exam version related metadata for all exams linked to all assigned courses for a given user
-- Table
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), assigned_exams AS (
	SELECT exam_id
	FROM course_exam_relationships
	WHERE enabled = true
	AND course_id IN (SELECT course_id FROM assigned_courses)
), highest_exam_versions AS (
	SELECT DISTINCT ON (exam_id)
			exam_id,
			content_version,
			pass_mark,
			estimated_completion_time
	FROM exam_versions
	WHERE exam_id IN (SELECT exam_id FROM assigned_exams)
	ORDER BY exam_id ASC, content_version DESC
)
SELECT ec.exam_id,
		ec.content_version,
		ec.content_jdoc->>'examTitle' AS exam_title,
		ec.content_jdoc->>'examSummary' AS exam_summary,
		ec.content_jdoc->>'examDescription' AS exam_description,
		hev.pass_mark,
		hev.estimated_completion_time
	FROM exam_content ec
	INNER JOIN highest_exam_versions hev
	ON (ec.exam_id = hev.exam_id AND ec.content_version = hev.content_version)
	WHERE ec.content_language = (SELECT preferred_language FROM user_preferred_language)
	ORDER BY ec.exam_id ASC;

-- JSON
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), assigned_exams AS (
	SELECT exam_id
	FROM course_exam_relationships
	WHERE enabled = true
	AND course_id IN (SELECT course_id FROM assigned_courses)
), highest_exam_versions AS (
	SELECT DISTINCT ON (exam_id)
			exam_id,
			content_version,
			pass_mark,
			estimated_completion_time
	FROM exam_versions
	WHERE exam_id IN (SELECT exam_id FROM assigned_exams)
	ORDER BY exam_id ASC, content_version DESC
)
SELECT json_build_object(
		'examId', ec.exam_id,
		'examVersion', ec.content_version,
		'examTitle', ec.content_jdoc->>'examTitle',
		'examSummary', ec.content_jdoc->>'examSummary',
		'examDescription', ec.content_jdoc->>'examDescription',
		'examPassMark', hev.pass_mark,
		'examEstimatedCompletionTime', hev.estimated_completion_time
	)
	FROM exam_content ec
	INNER JOIN highest_exam_versions hev
	ON (ec.exam_id = hev.exam_id AND ec.content_version = hev.content_version)
	WHERE ec.content_language = (SELECT preferred_language FROM user_preferred_language)
	ORDER BY ec.exam_id ASC;

-- All passed exams of latest versions for a given user
WITH assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), assigned_exams AS (
	SELECT exam_id
	FROM course_exam_relationships
	WHERE enabled = true
	AND course_id IN (SELECT course_id FROM assigned_courses)
), highest_exam_versions AS (
	SELECT exam_id,
			MAX(content_version) AS content_version
	FROM exam_versions
	WHERE exam_id IN (SELECT exam_id FROM assigned_exams)
	GROUP BY exam_id
)
SELECT uea.exam_id,
	uea.exam_version
	FROM user_exam_attempts uea
	INNER JOIN highest_exam_versions hev
	ON (uea.exam_id = hev.exam_id AND uea.exam_version = hev.content_version)
	WHERE uea.user_id = 'u1'
    AND uea.passed = true
	GROUP BY uea.exam_id, uea.exam_version
	ORDER BY uea.exam_id ASC;

-- Top-level exam JSON metadata with exam version related metadata plus exam completion status for all exams linked to all assigned courses for a given user
-- Table
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), assigned_exams AS (
	SELECT exam_id
	FROM course_exam_relationships
	WHERE enabled = true
	AND course_id IN (SELECT course_id FROM assigned_courses)
), exam_assignment_deadlines AS (
	SELECT cer.exam_id,
			uca.completion_deadline,
			uca.completion_tracking_period_start
	FROM user_course_assignments uca
	INNER JOIN course_exam_relationships cer
	ON (uca.course_id = cer.course_id)
	WHERE uca.enabled = true
	AND cer.enabled = true
), highest_exam_versions AS (
	SELECT DISTINCT ON (exam_id)
			exam_id,
			content_version,
			pass_mark,
			estimated_completion_time
	FROM exam_versions
	WHERE exam_id IN (SELECT exam_id FROM assigned_exams)
	ORDER BY exam_id ASC, content_version DESC
), exam_details AS (
	SELECT ec.exam_id,
			ec.content_version,
			ec.content_jdoc->>'examTitle' AS exam_title,
			ec.content_jdoc->>'examSummary' AS exam_summary,
			ec.content_jdoc->>'examDescription' AS exam_description,
			hev.pass_mark,
			hev.estimated_completion_time
	FROM exam_content ec
	INNER JOIN highest_exam_versions hev
	ON (ec.exam_id = hev.exam_id AND ec.content_version = hev.content_version)
	WHERE ec.content_language = (SELECT preferred_language FROM user_preferred_language)
), exam_completion AS (
	SELECT DISTINCT ON (uea.exam_id)
			uea.exam_id,
			uea.exam_version,
			uea.passed
	FROM user_exam_attempts uea
	INNER JOIN highest_exam_versions hev
	ON (uea.exam_id = hev.exam_id AND uea.exam_version = hev.content_version)
	INNER JOIN exam_assignment_deadlines ead
	ON (uea.exam_id = ead.exam_id)
	WHERE uea.user_id = 'u1'
    AND uea.passed = true
	AND uea.finished_at <= ead.completion_deadline
	AND uea.finished_at >= ead.completion_tracking_period_start
-- 	AND uea.finished_at <= '2003-01-01 00:00:00+09'::timestamptz
-- 	AND uea.finished_at >= '2000-01-01 00:00:00+09'::timestamptz
	ORDER BY uea.exam_id ASC, uea.exam_version DESC
)
SELECT ed.exam_id,
		ed.content_version,
		ed.exam_title,
		ed.exam_summary,
		ed.exam_description,
		ed.pass_mark,
		ed.estimated_completion_time,
		COALESCE(ec.passed, false) AS passed
	FROM exam_details ed
	LEFT JOIN exam_completion ec
	ON (ed.exam_id = ec.exam_id AND ed.content_version = ec.exam_version)
	GROUP BY ed.exam_id,
			ed.content_version,
			ed.exam_title,
			ed.exam_summary,
			ed.exam_description,
			ed.pass_mark,
			ed.estimated_completion_time,
			ec.passed
	ORDER BY ed.exam_id ASC;

-- JSON
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), assigned_exams AS (
	SELECT exam_id
	FROM course_exam_relationships
	WHERE enabled = true
	AND course_id IN (SELECT course_id FROM assigned_courses)
), exam_assignment_deadlines AS (
	SELECT cer.exam_id,
			uca.completion_deadline,
			uca.completion_tracking_period_start
	FROM user_course_assignments uca
	INNER JOIN course_exam_relationships cer
	ON (uca.course_id = cer.course_id)
	WHERE uca.enabled = true
	AND cer.enabled = true
), highest_exam_versions AS (
	SELECT DISTINCT ON (exam_id)
			exam_id,
			content_version,
			pass_mark,
			estimated_completion_time
	FROM exam_versions
	WHERE exam_id IN (SELECT exam_id FROM assigned_exams)
	ORDER BY exam_id ASC, content_version DESC
), exam_details AS (
	SELECT ec.exam_id,
			ec.content_version,
			ec.content_jdoc->>'examTitle' AS exam_title,
			ec.content_jdoc->>'examSummary' AS exam_summary,
			ec.content_jdoc->>'examDescription' AS exam_description,
			hev.pass_mark,
			hev.estimated_completion_time
	FROM exam_content ec
	INNER JOIN highest_exam_versions hev
	ON (ec.exam_id = hev.exam_id AND ec.content_version = hev.content_version)
	WHERE ec.content_language = (SELECT preferred_language FROM user_preferred_language)
), exam_completion AS (
	SELECT DISTINCT ON (uea.exam_id)
			uea.exam_id,
			uea.exam_version,
			uea.passed
	FROM user_exam_attempts uea
	INNER JOIN highest_exam_versions hev
	ON (uea.exam_id = hev.exam_id AND uea.exam_version = hev.content_version)
	INNER JOIN exam_assignment_deadlines ead
	ON (uea.exam_id = ead.exam_id)
    WHERE uea.user_id = 'u1'
	AND uea.passed = true
	AND uea.finished_at <= ead.completion_deadline
	AND uea.finished_at >= ead.completion_tracking_period_start
-- 	AND uea.finished_at <= '2003-01-01 00:00:00+09'::timestamptz
-- 	AND uea.finished_at >= '2000-01-01 00:00:00+09'::timestamptz
	ORDER BY uea.exam_id ASC, uea.exam_version DESC
)
SELECT json_build_object(
		'examId', ed.exam_id,
		'examVersion', ed.content_version,
		'examTitle', ed.exam_title,
		'examSummary', ed.exam_summary,
		'examDescription', ed.exam_description,
		'examPassMark', ed.pass_mark,
		'examEstimatedCompletionTime', ed.estimated_completion_time,
		'examPassed', COALESCE(ec.passed, false)
	)
	FROM exam_details ed
	LEFT JOIN exam_completion ec
	ON (ed.exam_id = ec.exam_id AND ed.content_version = ec.exam_version)
	GROUP BY ed.exam_id,
			ed.content_version,
			ed.exam_title,
			ed.exam_summary,
			ed.exam_description,
			ed.pass_mark,
			ed.estimated_completion_time,
			ec.passed
	ORDER BY ed.exam_id ASC;

-- Exam content once 'Start exam' clicked from course list
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), highest_exam_version AS (
	SELECT MAX(ev.content_version) AS content_version
	FROM exam_versions ev
	WHERE ev.exam_id = 'e1'
)
SELECT ec.content_jdoc
	FROM exam_content ec
	WHERE ec.exam_id = 'e1'
	AND ec.content_version = (SELECT content_version FROM highest_exam_version)
	AND ec.content_language = (SELECT preferred_language FROM user_preferred_language);

-- Course and exam metadata with completion for all assigned courses/exams for a given user
-- Table
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), highest_course_versions AS (
	SELECT DISTINCT ON (course_id)
			course_id,
			content_version	FROM course_versions
	WHERE course_id IN (SELECT course_id FROM assigned_courses)
	ORDER BY course_id ASC, content_version DESC
), section_completion AS (
	SELECT hcv.course_id,
			hcv.content_version,
			ucp.completed_sections
	FROM highest_course_versions hcv
	LEFT JOIN user_course_progress ucp
	ON (hcv.course_id = ucp.course_id AND hcv.content_version = ucp.course_learning_version)
), course_sections AS (
	SELECT cc.course_id,
			cc.content_version,
			jsonb_build_object(
				'sectionId', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionId'::jsonpath),
				'sectionTitle', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionTitle'::jsonpath),
				'sectionSummary', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionSummary'::jsonpath)
			) AS section_metadata
	FROM course_content cc
	INNER JOIN highest_course_versions hcv
	ON (cc.course_id = hcv.course_id AND cc.content_version = hcv.content_version)
	WHERE cc.content_language = (SELECT preferred_language FROM user_preferred_language)
), course_sections_and_completion AS (
	SELECT cs.course_id,
			cs.content_version,
			jsonb_set(cs.section_metadata, '{sectionCompleted}', to_jsonb(COALESCE((SELECT cs.section_metadata->>'sectionId' = ANY(sc.completed_sections)), false))) AS section_details
	FROM course_sections cs
	LEFT JOIN section_completion sc
	ON (cs.course_id = sc.course_id AND cs.content_version = sc.content_version)
	GROUP BY cs.course_id,
			cs.content_version,
			cs.section_metadata,
			sc.completed_sections
	ORDER BY cs.course_id
), assigned_exams AS (
	SELECT course_id,
			exam_id
	FROM course_exam_relationships
	WHERE enabled = true
	AND course_id IN (SELECT course_id FROM assigned_courses)
), exam_assignment_deadlines AS (
	SELECT cer.exam_id,
			uca.completion_deadline,
			uca.completion_tracking_period_start
	FROM user_course_assignments uca
	INNER JOIN course_exam_relationships cer
	ON (uca.course_id = cer.course_id)
	WHERE uca.enabled = true
	AND cer.enabled = true
), highest_exam_versions AS (
	SELECT DISTINCT ON (exam_id)
			exam_id,
			content_version,
			pass_mark,
			estimated_completion_time
	FROM exam_versions
	WHERE exam_id IN (SELECT exam_id FROM assigned_exams)
	ORDER BY exam_id ASC, content_version DESC
), exam_details AS (
	SELECT ec.exam_id,
			ec.content_version,
			ec.content_jdoc->>'examTitle' AS exam_title,
			ec.content_jdoc->>'examSummary' AS exam_summary,
			ec.content_jdoc->>'examDescription' AS exam_description,
			hev.pass_mark,
			hev.estimated_completion_time
	FROM exam_content ec
	INNER JOIN highest_exam_versions hev
	ON (ec.exam_id = hev.exam_id AND ec.content_version = hev.content_version)
	WHERE ec.content_language = (SELECT preferred_language FROM user_preferred_language)
), exam_completion AS (
	SELECT DISTINCT ON (uea.exam_id)
			uea.exam_id,
			uea.exam_version,
			uea.passed
	FROM user_exam_attempts uea
	INNER JOIN highest_exam_versions hev
	ON (uea.exam_id = hev.exam_id AND uea.exam_version = hev.content_version)
	INNER JOIN exam_assignment_deadlines ead
	ON (uea.exam_id = ead.exam_id)
    WHERE uea.user_id = 'u1'
	AND uea.passed = true
	AND uea.finished_at <= ead.completion_deadline
	AND uea.finished_at >= ead.completion_tracking_period_start
	ORDER BY uea.exam_id ASC, uea.exam_version DESC
), exam_details_and_completion AS (
	SELECT ae.course_id,
			jsonb_build_object(
				'examId', ed.exam_id,
				'examVersion', ed.content_version,
				'examTitle', ed.exam_title,
				'examSummary', ed.exam_summary,
				'examDescription', ed.exam_description,
				'examPassMark', ed.pass_mark,
				'examEstimatedCompletionTime', ed.estimated_completion_time,
				'examPassed', COALESCE(ec.passed, false)
			) AS exam_details_and_completion
	FROM exam_details ed
	INNER JOIN assigned_exams ae
	ON (ed.exam_id = ae.exam_id)
	LEFT JOIN exam_completion ec
	ON (ed.exam_id = ec.exam_id AND ed.content_version = ec.exam_version)
	GROUP BY ae.course_id,
			ed.exam_id,
			ed.content_version,
			ed.exam_title,
			ed.exam_summary,
			ed.exam_description,
			ed.pass_mark,
			ed.estimated_completion_time,
			ec.passed
	ORDER BY ed.exam_id ASC
), course_exams AS (
	SELECT edac.course_id,
		jsonb_agg(edac.exam_details_and_completion ORDER BY edac.course_id ASC) AS course_exams
	FROM exam_details_and_completion edac
	GROUP BY edac.course_id
	ORDER BY edac.course_id
)
SELECT csac.course_id,
		csac.content_version,
        cc.content_jdoc->>'courseTitle' AS course_title,
        cc.content_jdoc->>'courseSummary' AS course_summary,
        cc.content_jdoc->>'courseDescription' AS course_description,
		jsonb_agg(csac.section_details ORDER BY csac.course_id ASC) AS course_sections,
		ce.course_exams
	FROM course_sections_and_completion csac
    INNER JOIN course_content cc
    ON (csac.course_id = cc.course_id AND csac.content_version = cc.content_version)
	INNER JOIN course_exams ce
	ON (csac.course_id = ce.course_id)
    WHERE cc.content_language = (SELECT preferred_language FROM user_preferred_language)
	GROUP BY csac.course_id,
            csac.content_version,
            cc.content_jdoc,
            ce.course_exams
	ORDER BY csac.course_id ASC;

-- JSON
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = 'u1'
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = 'u1'
), highest_course_versions AS (
	SELECT DISTINCT ON (course_id)
			course_id,
			content_version	FROM course_versions
	WHERE course_id IN (SELECT course_id FROM assigned_courses)
	ORDER BY course_id ASC, content_version DESC
), section_completion AS (
	SELECT hcv.course_id,
			hcv.content_version,
			ucp.completed_sections
	FROM highest_course_versions hcv
	LEFT JOIN user_course_progress ucp
	ON (hcv.course_id = ucp.course_id AND hcv.content_version = ucp.course_learning_version)
), course_sections AS (
	SELECT cc.course_id,
			cc.content_version,
			jsonb_build_object(
				'sectionId', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionId'::jsonpath),
				'sectionTitle', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionTitle'::jsonpath),
				'sectionSummary', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionSummary'::jsonpath)
			) AS section_metadata
	FROM course_content cc
	INNER JOIN highest_course_versions hcv
	ON (cc.course_id = hcv.course_id AND cc.content_version = hcv.content_version)
	WHERE cc.content_language = (SELECT preferred_language FROM user_preferred_language)
), course_sections_and_completion AS (
	SELECT cs.course_id,
			cs.content_version,
			jsonb_set(cs.section_metadata, '{sectionCompleted}', to_jsonb(COALESCE((SELECT cs.section_metadata->>'sectionId' = ANY(sc.completed_sections)), false))) AS section_details
	FROM course_sections cs
	LEFT JOIN section_completion sc
	ON (cs.course_id = sc.course_id AND cs.content_version = sc.content_version)
	GROUP BY cs.course_id,
			cs.content_version,
			cs.section_metadata,
			sc.completed_sections
	ORDER BY cs.course_id
), assigned_exams AS (
	SELECT course_id,
			exam_id
	FROM course_exam_relationships
	WHERE enabled = true
	AND course_id IN (SELECT course_id FROM assigned_courses)
), exam_assignment_deadlines AS (
	SELECT cer.exam_id,
			uca.completion_deadline,
			uca.completion_tracking_period_start
	FROM user_course_assignments uca
	INNER JOIN course_exam_relationships cer
	ON (uca.course_id = cer.course_id)
	WHERE uca.enabled = true
	AND cer.enabled = true
), highest_exam_versions AS (
	SELECT DISTINCT ON (exam_id)
			exam_id,
			content_version,
			pass_mark,
			estimated_completion_time
	FROM exam_versions
	WHERE exam_id IN (SELECT exam_id FROM assigned_exams)
	ORDER BY exam_id ASC, content_version DESC
), exam_details AS (
	SELECT ec.exam_id,
			ec.content_version,
			ec.content_jdoc->>'examTitle' AS exam_title,
			ec.content_jdoc->>'examSummary' AS exam_summary,
			ec.content_jdoc->>'examDescription' AS exam_description,
			hev.pass_mark,
			hev.estimated_completion_time
	FROM exam_content ec
	INNER JOIN highest_exam_versions hev
	ON (ec.exam_id = hev.exam_id AND ec.content_version = hev.content_version)
	WHERE ec.content_language = (SELECT preferred_language FROM user_preferred_language)
), exam_completion AS (
	SELECT DISTINCT ON (uea.exam_id)
			uea.exam_id,
			uea.exam_version,
			uea.passed
	FROM user_exam_attempts uea
	INNER JOIN highest_exam_versions hev
	ON (uea.exam_id = hev.exam_id AND uea.exam_version = hev.content_version)
	INNER JOIN exam_assignment_deadlines ead
	ON (uea.exam_id = ead.exam_id)
    WHERE uea.user_id = 'u1'
	AND uea.passed = true
	AND uea.finished_at <= ead.completion_deadline
	AND uea.finished_at >= ead.completion_tracking_period_start
	ORDER BY uea.exam_id ASC, uea.exam_version DESC
), exam_details_and_completion AS (
	SELECT ae.course_id,
			jsonb_build_object(
				'examId', ed.exam_id,
				'examVersion', ed.content_version,
				'examTitle', ed.exam_title,
				'examSummary', ed.exam_summary,
				'examDescription', ed.exam_description,
				'examPassMark', ed.pass_mark,
				'examEstimatedCompletionTime', ed.estimated_completion_time,
				'examPassed', COALESCE(ec.passed, false)
			) AS exam_details_and_completion
	FROM exam_details ed
	INNER JOIN assigned_exams ae
	ON (ed.exam_id = ae.exam_id)
	LEFT JOIN exam_completion ec
	ON (ed.exam_id = ec.exam_id AND ed.content_version = ec.exam_version)
	GROUP BY ae.course_id,
			ed.exam_id,
			ed.content_version,
			ed.exam_title,
			ed.exam_summary,
			ed.exam_description,
			ed.pass_mark,
			ed.estimated_completion_time,
			ec.passed
	ORDER BY ed.exam_id ASC
), course_exams AS (
	SELECT edac.course_id,
		jsonb_agg(edac.exam_details_and_completion ORDER BY edac.course_id ASC) AS course_exams
	FROM exam_details_and_completion edac
	GROUP BY edac.course_id
	ORDER BY edac.course_id
)
SELECT jsonb_build_object(
			'courseId', csac.course_id,
			'courseVersion', csac.content_version,
            'courseTitle', cc.content_jdoc->>'courseTitle',
            'courseSummary', cc.content_jdoc->>'courseSummary',
            'courseDescription', cc.content_jdoc->>'courseDescription',
			'courseSections', jsonb_agg(csac.section_details ORDER BY csac.course_id ASC),
			'courseExams', ce.course_exams
		)
	FROM course_sections_and_completion csac
    INNER JOIN course_content cc
    ON (csac.course_id = cc.course_id AND csac.content_version = cc.content_version)
	INNER JOIN course_exams ce
	ON (csac.course_id = ce.course_id)
    WHERE cc.content_language = (SELECT preferred_language FROM user_preferred_language)
	GROUP BY csac.course_id,
            csac.content_version,
            cc.content_jdoc,
            ce.course_exams
	ORDER BY csac.course_id ASC;


-- Misc JSON
SELECT content_jdoc->'examSections' AS content FROM exams WHERE exam_id = 'e1';

SELECT jsonb_array_elements((SELECT jdoc->'examSections' FROM test1 WHERE id = 1));
SELECT value->>'sectionTitle' AS section_title, value->>'sectionSummary' AS section_summary FROM jsonb_array_elements((SELECT jdoc->'examSections' FROM test1 WHERE id = 1));

SELECT jsonb_path_query((SELECT jdoc->'examSections' FROM test1 WHERE id = 1), '$.sectionElements.elementContent');
SELECT jsonb_path_query((SELECT jdoc->'examSections' FROM test1 WHERE id = 1), '$.sectionId');
SELECT jsonb_path_query((SELECT jdoc FROM test1 WHERE id = 1), '$.examSections[*].sectionId');

SELECT a.section_id, b.section_title FROM test1 j, jsonb_path_query(j.jdoc, '$.examSections[*].sectionId'::jsonpath) a(section_id), jsonb_path_query(j.jdoc, '$.examSections[*].sectionTitle'::jsonpath) b(section_title) WHERE id = 1;

SELECT jsonb_path_query_array((SELECT jdoc->'examSections' FROM test1 WHERE id = 1), '$.sectionElements.elementContent.questionId');
SELECT jsonb_path_query_array((SELECT jdoc->'examSections' FROM test1 WHERE id = 1), '$[*].sectionElements.elementContent.questionId') @> '["ssq1","msq1","ssq2","msq2","ssq3"]'::jsonb;

SELECT jsonb_path_query_array((SELECT jdoc->'examSections' FROM test1 WHERE id = 1), '$[*].sectionId');
SELECT jsonb_path_query_array((SELECT jdoc->'examSections' FROM test1 WHERE id = 1), '$[*].sectionId') @> '["section1","section2","section3"]'::jsonb;