# FestivalttsOnRails
require "#{File.dirname(__FILE__)}/festival4r.rb"
MP3_FLASH_PLAYER_URL = "/flash/dewplayer.swf"
MP3_FOLDER_URL = "/festivaltts_mp3"
MP3_FOLDER_PATH = "#{RAILS_ROOT}/public/#{MP3_FOLDER_URL}"

def text_to_flash_player(text, opts = {})
  bgcolor = opts[:bgcolor] if opts[:bgcolor]
  width = opts[:width] if opts[:width]
  height = opts[:height] if opts[:height]

  filename = "#{(1000000000*rand).round}.mp3"
  
  text.to_mp3(MP3_FOLDER_PATH + "/" + filename)
  html_for_mp3_flash(MP3_FOLDER_URL + "/" + filename)

end

def html_for_mp3_flash(filename, bgcolor = "FFFFFF", width = 200, height = 20)
  "    <object type=\"application/x-shockwave-flash\"\n \
   data=\"#{MP3_FLASH_PLAYER_URL}?son=#{filename}&amp;bgcolor=#{bgcolor}\" width=\"#{width}\"\n \
   height=\"#{height}\">\n \
   <param name=\"movie\" value=\"#{MP3_FLASH_PLAYER_URL}?son=#{filename}&amp;bgcolor=#{bgcolor}\" />\n \
   </object>"
end

# <embed wmode="transparent" src="/flash/music.swf?url=/lametest2.mp3" quality="high"
# pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="150" height="50">
# </embed>