require "granite/adapter/sqlite"

Granite::Connections << Granite::Adapter::Sqlite.new(
  name: "sqlite",
  url: "sqlite3://./src/data/feathers.db"
)

class Ducky < Granite::Base
  connection sqlite
  table duckies # Name of the table to use for the model, defaults to class name snake cased

  column id : Int32, primary: true # Primary key, defaults to AUTO INCREMENT
  column username : String
  column points : Int64 = 0
  column at_me_consent : Bool = false
end
