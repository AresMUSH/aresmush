module AresMUSH
  module Manage
    describe Manage do
      describe :can_manage? do
        before do
          @actor = double
          Global.stub(:config) {{ "manage" => { "roles" => { "can_manage" => ['admin'] }}}}
        end
          
        it "should allow someone with the required role to reset a password" do
          @actor.stub(:has_any_role?).with(["admin"]) { true }
          Manage.can_manage?(@actor).should be_true
        end
        
        it "should not allow you to access someone else's email" do
          @actor.stub(:has_any_role?).with(["admin"]) { false }
          Manage.can_manage?(@actor).should be_false
        end
      end
    end
  end
end