class Entities::PersonAndOrganization < Maestrano::Connector::Rails::ComplexEntity
  def self.connec_entities_names
    %w(Person Organization)
  end

  def self.external_entities_names
    %w(Contact Lead)
  end

  # input :  {
  #             connec_entity_names[0]: [unmapped_connec_entitiy1, unmapped_connec_entitiy2],
  #             connec_entity_names[1]: [unmapped_connec_entitiy3, unmapped_connec_entitiy4]
  #          }
  # output : {
  #             connec_entity_names[0]: {
  #               external_entities_names[0]: [unmapped_connec_entitiy1, unmapped_connec_entitiy2]
  #             },
  #             connec_entity_names[1]: {
  #               external_entities_names[0]: [unmapped_connec_entitiy3],
  #               external_entities_names[1]: [unmapped_connec_entitiy4]
  #             }
  #          }
  def connec_model_to_external_model(connec_hash_of_entities)
    contacts = []
    organizations = []
    leads_people = []
    leads_organizations = []
    #In Connec! Leads are People or Organizations with field 'is_lead' = true
    split_leads_from_connec(connec_hash_of_entities['Person'],
                            leads_people,
                            contacts)
    split_leads_from_connec(connec_hash_of_entities['Organization'],
                            leads_organizations,
                            organizations)

    { 'Person' => { 'Contact' => contacts,
                    'Lead' => leads_people
                  },
      'Organization' => { 'Contact' => organizations,
                          'Lead' => leads_organizations
                        }
    }
  end

  # input :  {
  #             external_entities_names[0]: [unmapped_external_entity1, unmapped_external_entity2],
  #             external_entities_names[1]: [unmapped_external_entity3, unmapped_external_entity4]
  #          }
  # output : {
  #             external_entities_names[0]: {
  #               connec_entity_names[0]: [unmapped_external_entity1],
  #               connec_entity_names[1]: [unmapped_external_entity2]
  #             },
  #             external_entities_names[1]: {
  #               connec_entity_names[0]: [unmapped_external_entity3, unmapped_external_entity4]
  #             }
  #           }
  def external_model_to_connec_model(external_hash_of_entities)
    contacts = external_hash_of_entities['Contact']
    leads = external_hash_of_entities['Lead']

    modelled_hash = {'Contact' => { 'Person' => [], 'Organization' => [] },
                     'Lead' => {'Person' => [], 'Organization' => []}
                    }

    filter_entities_into_connec(modelled_hash, 'Contact', contacts, 'is_organization')
    filter_entities_into_connec(modelled_hash, 'Lead', leads, 'organization_name', 'last_name')

    modelled_hash
  end

  private

    def split_leads_from_connec(connec_hash, leads_array, contacts_array)
      connec_hash.each do |entity|
        entity['is_lead'] ? leads_array << entity : contacts_array << entity
      end
    end

    def filter_entities_into_connec(modelled_hash, entity_name, entities_array, *conditions)
      entities_array.each do |entity|
        if entity[conditions[0]] && !entity[conditions[1]]
          modelled_hash[entity_name]['Organization'] << entity
        else
          modelled_hash[entity_name]['Person'] << entity
        end
      end
    end
end
