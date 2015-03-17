require "spec_helper"

describe Mongoid::Errors::TooManyNestedAttributeRecords do

  describe "#message" do

    let(:error) do
      described_class.new("favorites", 5)
    end

    it "contains the problem in the message" do
      error.message.should include(
        "Accepting nested attributes for favorites is limited to 5 records."
      )
    end

    it "contains the summary in the message" do
      error.message.should include(
        "More documents were sent to be processed than the allowed limit."
      )
    end

    it "contains the resolution in the message" do
      error.message.should include(
        "The limit is set as an option to the macro, for example:"
      )
    end
  end
end
