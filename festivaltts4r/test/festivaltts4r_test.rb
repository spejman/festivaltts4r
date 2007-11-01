require File.dirname(__FILE__) + '/test_helper.rb'

class Festivaltts4rTest < Test::Unit::TestCase

  def test_to_speech_raises_festival_error
    assert_raises(FestivalSystemError) do
      params = {:festival => '/bin/not-a-real-program'}
      "hello world".to_speech(params)
    end

    assert_raises(FestivalSystemError) do
      params = {:festival => '/bin/false'}
      "hello world".to_speech(params)
    end
  end
  
end
