#!/usr/bin/env ruby

# config settings
branched_from_user = ''
push_to_user = ''


print "Branch text? "
branch_name = $stdin.gets.chomp

print "Branch from? "
branch_from = $stdin.gets.chomp

branch_name = branch_name.strip.downcase.tr(" ", "_").gsub("-", "").gsub("&", "").gsub("__", "_").gsub(":", "")
output_text = "git remote update; git co -b #{branch_name} #{branched_from_user}/#{branch_from}; git submodule update --init; git push #{push_to_user} #{branch_name}"

puts "#{output_text}\n"
system(output_text)
