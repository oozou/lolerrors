module Lolerrors
  class OSXAdapter < Lolerrors::Adapter
    def capture(message)
      Thread.new do
        puts 'Taking animated gif'
        %x( mkdir -p #{save_location} )
        %x( rm -vf #{video_file_path} #{gif_file_path} )
        create_gif_file
        make_caption message
        optimize_gif
        rename_gif
        %x( rm -vf #{video_file_path} )
        puts 'Took gif successfully'
      end
    end

    def create_gif_file
      %x( ffmpeg -f avfoundation \
                 -i "" \
                 -s 320x240 \
                 -r 10 \
                 -ss 0.7 \
                 -to 3.7 \
                 #{gif_file_path} )
    end

    def make_caption(message)
      %x( convert #{gif_file_path} \
                  -coalesce \
                  -gravity South \
                  -font #{font_path} \
                  -fill white \
                  -stroke black \
                  -strokewidth 2 \
                  -pointsize 24 \
                  -annotate +0+10 "! #{message}" \
                  #{gif_file_path} )
    end


    def optimize_gif
      %x( convert -layers Optimize #{gif_file_path} #{gif_file_path} )
    end

    private

    def font_path
      '/Library/Fonts/Impact.ttf'
    end
  end
end
