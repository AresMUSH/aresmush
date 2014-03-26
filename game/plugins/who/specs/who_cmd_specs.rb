require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoCmd do
      include PluginCmdTestHelper
      include MockClient

      before do        
        init_handler(WhoCmd, "who")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that doesn't allow args"
      it_behaves_like "a plugin that expects a single root" do
        let(:expected_root) { "who" }
      end
      
      describe :initialize do
        it "should read the template" do
          TemplateRenderer.should_receive(:create_from_file) do |file|
            file.end_with?("who.erb").should be_true
          end
          WhoCmd.new
        end
      end
      
      describe :handle do        
        before do
          
          @renderer = double
          @renderer.stub(:render) { "ABC" }
          WhoRenderer.stub(:new) { @renderer }
                   
          # Need to do this again now that we've stubbed out the renderer.
          init_handler(WhoCmd, "who")                 
        end

        it "should emit the results of the render methods" do
          client.should_receive(:emit).with("ABC")
          handler.handle
        end
      end
    end
  end
end