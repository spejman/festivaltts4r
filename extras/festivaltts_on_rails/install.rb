#RAILS_ROOT="../../../" unless defined?(RAILS_ROOT)
require "fileutils"
require File.join("#{File.dirname(__FILE__)}/lib/", "festivaltts_on_rails.rb")

def copy_files(source_path, destination_path, directory)
  source, destination = File.join(directory, source_path), File.join(RAILS_ROOT, destination_path)
  FileUtils.mkdir(destination) unless File.exist?(destination)
  FileUtils.cp_r(Dir.glob(source+'/*.*'), destination)
end

directory = File.dirname(__FILE__)
# Subdir for tmp mp3 files
FileUtils.mkdir(MP3_FOLDER_PATH)
copy_files("/flash", "/public/flash", directory)
