require_relative "lib/wikipedia_scraper/version"

Gem::Specification.new do |spec|
  spec.name        = "wikipedia_scraper"
  spec.version      = WikipediaScraper::VERSION
  spec.authors      = ["Kürşat Aydın"]
  spec.email        = ["kursataydin165@gmail.com"]

  spec.summary      = "Scrapes Wikipedia articles into structured markdown/JSON."
  spec.description  = "Fetches a Wikipedia page and converts its HTML into a " \
                       "structured hash of sections, tables, and markdown text."
  spec.homepage     = "https://github.com/rocketdey/wikipedia_scraper"
  spec.license      = "MIT"

  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/blob/main/CHANGELOG.md"

  
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:test|spec|features)/})
    end
  end

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.21"
  spec.add_dependency "nokogiri", "~> 1.15"

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rake", "~> 13.0"
end
