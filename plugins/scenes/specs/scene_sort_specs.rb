require_relative "../../plugin_test_loader"

module AresMUSH
  module Scenes
    describe LiveScenesRequestHandler do      
      describe :sort_scene do
        before do
          @private1 = double("private1")
          @private2 = double("private2")
          @open1 = double("open1")
          @open2 = double("open2")
          @yours1 = double("yours1")
          @yours2 = double("yours2")
          @enactor = double

          allow(Scenes).to receive(:is_participant?).with(@open1, @enactor) { false }
          allow(Scenes).to receive(:is_participant?).with(@open2, @enactor) { false }
          allow(Scenes).to receive(:is_participant?).with(@yours1, @enactor) { true }
          allow(Scenes).to receive(:is_participant?).with(@yours2, @enactor) { true }
          allow(Scenes).to receive(:is_participant?).with(@private1, @enactor) { false }
          allow(Scenes).to receive(:is_participant?).with(@private2, @enactor) { false }
          
          allow(@open1).to receive(:private_scene) { false }
          allow(@open2).to receive(:private_scene) { false }
          allow(@yours1).to receive(:private_scene) { false }
          allow(@yours2).to receive(:private_scene) { false }
          allow(@private1).to receive(:private_scene) { true }
          allow(@private2).to receive(:private_scene) { true }

          @handler = LiveScenesRequestHandler.new
        end

        context "basic sort" do
          it "should sort your scenes then open scenes then private scenes" do
            scenes = [ @open1, @private1, @yours1 ]
            sorted = scenes.sort { |s1, s2| @handler.sort_scene(s1, s2, @enactor) }
            expect(sorted[0]).to eq @yours1
            expect(sorted[1]).to eq @open1
            expect(sorted[2]).to eq @private1
          end
        end
        
        context "prefer open" do
          it "should sort your open scenes ahead of your private scenes" do
            allow(@yours1).to receive(:private_scene) { true }
            scenes = [ @open1, @yours2, @yours1 ]
            sorted = scenes.sort { |s1, s2| @handler.sort_scene(s1, s2, @enactor) }
            expect(sorted[0]).to eq @yours2
            expect(sorted[1]).to eq @yours1
            expect(sorted[2]).to eq @open1
          end
        end
        
        context "sort by date" do
          it "should sort recent updated scenes first" do
            allow(@private1).to receive(:updated_at) { DateTime.new(2021, 2, 6) }
            allow(@private2).to receive(:updated_at) {DateTime.new(2021, 1, 7) }

            scenes = [ @private1, @private2 ]
            sorted = scenes.sort { |s1, s2| @handler.sort_scene(s1, s2, @enactor) }
            expect(sorted[0]).to eq @private1
            expect(sorted[1]).to eq @private2
          end
        end
        
        context "sort combined" do
          it "should sort all scenes" do

            allow(@open1).to receive(:updated_at) { DateTime.new(2021, 1, 2) }
            allow(@open2).to receive(:updated_at) { DateTime.new(2021, 1, 3) }
            allow(@yours1).to receive(:updated_at) {DateTime.new(2021, 1, 4) }
            allow(@yours2).to receive(:updated_at) {DateTime.new(2021, 1, 5) }
            allow(@private1).to receive(:updated_at) { DateTime.new(2021, 1, 6) }
            allow(@private2).to receive(:updated_at) {DateTime.new(2021, 1, 7) }

            scenes = [ @open1, @private2, @yours2, @yours1, @open2, @private1 ]
            sorted = scenes.sort { |s1, s2| @handler.sort_scene(s1, s2, @enactor) }
            expect(sorted[0]).to eq @yours2
            expect(sorted[1]).to eq @yours1
            expect(sorted[2]).to eq @open2
            expect(sorted[3]).to eq @open1
            expect(sorted[4]).to eq @private2
            expect(sorted[5]).to eq @private1
          end
        end
        
      end
    end
  end
end
