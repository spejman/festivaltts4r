require File.dirname(__FILE__) + '/test_helper.rb'
require 'tempfile'

class Festivaltts4rTest < Test::Unit::TestCase

  def setup
    @mp3 = Tempfile.new('fake.mp3')
  end

  def teardown
    @mp3.unlink
  end

  def test_string_execute
    assert_raises(FestivalSystemError) do
      String.execute '/bin/false'
    end

    assert_nothing_raised do
      String.execute '/bin/true'
    end
  end

  def test_to_speech
    assert_raises(FestivalSystemError) do
      params = {:festival => '/bin/not-a-real-program'}
      "hello world".to_speech(params)
    end

    assert_raises(FestivalSystemError) do
      params = {:festival => '/bin/false'}
      "hello world".to_speech(params)
    end

    assert_nothing_raised do
      params = {:festival => '/bin/true'}
      "hello world".to_speech(params)
    end
  end

  def test_to_mp3
    assert_raises(FestivalSystemError) do
      params = {:lame => '/bin/false'}
      "hello world".to_mp3(@mp3.path, params)
    end

    assert_nothing_raised do
      params = {:text2wave => '/bin/true'}
      params = {:lame => '/bin/true'}
      "hello world".to_mp3(@mp3.path, params)
    end
  end

  def test_to_mp3_really_creates_a_file
    if system('which text2wave') && system('which lame')
      assert_equal 0, @mp3.size
      "hello world".to_mp3(@mp3.path, params={})
      assert_equal true, File.exists?(@mp3)
      assert @mp3.size > 0
    end
  end
end
