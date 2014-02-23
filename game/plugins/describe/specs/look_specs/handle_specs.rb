require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe LookCmd do
      before do
        @client = double(Client)
        @desc_iface = double    
        @model = double
        @look = Look.new
      end
      
      describe :handle do
        before do
          @args = double
          @args.stub(:target) { "target" }
          @look.stub(:crack) { @args }
        end
        
        it "should get the desc from the interface" do
          # TODO - refactor
          #@desc_iface.should_receive(:get_desc).with(@model)
          #@client.stub(:emit)
          #@look.handle(@desc_iface, @model, @client)
        end
        
        it "should emit the desc to the client" do
          # TODO - refactor
          #@desc_iface.stub(:get_desc).with(@model) { "DESC" }          
          #@client.should_receive(:emit).with("DESC")
          #@look.handle(@desc_iface, @model, @client)
        end    
        
        it "should crack the args" do
          # TODO - Refactor command
          #@look.should_receive(:crack).with(@cmd)
          # Short-circuit the rest of the command
          #@look.on_command(@client, @cmd)
        end
        
        it "should look for the target or here by default" do
          # TODO - Refactor command
          #VisibleTargetFinder.should_receive(:find).with("target", @client) { nil }
          #@look.on_command(@client, @cmd)
        end
        
        it "should not handle the command if the target is not found" do
          # TODO - Refactor command
          #VisibleTargetFinder.stub(:find) { nil }
          #@look.should_not_receive(:handle)
          #@look.on_command(@client, @cmd)
        end
        
        it "should call the command handler" do
          # TODO - Refactor command
          #model = double
          #iface = double(DescFunctions)
          #VisibleTargetFinder.stub(:find) { model }
          #Describe.stub(:interface) { iface }
          #@look.should_receive(:handle).with(iface, model, @client)
          #@look.on_command(@client, @cmd)
        end
      end
    end
  end
end