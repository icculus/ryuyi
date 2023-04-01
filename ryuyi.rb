#!/usr/bin/ruby

require 'discordrb'
require 'octokit'
#require 'pp'

# This is just laziness, we could do better than this.
discordtoken = File.read('discord-api-token.txt').strip
githubtoken = File.read('github-api-token.txt').strip
reponame = File.read('github-repo-name.txt').strip

github = Octokit::Client.new(:access_token => githubtoken)
repo = Octokit::Repository.new("dragonruby/gtk")

bot = Discordrb::Bot.new token: discordtoken

bot.mention do |event|
  highest_role = event.message.author.roles.map(&:position).max

  if highest_role < 31
    event.message.create_reaction("\u{1F44E}")  # thumbs down
  else
    # Dump out specific user mentions, like '<@81724812748124>'
    msgtxt = event.message.content.gsub(/\<\@\d+\>/, '').strip

    if msgtxt.start_with?('bug')
      bugmsg = event.message.referenced_message
      if bugmsg.nil?
        event.message.respond("Sorry, you need to reply to a message when mentioning me for this.", false, nil, nil, nil, event.message)
      else
        buguser = bugmsg.author.nick
        if buguser.nil?
          buguser = bugmsg.author.username
        end

        bugurl = bugmsg.link
        bugtext = bugmsg.content.gsub(/\<\@\d+\>/, '').strip
        bugtitle = msgtxt[3..msgtxt.length].strip
        if bugtitle == ''
          bugtitle = bugtext.split("\n")[0]
          if bugtitle.nil? or bugtitle == ''
            bugtitle = "Feedback from Discord user #{buguser} at #{bugmsg.timestamp.to_s}"
          end
        end

        bugquote = ''
        bugtext.lines.each { |l| bugquote << '> ' << l.strip << "\n" }

        bugbody = <<~ISSUE_BODY
          *****This bug was created by [ryuyi](https://github.com/icculus/ryuyi), a bot on the Discord server by Ryan.*****

          Discord user `#{buguser}` said this:

          #{bugquote}

          This discussion happened [here](#{bugurl}).
        ISSUE_BODY

        #pp repo
        #pp bugtitle
        #pp bugbody

        issue = github.create_issue(repo, bugtitle, bugbody)
        if !issue.nil? and !issue[:html_url].nil?
          event.message.respond("Ok, this is is now #{issue[:html_url]} !", false, nil, nil, nil, event.message)
        end
      end
    end
  end
end


bot.run

