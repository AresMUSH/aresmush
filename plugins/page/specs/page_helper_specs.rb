require "plugin_test_loader"

module AresMUSH
  module Page
  
    describe :get_recipients do
  
      before do
        @enactor = double
        stub_translate_for_testing
      end
            
      it "should fail if not found" do
        expect(Character).to receive(:find_one_by_name).with("dummy") { nil }
        result = Page.get_receipients(["dummy"], @enactor)
        expect(result[:error]).to eq 'page.invalid_recipient'
      end
        
      it "should fail if ignored" do
        dummy = double
        expect(dummy).to receive(:page_ignored) { [ @enactor ]}
        expect(Character).to receive(:find_one_by_name).with("dummy") { dummy }
        result = Page.get_receipients(["dummy"], @enactor)
        expect(result[:error]).to eq 'page.cant_page_ignored'
      end
        
      it "should fail if nobody but yourself listed" do
        expect(Character).to receive(:find_one_by_name).with("dummy") { @enactor }
        expect(@enactor).to receive(:page_ignored) { []}
        
        result = Page.get_receipients(["dummy"], @enactor)
        expect(result[:error]).to eq 'page.cant_page_just_yourself'
      end
        
      it "should convert names to players" do
        dummy = double
        expect(dummy).to receive(:page_ignored) { []}
        expect(Character).to receive(:find_one_by_name).with("dummy") { dummy }
          
        result = Page.get_receipients(["dummy"], @enactor)
        expect(result[:error]).to be_nil
        expect(result[:recipients]).to eq [ dummy ]
      end
        
    end
      
      
  end
end
