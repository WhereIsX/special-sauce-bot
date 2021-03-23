require "db"
require "sqlite3"

# singleton
# data wing-person

# https://crystal-lang.org/reference/database/index.html

alias Duckie = NamedTuple(
  # id: Int32,
  username: String,
  points: Int32,
  water_consent: Bool,
  at_me_consent: Bool,
)

# Duckie.new()

class DBLibrarian # aka "Alex"
  @db : DB::Database

  def initialize
    @db = DB.open "sqlite3://./feathers.db"
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
      points:        Int32,
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

  def goodbye
    @db.close
  end
end

l = DBLibrarian.new
p! l.create_duckie("where_is_x")
