module SystemHelpers
  def current_session
    Capybara.current_session
  end
end

RSpec.configure do |config|
  config.include SystemHelpers, type: :system
end
