module Heatmap
  extend ActiveSupport::Concern

  private

  def heatmap_legend(data)
    unless data.empty?
      quarter = data.values.max / 4
      legend = [quarter, quarter * 2, quarter * 3, quarter * 4]
    end
    legend || [2, 4, 6, 8]
  end

  def duration_heatmap_data
    data = {}
    self.events.where('start < ?', DateTime.now).each do |event|
      timestamp = event.start.to_i.to_s
      data[timestamp] = event.duration
    end
    data
  end

  def quantity_heatmap_data
    data = {}
    self.scheduled_items.each do |entry|
      event = Event.where(id: entry.event_id).first
      if event.start < DateTime.now
        timestamp = event.start.to_i.to_s
        data[timestamp] = entry.quantity
      end
    end
    data
  end
end