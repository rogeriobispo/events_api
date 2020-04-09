class CreateConcert
  attr_accessor :errors
  def save(params)
    @errors = []
    params['artist_ids'] = params['artist_ids'].uniq
    return false unless verify_single_artist(params['artist_ids'])

    return false unless verify_artists_exists(params['artist_ids'])

    @event = Event.new(params)
    verify_event_errors
    store
  end

  private

  def verify_single_artist(artists)
    error = {
      artists: ['Artists must be single to concert']
    }
    if artists.size > 1
      @errors.push error
      return false
    end

    true
  end

  def verify_artists_exists(artists)
    error = {
      artists: ['Artists must exists']
    }
    unless artists && Artist.exists?(artists.first)
      @errors.push error
      return false
    end

    true
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
