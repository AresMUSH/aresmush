require_relative "../../plugin_test_loader"

module AresMUSH
  module Handles
    describe HandlesEventHandler do
      include GlobalTestHelper
      include MockClient
      
      before do
        Global.stub(:read_config).with("api", "cron") { "x" }
        stub_global_objects
        @char = double
        @client = double
        @router = double
        Cron.stub(:is_cron_match?) { true }
      end
      
  
      context "success" do
        before do
          #@char.should_receive(:save!)
          @char.stub(:handle_friends=)
          @char.stub(:autospace=)
          @char.stub(:timezone=)
          @char.stub(:handle_friends) { [] }
          @char.stub(:autospace) { "" }
          @char.stub(:timezone) { "" }
        end
  
        it "should set the preferences if sync is on" do
          # TODO!!!
          #@char.stub(:handle_sync) { true }
          #@char.should_receive(:handle_friends=).with(["F1", "F2"])
          #@char.should_receive(:autospace=).with("as")
          #@char.should_receive(:timezone=).with("tz")
          #@client.should_receive(:emit_ooc).with("api.handle_synced")
          #Global.api_router.route_response(@client, response)
        end
  
        it "should only set friends if sync is off" do
          # TODO!!!
          #@char.stub(:handle_sync) { false }
          #response = ApiResponse.new("sync", ApiResponse.ok_status, "F1 F2||as||tz")
          #@char.should_receive(:handle_friends=).with(["F1", "F2"])
          #@char.should_not_receive(:autospace=)
          #@char.should_not_receive(:timezone=)
          #Global.api_router.route_response(@client, response)
        end     
  
        it "should need update if friends are different" do
          # TODO!!!
          #@response.stub(:args_str) { "F1 F2 F3||as||tz" }
          #Handles.update_needed(@char).should be_true
        end
  
        it "should need update if autospace is different" do
          # TODO!!!
          #@response.stub(:args_str) { "F1 F2||as2||tz" }
          #Handles.update_needed(@char).should be_true
        end 
  
        it "should need update if timezone is different" do
          # TODO!!!
          #@response.stub(:args_str) { "F1 F2||as||tz2" }
          #Handles.update_needed(@char).should be_true
        end
  
        it "should not need update if everything is same" do
          # TODO!!!
          #@response.stub(:args_str) { "F1 F2||as||tz" }
          #Handles.update_needed(@char).should be_false
        end
      end
    end
  end
end

