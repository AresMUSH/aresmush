module AresMUSH
  describe :OnOffOption do
    before do
      stub_translate_for_testing
    end
    
    it "should say on is on and valid" do
      option = OnOffOption.new("on")
      expect(option.is_on?).to be true
      expect(option.validate).to be_nil
    end

    it "should say off is off and valid" do
      option = OnOffOption.new("off")
      expect(option.is_on?).to be false
      expect(option.validate).to be_nil
    end
    
    it "should say a random value is off and invalid" do
      option = OnOffOption.new("foo")
      expect(option.is_on?).to be false
      expect(option.validate).to eq "dispatcher.invalid_on_off_option"
    end
    
    it "should ignore case and spaces" do
      option = OnOffOption.new("   On   ")
      expect(option.is_on?).to be true
      expect(option.validate).to be_nil
    end
  end
end
