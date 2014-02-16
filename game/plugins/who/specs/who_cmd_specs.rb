require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoCmd do

      before do        
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :initialize do
        it "should read the templates" do
          TemplateRenderer.should_receive(:create_from_file) do |file|
            file.end_with?("header.lq").should be_true
          end

          TemplateRenderer.should_receive(:create_from_file) do |file|
            file.end_with?("character.lq").should be_true
          end

          TemplateRenderer.should_receive(:create_from_file) do |file|
            file.end_with?("footer.lq").should be_true
          end
          WhoCmd.new
        end
        
        it "should initialize the renderer" do
          TemplateRenderer.should_receive(:create_from_file) { 1 }
          TemplateRenderer.should_receive(:create_from_file) { 2 }
          TemplateRenderer.should_receive(:create_from_file) { 3 }
          WhoRenderer.should_receive(:new).with(1, 2, 3)
          WhoCmd.new
        end
      end
      
      describe :want_command do
        before do
          @cmd = double
          @client = double          
          @who = WhoCmd.new
        end
        
        it "should want the who command" do
          @cmd.stub(:root_is?).with("who") { true }
          @who.want_command?(@client, @cmd).should be_true
        end

        it "should want the where command" do
          @cmd.stub(:root_is?).with("who") { false }
          @cmd.stub(:root_is?).with("where") { true }
          @who.want_command?(@client, @cmd).should be_true
        end 
        
        it "should not want another command" do
          @cmd.stub(:root_is?).with("who") { false }
          @cmd.stub(:root_is?).with("where") { false }
          @who.want_command?(@client, @cmd).should be_false
        end        
      end
      
      describe :validate do
        before do
          @cmd = double          
          @who = WhoCmd.new
          @who.cmd = @cmd          
        end
        
        it "should be valid if there are no args" do
          @cmd.stub(:root_only?) { true }
          @who.validate.should be_nil
        end
        
        it "should be invalid if there are args" do
          @cmd.stub(:root_only?) { false }
          @who.validate.should eq 'who.invalid_who_syntax'
        end
      end
      
      describe :handle do        
        before do
          @client1 = double("Client1")
          @client2 = double("Client2")
          
          @renderer = double
          @renderer.stub(:render) { "ABC" }
          
          WhoRenderer.stub(:new) { @renderer }
          
          @client_monitor = double
          Global.stub(:client_monitor) { @client_monitor }
          @client_monitor.stub(:logged_in_clients) { [@client1, @client2] }
          
          @client = double
          @cmd = double
          
          @who = WhoCmd.new
          @who.client = @client        
          @who.cmd = @cmd          
        end

        it "should call the renderer with the clients" do
          @client.stub(:emit)
          @renderer.should_receive(:render).with([@client1, @client2]) { "" }
          @who.handle
        end
        
        it "should emit the results of the render methods" do
          @client.should_receive(:emit).with("ABC")
          @who.handle
        end
      end
    end
  end
end