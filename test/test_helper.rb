ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
require 'capybara/rails'
require 'capybara/minitest'
require 'selenium/webdriver'

Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
  # Add more helper methods to be used by all tests here...
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :headless_chrome do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w[headless disable-gpu window-size=1920,1080] }
    )

    Capybara::Selenium::Driver.new app,
                                   browser: :chrome,
                                   desired_capabilities: capabilities
  end

  Capybara.javascript_driver = :headless_chrome
  Capybara.current_driver = Capybara.javascript_driver # :selenium by default
  Capybara.default_driver = :headless_chrome
end

def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until page.evaluate_script('window.XMLHttpRequest.DONE').eql?(4)
  end
end
