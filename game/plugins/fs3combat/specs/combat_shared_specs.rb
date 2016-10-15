module AresMUSH
  module FS3Combat
    describe FS3Combat do
        
      describe :find_combat_by_number do
        before do
          @combat1 = Combat.new(num: 1)
          @combat2 = Combat.new(num: 2)
          @client = double
          FS3Combat.stub(:combats) {[@combat1, @combat2]}
          SpecHelpers.stub_translate_for_testing
        end
        
        it "should fail if not a number" do
          @client.should_receive(:emit_failure).with("fs3combat.invalid_combat_number")
          FS3Combat.find_combat_by_number(@client, "A").should be_nil
        end
        
        it "should fail if not a valid number" do
          @client.should_receive(:emit_failure).with("fs3combat.invalid_combat_number")
          FS3Combat.find_combat_by_number(@client, 3).should be_nil
        end
        
        it "should succeed if valid number string specified" do
          FS3Combat.find_combat_by_number(@client, "1").should eq @combat1
          FS3Combat.find_combat_by_number(@client, "2").should eq @combat2
        end
        
        it "should succeed if valid number specified" do
          FS3Combat.find_combat_by_number(@client, 1).should eq @combat1
          FS3Combat.find_combat_by_number(@client, 2).should eq @combat2
        end
        
      end
    end
  end
end