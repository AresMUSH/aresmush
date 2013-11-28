require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
    describe Desc do
      before do
        @desc = Desc.new
        @client = double(Client).as_null_object
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "desc_set" }        
      end
      
      describe :want_command? do
        it "wants the desc command if logged in" do
          cmd = double
          cmd.stub(:logged_in?) { true }
          cmd.stub(:root_is?).with("desc") { true }
          @desc.want_command?(cmd).should be_true
        end

        it "doesn't want the desc command if not logged in" do
          cmd = double
          cmd.stub(:logged_in?) { false }
          cmd.stub(:root_is?).with("desc") { true }
          @desc.want_command?(cmd).should be_false
        end

        it "doesn't want another command" do
          cmd = double
          cmd.stub(:root_is?).with("desc") { false }
          cmd.stub(:logged_in?) { true }
          @desc.want_command?(cmd).should be_false
        end
      end
      
      describe :on_command do
        before do
          @cmd = double(Command)  
          @client = double(Client)
          @args = double(HashReader)          

          @args.stub(:target) { "Bob" }
          @args.stub(:desc) { "New desc" }
          @desc.stub(:crack) { @args }
        end
        
        it "should crack the args" do
          @desc.should_receive(:crack).with(@cmd) { @args }
          # Short-circuit the rest of the command.
          @desc.stub(:validate) { false }
          @desc.on_command(@client, @cmd)          
        end
        
        it "should not handle the cmd if the args were invalid" do
          @desc.should_receive(:validate).with(@args, @client) { false }
          @desc.should_not_receive(:handle)
          @desc.on_command(@client, @cmd)
        end
        
        it "should fail if nothing is found with the name" do
          @desc.stub(:validate) { true }
          VisibleTargetFinder.should_receive(:find).with("Bob", @client) { nil }
          @desc.should_not_receive(:handle)
          @desc.on_command(@client, @cmd)
        end        
        
        it "should call the command handler" do
          model = double
          @desc.stub(:validate) { true }
          VisibleTargetFinder.should_receive(:find).with("Bob", @client) { model }
          @desc.should_receive(:handle).with(model, "New desc", @client)
          @desc.on_command(@client, @cmd)
        end
      end            
    end
        
  end
end