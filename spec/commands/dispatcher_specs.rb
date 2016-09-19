$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  class ArbitraryEvent
  end
  
  describe Dispatcher do
    include GlobalTestHelper

    before do
      stub_global_objects
      @client = double(Client).as_null_object
      @client.stub(:id) { "1" }
      @client.stub(:room) { nil }
      @command = Command.new("x")
      @dispatcher = Dispatcher.new
      @plugin1 = double
      @plugin2 = double
      @plugin1.stub(:log_command)
      @plugin2.stub(:log_command)
      @shortcuts = {}
      plugin_manager.stub(:shortcuts) { @shortcuts }
      SpecHelpers.stub_translate_for_testing
    end

    describe :on_command do
      context "No Errors" do
        before do 
          Global.logger.stub(:error) do |msg| 
            raise msg
          end
        end
        
        it "performs alias substitutions" do
          plugin_manager.stub(:plugins) { [] }
          CommandAliasParser.should_receive(:substitute_aliases).with(@client, @command, @shortcuts)
          @dispatcher.on_command(@client, @command)
        end
      
        it "gets the list of plugins from the plugin manager" do
          plugin_manager.should_receive(:plugins) { [] }
          @dispatcher.on_command(@client, @command)
        end
      
        it "asks each plugin if it wants a command" do
          plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
          @plugin1.should_receive(:handle_command).with(@client, @command) { false }
          @plugin2.should_receive(:handle_command).with(@client, @command) { false }
          @dispatcher.on_command(@client, @command)
        end      
            
        it "stops after finding one plugin to handle the command" do
          plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
          @plugin1.should_receive(:handle_command).with(@client, @command) { true }
          @plugin2.should_not_receive(:handle_command)
          @dispatcher.on_command(@client, @command)
        end
      
        it "continues processing if the first plugin doesn't want the command" do
          plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
          @plugin1.should_receive(:handle_command).with(@client, @command) { false }
          @plugin2.should_receive(:handle_command).with(@client, @command) { true }
          @dispatcher.on_command(@client, @command)
        end

        it "sends huh message if nobody handles the command" do
          plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
          @plugin1.should_receive(:handle_command).with(@client, @command) { false }
          @plugin2.should_receive(:handle_command).with(@client, @command) { false }
          @client.should_receive(:emit_ooc).with("dispatcher.huh")
          @dispatcher.on_command(@client, @command)
        end      
      end
    
      context "Errors" do
        
        before do
          @dispatcher.stub(:queue_event) { }
        end
      
        it "keeps asking plugins if they want the command after an error" do
          plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
          @plugin1.should_receive(:handle_command).and_raise("an error")
          @plugin2.should_receive(:handle_command).with(@client, @command)
          @dispatcher.on_command(@client, @command)
        end
        
        it "catches exceptions from within the command handling" do
          plugin_manager.stub(:plugins) { [ @plugin1 ] }
          @plugin1.stub(:handle_command).and_raise("an error")
          @command.stub(:raw) { "raw" }
          @client.should_receive(:emit_failure).with("dispatcher.unexpected_error")
          @dispatcher.on_command(@client, @command)
        end
      
        it "allows a plugin exit exception to bubble up" do
          plugin_manager.stub(:plugins) { [ @plugin1 ] }
          @plugin1.stub(:handle_command) { true }
          @plugin1.stub(:handle_command).and_raise(SystemExit)
          expect {@dispatcher.on_command(@client, @command)}.to raise_error(SystemExit)
        end
      end
    end

    describe :on_event do
      it "should send the event to any class that handles it" do
        plugin1 = double
        plugin2 = double
        plugin_manager.stub(:plugins) { [ plugin1, plugin2 ] }
        event = double
        plugin1.should_receive(:handle_event).with(event)
        plugin2.should_receive(:handle_event).with(event)
        @dispatcher.on_event event
      end
    end
  end
end