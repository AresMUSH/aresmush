require "plugin_test_loader"

module AresMUSH
  module Website
    describe Website do
      describe :can_edit_wiki_file? do 
        before do
          @enactor = double
          allow(@enactor).to receive(:name) { "Bob" }
          allow(Website).to receive(:can_manage_wiki?).with(@enactor) { false }
          allow(Website).to receive(:can_manage_theme?).with(@enactor) { false }
        end
        
        it "should allow a wiki manager to manage anything" do
          allow(Website).to receive(:can_manage_wiki?).with(@enactor) { true }
          expect(Website.can_edit_wiki_file?(@enactor, "anyfolder")).to be true
        end

        it "should allow a theme manager to manage a theme file" do
          allow(Website).to receive(:can_manage_theme?).with(@enactor) { true }
          expect(Website.can_edit_wiki_file?(@enactor, "theme_images")).to be true
        end

        it "should NOT allow a theme manager to manage another random file" do
          allow(Website).to receive(:can_manage_theme?).with(@enactor) { true }
          expect(Website.can_edit_wiki_file?(@enactor, "anyfolder")).to be false
        end

        it "should NOT allow a random person to manage a random file" do
          expect(Website.can_edit_wiki_file?(@enactor, "anyfolder")).to be false
        end

        it "should NOT allow a random person to manage a theme image" do
          expect(Website.can_edit_wiki_file?(@enactor, "theme_images")).to be false
        end
        
        it "should allow a random person to manage their own files" do
          expect(Website.can_edit_wiki_file?(@enactor, "bob")).to be true
        end        
      end
      
      describe :is_restricted_wiki_page? do
        context "single page" do
          it "should return true if page is restricted" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test' ] }
            page = WikiPage.new(name: 'test')
            expect(Website.is_restricted_wiki_page?(page)).to be true
          end

          it "should return true for restricted page even if case is weird" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'TEST' ] }
            page = WikiPage.new(name: 'test')
            expect(Website.is_restricted_wiki_page?(page)).to be true
          end
        
          it "should return true for sanitized page name that's restricted" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'my test' ] }
            page = WikiPage.new(name: WikiPage.sanitize_page_name('my test'))
            expect(Website.is_restricted_wiki_page?(page)).to be true
          end
          
          it "should not restrict an open page" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test' ] }
            page = WikiPage.new(name: 'foo')
            expect(Website.is_restricted_wiki_page?(page)).to be false
          end
        end
        
        context "page category" do
          it "should return true if category is restricted" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test', 'policy:*'] }
            page = WikiPage.new(name: 'policy:test')
            expect(Website.is_restricted_wiki_page?(page)).to be true
          end
          
          it "should return false for a different category" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test', 'policy:*'] }
            page = WikiPage.new(name: 'theme:test')
            expect(Website.is_restricted_wiki_page?(page)).to be false
          end
          
          it "should still check for single pages even if category specified" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test', 'policy:*'] }
            page = WikiPage.new(name: 'test')
            expect(Website.is_restricted_wiki_page?(page)).to be true
          end
          
          it "should return false for an open page even if category specified" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test', 'policy:*'] }
            page = WikiPage.new(name: 'foo')
            expect(Website.is_restricted_wiki_page?(page)).to be false
          end
          
        end
        
      end
    end
  end
end
