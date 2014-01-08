#!/usr/bin/env ruby
require 'rubygems'
require 'json'

# config settings
branched_from_user = ''
branched_from_repo_name = ''
push_from_user = ''

print "Title? "
title = $stdin.gets.chomp.strip

print "Body? "
body = $stdin.gets.chomp.strip

branch_name = `git rev-parse --abbrev-ref HEAD`.strip
print "Branch Name: #{branch_name}\n"

branched_from = `git rev-parse --abbrev-ref --symbolic-full-name @{u}`.split('/')[-1].strip
print "Branched From: #{branched_from}\n"

command_to_be_ran = "curl -H 'Content-Type: application/json' -u #{push_from_user} -H 'Accept: application/json' -X POST -d '{\"title\":\"#{title}\",\"body\":\"#{body}\",\"head\":\"#{push_from_user}:#{branch_name}\",\"base\":\"#{branched_from}\"}' https://api.github.com/repos/#{branched_from_user}/#{branched_from_repo_name}/pulls"

print "\nCommand: #{command_to_be_ran}\n\n"

print "Do you want to run this(y/n)? "
run_it = $stdin.gets.chomp.strip

if (run_it.downcase == "y")
  pull_request_results = `#{command_to_be_ran}`

  print "Do you want to update PT ticket comment(y/n)? "
  pt_comment = $stdin.gets.chomp.strip

  if (pt_comment.downcase == "y")
    pull_request_link_parsed = JSON.parse(pull_request_results)
    pull_request_link = pull_request_link_parsed['html_url']

    unless(pull_request_link.nil?)
      print "Updating ticket with the Github pull request URL\n"

      story_id = branch_name.split("_")[0]
      system("GITHUB_PULL_REQUEST_URL=\"#{pull_request_link}\" PT_STORY_ID=\"#{story_id}\" ruby update_ticket_status.rb")
    else
      print "A pull request was already created for this no ticket update needed!\n"
    end
  end
end
