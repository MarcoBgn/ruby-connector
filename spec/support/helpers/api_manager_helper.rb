require 'spec_helper'

def rest_client_arguments_get
  { method: :get,
    url: "https://api.getbase.com/v2/contacts?",
    headers: {"Accept"=>"application/json", "Authorization"=>"Bearer "}}
end

def rest_client_arguments_post
  { method: :post,
    url: "https://api.getbase.com/v2/contacts",
    payload: JSON.generate({"data" => {"payload" => "test"}}),
    headers: {"Accept"=>"application/json", "Content-Type"=>"application/json", "Authorization"=>"Bearer "}}
end

def rest_client_arguments_put
  { method: :put,
    url: "https://api.getbase.com/v2/contacts/1",
    payload: JSON.generate({"data" => {"payload" => "test"}}),
    headers: {"Accept"=>"application/json", "Content-Type"=>"application/json", "Authorization"=>"Bearer "}}
end
