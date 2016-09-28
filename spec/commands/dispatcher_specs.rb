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
      @char = double
      @client.stub(:char) { @char }
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
          @handler = double
          @handler_class = double
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
          @plugin1.should_receive(:get_cmd_handler).with(@client, @command, @char) { false }
          @plugin2.should_receive(:get_cmd_handler).with(@client, @command, @char) { false }
          @dispatcher.on_command(@client, @command)
        end      
            
        it "stops after finding one plugin to handle the command" do
          plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
          @handler_class.stub(:new) { @handler }
          @handler.should_receive(:on_command).with(@client, @command, @char)
          @plugin1.should_receive(:get_cmd_handler).with(@client, @command, @char) { @handler_class }
          @plugin2.should_not_receive(:get_cmd_handler)
          @dispatcher.on_command(@client, @command)
        end
      
        it "continues processing if the first plugin doesn't want the command" do
          plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
          @handler_class.stub(:new) { @handler }
          @handler.should_receive(:on_command).with(@client, @command, @char)
          @plugin1.should_receive(:get_cmd_handler).with(@client, @command, @char) { nil }
          @plugin2.should_receive(:get_cmd_handler).with(@client, @command, @char) { @handler_class }
          @dispatcher.on_command(@client, @command)
        end

        it "sends huh message if nobody handles the command" do
          plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
          @plugin1.should_receive(:get_cmd_handler).with(@client, @command, @char) { nil }
          @plugin2.should_receive(:get_cmd_handler).with(@client, @command, @char) { nil }
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
          @plugin1.should_receive(:get_cmd_handler).and_raise("an error")
          @plugin2.should_receive(:get_cmd_handler).with(@client, @command, @char)
          @dispatcher.on_command(@client, @command)
        end
        
        it "catches exceptions from within the command handling" do
          plugin_manager.stub(:plugins) { [ @plugin1 ] }
          @plugin1.stub(:get_cmd_handler).and_raise("an error")
          @command.stub(:raw) { "raw" }
          @client.should_receive(:emit_failure).with("dispatcher.unexpected_error")
          @dispatcher.on_command(@client, @command)
        end
      
        it "allows a plugin exit exception to bubble up" do
          plugin_manager.stub(:plugins) { [ @plugin1 ] }
          @plugin1.stub(:get_cmd_handler) { true }
          @plugin1.stub(:get_cmd_handler).and_raise(SystemExit)
          expect {@dispatcher.on_command(@client, @command)}.to raise_error(SystemExit)
        end
      end
    end

    describe :on_event do
      before do
        dispatcher.stub(:spawn).and_yield
      end
      
      it "should send the event to any class that handles it" do
        plugin1 = double
        plugin2 = double
        plugin_manager.stub(:plugins) { [ plugin1, plugin2 ] }
        event = double
        handler_class = double
        handler1 = double
        handler2 = double
        handler_class.should_receive(:new) { handler1 }
        handler_class.should_receive(:new) { handler2 }
        plugin1.should_receive(:get_event_handler).with(event.class.to_s) { handler_class }
        plugin2.should_receive(:get_event_handler).with(event.class.to_s) { handler_class }
        handler1.should_receive(:on_event).with(event)
        handler2.should_receive(:on_event).with(event)
        @dispatcher.on_event event
      end
      
      it "should not send event to a class that doesn't want it" do
        plugin1 = double
        plugin2 = double
        plugin_manager.stub(:plugins) { [ plugin1, plugin2 ] }
        event = double
        handler_class = double
        handler = double
        handler_class.should_receive(:new) { handler }
        plugin1.should_receive(:get_event_handler).with(event.class.to_s) { nil }
        plugin2.should_receive(:get_event_handler).with(event.class.to_s) { handler_class }
        handler.should_receive(:on_event).with(event)
        @dispatcher.on_event event
      end
      
    end
  end
end