require "granite/adapter/sqlite"
Granite::Connections << Granite::Adapter::Sqlite.new(
  name: "sqlite",
  url: "sqlite3://./src/data/feathers.db"
)
