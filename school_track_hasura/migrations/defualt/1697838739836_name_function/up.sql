CREATE FUNCTION user_full_name(user_row users)
RETURNS TEXT AS $$
  SELECT user_row.first_name || ' ' || user_row.last_name
$$ LANGUAGE sql STABLE;
