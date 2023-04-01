#!/usr/bin/ruby

require 'discordrb'

bottoken = File.open('ryuyi-api-token.txt').read
bottoken.strip!

bot = Discordrb::Bot.new token: bottoken

bot.mention() do |event|
  highest_role = 0
  event.message.author.roles.each { |role|
    if role.position > highest_role
      highest_role = role.position
    end
  }

  if highest_role < 31
    event.message.create_reaction("\u{1F44E}")  # thumbs down
  else
    event.message.respond("I am responding to this specific message.", false, nil, nil, nil, event.message)
  end
end

bot.run

