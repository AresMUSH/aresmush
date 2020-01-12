require_relative "../../plugin_test_loader"

module AresMUSH
  module Scenes
    describe Scenes do
      describe :custom_format do
        before do
          @char = double
          @enactor = double
          @place = double
          @room = double
          
          allow(@enactor).to receive(:name) { "Bob" }
          allow(@enactor).to receive(:place) { nil }
          allow(@char).to receive(:pose_quote_color) { nil }
          allow(@char).to receive(:pose_nospoof) { nil }
          allow(@char).to receive(:pose_autospace) { "" }
          allow(Scenes).to receive(:format_autospace) do |enactor, format|
            format
          end
          
          stub_translate_for_testing
        end
        
        it "should format quote color" do
          allow(Scenes).to receive(:format_quote_color).with("Test", @char, false) { "Colored Quotes" }
          expect(Scenes.custom_format("Test", @room, @char, @enactor)).to eq "Colored Quotes"
        end
        
        it "should include place title if set" do
          allow(Scenes).to receive(:format_for_place).with(@room, @enactor, @char, "Test", false, nil) { "xxxTest" }
          expect(Scenes.custom_format("Test", @room, @char, @enactor)).to eq "xxxTest"
        end
                
        it "should include autospace if set" do
          allow(@char).to receive(:pose_autospace) { "%R" }
          expect(Scenes).to receive(:format_autospace).with(@enactor, "%R") { "-%R-" }
          expect(Scenes.custom_format("Test", @room, @char, @enactor)).to eq "-%R-Test"
        end
        
        it "should use page autospace for an OOC remark" do
          allow(@char).to receive(:page_autospace) { "%R" }
          expect(Scenes).to receive(:format_autospace).with(@enactor, "%R") { "-%R-" }
          expect(Scenes.custom_format("Test", @room, @char, @enactor, false, true)).to eq "-%R-Test"
        end
        
        it "should include nospoof if set and if an emit" do
          allow(@char).to receive(:pose_nospoof) { true }
          expect(Scenes.custom_format("Test", @room, @char, @enactor, true)).to eq "%xc%% scenes.emit_nospoof_from%xn%RTest"
        end
        
        it "should not include nospoof if not an emit" do
          allow(@char).to receive(:pose_nospoof) { true }
          expect(Scenes.custom_format("Test", @room, @char, @enactor, false)).to eq "Test"
        end
      end
      
      describe :format_quote_color do
        
        before do
          @char = double
          allow(@char).to receive(:pose_quote_color) { "%xh" }
        end
        
        it "should handle quote at front and end" do
          pose = "The cat said, \"I'm going to jump over the brown fox.\"  And then he did.  \"Whee!\" he shouted."
          expected = "The cat said, %xh\"I'm going to jump over the brown fox.\"%xn  And then he did.  %xh\"Whee!\"%xn he shouted."
          expect(Scenes.format_quote_color(pose, @char, false)).to eq expected
        end
        
        it "should handle quote at front but not end" do
          pose = "\"I'm going to jump over the brown fox,\" said the cat. And then he did.  \"Whee!\" he shouted."
          expected = "%xh\"I'm going to jump over the brown fox,\"%xn said the cat. And then he did.  %xh\"Whee!\"%xn he shouted."
          expect(Scenes.format_quote_color(pose, @char, false)).to eq expected
        end
        
        it "should handle quote at end but not front" do
          pose = "The cat said, \"I'm going to jump over the brown fox.\"  And then he did.  \"Whee!\""
          expected = "The cat said, %xh\"I'm going to jump over the brown fox.\"%xn  And then he did.  %xh\"Whee!\"%xn"
          expect(Scenes.format_quote_color(pose, @char, false)).to eq expected
        end
        
        it "should handle quotes at both ends" do
          pose = "\"I'm going to jump over the brown fox,\" said the cat. And then he did.  \"Whee!\""
          expected = "%xh\"I'm going to jump over the brown fox,\"%xn said the cat. And then he did.  %xh\"Whee!\"%xn"
          expect(Scenes.format_quote_color(pose, @char, false)).to eq expected
        end
        
        it "should handle more than two quotes" do
          pose = "The cat said, \"Whee!\" and then \"Whoosh!\" and then \"Wow!\"."
          expected = "The cat said, %xh\"Whee!\"%xn and then %xh\"Whoosh!\"%xn and then %xh\"Wow!\"%xn."
          expect(Scenes.format_quote_color(pose, @char, false)).to eq expected
        end
        
        it "should handle a single quote randomly" do
          pose = "The cat said, \"Whee! and then stopped."
          # Quote gets lost but that's OK for now.
          expected = "The cat said, %xh\"Whee! and then stopped.%xn"
          expect(Scenes.format_quote_color(pose, @char, false)).to eq expected
        end
        
        it "should handle no quotes" do
          pose = "The cat said he was going to jump over the brown fox."
          expect(Scenes.format_quote_color(pose, @char, false)).to eq pose
        end
        
        it "should handle smart quotes" do
          pose = "The cat said, \u201EI'm going to jump over the brown fox.\u2036  And then he did."
          expected = "The cat said, %xh\u201EI'm going to jump over the brown fox.\u2036%xn  And then he did."
          expect(Scenes.format_quote_color(pose, @char, false)).to eq expected
        end
        
        it "should not die if there's a missing quote" do
          pose = "The cat said, \"Whee! and then \"Whoosh!\" and then \"Wow!\"."
          # Doesn't highlight the right thing but at least all the text is included.  Best we can do with mismatched quotes.
          expected = "The cat said, %xh\"Whee! and then \"%xnWhoosh!%xh\" and then \"%xnWow!%xh\".%xn"
          expect(Scenes.format_quote_color(pose, @char, false)).to eq expected
        end
        
        it "should not colorize an OOC remark" do
          allow(@char).to receive(:page_autospace) { "" }
          pose = "The cat said, \"Whee!\" and then \"Whoosh!\" and then \"Wow!\"."
          expect(Scenes.format_quote_color(pose, @char, true)).to eq pose
        end
        
        it "should not colorize if color is blank" do
          allow(@char).to receive(:pose_quote_color) { "" }
          pose = "The cat said, \"Whee!\" and then \"Whoosh!\" and then \"Wow!\"."
          expect(Scenes.format_quote_color(pose, @char, false)).to eq pose
        end
      end
    end
  end
end
