require 'json'

module AresMUSH
  module BaseModel

    def self.included(model)
      model.include MongoMapper::Document
      model.timestamps!
      model.key :name, String
      model.key :name_upcase, String
      model.before_validation :save_upcase_name
    end

    def to_json
      JSON.pretty_generate(as_json)
    end

    private
    def save_upcase_name
      @name_upcase = @name.nil? ? "" : @name.upcase
    end
  end
end