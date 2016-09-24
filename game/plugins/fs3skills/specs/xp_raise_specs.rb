module AresMUSH
  module FS3Skills
    describe XpRaiseCmd do
      before do
        Global.stub(:read_config).with("fs3skills", "skill_costs") { { 2 => 3} }
        Global.stub(:read_config).with("fs3skills", "max_rating_through_xp") { 5 }
        Global.stub(:read_config).with("fs3skills", "days_between_xp_raises") { 1 }
        
        @handler = XpRaiseCmd.new
        
        @client = double
        @char = Character.new
        @char.stub(:save) { }
        @client.stub(:name) { "Bob" }
        @client.stub(:char) { @char }
        
        @handler.name = "Basketweaving"
        @handler.client = @client
        
        SpecHelpers.stub_translate_for_testing
      end
      
      context "failures" do
        before do
          @char.last_xp_spend = nil
          @char.xp = 10
          FS3Skills.stub(:ability_rating).with(@char, "Basketweaving") { 1 }
        end
        
        
        it "should fail if not enough xp" do
          @char.xp = 2
          @client.should_receive(:emit_failure).with('fs3skills.not_enough_xp')
          @handler.handle
        end
        
        it "should fail if too soon since last spend" do
          @char.last_xp_spend = Time.now
          @client.should_receive(:emit_failure).with('fs3skills.must_wait_to_spend')
          @handler.handle
        end
        
        it "should fail if already at max rating" do
          FS3Skills.stub(:ability_rating).with(@char, "Basketweaving") { 5 }
          @client.should_receive(:emit_failure).with('fs3skills.cant_raise_further_with_xp')
          @handler.handle
        end
      end
      
      context "success" do
        before do
          @char.xp = 4
          FS3Skills.stub(:ability_rating).with(@char, "Basketweaving") { 1 }
          FS3Skills.stub(:set_ability).with(@client, @char, "Basketweaving", 2) do
            @char.fs3_action_skills = { "a" => "b" }
            true
          end
        end
        
        it "should set the new skill and save them" do
          @handler.handle
          @char.fs3_action_skills["a"].should eq "b"
        end
        
        it "should adjust the character's xp" do
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
          FS3Skills.stub(:set_ability).with(@client, @char, "Basketweaving", 2) do
            false
          end
          @handler.handle
          @char.should_not_receive(:save)
        end        
      end
    end
  end
end
