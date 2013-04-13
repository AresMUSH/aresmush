require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe Look do
      before do
        container = double(Container)
        container.stub(:plugin_manager) { @plugin_manager }
        @plugin_manager = double(PluginManager)
        @client = double(Client)
        @look = Look.new(container)
        AresMUSH::Locale.stub(:translate).with("object.here") { "here" }        
      end
      
      describe :want_anon_command? do
        it "doesn't want any commands" do
          cmd = mock
          @look.want_anon_command?(cmd).should be_false
        end
      end

      describe :want_command? do
        it "wants the look command" do
          cmd = mock
          cmd.stub(:root_is?).with("look") { true }
          @look.want_command?(cmd).should be_true
        end

        it "doesn't want another command" do
          cmd = mock
          cmd.stub(:root_is?).with("look") { false }
          @look.want_command?(cmd).should be_false
        end
      end
      
      describe :on_command do
        before do
          @client.stub(:emit)
          @desc_interface = mock(DescFunctions)
        end
        
        it "should default to here if nothing specified" do
          cmd = Command.new(@client, "look")
          Rooms.should_receive(:find_visible_object).with("here", @client) { nil }
          @look.on_command(@client, cmd)
        end

        it "should look for an object with the specified name" do
          Rooms.should_receive(:find_visible_object).with("Bob", @client) { nil }
          cmd = Command.new(@client, "look Bob")
          @look.on_command(@client, cmd)
        end
        
        it "should allow an object with a multi-word name" do
          Rooms.should_receive(:find_visible_object).with("Bob's Room", @client) { nil }
          cmd = Command.new(@client, "look Bob's Room")
          @look.on_command(@client, cmd)
        end

        it "should fail if nothing is visible with the name" do
          Rooms.stub(:find_visible_object).with("Bob", @client) { nil }
          Describe.should_not_receive(:get_desc)
          cmd = Command.new(@client, "look Bob")
          @look.on_command(@client, cmd)
        end
                
        it "should get the desc if visible" do
          model = mock
          Describe.should_receive(:interface).with(@plugin_manager) { @desc_interface }
          Rooms.stub(:find_visible_object).with("Bob", @client) { model }
          @desc_interface.should_receive(:get_desc).with(model) { "desc" }
          cmd = Command.new(@client, "look Bob")
          @look.on_command(@client, cmd)
        end
        
        it "should emit the desc to the client" do
          model = mock
          Describe.should_receive(:interface).with(@plugin_manager) { @desc_interface }
          Rooms.stub(:find_visible_object).with("Bob", @client) { model }
          @desc_interface.stub(:get_desc).with(model) { "desc" }
          @client.should_receive(:emit).with("desc")
          cmd = Command.new(@client, "look Bob")
          @look.on_command(@client, cmd)
        end
      end
    end
  end
end