module AresMUSH
  module Help
    def self.load_help(topic_key, index = nil)
      index = index || Help.categories["main"]
      topic = index["topics"][topic_key]
      raise "Topic #{topic_key} not found" if topic.nil?
      raise "Help topic #{topic_key} misconfigured" if topic["file"].nil? || topic["dir"].nil?
      filename = File.join(topic["dir"], Global.locale.locale.to_s, topic["file"])
      # If current locale not found, try the default locale
      if (!File.exists?(filename))
        filename = File.join(topic["dir"], Global.locale.default_locale.to_s, topic["file"])
      end
      File.read(filename, :encoding => "UTF-8")
    end
  end
end
