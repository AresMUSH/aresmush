module AresMUSH
  module FS3Skills
    
    describe XpLangCmd do
      include CommandHandlerTestHelper

      before do
        Global.stub(:read_config).with("fs3skills", "lang_cost") { 3 }

        init_handler(XpLangCmd, "xp/lang english")
        
        enactor.stub(:name) { "Bob" }
        
        handler.name = "Spanish"
        
        SpecHelpers.stub_translate_for_testing
      end
      
      context "failures" do
        it "should fail if not enough xp" do
          enactor.stub(:xp) { 2 }
          client.should_receive(:emit_failure).with("fs3skills.not_enough_xp")
          handler.handle
        end
      end
      
      context "success" do
          before do
            enactor.stub(:xp) { 4 }
            enactor.stub(:xp=)
            enactor.stub(:last_xp_spend=)
            enactor.stub(:save)
            FS3Skills.stub(:add_unrated_ability) { true }
          end
          
          it "should give the char the language and save them" do
            FS3Skills.should_receive(:add_unrated_ability).with(client, enactor, "Spanish", :language)
            handler.handle
          end
          
          it "should adjust the char's xp" do
            enactor.should_receive(:xp=).with(1)
            handler.handle
          end
          
          it "should update their last xp spend time" do
            fake_time =  Time.new(2013)
            Time.stub(:now) { fake_time }
            enactor.should_receive(:last_xp_spend=).with(fake_time)
            handler.handle
          end
          
          it "should not save if the skill set fails" do
            FS3Skills.stub(:add_unrated_ability).with(client, enactor, "Spanish", :language) { false }
            enactor.should_not_receive(:save)
            handler.handle
          end
      end
    end
  end
end