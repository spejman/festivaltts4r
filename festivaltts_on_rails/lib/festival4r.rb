#
# Ruby Interface to festival tts system
#
# Requires festivaltts and lame.
# Must be run in a UNIX environment.
#
# You can found more information in my english blog http://spejman-on-rails.blogspot.com 
# or in the spanish one http://spejman.blogspot.com 
#
# Work done by Sergio Espeja (http://www.sergioespeja.com) and Mike Mondragon (http://blog.mondragon.cc)
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

    cmd = "echo \"#{text.to_s}\" | #{festival} #{language} 2>&1"

    self.class.execute cmd

  end
  
  # Creates a file with name "filename" and with the generated with festival tts, the string itself and lame.
  # Can handle one options:
  # - text --> speech given text instead of the string itself.  
  # - text2wave - alternative text2wave program and options besides 'text2wave'
  # - lame - alternative lame command other than 'lame --alt-preset cbr 16 -a --resample 11 --lowpass 5 --athtype 2 -X3 -'
  def to_mp3(filename, params={})
    text = params[:text] || self
    text2wave = params[:text2wave] || "text2wave"
    # athtype not on all LAMEs, i.e. --athtype 2 
    lame = params[:lame] || "lame --alt-preset cbr 16 -a --resample 11 --lowpass 5 -X3 -"
    raise "to_mp3 language option still not implemented" if params[:language]
    cmd = "echo \"#{text.to_s}\" | #{text2wave} | #{lame} > #{filename} 2>&1"

    self.class.execute cmd
  end

  def self.execute(cmd)
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
  
end

##
# A generic application error wrapper for festivaltts4r

class FestivalError < RuntimeError

  ##
  # The original exception

  attr_accessor :original_exception

  ##
  # Creates a new FestivalError with +message+ and +original_exception+

  def initialize(e)
    exception = e.class == String ? StandardError.new(e) : e
    @original_exception = exception
    message = "festivaltts4r error: #{exception.message} (#{exception.class})"
    super message
  end

end

class FestivalSystemError < FestivalError; end
