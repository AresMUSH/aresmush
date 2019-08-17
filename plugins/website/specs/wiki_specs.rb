require_relative "../../plugin_test_loader"

module AresMUSH
  module Website
    describe Website do
      describe :is_restricted_wiki_page? do
        before do
        end
        
        context "single page" do
          it "should return true if page is restricted" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test' ] }
            page = WikiPage.new(name: 'test')
            Website.is_restricted_wiki_page?(page).should be true
          end

          it "should return true for restricted page even if case is weird" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'TEST' ] }
            page = WikiPage.new(name: 'test')
            Website.is_restricted_wiki_page?(page).should be true
          end
        
          it "should return true for sanitized page name that's restricted" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'my test' ] }
            page = WikiPage.new(name: WikiPage.sanitize_page_name('my test'))
            Website.is_restricted_wiki_page?(page).should be true
          end
          
          it "should not restrict an open page" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test' ] }
            page = WikiPage.new(name: 'foo')
            Website.is_restricted_wiki_page?(page).should be false
          end
        end
        
        context "page category" do
          it "should return true if category is restricted" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test', 'policy:*'] }
            page = WikiPage.new(name: 'policy:test')
            Website.is_restricted_wiki_page?(page).should be true
          end
          
          it "should return false for a different category" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test', 'policy:*'] }
            page = WikiPage.new(name: 'theme:test')
            Website.is_restricted_wiki_page?(page).should be false
          end
          
          it "should still check for single pages even if category specified" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test', 'policy:*'] }
            page = WikiPage.new(name: 'test')
            Website.is_restricted_wiki_page?(page).should be true
          end
          
          it "should return false for an open page even if category specified" do
            allow(Global).to receive(:read_config).with("website", "restricted_pages") { [ 'test', 'policy:*'] }
            page = WikiPage.new(name: 'foo')
            Website.is_restricted_wiki_page?(page).should be false
          end
          
        end
        
      end
    end
  end
end
