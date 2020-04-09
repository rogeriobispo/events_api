class CreateFestival
  attr_accessor :errors
  def save(params)
    @errors = []
    return false unless verify_artists_exists(params['artist_ids'])

    @event = Event.new(params)
    verify_event_errors
    store
  end

  private

  def verify_artists_exists(artist_ids)
    Artist.find(artist_ids.uniq)
    true
  rescue
    error = {
      artists: ['All Artists must exists']
    }

    @errors.push error
    false
  end

  def verify_event_errors
    @event.validate
    @errors.push @event.errors if @event.errors.size.positive?
  end

  def store
    @event.save if @errors.empty?

    return @event if @errors.empty?

    false
  end
end
