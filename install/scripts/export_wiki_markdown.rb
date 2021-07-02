module AresMUSH

  puts "======================================================================="
  puts "Exporting Wiki"
  puts "======================================================================="

  if (!File.exist?("wiki_md"))
    Dir.mkdir "wiki_md"
  end
  WikiPage.all.each do |p|
    File.open("wiki_md/#{p.name}", 'w') do |file|
       file.write "# #{p.heading}\n\n#{p.current_version.text}"
    end
   end


  puts "Script complete!"
end