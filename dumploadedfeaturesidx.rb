require_relative 'dumpstrtable'

vm = DbgScript.get_global("#{RUBYMOD}!ruby_current_vm")

dump_strtable(vm.loaded_features_index)
