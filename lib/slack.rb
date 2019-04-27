#!/usr/bin/env ruby
require "pry"
require "httparty"
require "dotenv"
require_relative "../lib/workspace"
Dotenv.load

def display_options
  puts "\nChoose from one of the following:"
  puts "------------------------------"
  puts "\nSelect user"
  puts "\nSelect channel"
  puts "\nDetails"
  puts "\nMessage"
  puts "\nChange Settings"
  puts "\nQuit"
  option = gets.chomp.downcase
  return verify_options(option)
end

def verify_options(option)
  options = ["select user", "select channel", "details", "message", "change settings", "quit"]
  until options.include?(option)
    puts "Please input a valid option."
    option = display_options
  end
  return option
end

def main
  puts "Welcome to the Ada Slack CLI!"
  puts "\nWhat would you like to do?"

  option = display_options
  until option == "quit"
    case option
    when "select user"
      puts "You chose to select a user. Please provide a username or Slack ID"
      selected = gets.chomp()
      workspace = Workspace.new(selected: selected)
      recipient = workspace.select_user
      until !recipient.nil?
        puts "Please provide a valid username or Slack ID"
        selected = gets.chomp
        workspace = Workspace.new(selected: selected)
        recipient = workspace.select_user
      end
      puts "You have selected #{recipient.real_name}"
      puts "\nWhat would you like to do next?"
      option = display_options
    when "select channel"
      puts "You chose to select a channel. Please provide a channel name or Slack ID"
      selected = gets.chomp()
      workspace = Workspace.new(selected: selected)
      recipient = workspace.select_channel
      until !recipient.nil?
        puts "Please provide a valid Channel name or Slack ID"
        selected = gets.chomp
        workspace = Workspace.new(selected: selected)
        recipient = workspace.select_channel
      end
      puts "You have selected #{recipient.name}"
      option = display_options
    when "details"
      begin
        workspace.show_details(recipient)
        puts "\nWhat would you like to do next?"
        option = display_options
      rescue
        puts "You must select a user or channel first."
        puts "\nWhat would you like to do next?"
        option = display_options
      end
    when "message"
      begin
        recipient.slack_id #checking if recipient exists; if it doesn't will throw name error => rescue clause
        puts "What message would you like to send?"
        message = gets.chomp
        workspace.send_message(message, recipient)
        puts "\nYou're message has been sent."
        puts "\nWhat would you like to do next?"
        option = display_options
      rescue
        puts "You must select a user or channel first."
        puts "\nWhat would you like to do next?"
        option = display_options
      end
    when "change settings"
      puts "You can change the username displayed"
      # puts "Please type either 'username' or 'icon emoji' or both to change either"
      puts "What username would you like to use?"
      setting_username_change = gets.chomp
      params = {}
      params[:username] = setting_username_change
      Workspace.save_settings(params)
      puts "Thanks, username is now #{setting_username_change}."
      puts "Quit and restart the program for this change to be implemented"
      option = display_options
    end
  end

  puts "Thank you for using the Ada Slack CLI"
end

main if __FILE__ == $PROGRAM_NAME

def verify_icon_emojis
end
