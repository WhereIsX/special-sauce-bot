require "./../../config/db.cr"

module Model
  class Command < Granite::Base
    connection sqlite
    table command # Name of the table to use for the model, defaults to class name snake cased

    column id : Int32, primary: true # Primary key, defaults to AUTO INCREMENT
    column name : String
    column response : String
    column created_at : Time
  end
end
