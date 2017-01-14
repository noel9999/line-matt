module Handlers
  class Base
    TYPES = %w(video text).freeze
    attr_reader :match_result

    def initialize(message:, options: {})
      fail 'Pattern must be either a Regexp or an array of Regexp' unless check_pattern?
      @match_result ||= match_any?(message)
      post_initialize(options)
    end

    def post_initialize(options)
      nil
    end

    def pattern
      fail 'not implement yet'
    end

    def outcome
      fail 'not implement yet'
    end

    def valid?
      !match_result.nil?
    end

    private

    def message
      match_result.to_s
    end

    def key_words
      fail 'No key_words matched' unless match_result.respond_to?(:captures)
      @key_words ||= match_result.captures.dup
      @key_words.freeze
    end

    def check_pattern?
      if pattern.is_a?(Array)
        pattern.all? { |element| element.is_a? Regexp }
      else
        pattern.is_a? Regexp
      end
    end

    def match_any?(message)
      Array(pattern).find { |e| e =~ message }.match message
    end
  end
end