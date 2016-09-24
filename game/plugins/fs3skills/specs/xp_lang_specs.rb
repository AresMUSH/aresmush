module AresMUSH
  module FS3Skills
    
    describe XpLangCmd do

      before do
        Global.stub(:read_config).with("fs3skills", "lang_cost") { 3 }
        
        @handler = XpLangCmd.new
        
        @client = double
        @char = Character.new
        @char.stub(:save) { }
        @client.stub(:name) { "Bob" }
        @client.stub(:char) { @char }
        
        @handler.name = "Spanish"
        @handler.client = @client
        
        SpecHelpers.stub_translate_for_testing
      end
      
      context "failures" do
        it "should fail if not enough xp" do
          @char.xp = 2
          @client.should_receive(:emit_failure).with("fs3skills.not_enough_xp")
          @handler.handle
        end
      end
      
      context "success" do
          before do
            @char.xp = 4
            FS3Skills.stub(:add_unrated_ability).with(@client, @char, "Spanish", :language) do
              @char.fs3_languages = ["Spanish"]
              true
            end
          end
          
          it "should give the char the language and save them" do
            @handler.handle
            @char.fs3_languages.should eq ["Spanish"]
          end
          
          it "should adjust the char's xp" do
            @handler.handle
            @char.xp.should eq 1
          end
          
          it "should update their last xp spend time" do
            fake_time =  Time.new(2013)
            Time.stub(:now) { fake_time }
            @handler.handle
            @char.last_xp_spend.should eq fake_time
          end
          
          it "should not save if the skill set fails" do
            FS3Skills.stub(:add_unrated_ability).with(@client, @char, "Spanish", :language) do
              false
            end
            @char.should_not_receive(:save)
            @handler.handle
          end
      end
    end
  end
end