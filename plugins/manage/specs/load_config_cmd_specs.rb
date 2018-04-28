require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadConfigCmd do
      include GlobalTestHelper
  
      before do
        @client = double
        @handler = LoadConfigCmd.new(@client, nil, nil)
        SpecHelpers.stub_translate_for_testing
        stub_global_objects
        dispatcher.stub(:queue_event)
      end
            
      describe :handle do
        before do
          config_reader.stub(:clear_config)
          config_reader.stub(:load_game_config)
          config_reader.stub(:validate_game_config)
          help_reader.stub(:load_game_help)
          @plugin = double
          plugin_manager.stub(:plugins) { [@plugin] }
        end
        
        it "should reset and load the game config" do           
          config_reader.should_receive(:load_game_config) {}
          @client.should_receive(:emit_success).with('manage.config_loaded')
          @handler.handle
        end
        
        it "should handle errors from game config" do
          config_reader.should_receive(:validate_game_config).and_raise("error")
          @client.should_receive(:emit_failure).with('manage.game_config_invalid')
          @handler.handle
        end    
        
        it "should send the config updated event" do
          @client.should_receive(:emit_success).with('manage.config_loaded')
          dispatcher.should_receive(:queue_event) do |event|
            event.class.should eq ConfigUpdatedEvent
          end
          @handler.handle          
        end
              
      end
    end
  end
end