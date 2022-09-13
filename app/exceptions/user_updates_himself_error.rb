class UserUpdatesHimselfError < StandardError
  attr_reader :message

  def initialize(message = 'User can not update himself')
    @message = message
  end
end
