require_relative 'osia_helper'
require 'open3'

HISTORY = 'git_history'

j = get_json
apps = j['projects']

h = {}
apps.each_with_index do |a, i|
  t = a['title']
  puts "#{i + 1}/#{apps.count}. checking #{t}"
  stdout, stderr, status = Open3.capture3('git', 'log', '--all', "--grep=#{t}")
  r = status.success? ? stdout : stderr

  h[t] = r
end

File.open(HISTORY, 'w') { |f| f.write JSON.pretty_generate h }
puts "wrote #{HISTORY} ✨"
