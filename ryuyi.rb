#!/usr/bin/ruby

require 'discordrb'

bottoken = File.open('ryuyi-api-token.txt').read
bottoken.strip!
puts(bottoken)

bot = Discordrb::Bot.new token: bottoken

bot.mention() do |event|
  puts("Saw a mention!")
  txt = ''
  txt << 'text='
  txt << event.message.content
  txt << ',nick='
  txt << event.message.author.nick
  txt << ',roles='
  event.message.author.roles.each { |role|
    txt << role.name
    txt << '('
    txt << role.position.to_s
    txt << '),'
  }
  puts(txt)

  event.message.reply(txt)
end

bot.run

