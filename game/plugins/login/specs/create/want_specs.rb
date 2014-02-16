require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
    describe Create do
      before do
        @cmd = double(Command)
        @client = double(Client)
        @create = Create.new
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :want_command? do
        it "should want the create command" do
          @cmd.stub(:root_is?).with("create") { true }
          @create.want_command?(@client, @cmd).should eq true
        end

        it "should not want a different command" do
          @cmd.stub(:root_is?).with("create") { false }
          @create.want_command?(@client, @cmd).should eq false
        end
      end
    end
  end
end

