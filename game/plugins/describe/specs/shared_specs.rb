require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
    describe Describe do
      describe :set_desc do
        before do
          @model = double.as_null_object  
        end
        
        it "should set the desc on the model" do
          @model.should_receive(:description=).with("New desc")
          Describe.set_desc(@model, "New desc")
        end

        it "should save the model" do
          @model.should_receive(:save!)    
          Describe.set_desc(@model, "New desc")
        end        
      end
    end
    
    describe :outfits do
      it "should get the outfits from the config" do
        outfits = { 'foo' => 'foo desc', 'bar' => 'bar desc' }
        Global.stub(:config) { { 'describe' => { 'outfits' => outfits } } }
        Describe.outfits.should eq outfits
      end
    end
    
    describe :outfit do
      before do
        Describe.stub(:outfits) { { 'foo' => 'foo desc', 'bar' => 'bar desc' } }
      end
      
      it "should return nil if the outfit doesn't exist" do
        Describe.outfit("zzz").should eq nil
      end

      it "should get the outfit by name" do
        Describe.outfit('foo').should eq 'foo desc'
      end
    end
  end
end