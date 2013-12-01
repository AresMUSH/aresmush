require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe Look do
      before do       
        @cmd = double(Command)
        @look = Look.new
      end

      describe :want_command? do
        it "wants the look command" do
          @cmd.stub(:root_is?).with("look") { true }
          @look.want_command?(@cmd).should be_true
        end
        
        it "doesn't want another command" do
          @cmd.stub(:root_is?).with("look") { false }
          @look.want_command?(@cmd).should be_false
        end
      end
      
    end
  end
end