require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe DescCommandHandler do
      before do
        @model = { "name" => "Bob" }
        @client = double(Client)
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "desc_set" }        
      end

      describe :execute do
        it "should set the desc" do
          @client.stub(:emit_success)
          Describe.should_receive(:set_desc).with(@model, "My desc")
          DescCommandHandler.execute(@model, "My desc", @client)
        end
        
        it "should emit success" do
          Describe.stub(:set_desc)
          @client.should_receive(:emit_success).with("desc_set")
          DescCommandHandler.execute(@model, "My desc", @client)
        end
      end
    end
    
    describe DescModelFinder do
      it "should find the room model" do
        model = mock
        client = double(Client)
        Rooms.should_receive(:find_visible_object).with("Bob", client) { model }
        DescModelFinder.find("Bob", client)
      end
    end
    
    describe DescValidator do
      before do
        @client = double(Client)
        AresMUSH::Locale.stub(:translate).with("describe.invalid_desc_syntax") { "invalid_desc_syntax" }
      end
      
      it "should emit failure if args are nil" do
        @client.should_receive(:emit_failure).with("invalid_desc_syntax")
        DescValidator.validate(nil, @client).should be_false
      end
      
      it "should return success if args are not nil" do
        DescValidator.validate("", @client).should be_true        
      end      
    end
    
  
    describe Desc do
      before do
        @container = double(Container)
        @desc = Desc.new(@container)
        @client = double(Client).as_null_object
        AresMUSH::Locale.stub(:translate).with("describe.invalid_desc_syntax") { "invalid_desc_syntax" }
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
          @model = { "name" => "Bob" }    
          @client = double(Client)     
        end
        
        it "should fail if the args were invalid" do
          DescCommandHandler.should_not_receive(:execute)
          DescValidator.should_receive(:validate)
          cmd = Command.new(@client, "desc Bob=New desc")
          @desc.on_command(@client, cmd)
        end
        
        it "should fail if nothing is found with the name" do
          DescModelFinder.stub(:find).with("Bob", @client) { nil }
          DescCommandHandler.should_not_receive(:execute)

          cmd = Command.new(@client, "desc Bob=New desc")
          @desc.on_command(@client, cmd)
        end
        
        it "should let you desc a multi-word object name" do
          # Return nil because we don't care about actually executing the handler, just about
          # whether we can find the room.
          DescModelFinder.should_receive(:find).with("Bob's Room", @client) { nil }
          cmd = Command.new(@client, "desc Bob's Room=New desc")
          @desc.on_command(@client, cmd)
        end
        
        it "should find the model" do
          model = mock
          DescModelFinder.should_receive(:find).with("Bob", @client) { model }
          DescCommandHandler.stub(:execute)

          cmd = Command.new(@client, "desc Bob=New desc")
          @desc.on_command(@client, cmd)
        end
        
        it "should call the command handler" do
          model = mock
          DescModelFinder.stub(:find).with("Bob", @client) { model }
          DescCommandHandler.should_receive(:execute).with(model, "New desc", @client)

          cmd = Command.new(@client, "desc Bob=New desc")
          @desc.on_command(@client, cmd)
        end
      end
    end
        
  end
end