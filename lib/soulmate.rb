require 'uri'
require 'multi_json'
require 'redis'

require 'soulmate/version'
require 'soulmate/normalizer'
require 'soulmate/helpers'
require 'soulmate/base'
require 'soulmate/matcher'
require 'soulmate/loader'

module Soulmate

  extend self

  attr_writer :min_complete
  attr_writer :normalizer


  MIN_COMPLETE = 2
  DEFAULT_STOP_WORDS = ["vs", "at", "the"]
  DEFAULT_NORMALIZER = ->(str) { Soulmate::Normalizer.call(str) }

  def redis=(url_or_connection)
    if url_or_connection.is_a?(String)
      @redis = nil
      @redis_url = url
    else
      @redis = url_or_connection
      @redus_url = nil
    end

    redis
  end

  def redis
    @redis ||= (
      url = URI(@redis_url || ENV["REDIS_URL"] || "redis://127.0.0.1:6379/0")

      ::Redis.new({
        :host => url.host,
        :port => url.port,
        :db => url.path[1..-1],
        :password => url.password
      })
    )
  end

  def stop_words
    @stop_words || DEFAULT_STOP_WORDS
  end

  def stop_words=(arr)
    @stop_words = Array(arr).flatten
  end

  def min_complete
    @min_complete || MIN_COMPLETE
  end

  def normalizer
    @normalizer || DEFAULT_NORMALIZER
  end


end
