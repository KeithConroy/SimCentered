module ItemHeatmap
  extend ActiveSupport::Concern

  def heatmap
    render json: heatmap_json(@item)
  end

  private

  def heatmap_json(item)
    data = item.disposable ? disposable_heatmap_data(item) : capital_heatmap_data(item)
    name = item.disposable ? ['item used', 'items used'] : ['hour', 'hours']
    unless data.empty?
      quarter = data.values.max / 4
      legend = [quarter,quarter*2,quarter*3,quarter*4]
    end

    { data: data, name: name, legend: legend || [2,4,6,8]}
  end

  def disposable_heatmap_data(item, data = {})
    item.scheduled_items.each do |entry|
      event = Event.where(id: entry.event_id).first
      if event.start < DateTime.now
        timestamp = event.start.to_i.to_s
        data[timestamp] = entry.quantity
      end
    end
    data
  end

  def capital_heatmap_data(item, data = {})
    item.events.each do |event|
      if event.start < DateTime.now
        timestamp = event.start.to_i.to_s
        data[timestamp] = event_duration(event)
      end
    end
    data
  end
end