require 'osx_adapter.rb'
require 'linux_adapter.rb'

class Adapter
  def capture(message)
    raise NotImplementedError("Must use concrete subclass for capture")
  end

  def set_excutable_permission
  end

  def rename_gif
    %x( mv #{gif_file_path} ~/lolerrors/snapshot_#{Time.now.to_i}.gif )
  end

  def video_file_path
    "#{save_location}/snapshot.mov"
  end

  def gif_file_path
    "#{save_location}/snapshot.gif"
  end

  def save_location
    '~/lolerrors'
  end

  def self.get_adapter
    return OSXAdapter.new if mac?
    return LinuxAdapter.new if linux?
    return Adapter.new
  end

  private

  def windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def unix?
    !OS.windows?
  end

  def linux?
    OS.unix? and not OS.mac?
  end
end