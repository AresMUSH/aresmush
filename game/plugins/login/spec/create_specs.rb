$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "create"

module AresMUSH
  module Login
    describe Create do
      describe :want_command? do
        it "should want an anon command if the root is 'create'" do
          cmd = double(Command)
          cmd.stub(:root_is?).with("create") { true }
          create = Create.new(nil)
          create.want_anon_command?(cmd).should eq true
        end
      end
    end
  end
end

