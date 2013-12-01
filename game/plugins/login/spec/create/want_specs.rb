require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
    describe Create do
      before do
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :want_command? do
        it "should want the create command" do
          cmd = double(Command)
          cmd.stub(:root_is?).with("create") { true }
          create = Create.new
          create.want_command?(cmd).should eq true
        end

        it "should not want a different command" do
          cmd = double(Command)
          cmd.stub(:root_is?).with("create") { false }
          create = Create.new
          create.want_command?(cmd).should eq false
        end
      end
    end
  end
end

