# Dump any VALUE.
#
require_relative 'rubyval'

p RubyVal.new(Integer(ARGV[1])).to_native
