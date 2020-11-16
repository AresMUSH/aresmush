require_relative "../../plugin_test_loader"

module AresMUSH
  module Scenes
    describe Scenes do
      describe :parse_web_pose do
        before do
          @enactor = double
          @room = double
          
          allow(@enactor).to receive(:name) { "Bob" }
          allow(AresMUSH::Locale).to receive(:translate).with("object.say", { :name => "Bob", :msg => "Hi." }) { "Bob says, \"Hi.\"" }
          allow(AresMUSH::Locale).to receive(:translate).with("object.pose", { :name => "Bob", :msg => "dances." }) { "Bob dances." }
        end

        context "OOC Poses" do
          it "should format a pose with an OOC prefix" do
            result = Scenes.parse_web_pose("ooc :dances.", @enactor, "pose")
            expect(result[:pose]).to eq "Bob dances."
            expect(result[:is_ooc]).to eq true
            expect(result[:is_emit]).to eq false
            expect(result[:is_setpose]).to eq false
            expect(result[:is_gmpose]).to eq false
          end
          
          it "should format a pose from the OOC button" do
            result = Scenes.parse_web_pose(":dances.", @enactor, "ooc")
            expect(result[:pose]).to eq "Bob dances."
            expect(result[:is_ooc]).to eq true
            expect(result[:is_emit]).to eq false
            expect(result[:is_setpose]).to eq false
            expect(result[:is_gmpose]).to eq false
          end
        end
        
        context "GM Poses" do
          it "should format a pose with an emit/gm prefix" do
            result = Scenes.parse_web_pose("emit/gm Dance party.", @enactor, "pose")
            expect(result[:pose]).to eq "Dance party."
            expect(result[:is_ooc]).to eq false
            expect(result[:is_emit]).to eq true
            expect(result[:is_setpose]).to eq false
            expect(result[:is_gmpose]).to eq true
          end
          
          it "should format a pose from the GM pose button" do
            result = Scenes.parse_web_pose("Dance party.", @enactor, "gm")
            expect(result[:pose]).to eq "Dance party."
            expect(result[:is_ooc]).to eq false
            expect(result[:is_emit]).to eq true
            expect(result[:is_setpose]).to eq false
            expect(result[:is_gmpose]).to eq true
          end
        end
        
        context "Set Poses" do
          it "should format a pose with an emit/set prefix" do
            result = Scenes.parse_web_pose("emit/set Dance party.", @enactor, "pose")
            expect(result[:pose]).to eq "Dance party."
            expect(result[:is_ooc]).to eq false
            expect(result[:is_emit]).to eq true
            expect(result[:is_setpose]).to eq true
            expect(result[:is_gmpose]).to eq false
          end
          
          it "should format a pose from the Set Pose button" do
            result = Scenes.parse_web_pose("Dance party.", @enactor, "setpose")
            expect(result[:pose]).to eq "Dance party."
            expect(result[:is_ooc]).to eq false
            expect(result[:is_emit]).to eq true
            expect(result[:is_setpose]).to eq true
            expect(result[:is_gmpose]).to eq false
          end
        end
        
        context "Regular Poses" do
          it "should format a pose with an emit prefix" do
            result = Scenes.parse_web_pose("emit Dance party.", @enactor, "pose")
            expect(result[:pose]).to eq "Dance party."
            expect(result[:is_ooc]).to eq false
            expect(result[:is_emit]).to eq true
            expect(result[:is_setpose]).to eq false
            expect(result[:is_gmpose]).to eq false
          end
          
          it "should format a regular pose" do
            result = Scenes.parse_web_pose(":dances.", @enactor, "pose")
            expect(result[:pose]).to eq "Bob dances."
            expect(result[:is_ooc]).to eq false
            expect(result[:is_emit]).to eq false
            expect(result[:is_setpose]).to eq false
            expect(result[:is_gmpose]).to eq false
          end
          
          it "should format a pose startig with a quote as an emit" do
            result = Scenes.parse_web_pose("\"Hi there,\" Fara said.", @enactor, "pose")
            expect(result[:pose]).to eq "\"Hi there,\" Fara said."
            expect(result[:is_ooc]).to eq false
            expect(result[:is_emit]).to eq true
            expect(result[:is_setpose]).to eq false
            expect(result[:is_gmpose]).to eq false
          end
          
          it "should format a pose startig with an apostrophe as an emit" do
            result = Scenes.parse_web_pose("'Hi there,' Fara said.", @enactor, "pose")
            expect(result[:pose]).to eq "'Hi there,' Fara said."
            expect(result[:is_ooc]).to eq false
            expect(result[:is_emit]).to eq true
            expect(result[:is_setpose]).to eq false
            expect(result[:is_gmpose]).to eq false
          end
          
          it "should format a pose with no prefix as an emit" do
            result = Scenes.parse_web_pose("Dance party.", @enactor, "pose")
            expect(result[:pose]).to eq "Dance party."
            expect(result[:is_ooc]).to eq false
            expect(result[:is_emit]).to eq true
            expect(result[:is_setpose]).to eq false
            expect(result[:is_gmpose]).to eq false
          end
        end
        
        context "Commands" do
          it "should parse a command without args" do
            result = Scenes.parse_web_pose("/dance", @enactor, "pose")
            expect(result[:command]).to eq "dance"
            expect(result[:args]).to eq ""
          end
          
          it "should parse a command with args" do
            result = Scenes.parse_web_pose("/dance x=y", @enactor, "pose")
            expect(result[:command]).to eq "dance"
            expect(result[:args]).to eq "x=y"
          end
        end
        
      end
    end
  end
end
