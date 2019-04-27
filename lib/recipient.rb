require "pry"
require "httparty"

class Recipient
  BASE_URL = "https://slack.com/api/"

  attr_reader :slack_id, :name

  def initialize(slack_id:, name:)
    @slack_id = slack_id
    raise ArgumentError if !name.is_a? String
    @name = name
  end

  def send_message(params)
    endpoint = "chat.postMessage"
    url = BASE_URL + endpoint
    params[:token] = ENV["SLACK_API_TOKEN"]
    response = HTTParty.post(url, body: params)
    unless response.code == 200 && response.parsed_response["ok"]
      raise SlackApiError, response["error"]
    end
    return response
  end

  private

  def self.get(endpoint, params = {})
    url = BASE_URL + endpoint
    params[:token] = ENV["SLACK_API_TOKEN"]
    response = HTTParty.get(url, query: params)
    unless response.code == 200 && response.parsed_response["ok"]
      raise SlackApiError, response["error"]
    end
    return response
  end

  def self.list
    raise NotImplementedError, "Implement me in a child class!"
  end

  def self.details
    raise NotImplementedError, "Implement me in a child class!"
  end
end
