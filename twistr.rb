#!/usr/bin/env ruby
# coding: utf-8

require 'date'
require 'tweetstream'
require 'terminal-notifier'
require 'uri'

trackWord = ARGV[0]
dtOld = DateTime.now

Signal.trap(:INT) { exit(0) }

TweetStream.configure do |config|
  config.consumer_key       = 'IhpRxSgkk257Q97cWodoPg'
  config.consumer_secret    = 'c2PsEJQMgA3REMUM3AU9xsoxaFNo4QOQexD6uXjh33M'
  config.oauth_token        = '5735002-1yk7kztSaYgK5Ohcz0zxgy54jpo82lJWI1H35tmI3R'
  config.oauth_token_secret = 'BGIgwvSyKmOEdt9W5ZAHXp7IHLA6cfspyf1l2B54A8U'
  config.auth_method        = :oauth
end


TweetStream::Client.new.track(trackWord) do |status|

  
  text = status.text
  
  noti = status.text
  noti = noti.gsub(/(\r\n|\r|\n|\f)/, ' ')
  noti = noti.gsub(/(\s|　)+/, ' ')
  noti = noti.gsub(/RT\s@.+:\s/, 'RT: ')
  noti = noti.gsub(/\s#\w+/, '')
  noti = noti.gsub(/\s#{URI::regexp(%w(http https))}/, '')

  dtnow = DateTime.now

  puts
  puts "\e[1m#{dtnow.year}.#{dtnow.month}.#{dtnow.day} #{dtnow.hour}:#{dtnow.min}:#{dtnow.sec} @#{status.user.screen_name}\e[0m"
  # puts "#{text.gsub(/(\r\n|\r|\n|\f)/, ' ')}"
  # puts text
  # puts noti
  text.chars.map{|c| print c; sleep 0.015}
  puts
  
  if ! noti.include?('RT:')
    if ((DateTime.now-dtOld)*24*60*60).to_i > 30
      soundname = 'default'
    else
      soundname = 'muon'
    end
    # Process.detach(spawn("say \"#{noti}\""))
    TerminalNotifier.notify(noti, \
      title:    "#{status.user.screen_name}", \
      sound:    soundname, \
      activate: 'com.apple.Terminal')
  end
  dtOld = DateTime.now
  
end


