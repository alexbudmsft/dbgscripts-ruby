# Dump $" or $LOADED_FEATURES from current VM.
#
require_relative 'rubyval'

vm = DbgScript.get_global("#{RUBYMOD}!ruby_current_vm")
puts RubyVal.new(vm.loaded_features.value).value.to_a
