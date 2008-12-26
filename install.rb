#!/usr/bin/ruby
files = ARGV.empty? ? Dir['*'] : ARGV
for file in Dir['*']
   next if File.expand_path(file) == File.expand_path($0)
   dotted = "~/.#{file}"
   if File.exists? File.expand_path( dotted)
    if test ?l, File.expand_path( dotted)
      puts "#{dotted} already installed, won't install"
    else
      puts "#{dotted} already exists, won't install"
    end
   else
    if system('ln', '-s', File.expand_path(file), File.expand_path(dotted))
      puts "successfully installed #{dotted}"
    else
      puts "something wrong while installing #{dotted}"
    end
  end
end
