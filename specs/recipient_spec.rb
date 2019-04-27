require_relative "test_helper"
require "pry"
describe "recipient class" do
  describe "initialize" do
    it "creates an instance of Recipient" do
      #check slack_if format
      slack_id = 1
      name = "Maria"
      expect(Recipient.new(slack_id: slack_id, name: name)).must_be_kind_of Recipient
    end

    it "raises an argument error if name is not a string" do
      expect { Recipient.new(slack_id: 1, name: 21) }.must_raise ArgumentError
    end
  end

  describe "can connect to API" do
    it "can connect" do
      VCR.use_cassette("find channels") do
        response = Recipient.get("channels.list")
        expect(response["channels"]).wont_be_nil
        expect(response["channels"].map { |channel| channel["name"] }.length).must_be :>, 0
      end
    end

    it "gives a list with more than one user name" do
      VCR.use_cassette("find channels") do
        endpoint = "users.list"
        response = Recipient.get(endpoint)
        # Binding.pry
        expect(response).wont_be_nil
        expect(response["members"].map { |member| member["name"] }.length).must_be :>, 0
      end
    end
    it "can find the status of a member" do
      VCR.use_cassette("user status") do
        endpoint = "users.list"
        response = Recipient.get(endpoint)
        expect(response["members"][0]["profile"]["status_text"].length).wont_be_nil
        expect(response["members"].select { |member| member["real_name"] == "Maria Wissler" }[0]["profile"]["status_text"]).must_be_kind_of String
      end
    end
  end
end
