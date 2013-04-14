require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
    describe Desc do
      before do
        @container = double(Container)
        @desc = Desc.new(@container)
        @client = double(Client).as_null_object
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "desc_set" }        
      end
      
      describe :want_anon_command? do
        it "doesn't want any commands" do
          cmd = mock
          @desc.want_anon_command?(cmd).should be_false
        end
      end

      describe :want_command? do
        it "wants the desc command" do
          cmd = mock
          cmd.stub(:root_is?).with("desc") { true }
          @desc.want_command?(cmd).should be_true
        end

        it "doesn't want another command" do
          cmd = mock
          cmd.stub(:root_is?).with("desc") { false }
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
          DescCmdCracker.stub(:crack) { @args }
        end
        
        it "should crack the args" do
          DescCmdCracker.should_receive(:crack).with(@cmd) { @args }
          # Short-circuit the rest of the command.
          DescCmdValidator.stub(:validate) { false }
          @desc.on_command(@client, @cmd)          
        end
        
        it "should not handle the cmd if the args were invalid" do
          DescCmdValidator.should_receive(:validate).with(@args, @client) { false }
          DescCmdHandler.should_not_receive(:handle)
          @desc.on_command(@client, @cmd)
        end
        
        it "should fail if nothing is found with the name" do
          DescCmdValidator.stub(:validate) { true }
          VisibleTargetFinder.should_receive(:find).with("Bob", @client) { nil }
          DescCmdHandler.should_not_receive(:handle)
          @desc.on_command(@client, @cmd)
        end        
        
        it "should call the command handler" do
          model = mock
          DescCmdValidator.stub(:validate) { true }
          VisibleTargetFinder.should_receive(:find).with("Bob", @client) { model }
          DescCmdHandler.should_receive(:handle).with(model, "New desc", @client)
          @desc.on_command(@client, @cmd)
        end
      end
    end
        
  end
end