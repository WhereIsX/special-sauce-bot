require "../src/models/command.cr"

def populate_z_commands
  commands = Hash(String, String).from_json(File.read("./src/data/commands.json"))
  commands.each do |name, resp|
    next if Model::Command.find_by(name: name)

    c = Model::Command.create(name: name, response: resp, created_at: Time.local)
    if c.errors.any?
      raise c.errors.t_s
    end
  end
end

p! populate_z_commands
