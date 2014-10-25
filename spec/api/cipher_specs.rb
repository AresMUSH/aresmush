module AresMUSH
  module Api
    describe Api do
      it "should encrypt and decrypt the data" do
        data = "top secret stuff"
        key = ApiCrypt.generate_key
        encrypted = ApiCrypt.encrypt(key, data)
        decrypted = ApiCrypt.decrypt(key, encrypted[:iv], encrypted[:data])
        decrypted.should eq data
      end
    end
  end
end