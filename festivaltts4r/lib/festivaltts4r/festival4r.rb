#
# Ruby Interface to festival tts system
#
# Requires festivaltts and lame.
# Must be run in a UNIX environment.
#
# You can found more information in my english blog http://spejman-on-rails.blogspot.com 
# or in the spanish one http://spejman.blogspot.com 
#
# Work done by Sergio Espeja (http://www.sergioespeja.com)
#
# It is free software, and may be redistributed under GPL license.
# Copyright (c) 2007 Sergio Espeja


class String
  
  # Outputs the speech generated with festival tts and the string itself.
  # Can handle these options:
  # - text --> speech given text instead of the string itself.
  # - language --> speech language desired (festival voices for given languages are required )  
  # - festival --> alternative festival program and options besides 'festival --tts'

  def to_speech(params={})  
    text = params[:text] || self
    festival = params[:festival] || "festival --tts"
    language = "--language " + params[:language] if params[:language]

    cmd = "echo \"#{text.to_s}\" | #{festival} #{language}"

    begin
      out = IO.popen(cmd)
      Process.wait
      e = $?.exitstatus
    rescue StandardError => err
      raise FestivalError.new(err)
    else
      raise FestivalSystemError.new("0 not returned:\n#{cmd}\n#{out.readlines}"
        ) unless e.eql?(0)
    end

  end
  
  # Creates a file with name "filename" and with the generated with festival tts, the string itself and lame.
  # Can handle one options:
  # - text --> speech given text instead of the string itself.  
  def to_mp3(filename, params={})
    text = params[:text] || self
    raise "to_mp3 language option still not implemented" if params[:language]
    system("echo \"#{text.to_s}\" | text2wave | lame --alt-preset cbr 16 -a --resample 11 --lowpass 5 --athtype 2 -X3 - > #{filename} 2> /dev/null")
  end
  
end

##
# A generic application error wrapper for festivaltts4r

class FestivalError < RuntimeError

  ##
  # The original exception

  attr_accessor :original_exception

  ##
  # Creates a new MediaBotError with +message+ and +original_exception+

  def initialize(e)
    exception = e.class == String ? StandardError.new(e) : e
    @original_exception = exception
    message = "festivaltts4r error: #{exception.message} (#{exception.class})"
    super message
  end

end

class FestivalSystemError < FestivalError; end
