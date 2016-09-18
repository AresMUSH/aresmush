$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Character do
    before do
      SpecHelpers.stub_translate_for_testing
    end
    
    describe :found? do
      it "should return true if there is an existing char" do
        Character.stub(:find_by_name).with("Bob") { double }
        Character.found?("Bob").should be_true
      end
      
      it "should return false if no char exists" do
        Character.stub(:find_by_name).with("Bob") { nil }
        Character.found?("Bob").should be_false
      end
    end  
  end
end