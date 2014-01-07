#!/usr/bin/env ruby
print "Branch text? "
branch_name = $stdin.gets.chomp

print "Branch from? "
branch_from = $stdin.gets.chomp

branch_name = branch_name.strip.downcase.tr(" ", "_").gsub("-", "").gsub("&", "").gsub("__", "_").gsub(":", "")
output_text = "git remote update; git co -b #{branch_name} upstream/#{branch_from}; git submodule update --init; git push [username] #{branch_name}"

puts "#{output_text}\n"
system(output_text)
