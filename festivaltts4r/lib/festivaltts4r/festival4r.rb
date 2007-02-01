#
# Ruby Interface to festival tts system
# 

class String
  
  def to_speech(params={})
  
    text = params[:text] || self
    language = "--language " + params[:language] if params[:language]
    system("echo \"#{text.to_s}\" | festival --tts #{language}")
  end
  
  def to_mp3(filename, params={})

    text = params[:text] || self
    raise "to_mp3 language option still not implemented" if params[:language]
    system("echo \"#{text.to_s}\" | text2wave | lame - - > #{filename}.mp3 2> /dev/null")
  end
  
end