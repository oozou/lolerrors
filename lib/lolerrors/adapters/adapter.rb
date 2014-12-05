module Lolerrors
  class Adapter
    def capture(message)
      raise NotImplementedError("Must use concrete subclass for capture")
    end

    def set_executable_permission
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
      return ::Lolerrors::OSXAdapter.new if OS.mac?
      return ::Lolerrors::LinuxAdapter.new if OS.linux?
      return ::Lolerrors::Adapter.new
    end
  end
end