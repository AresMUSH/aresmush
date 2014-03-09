require_relative "../../plugin_test_loader"

module AresMUSH
  module HelpSystem
    describe HelpListCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(HelpListCmd, "help")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      
      describe :crack! do
        it "should find the category based on the root" do
          HelpSystem.stub(:category_for_command).with("help") { "cat" }
          handler.crack!
          handler.category.should eq "cat"
        end        
      end  
     
      describe :handle do  
        before do
          handler.stub(:category) { "cat" }
          HelpSystem.stub(:category).with("cat") { { "toc" => { "a" => "a topic", "b" => "b topic" } } }
          AresMUSH::Locale.stub(:translate).with("help.toc", { :category => "cat title" }) { "title" }        
        end
        
        it "should display all toc topics" do
          list = ["     %xhA%xn - a topic", "     %xhB%xn - b topic"]
          HelpSystem.should_receive(:category_title).with("cat") { "cat title" }
          BorderedDisplay.should_receive(:list).with(list, "title") { "list output" }
          client.should_receive(:emit).with("list output")
          handler.handle
        end
        
        it "should raise an error if the toc is undefined" do
          HelpSystem.stub(:category).with("cat") { { "topics" => { "a" => "a topic", "b" => "b topic" } } }
          expect{handler.handle}.to raise_error(IndexError)
        end
      end
    end
  end
end