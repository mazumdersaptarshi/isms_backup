-- Types
CREATE TYPE account_role AS ENUM ('admin', 'user');
CREATE TYPE content_language AS ENUM ('en', 'ja');
CREATE TYPE app_theme AS ENUM ('light', 'dark');


-- Tables
CREATE TABLE IF NOT EXISTS domains
(
    domain_id text PRIMARY KEY,
    enabled boolean NOT NULL DEFAULT true,
    company_name text NOT NULL,
    primary_admin_given_name text NOT NULL,
    primary_admin_family_name text NOT NULL,
    primary_admin_email text NOT NULL,
    primary_admin_other_contact_details text NOT NULL,
    secondary_admin_given_name text NOT NULL,
    secondary_admin_family_name text NOT NULL,
    secondary_admin_email text NOT NULL,
    secondary_admin_other_contact_details text NOT NULL,
    note text,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL
);

CREATE TABLE IF NOT EXISTS users
(
    user_id text PRIMARY KEY,
    domain_id text NOT NULL REFERENCES domains (domain_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    enabled boolean NOT NULL DEFAULT true,
    account_role account_role NOT NULL,
    given_name text NOT NULL,
    family_name text NOT NULL,
    email text NOT NULL,
    last_login timestamptz,
    note text,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL
);

CREATE TABLE IF NOT EXISTS user_settings
(
    user_id text NOT NULL REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    preferred_language content_language NOT NULL,
    app_theme app_theme NOT NULL,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL
);

CREATE TABLE IF NOT EXISTS courses
(
    course_id text PRIMARY KEY,
    enabled boolean NOT NULL DEFAULT true,
    note text,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL
);

CREATE TABLE IF NOT EXISTS course_versions
(
    course_id text NOT NULL REFERENCES courses (course_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    content_version real NOT NULL CONSTRAINT valid_content_version CHECK (content_version > 0::real),
    note text,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL,
    PRIMARY KEY (course_id, content_version)
);

CREATE TABLE IF NOT EXISTS course_content
(
    course_id text NOT NULL,
    content_version real NOT NULL,
    content_language content_language NOT NULL,
    content_jdoc jsonb NOT NULL,
    note text,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL,
    PRIMARY KEY (course_id, content_version, content_language),
    FOREIGN KEY (course_id, content_version) REFERENCES course_versions (course_id, content_version) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS exams
(
    exam_id text PRIMARY KEY,
    enabled boolean NOT NULL DEFAULT true,
    note text,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL
);

CREATE TABLE IF NOT EXISTS exam_versions
(
    exam_id text NOT NULL REFERENCES exams (exam_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    content_version real NOT NULL CONSTRAINT valid_content_version CHECK (content_version > 0::real),
    pass_mark integer NOT NULL CONSTRAINT valid_pass_mark CHECK (pass_mark > 0::integer),
    estimated_completion_time interval HOUR TO MINUTE NOT NULL CONSTRAINT valid_estimated_completion_time CHECK (estimated_completion_time > '0'::interval),
    note text,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL,
    PRIMARY KEY (exam_id, content_version)
);

CREATE TABLE IF NOT EXISTS exam_content
(
    exam_id text NOT NULL,
    content_version real NOT NULL,
    content_language content_language NOT NULL,
    content_jdoc jsonb NOT NULL,
    note text,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL,
    PRIMARY KEY (exam_id, content_version, content_language),
    FOREIGN KEY (exam_id, content_version) REFERENCES exam_versions (exam_id, content_version) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS course_exam_relationships
(
    course_id text NOT NULL REFERENCES courses (course_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    exam_id text NOT NULL REFERENCES exams (exam_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    enabled boolean NOT NULL DEFAULT true,
    note text,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL,
    PRIMARY KEY (course_id, exam_id)
);

CREATE TABLE IF NOT EXISTS domain_course_assignments
(
    domain_id text NOT NULL REFERENCES domains (domain_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    course_id text NOT NULL REFERENCES courses (course_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    enabled boolean NOT NULL DEFAULT true,
    note text,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL,
    PRIMARY KEY (domain_id, course_id)
);

CREATE TABLE IF NOT EXISTS user_course_assignments
(
    user_id text NOT NULL REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    course_id text NOT NULL REFERENCES courses (course_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    enabled boolean NOT NULL DEFAULT true,
    completion_deadline timestamptz NOT NULL CONSTRAINT valid_completion_deadline CHECK (completion_deadline > now()),
    completion_tracking_period_start timestamptz NOT NULL DEFAULT now(),
    recurring_completion_required_interval interval YEAR TO MONTH CONSTRAINT valid_recurring_completion_required_interval CHECK (recurring_completion_required_interval > '0'::interval),
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL,
    PRIMARY KEY (user_id, course_id),
    CONSTRAINT valid_tracking_time_range CHECK (completion_tracking_period_start < completion_deadline)
);

CREATE TABLE IF NOT EXISTS user_course_progress
(
    user_id text NOT NULL REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    course_id text NOT NULL,
    course_learning_version real NOT NULL,
    course_learning_completed_at timestamptz,
    completed_sections text[],
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL,
    PRIMARY KEY (user_id, course_id, course_learning_version),
    FOREIGN KEY (course_id, course_learning_version) REFERENCES course_versions (course_id, content_version) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS user_exam_attempts
(
    attempt_id serial NOT NULL,
    user_id text NOT NULL REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    course_id text NOT NULL REFERENCES courses (course_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    exam_id text NOT NULL,
    exam_version real NOT NULL,
    passed boolean NOT NULL,
    score integer NOT NULL CONSTRAINT positive_score CHECK (score >= 0::integer),
    started_at timestamptz NOT NULL,
    finished_at timestamptz NOT NULL,
    responses_jdoc jsonb,
    row_created_at timestamptz NOT NULL,
    row_created_by text NOT NULL,
    row_modified_at timestamptz NOT NULL,
    row_modified_by text NOT NULL,
    PRIMARY KEY (attempt_id, user_id, course_id, exam_id),
	FOREIGN KEY (exam_id, exam_version) REFERENCES exam_versions (exam_id, content_version) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT valid_attempt_time_range CHECK (started_at < finished_at)
);


-- Indices
-- domains
CREATE INDEX domains_domain_id_index ON domains (domain_id);
CREATE INDEX domains_enabled_index ON domains (enabled);

-- users
CREATE INDEX users_user_id_index ON users (user_id);
CREATE INDEX users_domain_id_index ON users (domain_id);
CREATE INDEX users_enabled_index ON users (enabled);
CREATE INDEX users_account_role_index ON users (account_role);

-- user_settings
CREATE INDEX user_settings_user_id_index ON user_settings (user_id);
CREATE INDEX user_settings_preferred_language_index ON user_settings (preferred_language);

-- courses
CREATE INDEX courses_course_id_index ON courses (course_id);
CREATE INDEX courses_enabled_index ON courses (enabled);

-- course_versions
CREATE INDEX course_versions_course_id_index ON course_versions (course_id);
CREATE INDEX course_versions_content_version_index ON course_versions (content_version);

-- course_content
CREATE INDEX course_content_course_id_index ON course_content (course_id);
CREATE INDEX course_content_content_version_index ON course_content (content_version);
CREATE INDEX course_content_content_language_index ON course_content (content_language);

-- exams
CREATE INDEX exams_exam_id_index ON exams (exam_id);
CREATE INDEX exams_enabled_index ON exams (enabled);

-- exam_versions
CREATE INDEX exam_versions_exam_id_index ON exam_versions (exam_id);
CREATE INDEX exam_versions_content_version_index ON exam_versions (content_version);

-- exam_content
CREATE INDEX exam_content_exam_id_index ON exam_content (exam_id);
CREATE INDEX exam_content_content_version_index ON exam_content (content_version);
CREATE INDEX exam_content_content_language_index ON exam_content (content_language);

-- course_exam_relationships
CREATE INDEX course_exam_relationships_course_id_index ON course_exam_relationships (course_id);
CREATE INDEX course_exam_relationships_exam_id_index ON course_exam_relationships (exam_id);
CREATE INDEX course_exam_relationships_enabled_index ON course_exam_relationships (enabled);

-- domain_course_assignments
CREATE INDEX domain_course_assignments_domain_id_index ON domain_course_assignments (domain_id);
CREATE INDEX domain_course_assignments_course_id_index ON domain_course_assignments (course_id);
CREATE INDEX domain_course_assignments_enabled_index ON domain_course_assignments (enabled);

-- user_course_assignments
CREATE INDEX user_course_assignments_user_id_index ON user_course_assignments (user_id);
CREATE INDEX user_course_assignments_course_id_index ON user_course_assignments (course_id);
CREATE INDEX user_course_assignments_enabled_index ON user_course_assignments (enabled);
CREATE INDEX user_course_assignments_completion_deadline_index ON user_course_assignments (completion_deadline);
CREATE INDEX user_course_assignments_completion_tracking_period_start_index ON user_course_assignments (completion_tracking_period_start);

-- user_course_progress
CREATE INDEX user_course_progress_user_id_index ON user_course_progress (user_id);
CREATE INDEX user_course_progress_course_id_index ON user_course_progress (course_id);
CREATE INDEX user_course_progress_course_learning_version_index ON user_course_progress (course_learning_version);
CREATE INDEX user_course_progress_course_learning_completed_at_index ON user_course_progress (course_learning_completed_at);

-- user_exam_attempts
CREATE INDEX user_exam_attempts_user_id_index ON user_exam_attempts (user_id);
CREATE INDEX user_exam_attempts_course_id_index ON user_exam_attempts (course_id);
CREATE INDEX user_exam_attempts_exam_id_index ON user_exam_attempts (exam_id);
CREATE INDEX user_exam_attempts_exam_version_index ON user_exam_attempts (exam_version);
CREATE INDEX user_exam_attempts_passed_index ON user_exam_attempts (passed);
CREATE INDEX user_exam_attempts_finished_at_index ON user_exam_attempts (finished_at);


-- Trigger functions
CREATE OR REPLACE FUNCTION populate_row_audit_columns()
RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
BEGIN
    -- Raise an exception if any of the row audit columns are specified in the query
    IF NEW.row_created_at IS NOT NULL THEN
        RAISE EXCEPTION 'Manually setting "row_created_at" in an INSERT query is forbidden.';
    ELSEIF NEW.row_created_by IS NOT NULL THEN
        RAISE EXCEPTION 'Manually setting "row_created_by" in an INSERT query is forbidden.';
    ELSEIF NEW.row_modified_at IS NOT NULL THEN
        RAISE EXCEPTION 'Manually setting "row_modified_at" in an INSERT query is forbidden.';
    ELSEIF NEW.row_modified_by IS NOT NULL THEN
        RAISE EXCEPTION 'Manually setting "row_modified_by" in an INSERT query is forbidden.';
    END IF;

    -- Only populate the audit columns and insert the new row if all the above checks pass
    NEW.row_created_at := now();
    NEW.row_created_by := current_user;
    NEW.row_modified_at := now();
    NEW.row_modified_by := current_user;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION prevent_row_creation_timestamp_manual_update()
RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
BEGIN
    RAISE EXCEPTION 'Direct UPDATE of "row_created_at" is forbidden.';
END;
$$;

CREATE OR REPLACE FUNCTION prevent_row_creation_user_manual_update()
RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
BEGIN
    RAISE EXCEPTION 'Direct UPDATE of "row_created_by" is forbidden.';
END;
$$;

CREATE OR REPLACE FUNCTION prevent_row_modification_timestamp_manual_update()
RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
BEGIN
    RAISE EXCEPTION 'Direct UPDATE of "row_modified_at" is forbidden.';
END;
$$;

CREATE OR REPLACE FUNCTION prevent_row_modification_user_manual_update()
RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
BEGIN
    RAISE EXCEPTION 'Direct UPDATE of "row_modified_by" is forbidden.';
END;
$$;

CREATE OR REPLACE FUNCTION update_row_modification_audit_columns()
RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
BEGIN
    -- Only update the row modification audit columns if values were actually changed
    IF ROW(NEW.*) IS DISTINCT FROM ROW(OLD.*) THEN
        NEW.row_modified_at = now();
        NEW.row_modified_by = current_user;
        RETURN NEW;
    ELSE
        RETURN OLD;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION enforce_increasing_course_version()
RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
DECLARE
    highest_existing_content_version real;
BEGIN
    -- Get the highest content_version of all existing rows for the provided course_id
    SELECT MAX(cv.content_version)
        INTO highest_existing_content_version
        FROM course_versions cv
        WHERE cv.course_id = NEW.course_id;

    -- Only insert the new row if content_version is greater than the highest existing content_version or no versions already exist
    IF (NEW.content_version > highest_existing_content_version OR highest_existing_content_version IS NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION '"content_version" of new row must be greater than the highest existing "content_version" for the provided "course_id"';
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION enforce_increasing_exam_version()
RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
DECLARE
    highest_existing_content_version real;
BEGIN
    -- Get the highest content_version of all existing rows for the provided exam_id
    SELECT MAX(ev.content_version)
        INTO highest_existing_content_version
        FROM exam_versions ev
        WHERE ev.exam_id = NEW.exam_id;

    -- Only insert the new row if content_version is greater than the highest existing content_version or no versions already exist
    IF (NEW.content_version > highest_existing_content_version OR highest_existing_content_version IS NULL) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION '"content_version" of new row must be greater than the highest existing "content_version" for the provided "exam_id"';
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION prevent_existing_content_version_update()
RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
BEGIN
    RAISE EXCEPTION 'Modification of "content_version" for an existing row is forbidden; create a new row for major changes such as this.';
END;
$$;

CREATE OR REPLACE FUNCTION prevent_existing_exam_pass_mark_update()
RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
BEGIN
    RAISE EXCEPTION 'Modification of "pass_mark" for an existing row is forbidden; create a new row for major changes such as this.';
END;
$$;

CREATE OR REPLACE FUNCTION prevent_existing_exam_estimated_completion_time_update()
RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
BEGIN
    RAISE EXCEPTION 'Modification of "estimated_completion_time" for an existing row is forbidden; create a new row for major changes such as this.';
END;
$$;


-- Triggers
-- domains
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON domains
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON domains
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON domains
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON domains
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON domains
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON domains
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- users
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON users
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON users
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON users
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON users
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON users
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- user_settings
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON user_settings
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON user_settings
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON user_settings
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON user_settings
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON user_settings
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON user_settings
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- courses
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON courses
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON courses
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON courses
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON courses
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON courses
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON courses
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- course_versions
CREATE TRIGGER enforce_increasing_course_version
    BEFORE INSERT ON course_versions
    FOR EACH ROW EXECUTE PROCEDURE enforce_increasing_course_version();

CREATE TRIGGER aa_prevent_existing_content_version_update
    BEFORE UPDATE OF content_version ON course_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_existing_content_version_update();

CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON course_versions
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON course_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON course_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON course_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON course_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON course_versions
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- course_content
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON course_content
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON course_content
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON course_content
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON course_content
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON course_content
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON course_content
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- exams
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON exams
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON exams
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON exams
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON exams
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON exams
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON exams
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- exam_versions
CREATE TRIGGER enforce_increasing_exam_version
    BEFORE INSERT ON exam_versions
    FOR EACH ROW EXECUTE PROCEDURE enforce_increasing_exam_version();

CREATE TRIGGER aa_prevent_existing_content_version_update
    BEFORE UPDATE OF content_version ON exam_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_existing_content_version_update();

CREATE TRIGGER aa_prevent_existing_exam_pass_mark_update
    BEFORE UPDATE OF pass_mark ON exam_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_existing_exam_pass_mark_update();

CREATE TRIGGER aa_prevent_existing_exam_estimated_completion_time_update
    BEFORE UPDATE OF estimated_completion_time ON exam_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_existing_exam_estimated_completion_time_update();

CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON exam_versions
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON exam_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON exam_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON exam_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON exam_versions
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON exam_versions
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- exam_content
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON exam_content
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON exam_content
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON exam_content
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON exam_content
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON exam_content
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON exam_content
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- course_exam_relationships
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON course_exam_relationships
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON course_exam_relationships
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON course_exam_relationships
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON course_exam_relationships
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON course_exam_relationships
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON course_exam_relationships
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- domain_course_assignments
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON domain_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON domain_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON domain_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON domain_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON domain_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON domain_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- user_course_assignments
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON user_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON user_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON user_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON user_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON user_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON user_course_assignments
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- user_course_progress
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON user_course_progress
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON user_course_progress
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON user_course_progress
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON user_course_progress
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON user_course_progress
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON user_course_progress
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();

-- user_exam_attempts
CREATE TRIGGER populate_row_audit_columns
    BEFORE INSERT ON user_exam_attempts
    FOR EACH ROW EXECUTE PROCEDURE populate_row_audit_columns();

CREATE TRIGGER aa_prevent_row_creation_timestamp_manual_update
    BEFORE UPDATE OF row_created_at ON user_exam_attempts
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_creation_user_manual_update
    BEFORE UPDATE OF row_created_by ON user_exam_attempts
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_creation_user_manual_update();

CREATE TRIGGER aa_prevent_row_modification_timestamp_manual_update
    BEFORE UPDATE OF row_modified_at ON user_exam_attempts
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_timestamp_manual_update();

CREATE TRIGGER aa_prevent_row_modification_user_manual_update
    BEFORE UPDATE OF row_modified_by ON user_exam_attempts
    FOR EACH ROW EXECUTE PROCEDURE prevent_row_modification_user_manual_update();

CREATE TRIGGER update_row_modification_audit_columns
    BEFORE UPDATE ON user_exam_attempts
    FOR EACH ROW EXECUTE PROCEDURE update_row_modification_audit_columns();
