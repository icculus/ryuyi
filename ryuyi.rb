#!/usr/bin/ruby

require 'discordrb'

bottoken = File.open('ryuyi-api-token.txt').read
bottoken.strip!

bot = Discordrb::Bot.new token: bottoken

bot.mention() do |event|
  puts("Saw a mention!")
  txt = ''
  txt << 'text='
  txt << event.message.content
  txt << ',username='
  if event.message.author.username.nil?
    txt << '(nil)'
  else
    txt << event.message.author.username
  end
  txt << ',nick='
  if event.message.author.nick.nil?
    txt << '(nil)'
  else
    txt << event.message.author.nick
  end
  txt << ',roles='
  event.message.author.roles.each { |role|
    txt << role.name
    txt << '('
    txt << role.position.to_s
    txt << '),'
  }
  puts(txt)

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

