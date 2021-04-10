require "./../../config/db.cr"

class Leak < Granite::Base
  connection sqlite
  table leak # Name of the table to use for the model, defaults to class name snake cased

  column id : Int32, primary: true # Primary key, defaults to AUTO INCREMENT
  column created_at : Time
end
