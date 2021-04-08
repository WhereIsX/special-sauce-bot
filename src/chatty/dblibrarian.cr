require "db"
require "sqlite3"

# singleton
# data wing-person

# https://crystal-lang.org/reference/database/index.html

alias Duckie = NamedTuple(
  # id: Int32,
  username: String,
  points: Int64,
  water_consent: Bool,
  at_me_consent: Bool,
)

# Duckie.new()

class DBLibrarian # aka "Alex"
  @db : DB::Database

  def initialize
    @db = DB.open "sqlite3://./src/data/feathers.db"
  end

  # some bug here w 2 records.
  def create_duckie(username : String) : Bool
    result = @db.exec("INSERT OR IGNORE INTO duckies (username) VALUES (?)", username)
    return result.rows_affected == 1
  end

  def get_duckie(username : String) : Duckie | Nil
    query = "SELECT username, points, water_consent, at_me_consent FROM duckies WHERE username = (?)"

    return @db.query_one?(query, username, as: {
      username:      String,
      points:        Int64,
      water_consent: Bool,
      at_me_consent: Bool,
    })
  end

  def delete_duckie(username : String) : Bool
    query = "DELETE FROM duckies WHERE username = ?"
    result = @db.exec(query, username)
    return result.rows_affected == 1
  end

  def water_consent(username : String, update : Int32)
    query = "UPDATE duckies SET water_consent = ? WHERE USERNAME = ?"
    p! @db.exec(query, update, username)
  end

  def at_me_consent(username : String, update : Int32)
    query = "UPDATE duckies SET at_me_consent = ? WHERE USERNAME = ?"
    p! @db.exec(query, update, username)
  end

  def create_new_leak : Bool
    query = "INSERT INTO leaks (created_at) VALUES (#{Time.utc.to_rfc2822})"
    result = @db.exec(query)
    return result.rows_affected == 1
  end

  def get_last_leak : String | Nil
    query = "SELECT created_at FROM leaks ORDER BY id DESC LIMIT 1"
    return @db.query_one?(query: query, as: String)
  end

  def update_points(duckie : String, n : Int32) : Bool
    query = "UPDATE duckies SET points = points + ? WHERE username = ?"
    result = @db.exec(query, n, duckie)
    return result.rows_affected == 1
  end

  def create_yak_counter : Bool
    datetime = Time.utc.to_rfc2822
    query = "INSERT INTO yak (created_at) VALUES (#{datetime})"
    result = @db.exec(query)
    return result.rows_affected == 1
  end

  def get_latest_yak
    query = "SELECT * FROM yak ORDER BY id DESC LIMIT 1"
    @db.query_one?(query: query, as: {
      id:         Int32,
      counter:    Int32,
      created_at: String,
      updated_at: String,
    })
  end

  def increment_yak_counter : Bool
    query = "UPDATE yak SET counter = counter + 1"
    result = @db.exec(query)
    return result.rows_affected == 1
  end

  def reset_yak_counter : Bool
    query = "UPDATE yak SET counter = 0"
    result = @db.exec(query)
    return result.rows_affected == 1
  end

  def goodbye
    @db.close
  end
end

# l = DBLibrarian.new
# p! l.get_last_leak
