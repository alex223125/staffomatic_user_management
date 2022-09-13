# frozen_string_literal: true

class UserSelfdestructionError < StandardError
  attr_reader :message

  def initialize(message = 'User can not destroy himself')
    @message = message
  end
end
