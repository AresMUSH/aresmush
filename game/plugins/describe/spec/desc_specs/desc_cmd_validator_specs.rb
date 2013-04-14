require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe

    describe DescCmdValidator do
      before do
        @client = double(Client)
        AresMUSH::Locale.stub(:translate).with("describe.invalid_desc_syntax") { "invalid_desc_syntax" }
      end
      
      it "should emit failure if args are nil" do
        @client.should_receive(:emit_failure).with("invalid_desc_syntax")
        DescCmdValidator.validate(nil, @client).should be_false
      end
      
      it "should emit failure if target is nil" do
        args = mock
        args.stub(:desc) { "desc" }
        args.stub(:target) { nil }
        @client.should_receive(:emit_failure).with("invalid_desc_syntax")
        DescCmdValidator.validate(args, @client).should be_false
      end

      it "should emit failure if desc is nil" do
        args = mock
        args.stub(:target) { "target" }
        args.stub(:desc) { nil }
        @client.should_receive(:emit_failure).with("invalid_desc_syntax")
        DescCmdValidator.validate(args, @client).should be_false
      end
      
      it "should return true if args are valid" do
        args = mock
        args.stub(:target) { "target" }
        args.stub(:desc) { "desc" }
        DescCmdValidator.validate(args, @client).should be_true
      end
    end     
  end
end