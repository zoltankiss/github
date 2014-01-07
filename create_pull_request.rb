#!/usr/bin/env ruby

print "Title? "
title = $stdin.gets.chomp.strip

print "Body? "
body = $stdin.gets.chomp.strip

branch_name = `git rev-parse --abbrev-ref HEAD`.strip
print "Branch Name: #{branch_name}\n"

branched_from = `git rev-parse --abbrev-ref --symbolic-full-name @{u}`.gsub("[remote_name]/", "").strip
print "Branched From: #{branched_from}\n"

command_to_be_ran = "curl -H 'Content-Type: application/json' -u [username] -H 'Accept: application/json' -X POST -d '{\"title\":\"#{title}\",\"body\":\"#{body}\",\"head\":\"[username]:#{branch_name}\",\"base\":\"#{branched_from}\"}' https://api.github.com/repos/[to_username]/[to_repo]/pulls"

print "\nCommand: #{command_to_be_ran}\n\n"

print "Do you want to run this(y/n)? "
run_it = $stdin.gets.chomp.strip

if (run_it.downcase == "y")
  system(command_to_be_ran)
end
