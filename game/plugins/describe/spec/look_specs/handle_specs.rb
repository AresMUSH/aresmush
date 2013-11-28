require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe Look do
      before do
        @client = double(Client)
        @desc_iface = double    
        @model = double
        @look = Look.new
      end
      
      describe :handle do
        it "should get the desc from the interface" do
          @desc_iface.should_receive(:get_desc).with(@model)
          @client.stub(:emit)
          @look.handle(@desc_iface, @model, @client)
        end
        
        it "should emit the desc to the client" do
          @desc_iface.stub(:get_desc).with(@model) { "DESC" }          
          @client.should_receive(:emit).with("DESC")
          @look.handle(@desc_iface, @model, @client)
        end        
      end
    end
  end
end