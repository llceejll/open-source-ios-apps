require 'octokit'
require 'awesome_print'

g = ARGV[0]

if g.nil?
  puts "Usage: get_lic <repo> \n  i.e. get_lic dkhamsing/BrandColors"
  exit
end

client = Octokit

begin
  r = client.repo g
  ap r
  lic = r[:license][:key]

  print "Result: "
  ap lic
rescue StandardError => e
  puts "Error: #{e}"
end
