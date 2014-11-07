module Lolerrors
  class Middleware
    def initialize(app)
      @app = app
      set_executable_permission
    end

    def call(env)
      @app.call env
    rescue => e
      capture e
    end

  private

    def set_executable_permission
      executables = %w(
        vendor/ext/videosnap
      )
      system "bash -c \"chmod +x  #{executables.join(' ')}\""
    end

    def capture(exception)
      message = exception.message.truncate(32)
      Thread.new do
        puts 'Taking animated gif'
        %x( mkdir -p #{save_location} )
        %x( rm -vf #{video_file_path} #{gif_file_path} )
        create_movie_file
        create_intermediate_gif_file
        make_caption message
        optimize_gif
        rename_gif
        %x( rm -vf #{video_file_path} )
        puts 'Took gif successfully'
      end
      raise exception
    end

    def create_movie_file
      %x( #{videosnap_path} -t 3.7 -s 240 --no-audio #{video_file_path} )
    end

    def create_intermediate_gif_file
      %x( ffmpeg -ss 0.7 -i #{video_file_path} -r 10 -f gif #{gif_file_path} )
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

    def rename_gif
      %x( mv #{gif_file_path} ~/lolerrors/snapshot_#{Time.now.to_i}.gif )
    end

    def optimize_gif
      %x( convert -layers Optimize #{gif_file_path} #{gif_file_path} )
    end

    def font_path
      '/Library/Fonts/Impact.ttf'
    end

    def videosnap_path
      File.join(Configuration::LOLERRORS_ROOT, 'vendor', 'ext', 'videosnap')
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
  end
end
