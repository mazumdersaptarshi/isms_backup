String query15 = '''
WITH domainUsers AS
(SELECT user_id, given_name, family_name FROM users 
WHERE domain_id = 'domain01'
ORDER BY user_id ASC )

SELECT json_build_object('userId', du.user_id,
						'givenName', du.given_name,
						 'familyName', du.family_name
						) AS domain_users_json
FROM domainUsers du
''';
