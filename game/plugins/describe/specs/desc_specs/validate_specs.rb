require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe

    describe Desc do
      before do
        @desc = Desc.new
        @cmd = double
        @cmd.stub(:logged_in?) { true }
        @desc.cmd = @cmd
        SpecHelpers.stub_translate_for_testing
      end
      
      it "should fail if not logged in" do
        @cmd.stub(:logged_in?) { false }
        @desc.validate.should eq "dispatcher.must_be_logged_in"
      end
      
      it "should fail if target is nil" do
        @desc.stub(:args) { HashReader.new( { "target" => nil, "desc" => "My desc" } ) }
        @desc.validate.should eq "describe.invalid_desc_syntax"
      end

      it "should fail if target is nil" do
        @desc.stub(:args) { HashReader.new( { "target" => nil, "desc" => "My desc" } ) }
        @desc.validate.should eq "describe.invalid_desc_syntax"
      end

      it "should pass if all args are valid" do
        @desc.stub(:args) { HashReader.new( { "target" => "Bob", "desc" => "My desc" } ) }
        @desc.validate.should be_nil
      end
    end     
  end
end