require_relative 'dumpstrtable'

vm = DbgScript.get_global("#{RUBYMOD}!ruby_current_vm")

dump_strtable(vm.loading_table)
