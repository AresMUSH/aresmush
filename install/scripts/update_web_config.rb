puts "======================================================================="
puts "Updating  web config."
puts "======================================================================="

path = "/etc/nginx/sites-available/default"
config = File.read(path)

new_config = config.gsub("location /api/ {", "location ~ /game/(config|logs) {\n\t\tdeny all;\n\t\treturn 404;\n\t\t}\n\n\n\tlocation /api/ {")

File.open(path, "w") do |file|
  file.puts new_config
end

`service nginx restart`

puts "Done!"