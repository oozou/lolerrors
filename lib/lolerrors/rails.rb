module Lolerrors
  class Railtie < Rails::Railtie
    initializer "lolerrors.configure_rails_initialization" do |app|
      if defined? ActionDispatch::DebugExceptions
        app.middleware.insert_after ActionDispatch::DebugExceptions, "Lolerrors::Middleware"
      else
        app.middleware.use "Lolerrors::Middleware"
      end
    end
  end
end
