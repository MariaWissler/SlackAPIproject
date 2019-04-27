require_relative "test_helper"

describe "workspace class" do
  before do
    VCR.use_cassette("create workspace object") do
      selected = "USLACKBOT" #id of slackbot
      @workspace = Workspace.new(selected: selected)
    end
  end

  describe "initialize" do
    it "creates an instance of workspace" do
      expect(@workspace).must_be_kind_of Workspace
    end
  end

  describe "#select_user" do
    it "returns an instance of User" do
      expect(@workspace.select_user).must_be_kind_of User
    end

    it "returned the correct user" do
      user = @workspace.select_user
      expect(user.name).must_equal "slackbot"
    end

    it "returns nil if username or slack id is not found" do
      VCR.use_cassette("check nil returned") do
        selected = "chewy" #id of nonexistent slackbot
        @workspace2 = Workspace.new(selected: selected)
      end
      expect(@workspace2.select_user).must_be_nil
    end
  end

  describe "#selected_channel" do
    before do
      VCR.use_cassette("create workspace object") do
        selected = "CH0ED08E4" #id for general channel
        @workspace = Workspace.new(selected: selected)
      end
    end
    it "returns an instance of Channel" do
      expect(@workspace.select_channel).must_be_kind_of Channel
    end

    it "returned the correct user" do
      channel = @workspace.select_channel
      expect(channel.name).must_be_kind_of String
    end

    it "returns nil if username or slack id is not found" do
      VCR.use_cassette("check nil returned") do
        selected = "name your channel"
        @workspace_channel = Workspace.new(selected: selected)
      end
      expect(@workspace_channel.select_channel).must_be_nil
    end
  end

  describe "#send_message" do
    it "connects to the api ok" do
      VCR.use_cassette("") do
        selected = "CH0ED08E4" #id for general channel
        @workspace = Workspace.new(selected: selected)
        channel_selected = @workspace.select_channel
        message = "hello"
        response = @workspace.send_message(message, channel_selected)
        expect(response.code).must_equal 200
        expect(response.parsed_response["ok"]).must_equal true
      end
    end

    it "returns an error if the message is empty" do
      VCR.use_cassette("") do
        selected = "CH0ED08E4" #id for general channel
        @workspace = Workspace.new(selected: selected)
        channel_selected = @workspace.select_channel
        message = ""
        exception = expect { @workspace.send_message(message, channel_selected) }.must_raise SlackApiError
        expect(exception.message).must_equal "no_text"
      end
    end
  end
end
