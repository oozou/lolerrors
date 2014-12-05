module Lolerrors
  class LinuxAdapter < Lolerrors::Adapter
    def capture(message)
      Thread.new do
        puts 'Taking animated gif'
        %x( mkdir -p #{save_location} )
        %x( rm -vf #{video_file_path} #{gif_file_path} )
        create_gif_file
        make_caption message
        rename_gif
        puts 'Took gif successfully'
      end
    end

    private

    def create_gif_file
      %x( ffmpeg -f v4l2 \
                 -i /dev/video0 \
                 -s 320x240 \
                 -r 10 \
                 -ss 0.7 \
                 -to 3.7 \
                 #{gif_file_path} )
    end

    def make_caption(message)
      %x( convert #{gif_file_path} \
                  -gravity South \
                  -fill white \
                  -stroke black \
                  -strokewidth 1 \
                  -pointsize 18 \
                  -annotate +0+10 "! #{message}" \
                  #{gif_file_path} )
    end
  end
end
