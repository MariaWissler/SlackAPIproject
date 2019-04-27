require_relative "test_helper"
require "pry"
describe "channel class" do
  describe "initialize" do
    it "creates and instance of channel" do
      topic = "random"
      member_count = 3
      name = "cyndilopez6"
      slack_id = 1
      expect(Channel.new(name: name, slack_id: slack_id, topic: topic, member_count: member_count)).must_be_kind_of Channel
    end
  end

  describe "can connect to API" do
    it "accesses api" do
      VCR.use_cassette("connect to endpoints channels_list") do
        endpoint = "channels.list"
        @response = Channel.get(endpoint)
      end
      expect(@response.code == 200 && @response.parsed_response["ok"]).must_equal true
    end
  end

  describe "raises errors for incorrect endpoint" do
    it "raises an error for incorrect endpoint" do
      VCR.use_cassette("check_method_error_raised") do
        endpoint = "ret424252E#1231+=.y"
        exception = expect { Channel.get(endpoint) }.must_raise SlackApiError
        expect(exception.message).must_equal "unknown_method"
      end
    end

    # it "raises an error for incorrect token" do
    #   VCR.use_cassette("check_auth_error_raised") do
    #     endpoint = "channels.list"
    #     params = {:token => "0123456789abcdef"}
    #     p params
    #     expect(Channel.get(endpoint, params)).must_equal "invalid_auth"
    #   end
    # end
  end

  describe "creates list of channels" do
    it "returns a type of array" do
      VCR.use_cassette("returns array") do
        expect(Channel.list.is_a? Array).must_equal true
      end
    end

    it "returns an array of Channel objects" do
      VCR.use_cassette("returns object Channel") do
        expect(Channel.list[0]).must_be_kind_of Channel
      end
    end

    it "returns an accurate list of channels in slack workspace" do
      VCR.use_cassette("correct channels") do
        expect(Channel.list.map { |channel| channel.name }.length).must_be :>, 0
      end
    end
  end
end
