$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH
  describe Cron do
    include GlobalTestHelper
   
    before do
      stub_global_objects
    end
      
    describe :raise_event do
      it "should send the cron event with the current time" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        allow(Time).to receive(:now) { time }
        expect(dispatcher).to receive(:on_event) do |event|
          expect(event.class).to eq CronEvent
          expect(event.time).to eq time
        end
        Cron.raise_event
      end
    end
    
    describe :is_cron_match? do
      it "should match a matching date" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "date" => [25] }
        expect(Cron.is_cron_match?(cron, time)).to be true
      end

      it "should not match a different date" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "date" => [26] }
        expect(Cron.is_cron_match?(cron, time)).to be false
      end
      
      it "should match a matching day of week" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "day_of_week" => ["sat"] }
        expect(Cron.is_cron_match?(cron, time)).to be true
      end

      it "should not match a different day of week" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "day_of_week" => ["sun"] }
        expect(Cron.is_cron_match?(cron, time)).to be false
      end
      
      it "should match a matching hour" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "hour" => [14] }
        expect(Cron.is_cron_match?(cron, time)).to be true
      end

      it "should not match a different hour" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "hour" => [17] }
        expect(Cron.is_cron_match?(cron, time)).to be false
      end
      
      it "should match a matching minute" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "minute" => [22] }
        expect(Cron.is_cron_match?(cron, time)).to be true
      end

      it "should not match a different minute" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "minute" => [27] }
        expect(Cron.is_cron_match?(cron, time)).to be false
      end
      
      
      it "should match a matching combo" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "minute" => [22], "hour" => [14], "date" => [25] }
        expect(Cron.is_cron_match?(cron, time)).to be true
      end

      it "should not match a different combo" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "minute" => [27], "hour" => [14], "date" => [25] }
        expect(Cron.is_cron_match?(cron, time)).to be false
      end
      
      it "should match any result in the list" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "minute" => [4, 18, 22] }
        expect(Cron.is_cron_match?(cron, time)).to be true
      end
      
      it "should not match an empty cron spec" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = {}
        expect(Cron.is_cron_match?(cron, time)).to be false
      end
    end
  end   
end
