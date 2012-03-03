# coding: utf-8

class Fluent::SimplefilterOutput < Fluent::Output
  Fluent::Plugin.register_output('simplefilter', self)

  # config_param :hoge, :string, :default => 'hoge'
  config_param :file_exists, :string
  config_param :tag, :string

  def initialize
    super
  end

  def filtered?
    File.exist?(@file_exists)
  end

  def configure(cnf)
    super
  end

  def start
    super
  end

  def shutdown
    super
  end

  def format(tag, time, record)
    [tag, time, record].to_msgpack
  end

  def emit(tag, es, chain)
    es.each do |time, record|
      Fluent::Engine.emit(@tag, time, record) unless filtered?
    end
    chain.next
  end
end
