require 'singleton'

class QueryParamsManager
  include Singleton

  def self.query_params(auth_params)
    URI.escape(auth_params.collect{|k,v| "#{k}=#{v}"}.join('&'))
  end

  def self.batched_call(opts)
    #the page requested is calculated from the offset ([:__skip)]) and (opts[:__limit])
    page = opts[:__skip] == 0 ? 1 : (opts[:__skip] / opts[:__limit] + 1)
    { page: page, per_page: opts[:__limit]}
  end

  def self.by_updated_at
    { sort_by: "updated_at"}
  end
end
