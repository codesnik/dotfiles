#!/usr/bin/ruby

# this won't bite your Bundle-using programs too
require 'rubygems'

# don't know if they are needed

#require 'irb/completion'
#require 'irb/ext/save-history'

#IRB.conf[:SAVE_HISTORY] = 100
#IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history" 
IRB.conf[:PROMPT_MODE]  = :SIMPLE
IRB.conf[:AUTO_INDENT] = true

def provided_by lib
  begin
    require lib
    yield
  rescue LoadError
    puts "#{lib} is not available"
  end
end

provided_by 'wirble' do
  Wirble.init
  # thoose do not work, actually
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
  Wirble.colorize MY_COLORS

end

provided_by 'hirb' do
  Hirb.enable :formatter => false
end

provided_by 'yaml' do
  # I love that 'y something' shortcut
end


provided_by 'looksee/shortcuts' do
end

#provided_by 'soma' do
#  Soma.start
#end

provided_by 'ap' do
  # awesome print!
end

# Just for Rails...
if defined? Rails

  if defined? ActiveRecord::Base
    require 'logger'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  if defined? DataObjects::Sqlite3
    # DataMapper::Logger.new(STDOUT, :debug)
    DataObjects::Sqlite3.logger = Logger.new(STDOUT)
  end

  rails_root = File.basename(Rails.root || Dir.pwd)
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
  
  #IRB.conf[:IRB_RC] = Proc.new do
    # nice shortcut: Class[:first] eq Class.find(:first)
    #ActiveRecord::Base.instance_eval { alias :[] :find }
  #end

  ## helper.url_for.. got from: http://errtheblog.com/posts/41-real-console-helpers
  #def Object.method_added(method)
  #  return super(method) unless method == :helper
  #  (class<<self;self;end).send(:remove_method, :method_added)

  #  def helper(*helper_names)
  #    returning $helper_proxy ||= Object.new do |helper|
  #      helper_names.each { |h| helper.extend "#{h}_helper".classify.constantize }
  #    end
  #  end

  #  helper.instance_variable_set("@controller", ActionController::Integration::Session.new)

  #  def helper.method_missing(method, *args, &block)
  #    @controller.send(method, *args, &block) if @controller && method.to_s =~ /_path$|_url$/
  #  end

  #  helper :application rescue nil
  #end 

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


def debug
  require 'ruby-debug'
  debugger
  yield
end
