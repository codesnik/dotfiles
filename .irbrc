#!/usr/bin/ruby
# ^^ for dumb vim ft autodetection
# TODO we need to do something when wirble gem isn't available
require 'rubygems'
require 'wirble'
require 'ruby-debug'

Wirble.init
MY_COLORS = {
  :comma            => :red,
  :refers           => :red,
  :open_hash        => :blue,
  :close_hash       => :blue,
  :open_array       => :green,
  :close_array      => :green,
  :open_object      => :light_red,
  :object_class     => :light_green,
  :object_addr      => :purple,
  :object_line      => :light_purple,
  :close_object     => :light_red,
  :symbol           => :yellow,
  :symbol_prefix    => :yellow,
  :number           => :cyan,
  :string           => :cyan,
  :keyword          => :white,
  :range            => :light_blue,
}
#Wirble.colorize MY_COLORS

Wirble.colorize 

# I love that 'y something' shortcut
require 'yaml'

#require 'irb/completion'
#require 'irb/ext/save-history'

IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history" 
IRB.conf[:PROMPT_MODE]  = :SIMPLE
IRB.conf[:AUTO_INDENT_MODE] = true

script_console_running = ENV.include?('RAILS_ENV') && IRB.conf[:LOAD_MODULES] && IRB.conf[:LOAD_MODULES].include?('console_with_helpers')
rails_running = ENV.include?('RAILS_ENV') && !(IRB.conf[:LOAD_MODULES] && IRB.conf[:LOAD_MODULES].include?('console_with_helpers'))
irb_standalone_running = !script_console_running && !rails_running

if script_console_running
    require 'logger'
    Object.const_set(:RAILS_DEFAULT_LOGGER, Logger.new(STDOUT))
end

# Just for Rails...
if rails_running

  rails_root = File.basename(Dir.pwd)
  if rails_root == 'trunk'
    rails_root = File.basename(File.expand_path('..'))
  end

  IRB.conf[:PROMPT] ||= {}
  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{rails_root}> ",
    :PROMPT_S => "#{rails_root}* ",
    :PROMPT_C => "#{rails_root}? ",
    :RETURN   => "=> %s\n" 
  }
  IRB.conf[:PROMPT_MODE] = :RAILS

  # Called after the irb session is initialized and Rails has
  # been loaded (props: Mike Clark).
  
  IRB.conf[:IRB_RC] = Proc.new do
    # doesn't work anymore, cause logger's cached
    #ActiveRecord::Base.logger = Logger.new(STDOUT)
    # nice shortcut: Class[:first] eq Class.find(:first)
    ActiveRecord::Base.instance_eval { alias :[] :find }
  end

end


# tracing support
################################################################################
def enable_trace( event_regex = /^(call|return)/, class_regex = /IRB|Wirble|RubyLex|RubyToken/ )
  puts "Enabling method tracing with event regex #{event_regex.inspect} and class exclusion regex #{class_regex.inspect}"

  level = 0
  set_trace_func Proc.new{|event, file, line, id, binding, classname|

    level += 1  if event == 'call'

    if event =~ event_regex && classname.to_s !~ class_regex
     
      file = File.expand_path(file)
      # making relative
      if file.index(Dir.pwd) == 0
        file[Dir.pwd + '/'] = ''
      end

      printf "[%8s]%#{level}s %-#{[30-level, 0].max}s %-30s (%s:%-2d)\n", event, '', id, classname, file, line 
    end

    level -= 1  if event == 'return'
      
  }
  return
end

def disable_trace
  puts "Disabling method tracing"

  set_trace_func nil
end

