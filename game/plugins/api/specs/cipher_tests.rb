require_relative "../../plugin_test_loader"

module AresMUSH
  module Api
    describe Api do
      it "should encrypt and decrypt the data" do
        data = "top secret stuff"
        key = Api.generate_key
        encrypted = Api.encrypt(key, data)
        decrypted = Api.decrypt(key, encrypted[:iv], encrypted[:data])
        decrypted.should eq data
      end
    end
  end
end