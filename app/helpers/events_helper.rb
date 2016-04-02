module EventsHelper
  def event_duration(event)
    (event.finish.to_i - event.start.to_i) / 3600.0
  end
end
