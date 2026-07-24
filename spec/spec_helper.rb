# RSpec boilerplate/config — loaded by every spec file, sets up `require 'wikipedia_scraper'` oncerequire 'wikipedia_scraper'
require 'json'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
end

# Reads a fixture file (HTML or JSON) as raw text.
def fixture(name)
  File.read(File.join(__dir__, 'fixtures', name))
end

# Parses a fixture JSON file, with symbol keys (matches your code's :label, :content, etc.)
def fixture_json(name)
  JSON.parse(fixture(name), symbolize_names: true)
end

# Builds a Nokogiri element from a small HTML snippet, for unit tests.
# Pass a CSS selector to grab a specific element out of the fragment.
def element_from(html, selector = nil)
  fragment = Nokogiri::HTML.fragment(html)
  selector ? fragment.at_css(selector) : fragment.children.find(&:element?)
end