module AresMUSH
  module FS3Combat
    describe FS3Combat do
      include MockClient
      
        
      describe :find_combat_by_number do
        before do
          @combat1 = double
          @combat2 = double
          @client = double
          FS3Combat.stub(:combats) {[@combat1, @combat2]}
          SpecHelpers.stub_translate_for_testing
        end
        
        it "should fail if not a number" do
          @client.should_receive(:emit_failure).with("fs3combat.invalid_combat_number")
          FS3Combat.find_combat_by_number(@client, "A").should be_nil
        end
        
        it "should fail if equal to 0" do
          @client.should_receive(:emit_failure).with("fs3combat.invalid_combat_number")
          FS3Combat.find_combat_by_number(@client, "0").should be_nil
        end

        it "should fail if less than 0" do
          @client.should_receive(:emit_failure).with("fs3combat.invalid_combat_number")
          FS3Combat.find_combat_by_number(@client, "-1").should be_nil
        end
        
        it "should fail if > count" do
          @client.should_receive(:emit_failure).with("fs3combat.invalid_combat_number")
          FS3Combat.find_combat_by_number(@client, "3").should be_nil
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