require "httparty"
require_relative "../lib/user"
require_relative "../lib/channel"
require_relative "../lib/recipient"
require "json"

class Workspace
  attr_reader :users, :channels, :selected

  def initialize(selected:)
    @users = User.list
    @channels = Channel.list
    @selected = selected # either user or channel info
  end

  def select_user
    user_selected = users.detect do |user|
      user.slack_id == selected || user.name == selected
    end
    return user_selected
  end

  def select_channel
    channel_selected = channels.detect do |channel|
      channel.slack_id == selected || channel.name == selected
    end
    return channel_selected
  end

  def self.save_settings(params)
    settings_file = File.open("bot-settings.json", "w") do |f|
      f.write(params.to_json)
    end
  end

  def bot_settings_file_exist
    begin
      readfile = File.read("bot-settings.json")
      return readfile
    rescue
      readfile = nil
    end
  end

  def send_message(message, recipient)
    params = {}
    params[:text] = message
    params[:channel] = recipient.slack_id
    readfile = bot_settings_file_exist #check if settings have been changed
    params.merge!(eval(readfile)) if !readfile.nil?
    recipient.send_message(params)
  end

  def show_details(recipient)
    recipient.details
  end
end
