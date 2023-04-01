#!/usr/bin/ruby

require 'discordrb'

bottoken = File.read('ryuyi-api-token.txt').strip

bot = Discordrb::Bot.new token: bottoken

bot.mention do |event|
  highest_role = event.message.author.roles.map(&:position).max

  if highest_role < 31
    event.message.create_reaction("\u{1F44E}")  # thumbs down
  else
    event.message.respond("I am responding to this specific message.", false, nil, nil, nil, event.message)
  end
end

bot.run

