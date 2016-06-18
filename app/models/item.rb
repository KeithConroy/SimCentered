class Item < ActiveRecord::Base
  include BelongsToOrganization
  include Heatmap

  attr_accessor :busy

  has_many :scheduled_items
  has_many :events, through: :scheduled_items

  validates_presence_of :title, :quantity

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
    data = self.disposable ? quantity_heatmap_data : duration_heatmap_data
    name = self.disposable ? ['item used', 'items used'] : ['hour', 'hours']
    { data: data, name: name, legend: heatmap_legend(data) }
  end
end
