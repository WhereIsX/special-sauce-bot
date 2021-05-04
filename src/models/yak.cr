require "./../../config/db.cr"

module Model
  class Yak < Granite::Base
    connection sqlite
    table yak # Name of the table to use for the model, defaults to class name snake cased

    column id : Int32, primary: true # Primary key, defaults to AUTO INCREMENT
    column created_at : Time
    column topic : String
  end
end
