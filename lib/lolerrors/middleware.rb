module Lolerrors
  class Middleware
    def initialize(app)
      @app = app
      set_executable_permission
    end

    def call(env)
      @app.call env
    rescue => ex
      capture ex
    end

  private

    def videosnap_path
      'vendor/ext/videosnap'
    end

    def font_path
      '/Library/Fonts/Impact.ttf'
    end

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
        %x( mkdir -p ~/lolerrors )
        %x( rm -vf ~/lolerrors/snapshot.mov ~/lolerrors/snapshot.gif )
        create_movie_file
        create_intermediate_gif_file
        make_caption message
        optimize_gif
        rename_gif
        %x( rm -vf ~/lolerrors/snapshot.mov )
        puts 'Took gif successfully'
      end
      raise exception
    end

    def create_movie_file
      %x( #{videosnap_path} -t 3.7 -s 240 --no-audio ~/lolerrors/snapshot.mov )
    end

    def create_intermediate_gif_file
      %x( ffmpeg -ss 0.7 -i ~/lolerrors/snapshot.mov -r 10 -pix_fmt rgb24 -f gif ~/lolerrors/snapshot.gif )
    end

    def make_caption(message)
      %x( convert ~/lolerrors/snapshot.gif \
                  -coalesce \
                  -gravity South \
                  -font #{font_path} \
                  -fill white \
                  -stroke black \
                  -strokewidth 2 \
                  -pointsize 24 \
                  -annotate +0+10 "! #{message}" \
                  ~/lolerrors/snapshot.gif )
    end

    def rename_gif
      %x( mv ~/lolerrors/snapshot.gif ~/lolerrors/snapshot_#{Time.now.to_i}.gif )
    end

    def optimize_gif
      %x( convert -layers Optimize ~/lolerrors/snapshot.gif ~/lolerrors/snapshot.gif )
    end

  end
end
