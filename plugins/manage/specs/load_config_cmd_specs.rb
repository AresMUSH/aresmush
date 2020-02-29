require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadConfigCmd do
      include GlobalTestHelper
  
      before do
        @client = double
        @handler = LoadConfigCmd.new(@client, nil, nil)
        stub_translate_for_testing
        stub_global_objects
        allow(dispatcher).to receive(:queue_event)
      end
            
      describe :handle do
        before do
          allow(config_reader).to receive(:clear_config)
          allow(config_reader).to receive(:load_game_config)
          allow(config_reader).to receive(:validate_game_config)
          allow(help_reader).to receive(:load_game_help)
          allow(plugin_manager).to receive(:check_plugin_config) { [] }
          @plugin = double
          allow(plugin_manager).to receive(:plugins) { [@plugin] }
        end
        
        it "should reset and load the game config" do           
          expect(config_reader).to receive(:load_game_config) {}
          expect(@client).to receive(:emit_success).with('manage.config_loaded')
          @handler.handle
        end
        
        it "should handle errors from game config" do
          expect(config_reader).to receive(:validate_game_config).and_raise("error")
          expect(@client).to receive(:emit_failure).with('manage.game_config_invalid')
          @handler.handle
        end   
        
        it "should handle errors from plugin config" do
          allow(plugin_manager).to receive(:check_plugin_config) { [ 'errors' ] }
          expect(@client).to receive(:emit_failure).with('manage.error_loading_config')
          @handler.handle
        end    
        
        it "should send the config updated event" do
          expect(@client).to receive(:emit_success).with('manage.config_loaded')
          expect(dispatcher).to receive(:queue_event) do |event|
            expect(event.class).to eq ConfigUpdatedEvent
          end
          @handler.handle          
        end
              
      end
    end
  end
end
