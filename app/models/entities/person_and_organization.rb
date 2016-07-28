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
    leads = []

    connec_hash_of_entities['Person'].each do |person|
      if person['is_lead']
        leads << person
      else
        contacts << person
      end
    end

    { 'Person' => { 'Contact' => contacts,
                    'Lead' => leads
                  },
      'Organization' => { 'Contact' => connec_hash_of_entities['Organization'] }
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
    contacts = external_hash_of_entities['Contact'] ? external_hash_of_entities['Contact'] : []
    leads = external_hash_of_entities['Lead'] ? external_hash_of_entities['Lead'] : []

    modelled_hash = {'Contact' => { 'Person' => [], 'Organization' => [] }}

    contacts.each do |contact|
      if contact['is_organization']
        modelled_hash['Contact']['Organization'] << contact
      else
        modelled_hash['Contact']['Person'] << contact
      end
    end

    leads.each do |lead|
      if lead['organization_name']
        modelled_hash['Contact']['Organization'] << lead
      else
        modelled_hash['Contact']['Person'] << lead
      end
    end
    modelled_hash
  end
end
