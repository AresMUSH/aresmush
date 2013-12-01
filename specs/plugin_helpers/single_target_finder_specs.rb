$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe SingleTargetFinder
  describe :find do
    before do
      @client = double
      @test_class = double
    end

    it "should search the specified class by name or ID" do
      @test_class.should_receive(:find_by_name_or_id).with("foo")
      SingleResultSelector.stub(:select)
      SingleTargetFinder.find("foo", @test_class)
    end
    
    it "should call the single object selector with the find results" do
      result = double
      @test_class.stub(:find_by_name_or_id).with("foo") { [ "a", "b"] }
      SingleResultSelector.should_receive(:select).with([ "a", "b"]) { result }
      SingleTargetFinder.find("foo", @test_class).should eq result
    end
    
  end
end


