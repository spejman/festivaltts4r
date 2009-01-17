# Include festivaltts4r lib subdirectory files.
Dir[File.join(File.dirname(__FILE__), 'festivaltts4r/**/*.rb')].sort.each { |lib| require lib }