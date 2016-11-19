module AresMUSH
  describe :OnOffOption do
    before do
      SpecHelpers.stub_translate_for_testing
    end
    
    it "should say on is on and valid" do
      option = OnOffOption.new("on")
      option.is_on?.should be true
      option.validate.should be_nil
    end

    it "should say off is off and valid" do
      option = OnOffOption.new("off")
      option.is_on?.should be false
      option.validate.should be_nil
    end
    
    it "should say a random value is off and invalid" do
      option = OnOffOption.new("foo")
      option.is_on?.should be false
      option.validate.should eq "dispatcher.invalid_on_off_option"
    end
    
    it "should ignore case and spaces" do
      option = OnOffOption.new("   On   ")
      option.is_on?.should be true
      option.validate.should be_nil
    end
  end
end
