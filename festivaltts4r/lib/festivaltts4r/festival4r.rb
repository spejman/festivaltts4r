#
# Ruby Interface to festival tts system
# 

class String
  def to_speech(text=self)
    system("echo \"#{text.to_s}\" | festival --tts")
  end
end