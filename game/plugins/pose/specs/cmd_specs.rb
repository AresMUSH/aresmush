require_relative "../../plugin_test_loader"

module AresMUSH
  module Pose
    describe EmitCmd do    
      it_behaves_like "a pose command" do
        let(:cmd_class) { EmitCmd } 
        let(:cmd_name) { "emit" }
        let(:expected_emit) { "test" }
      end
    end
    
    describe PoseCmd do    
      it_behaves_like "a pose command" do
        let(:cmd_class) { PoseCmd } 
        let(:cmd_name) { "pose" }
        let(:expected_emit) { "Bob test" }
      end
    end
    
    describe SayCmd do    
      it_behaves_like "a pose command" do
        let(:cmd_class) { SayCmd } 
        let(:cmd_name) { "say" }
        let(:expected_emit) { "Bob says test" }
      end
    end
    
    describe OOCSayCmd do    
      it_behaves_like "a pose command" do
        let(:cmd_class) { OOCSayCmd } 
        let(:cmd_name) { "ooc" }
        let(:expected_emit) { "%xc<OOC>%xn Bob says test" }
      end
    end
  end
end
