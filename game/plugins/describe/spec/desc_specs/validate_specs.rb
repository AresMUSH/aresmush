require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe

    describe Desc do
      before do
        @desc = Desc.new
        @cmd = double
        @cmd.stub(:logged_in?) { true }
        @args = double
        @desc.stub(:args) { @args }
        @desc.cmd = @cmd
        AresMUSH::Locale.stub(:translate).with("describe.invalid_desc_syntax") { "invalid_desc_syntax" }
        AresMUSH::Locale.stub(:translate).with("dispatcher.must_be_logged_in") { "must_be_logged_in" }
      end
      
      it "should fail if not logged in" do
        @cmd.stub(:logged_in?) { false }
        @desc.validate.should eq "must_be_logged_in"
      end
      
      it "should fail if args are nil" do
        @args = nil
        @desc.validate.should eq "invalid_desc_syntax"
      end
      
      it "should fail if target is nil" do
        @args.stub(:target) { nil }
        @args.stub(:desc) { "desc" }
        @desc.validate.should eq "invalid_desc_syntax"
      end

      it "should fail if target is nil" do
        @args.stub(:target) { "target" }
        @args.stub(:desc) { nil }
        @desc.validate.should eq "invalid_desc_syntax"
      end

      it "should pass if all args are valid" do
        @args.stub(:target) { "target" }
        @args.stub(:desc) { "desc" }
        @desc.validate.should be_nil
      end
    end     
  end
end