#!/usr/bin/env ruby
require 'nokogiri'
require 'rubygems'

username = "[username]"

system "stty -echo"
print "Pivital Password? "
password = $stdin.gets.chomp
system "stty echo"

print "\nPivital Project ID? "
project_id = $stdin.gets.chomp

token_request = `curl -u #{username}:#{password} -X GET https://www.pivotaltracker.com/services/v3/tokens/active`
token_xml = Nokogiri::XML::Document.parse(token_request)

token = ''
doc = token_xml.xpath("//token")
doc.each do |node|
  if (node.name == 'token')
    node.children.each do |child_node|
      if (child_node.name == 'guid')
        token = child_node.text.strip
      end
    end
  end
end

github_url = ENV['GITHUB_PULL_REQUEST_URL']
story_id = ENV['PT_STORY_ID']

print "Updating PT ticket comment...\n"
command = `curl -H "X-TrackerToken: #{token}" -X POST -H "Content-type: application/xml" -d "<note><text>#{github_url}</text></note>" http://www.pivotaltracker.com/services/v3/projects/#{project_id}/stories/#{story_id}/notes`
