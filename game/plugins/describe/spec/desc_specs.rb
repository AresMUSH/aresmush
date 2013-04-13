require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
  
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
        end
        
        it "should fail if no desc is specified" do
          Describe.should_not_receive(:set_desc)
          @client.should_receive(:emit_failure).with('invalid_desc_syntax')
          cmd = Command.new(@client, "desc Bob")
          @desc.on_command(@client, cmd)
        end
        
        it "should fail if nothing is visible with the name" do
          Rooms.should_receive(:find_visible_object).with("Bob", @client) { nil }
          Describe.should_not_receive(:set_desc)

          cmd = Command.new(@client, "desc Bob=New desc")
          @desc.on_command(@client, cmd)
        end
        
        it "should set the desc if visible" do          
          Rooms.should_receive(:find_visible_object).with("Bob", @client) { @model }
          Describe.should_receive(:set_desc).with(@model, "New desc")
          cmd = Command.new(@client, "desc Bob=New desc")
          @desc.on_command(@client, cmd)
        end
        
        it "should notify the client" do
          Rooms.stub(:find_visible_object).with("Bob", @client) { @model }
          Describe.stub(:set_desc).with(@model, "New desc")
          
          @client.should_receive(:emit_success).with("desc_set")

          cmd = Command.new(@client, "desc Bob=New desc")
          @desc.on_command(@client, cmd)
        end
        
        it "should let you desc a multi-word object name" do
          Rooms.should_receive(:find_visible_object).with("Bob's Room", @client) { @model }
          Describe.should_receive(:set_desc).with(@model, "New desc")
          cmd = Command.new(@client, "desc Bob's Room=New desc")
          @desc.on_command(@client, cmd)
        end
      end
    end
  end
end