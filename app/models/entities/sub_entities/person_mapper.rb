class Entities::SubEntities::PersonMapper
  extend HashMapper

  after_denormalize do |input, output|
    if input['is_organization'].nil?
      output[:is_lead] = true
      output[:is_customer] = false
    end
    output[:assignee_type] = "AppUser" if output[:assignee_id]
    output
  end

  after_normalize do |input, output|

    output.delete('contact_id') if input[:is_lead]
    output
  end

  map from('job_title'), to('title')
  map from('first_name'), to('first_name')
  map from('last_name'), to('last_name'), default: "Not Available"
  map from('email/address'), to('email')

  map from('organization_id'), to('contact_id', &:to_i)
  map from('assignee_id'), to('owner_id', &:to_i)

  map from('contact_channel/skype'), to('skype')
  map from('phone_work/landline'), to('phone')
  map from('phone_work/mobile'), to('mobile')
  map from('phone_work/fax'), to('fax')

  map from('address_work/billing/line1'), to('address/line1')
  map from('address_work/billing/city'), to('address/city')
  map from('address_work/billing/postal_code'), to('address/postal_code')
  map from('address_work/billing/country'), to('address/country')
end
