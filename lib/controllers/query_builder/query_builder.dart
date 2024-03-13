class QueryBuilder {
  String queryTemplate;
  List<dynamic>? inputs;

  QueryBuilder({required this.queryTemplate, this.inputs});

  /// Builds an SQL query string from a template and a list of inputs.
  ///
  /// This function replaces placeholders in the SQL template with values
  /// from the `inputs` list. Placeholders in the template should be formatted
  /// like {0}, {1}, {2}, etc., corresponding to the index of the value in the
  /// `inputs` list.
  ///
  /// Args:
  ///   template (String): The SQL query template containing placeholders.
  ///   inputs (List<dynamic>): A list of values to replace the placeholders in the template.
  ///
  /// Returns:
  ///   String: The final SQL query with all placeholders replaced by actual values.
  ///
  /// Example:
  ///   String template = "SELECT * FROM avg_scores WHERE score <= {0} AND course_id = {1}";
  ///   List<dynamic> inputs = [70, 'ip78hd'];
  ///   String query = buildSqlQuery(template, inputs);
  ///   // query will be "SELECT * FROM avg_scores WHERE score <=  70 AND course_id = 'ip78hd' "
  ///
  static String buildSqlQuery(String template, List<dynamic> inputs) {
    // This will hold the final query.
    String query = template;

    // Loop through each input to replace placeholders in the template.
    for (int i = 0; i < inputs.length; i++) {
      // Create a pattern for each placeholder based on its index.
      String placeholder = '{$i}';

      // Replace the placeholder with the corresponding input.
      // Strings are enclosed in single quotes, while other types are converted to string directly.
      String replacement = inputs[i] is String ? "'${inputs[i]}'" : inputs[i].toString();
      query = query.replaceAll(placeholder, replacement);
    }

    return query; // Return the final SQL query.
  }
}
