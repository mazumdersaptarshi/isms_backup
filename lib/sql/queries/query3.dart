String query3 = '''
WITH user_profile_details AS (SELECT user_id, account_role, given_name, family_name, email, last_login FROM users
WHERE user_id = {0})

SELECT json_build_object('userId', upd.user_id, 
						'accountRole', upd.account_role,
						 'givenName', upd.given_name,
						 'familyName', upd.family_name,
						 'email', upd.email, 
						 'lastLogin', upd.last_login
						) as user_profile_json
						
FROM user_profile_details upd
''';
