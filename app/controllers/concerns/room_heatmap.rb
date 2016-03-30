module RoomHeatmap
  extend ActiveSupport::Concern

  def heatmap
    @room = find_room or return
    data = heatmap_data(@room)
    unless data.empty?
      quarter = data.values.max / 4
      legend = [quarter,quarter*2,quarter*3,quarter*4]
    end

    render json: { data: data, name: ['hour', 'hours'], legend: legend || [2,4,6,8]}
  end

  private

  def heatmap_data(room, data = {})
    room.events.each do |event|
      if event.start < DateTime.now
        timestamp = event.start.to_i.to_s
        data[timestamp] = event_duration(event)
      end
    end
    data
  end

end