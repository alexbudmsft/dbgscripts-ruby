require_relative 'config'
require_relative 'rubyval'

def dump_strtable(tbl)
  num_bins = tbl.num_bins.value

  if tbl.entries_packed.value != 0
    raise NotImplementedError
  end

  for i in 0...num_bins
    bin = tbl.as.big.bins[i]
    entry = bin
    while entry.value != 0
      rec_val = entry.record.value
      rbval = RubyVal.new(rec_val).to_native
      puts "Key: #{DbgScript.read_string(entry.key.value)}, " \
           "Value: #{rbval} (Raw: #{rec_val.to_s(16)})"
      entry = entry.next
    end
  end
end
