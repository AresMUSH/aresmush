require "plugin_test_loader"

module AresMUSH
  module Page
  
    describe :get_recipients do
  
      before do
        @enactor = double
        @target = double
        allow(@target).to receive(:has_page_blocked?) { false }
        allow(@enactor).to receive(:has_page_blocked?) { false }
        allow(@enactor).to receive(:page_blocks) { [] }
        stub_translate_for_testing
      end
            
      it "should fail if not found" do
        expect(Character).to receive(:find_one_by_name).with("dummy") { nil }
        result = Page.get_receipients(["dummy"], @enactor)
        expect(result[:error]).to eq 'page.invalid_recipient'
      end
        
      it "should fail if they blocked you" do
        expect(@target).to receive(:has_page_blocked?).with(@enactor) { true }
        expect(Character).to receive(:find_one_by_name).with("dummy") { @target }
        result = Page.get_receipients(["dummy"], @enactor)
        expect(result[:error]).to eq 'page.recipient_do_not_disturb'
      end
      
      it "should fail if you blocked them" do
        expect(@enactor).to receive(:has_page_blocked?).with(@target) { true }
        expect(Character).to receive(:find_one_by_name).with("dummy") { @target }
        result = Page.get_receipients(["dummy"], @enactor)
        expect(result[:error]).to eq 'page.cant_page_someone_you_blocked'
      end
        
      it "should fail if nobody but yourself listed" do
        expect(Character).to receive(:find_one_by_name).with("dummy") { @enactor }
        
        result = Page.get_receipients(["dummy"], @enactor)
        expect(result[:error]).to eq 'page.cant_page_just_yourself'
      end
        
      it "should convert names to players" do
        expect(Character).to receive(:find_one_by_name).with("dummy") { @target }
          
        result = Page.get_receipients(["dummy"], @enactor)
        expect(result[:error]).to be_nil
        expect(result[:recipients]).to eq [ @target ]
      end
        
    end
      
      
  end
end
