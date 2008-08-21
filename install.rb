#!/usr/bin/ruby
puts $0
for file in Dir['*']
   next if File.expand_path(file) == File.expand_path($0)
   dotted = "~/.#{file}"
   if File.exists? File.expand_path( dotted)
    puts "#{dotted} already exists, won't install"
   else
    system('ln', '-s', File.expand_path(file), File.expand_path(dotted))
  end
end
