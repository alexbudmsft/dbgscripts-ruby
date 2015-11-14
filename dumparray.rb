# Dump any RArray.
#
require_relative 'rubyval'

arr = RubyVal.new(Integer(ARGV[1]))

p arr.value.to_a
