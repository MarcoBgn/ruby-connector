class Entities::SubEntities::OrganizationMapper
  extend HashMapper

  map from('updated_at'), to('data/updated_at')
  map from('created_at'), to('data/created_at')
  map from('name'), to('data/name')
  map from('industry'), to('data/industry')
  map from('email/address'), to('data/email')

  map from('address_work/billing/line1'), to('data/address/line1')
  map from('address_work/billing/city'), to('data/address/city')
  map from('address_work/billing/postal_code'), to('data/address/postal_code')
  map from('address_work/billing/region'), to('data/address/state')
  map from('address_work/billing/country'), to('data/address/country')

  map from('/website/url'), to('/data/website')
end
