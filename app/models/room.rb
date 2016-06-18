class Room < ActiveRecord::Base
  include BelongsToOrganization
  include Heatmap

  attr_accessor :busy

  has_and_belongs_to_many :events

  validates_presence_of :title

  class << self
    def list(organization_id, page)
      local(organization_id)
        .order(title: :asc)
        .paginate(page: page, per_page: 15)
    end

    def search(organization_id, phrase)
      local(organization_id)
        .where('lower(title) LIKE ?', "%#{phrase}%")
        .order(title: :asc)
    end
  end

  def heatmap_json
    data = duration_heatmap_data
    { data: data, name: ['hour', 'hours'], legend: heatmap_legend(data) }
  end
end
