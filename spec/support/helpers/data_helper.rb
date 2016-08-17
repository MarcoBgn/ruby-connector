require 'spec_helper'

def api_get_call_contacts
  {
    "items" =>
    [
      {
        "data" =>
        {
          "id" => 135906739,
          "creator_id" => 960788,
          "contact_id" => nil,
          "created_at" => "2016-07-19T10=>20=>07Z",
          "updated_at" => "2016-07-19T10=>20=>08Z",
          "title" => nil,
          "name" => "Base CRM",
          "first_name" => nil,
          "last_name" => nil,
          "description" => nil,
          "industry" => nil,
          "website" => nil,
          "email" => nil,
          "phone" => nil,
          "mobile" => nil,
          "fax" => nil,
          "twitter" => nil,
          "facebook" => nil,
          "linkedin" => nil,
          "skype" => nil,
          "owner_id" => 960788,
          "is_organization" => true,
          "address"=>
            {
              "city" => "Chicago",
              "line1" => "Suite 200 212 W. Superior",
              "postal_code" => nil,
              "state" => "IL",
              "country"=> "United States"
            },
          "tags" => [],
          "custom_fields" => {},
          "customer_status" => "none",
          "prospect_status" => "current"
        },
      "meta" => {"version" => 2,"type" => "contact"}},
      {
        "data" =>
        {
          "id" => 135906741,
          "creator_id" => 960788,
          "contact_id" => 135906739,
          "created_at" => "2016-07-19T10=>20=>07Z",
          "updated_at" => "2016-07-19T10=>20=>08Z",
          "title" => nil,"name" => "Support Team",
          "first_name" => "Support",
          "last_name" => "Team",
          "description" => nil,
          "industry" => nil,
          "website" => nil,
          "email" => nil,
          "phone" => "+1 (800) 940-9650",
          "mobile" => nil,"fax"=>nil,
          "twitter" => nil,
          "facebook" => nil,
          "linkedin" => nil,
          "skype" => nil,
          "owner_id" => 960788,
          "is_organization" => false,
          "address" => {"city" => "Chicago",
          "line1" => "Suite 200 212 W. Superior",
          "postal_code" => nil,
          "state" => "IL",
          "country" => "United States"},
          "tags" => [],
          "custom_fields" => {},
          "customer_status" => "none",
          "prospect_status" => "current"},
          "meta" => {"version" => 2,
            "type" => "contact"}
        }
    ],
      "meta" =>
      {
      "type" => "collection","count" => 2,
      "links" =>
        {
          "self" => "https://api.getbase.com/v2/contacts?page=1&per_page=25"
        }
      }
    }.to_json
end

def api_response_from_post
  {
    "meta" =>
      {
        "type"=> "product"
      },
   "data" =>
      {
        "id" => 470988,
        "updated_at" => "2016-07-20T15=>34=>24Z",
        "created_at" => "2016-07-20T15=>34=>24Z",
        "active" => true,
        "description" => "Includes more storage options",
        "name" => "Enterprise NEW Plan",
        "sku" => "enterprise-plan",
        "prices" =>
        [
          {"currency" => "PL N" ,"amount"=>"2599.99"},
          {"currency" => "USD","amount"=>"2599.99"}
        ],
        "max_discount" => 15,
        "max_markup" => nil,
        "cost" => "1599.99",
        "cost_currency" => "USD"
      }
  }.to_json
end

def api_response_error
  {
  "errors" => [
    {
      "meta" => {
        "type" => "error",
        "links" => {
          "more_info" => "https://developers.getbase.com/docs/rest/articles/errors"
        }
      },
      "error" => {
        "message" => "resource you are looking for was not found",
        "code" => "not_found",
        "resource" => "product",
        "details" => "Resource of the type 'product' with the id '23231' was not found."
      }
    }
  ],
  "meta" => {
    "type" => "collection",
    "links" => {
      "more_info" => "https://developers.getbase.com/docs/rest/articles/errors"
    },
    "http_status" => "404 Not Found",
    "logref" => "am2a2-s2pur-icd17-05rkg"
  }
}.to_json
end

def mapped_connec_entity
  { "id" =>  12345678, "first_name" => "John", "last_name" => "Smith"}
end
