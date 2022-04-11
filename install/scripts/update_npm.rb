puts "======================================================================="
puts "Updating  NPM version."
puts "======================================================================="

path = "/home/ares/aresmush/node-modules"
FileUtils.rm_rf(path)

`npm install -g npm`
`nvm install 16`
`nvm use 16`
`npm install -g ember-cli`

puts "Done! Now you may restart the game like normal."