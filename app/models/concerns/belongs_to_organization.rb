module BelongsToOrganization
  extend ActiveSupport::Concern

  included do
    belongs_to :organization
    validates_presence_of :organization_id
  end

  module ClassMethods
    def local(organization_id)
      where(organization_id: organization_id)
    end
  end

  private

  def check_organization(resource)
    if resource.organization_id != organization_id
      raise "This #{resource.class} does not belong to your organization"
    end
  end
end
