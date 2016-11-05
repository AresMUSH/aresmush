require_relative "../../plugin_test_loader"

module AresMUSH
  module Pose
    describe Pose do
      describe :custom_format do
        before do
          @char = double
          @enactor = double
          @enactor.stub(:name) { "Bob" }
          @char.stub(:pose_quote_color) { nil }
          @char.stub(:pose_nospoof) { nil }
          @char.stub(:pose_autospace) { "" }
          SpecHelpers.stub_translate_for_testing
        end
        
        describe "colorize" do
          before do
            @char.stub(:pose_quote_color) { "%xh" }
          end
          
          it "should handle no quote at front and end" do
            pose = "The cat said, \"I'm going to jump over the brown fox.\"  And then he did.  \"Whee!\" he shouted."
            expected = "The cat said, %xh\"I'm going to jump over the brown fox.\"%xn  And then he did.  %xh\"Whee!\"%xn he shouted."
            Pose.custom_format(pose, @char, @enactor).should eq expected
          end
          
          it "should handle quote at front but not end" do
            pose = "\"I'm going to jump over the brown fox,\" said the cat. And then he did.  \"Whee!\" he shouted."
            expected = "%xh\"I'm going to jump over the brown fox,\"%xn said the cat. And then he did.  %xh\"Whee!\"%xn he shouted."
            Pose.custom_format(pose, @char, @enactor).should eq expected
          end
          
          it "should handle quote at end but not front" do
            pose = "The cat said, \"I'm going to jump over the brown fox.\"  And then he did.  \"Whee!\""
            expected = "The cat said, %xh\"I'm going to jump over the brown fox.\"%xn  And then he did.  %xh\"Whee!\"%xn"
            Pose.custom_format(pose, @char, @enactor).should eq expected
          end
          
          it "should handle quotes at both ends" do
            pose = "\"I'm going to jump over the brown fox,\" said the cat. And then he did.  \"Whee!\""
            expected = "%xh\"I'm going to jump over the brown fox,\"%xn said the cat. And then he did.  %xh\"Whee!\"%xn"
            Pose.custom_format(pose, @char, @enactor).should eq expected
          end
          
          it "should handle more than two quotes" do
            pose = "The cat said, \"Whee!\" and then \"Whoosh!\" and then \"Wow!\"."
            expected = "The cat said, %xh\"Whee!\"%xn and then %xh\"Whoosh!\"%xn and then %xh\"Wow!\"%xn."
            Pose.custom_format(pose, @char, @enactor).should eq expected
          end
          
          it "should handle a single quote randomly" do
            pose = "The cat said, \"Whee! and then stopped."
            # Quote gets lost but that's OK for now.
            expected = "The cat said, Whee! and then stopped."
            Pose.custom_format(pose, @char, @enactor).should eq expected
          end
          
          it "should handle no quotes" do
            pose = "The cat said he was going to jump over the brown fox."
            Pose.custom_format(pose, @char, @enactor).should eq pose
          end
          
          it "should not die if there's a missing quote" do
            pose = "The cat said, \"Whee! and then \"Whoosh!\" and then \"Wow!\"."
            # Quote gets lost but that's OK for now.
            expected = "The cat said, %xh\"Whee! and then \"%xnWhoosh!%xh\" and then \"%xnWow!."
            Pose.custom_format(pose, @char, @enactor).should eq expected
          end
          
          it "should not colorize an OOC remark" do
            pose = "The cat said, \"Whee!\" and then \"Whoosh!\" and then \"Wow!\"."
            Pose.custom_format(pose, @char, @enactor, false, true).should eq pose
          end
          
          it "should not colorize if color is blank" do
            @char.stub(:pose_quote_color) { "" }
            pose = "The cat said, \"Whee!\" and then \"Whoosh!\" and then \"Wow!\"."
            Pose.custom_format(pose, @char, @enactor).should eq pose
          end
        end
        
        it "should include autospace if set" do
          @char.stub(:pose_autospace) { "%R" }
          Pose.custom_format("Test", @char, @enactor).should eq "%RTest"
        end
        
        it "should include nospoof if set and if an emit" do
          @char.stub(:pose_nospoof) { true }
          Pose.custom_format("Test", @char, @enactor, true).should eq "%xc%% pose.emit_nospoof_from%xn%RTest"
        end
        
        it "should not include nospoof if not an emit" do
          @char.stub(:pose_nospoof) { true }
          Pose.custom_format("Test", @char, @enactor, false).should eq "Test"
        end
      end
    end
  end
end