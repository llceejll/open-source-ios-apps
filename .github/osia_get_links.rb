require_relative 'osia_helper'

UNIQUES = 'check-unique.txt' # should be unique
LINKS   = 'check-links.txt'  # allow dupes
INFO    = 'check-info.txt'   # errors are allowed

def apps_archived(apps)
  a = apps.select {|a| a['tags'] != nil }.select {|b| b['tags'].include?'archive'}
  a.sort_by { |k, v| k['title'] }
end

j = get_json
a = j['projects']
archived = apps_archived a
active = a.reject { |x| archived.include? x }

uniques = active.flat_map do |app|
  [app['source'], *Array(app['screenshots'])]
end.compact.uniq

info = active.filter_map { |app| app['itunes'] }.uniq

uniques.each_with_index { |z, i| puts "#{i+1} #{z}" }

puts "Writing #{UNIQUES}"
File.open(UNIQUES, 'w') { |f| f.puts uniques }

puts "Writing #{INFO}"
File.open(INFO, 'w') { |f| f.puts info }

links = active.filter_map { |app| app['homepage'] }.uniq

links.each_with_index { |z, i| puts "#{i+1} #{z}" }

puts "Writing #{LINKS}"
File.open(LINKS, 'w') { |f| f.puts links }
