class CreateEvent
  attr_accessor :errors
  def CreateEvent.new(type)
    return CreateConcert.new if type == 'concert'

    return CreateFestival.new if type == 'festival'

    CreateDfault.new
  end
end

class CreateDfault
  attr_accessor :errors

  def save(params = nil)
    puts params.to_s
    error = {
      event: ['Kind not implemented']
    }
    @errors = [error]
    false
  end
end
