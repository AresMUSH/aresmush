$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  class ArbitraryEvent
  end
  
  describe Dispatcher do
    include GlobalTestHelper

    before do
      stub_global_objects
      @enactor = double
      @client = double
      allow(@client).to receive(:id) { "1" }
      allow(@client).to receive(:room) { nil }
      allow(@client).to receive(:char) { @enactor }
      @command = Command.new("x")
      @dispatcher = Dispatcher.new
      @plugin1 = double
      @plugin2 = double
      allow(@plugin1).to receive(:log_command)
      allow(@plugin2).to receive(:log_command)
      @shortcuts = {}
      allow(@client).to receive(:emit_ooc)
      allow(@enactor).to receive(:is_statue?) { false }
      allow(plugin_manager).to receive(:shortcuts) { @shortcuts }
      allow(CommandAliasParser).to receive(:substitute_aliases)
      stub_translate_for_testing
    end

    describe :on_command do
      context "No Errors" do
        before do 
          allow(Global.logger).to receive(:error) do |msg| 
            raise msg
          end
          @handler = double
          @handler_class = double
          allow(plugin_manager).to receive(:sorted_plugins) { [] }
        end
        
        it "performs alias substitutions" do
          expect(CommandAliasParser).to receive(:substitute_aliases).with(@enactor, @command, @shortcuts)
          @dispatcher.on_command(@client, @command)
        end
      
        it "should look up the enactor" do
          expect(@client).to receive(:char) { @enactor }
          @dispatcher.on_command(@client, @command)
        end
        
        it "should do nothing if enactor is a statue" do
          expect(@enactor).to receive(:is_statue?) { true }
          expect(@client).to receive(:emit_failure).with("dispatcher.you_are_statue")
          @dispatcher.on_command(@client, @command)
        end
        
        it "gets the list of plugins from the plugin manager" do
          expect(plugin_manager).to receive(:sorted_plugins) { [] }
          @dispatcher.on_command(@client, @command)
        end
      
        it "asks each plugin if it wants a command" do
          allow(plugin_manager).to receive(:sorted_plugins) { [ @plugin1, @plugin2 ] }
          expect(@plugin1).to receive(:get_cmd_handler).with(@client, @command, @enactor) { false }
          expect(@plugin2).to receive(:get_cmd_handler).with(@client, @command, @enactor) { false }
          @dispatcher.on_command(@client, @command)
        end      
            
        it "stops after finding one plugin to handle the command" do
          allow(plugin_manager).to receive(:sorted_plugins) { [ @plugin1, @plugin2 ] }
          allow(@handler_class).to receive(:new).with(@client, @command, @enactor) { @handler }
          expect(@handler).to receive(:on_command)
          expect(@plugin1).to receive(:get_cmd_handler).with(@client, @command, @enactor) { @handler_class }
          expect(@plugin2).to_not receive(:get_cmd_handler)
          @dispatcher.on_command(@client, @command)
        end
      
        it "continues processing if the first plugin doesn't want the command" do
          allow(plugin_manager).to receive(:sorted_plugins) { [ @plugin1, @plugin2 ] }
          allow(@handler_class).to receive(:new).with(@client, @command, @enactor) { @handler }
          expect(@handler).to receive(:on_command)
          expect(@plugin1).to receive(:get_cmd_handler).with(@client, @command, @enactor) { nil }
          expect(@plugin2).to receive(:get_cmd_handler).with(@client, @command, @enactor) { @handler_class }
          @dispatcher.on_command(@client, @command)
        end

        it "sends huh message if nobody handles the command" do
          allow(plugin_manager).to receive(:sorted_plugins) { [ @plugin1, @plugin2 ] }
          expect(@plugin1).to receive(:get_cmd_handler).with(@client, @command, @enactor) { nil }
          expect(@plugin2).to receive(:get_cmd_handler).with(@client, @command, @enactor) { nil }
          expect(@client).to receive(:emit_ooc).with("dispatcher.huh")
          @dispatcher.on_command(@client, @command)
        end      
      end
    
      context "Errors" do
        
        before do
          allow(@dispatcher).to receive(:queue_event) { }
        end
      
        it "keeps asking plugins if they want the command after an error" do
          allow(plugin_manager).to receive(:sorted_plugins) { [ @plugin1, @plugin2 ] }
          expect(@plugin1).to receive(:get_cmd_handler).and_raise("an error")
          expect(@plugin2).to receive(:get_cmd_handler).with(@client, @command, @enactor)
          @dispatcher.on_command(@client, @command)
        end
        
        it "catches exceptions from within the command handling" do
          allow(plugin_manager).to receive(:sorted_plugins) { [ @plugin1 ] }
          allow(@plugin1).to receive(:get_cmd_handler).and_raise("an error")
          allow(@command).to receive(:raw) { "raw" }
          expect(@client).to receive(:emit_failure).with("dispatcher.unexpected_error")
          @dispatcher.on_command(@client, @command)
        end
      
        it "allows a plugin exit exception to bubble up" do
          allow(plugin_manager).to receive(:sorted_plugins) { [ @plugin1 ] }
          allow(@plugin1).to receive(:get_cmd_handler) { true }
          allow(@plugin1).to receive(:get_cmd_handler).and_raise(SystemExit)
          expect {@dispatcher.on_command(@client, @command)}.to raise_error(SystemExit)
        end
      end
    end

    describe :on_event do
      before do
        allow(dispatcher).to receive(:spawn).and_yield
      end
      
      it "should send the event to any class that handles it" do
        plugin1 = double
        plugin2 = double
        allow(plugin_manager).to receive(:sorted_plugins) { [ plugin1, plugin2 ] }
        event = double
        handler_class = double
        handler1 = double
        handler2 = double
        expect(handler_class).to receive(:new) { handler1 }
        expect(handler_class).to receive(:new) { handler2 }
        expect(plugin1).to receive(:get_event_handler).with(event.class.to_s) { handler_class }
        expect(plugin2).to receive(:get_event_handler).with(event.class.to_s) { handler_class }
        expect(handler1).to receive(:on_event).with(event)
        expect(handler2).to receive(:on_event).with(event)
        @dispatcher.on_event event
      end
      
      it "should not send event to a class that doesn't want it" do
        plugin1 = double
        plugin2 = double
        allow(plugin_manager).to receive(:sorted_plugins) { [ plugin1, plugin2 ] }
        event = double
        handler_class = double
        handler = double
        expect(handler_class).to receive(:new) { handler }
        expect(plugin1).to receive(:get_event_handler).with(event.class.to_s) { nil }
        expect(plugin2).to receive(:get_event_handler).with(event.class.to_s) { handler_class }
        expect(handler).to receive(:on_event).with(event)
        @dispatcher.on_event event
      end
      
    end
  end
end
