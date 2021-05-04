require "./command.cr"
require "../../models/ducky.cr"

Command.new(
  name: "!consent",
  description: "whether the bot can @ you in chat; !consent <revoke/give> "
) do |ircm|
  update = Command::Update.parse?(ircm.words[1])
  ducky = Model::Ducky.find_by(username: ircm.username)

  if ducky.nil?
    next "sorry, we couldn't find you. have you already `!start_record` ?"
  end

  case update
  in Nil
    next "try !consent <give/revoke>"
  in Command::Update::Revoke
    ducky.at_me_consent = false
  in Command::Update::Give
    ducky.at_me_consent = true
  end
  if ducky.save
    next "aye aye!"
  else
    next "that failed :( time to git blame/annotate where_is_x"
  end
end
