require "pry"
require "httparty"

class Channel < Recipient
  attr_reader :topic, :member_count

  def initialize(name:, slack_id:, topic:, member_count:)
    super(name: name, slack_id: slack_id)
    @topic = topic
    @member_count = member_count
  end

  def self.list
    response = self.get("channels.list")
    channel_list = []
    response["channels"].each do |channel|
      name = channel["name"]
      slack_id = channel["id"]
      topic = channel["topic"]
      member_count = channel["members"].count
      channel_list << self.new(name: name, slack_id: slack_id, topic: topic, member_count: member_count)
    end
    return channel_list
  end

  def details
    puts "Name: #{self.name}"
    puts "ID: #{self.slack_id}"
    puts "Topic: #{self.topic["value"]}"
    puts "Number of members: #{self.member_count}"
  end
end
