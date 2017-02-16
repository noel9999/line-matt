HANDLERS_DIR = File.expand_path('./handlers', File.dirname(__FILE__))
# puts HANDLERS_DIR
# $LOAD_PATH.unshift(HANDLERS_DIR) unless $LOAD_PATH.include?(HANDLERS_DIR)
# puts $LOAD_PATH
# require './handlers/base'

require File.join(HANDLERS_DIR, 'base')
NOT_REQUIRED = %W(. ..).freeze
HANDLERS  = Dir.entries(HANDLERS_DIR) - NOT_REQUIRED
HANDLERS.each do |handler|
  send :require , File.join(HANDLERS_DIR, handler)
end



class HandlerDispatcher
  def initialize
  end

  def lala
    puts 'lala'
  end

  def self.handlers
    Handlers
  end
end