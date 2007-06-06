#
# Ruby Interface to festival tts system
#
# Requires festivaltts and lame.
# Must be run in a UNIX environment.

class String
  
  # Outputs the speech generated with festival tts and the string itself.
  # Can handle two params:
  # - text --> speech given text instead of the string itself.
  # - language --> speech language desired (festival voices for given languages
  #  are required )  
  def to_speech(params={})  
    text = params[:text] || self
    language = "--language " + params[:language] if params[:language]
    system("echo \"#{text.to_s}\" | festival --tts #{language}")
  end
  
  # Creates a file with name "filename" and with the generated with festival tts, the string itself and lame.
  # Can handle one parameter:
  # - text --> speech given text instead of the string itself.  
  def to_mp3(filename, params={})
    text = params[:text] || self
    raise "to_mp3 language option still not implemented" if params[:language]
    system("echo \"#{text.to_s}\" | text2wave | lame --alt-preset cbr 16 -a --resample 11 --lowpass 5 --athtype 2 -X3 - > #{filename} 2> /dev/null")
  end
  
end