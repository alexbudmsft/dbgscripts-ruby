# Dump any VALUE.
#
require_relative 'rubyval'

rbval = RubyVal.new(Integer(ARGV[1]))
puts "Type: #{rbval.type}"
p rbval.to_native
