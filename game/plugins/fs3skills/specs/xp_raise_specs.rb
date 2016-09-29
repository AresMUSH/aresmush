module AresMUSH
  module FS3Skills
    describe XpRaiseCmd do

      include CommandHandlerTestHelper

      before do
        Global.stub(:read_config).with("fs3skills", "skill_costs") { { 2 => 3} }
        Global.stub(:read_config).with("fs3skills", "max_rating_through_xp") { 5 }
        Global.stub(:read_config).with("fs3skills", "days_between_xp_raises") { 1 }
        
        init_handler(XpRaiseCmd, "xp/raise Basketweaving")
        
        enactor.stub(:name) { "Bob" }
        
        handler.name = "Basketweaving"
        
        SpecHelpers.stub_translate_for_testing
      end
      
      context "failures" do
        before do
          enactor.stub(:last_xp_spend) { nil }
          enactor.stub(:xp) { 10 }
          FS3Skills.stub(:ability_rating).with(enactor, "Basketweaving") { 1 }
        end
        
        
        it "should fail if not enough xp" do
          enactor.stub(:xp) { 2 }
          client.should_receive(:emit_failure).with('fs3skills.not_enough_xp')
          handler.handle
        end
        
        it "should fail if too soon since last spend" do
          enactor.stub(:last_xp_spend) { Time.now }
          client.should_receive(:emit_failure).with('fs3skills.must_wait_to_spend')
          handler.handle
        end
        
        it "should fail if already at max rating" do
          FS3Skills.stub(:ability_rating).with(enactor, "Basketweaving") { 5 }
          client.should_receive(:emit_failure).with('fs3skills.cant_raise_further_with_xp')
          handler.handle
        end
      end
      
      context "success" do
        before do
          enactor.stub(:xp) { 4 }
          enactor.stub(:last_xp_spend) { Time.new(2012) }
          enactor.stub(:xp=)
          enactor.stub(:last_xp_spend=)
          enactor.stub(:save)
          FS3Skills.stub(:ability_rating).with(enactor, "Basketweaving") { 1 }
          FS3Skills.stub(:set_ability) { true }
        end
        
        it "should set the new skill and save them" do
          FS3Skills.should_receive(:set_ability).with(client, enactor, "Basketweaving", 2) { true }
          handler.handle
        end
        
        it "should adjust the character's xp" do
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
          FS3Skills.stub(:set_ability).with(client, enactor, "Basketweaving", 2) { false }
          handler.handle
          enactor.should_not_receive(:save)
        end        
      end
    end
  end
end
