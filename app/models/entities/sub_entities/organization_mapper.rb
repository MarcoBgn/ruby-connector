class Entities::SubEntities::OrganizationMapper
  extend HashMapper

  after_denormalize do |input, output|
    if input['organization_name']
      output[:name] = input['organization_name']
      output[:is_lead] = true
      output[:is_customer] = false
    else
      output[:name] = input['name']
    end
    output
  end

  after_normalize do |input, output|
    if input[:is_lead]
      output['organization_name'] = input[:name]
    else
      output['is_organization'] = true
      output['name'] = input[:name]
    end
    output
  end

  map from('industry'), to('industry')
  map from('email/address'), to('email')

  map from('contact_channel/skype'), to('skype')
  map from('phone_work/landline'), to('phone')
  map from('phone_work/mobile'), to('mobile')
  map from('phone_work/fax'), to('fax')

  map from('assignee_id'), to('owner_id', &:to_i)

  map from('address_work/billing/line1'), to('address/line1')
  map from('address_work/billing/city'), to('address/city')
  map from('address_work/billing/postal_code'), to('address/postal_code')
  map from('address_work/billing/region'), to('address/state')
  map from('address_work/billing/country'), to('address/country')

  map from('website/url'), to('website')
end
