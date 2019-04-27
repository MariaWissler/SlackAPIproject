require "pry"
require "httparty"
require_relative "recipient.rb"

class User < Recipient
  attr_reader :real_name, :status_text, :status_emoji

  def initialize(name:, slack_id:, real_name:, status_text: nil, status_emoji: nil)
    super(name: name, slack_id: slack_id)
    @real_name = real_name
    @status_text = status_text
    @status_emoji = status_emoji
  end

  def self.list #factory method
    response = self.get("users.list")
    user_list = []
    response["members"].each do |member|
      name = member["name"]
      slack_id = member["id"]
      real_name = member["real_name"]
      status_text = member["profile"]["status_text"]
      status_emoji = member["profile"]["status_emoji"]
      user_list << self.new(name: name, slack_id: slack_id, real_name: real_name, status_text: status_text, status_emoji: status_emoji)
    end
    return user_list
  end

  def details #business logic
    puts "Username: #{self.name}"
    puts "ID: #{self.slack_id}"
    puts "Name: #{self.real_name}"
    puts "Status: #{self.status_text}"
  end
end
