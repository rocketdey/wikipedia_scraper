# a `Page` class — owns fetching a URL, running `TagScraper`, and building/saving the result hash
require 'httparty'
require 'nokogiri'
require 'json'

module WikipediaScraper
  class Page
    HEADERS = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0',
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.9',
      'Connection': 'keep-alive',
      'Upgrade-Insecure-Requests': '1',
      'Sec-Fetch-Dest': 'document',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-Site': 'none',
      'Sec-Fetch-User': '?1',
      'Priority': 'u=0, i',
      'TE': 'trailers',
    }.freeze

    attr_reader :url, :title, :short_description, :sections

    def self.fetch(url)
      response = HTTParty.get(url, headers: HEADERS)
      doc = Nokogiri::HTML(response)
      raise "Failed to parse #{url} as HTML" unless doc.html?

      new(doc)
    end

    def initialize(doc)
      @url = doc.at_css("link[rel='canonical']")&.attr('href')
      puts "Scraping #{url}"
      @title = TagScraper.to_markdown(doc.at_css("#firstHeading"))
      @short_description = doc.at_css(".shortdescription")&.text
      @sections = []

      doc.css(".mw-content-ltr > section").each do |section|
        section_scraper(section, @sections)
      end
    end

    def to_h
      { title: title, short_description: short_description, url: url, sections: sections }
    end

    def save_json(path)
      file_path = path[-1] == '/' ? "#{path}#{url.split('/').last}.json" : "#{path}/#{url.split('/').last}.json"
      File.open(file_path, 'w') do |f|
        f.write(JSON.pretty_generate(to_h) + "\n")
      end
    end

    private

    def section_scraper(section, parent_content)
      heading_elem = section.at_css("div.mw-heading")
      new_section = {
        id: section['data-mw-section-id'].to_i,
        heading: heading_elem && TagScraper.to_markdown(heading_elem.children[0]),
        content: []
      }
      parent_content << new_section

      section.children.each do |node|
        if node.name == 'section'
          section_scraper(node, new_section[:content])
          next
        end

        next unless !node.content.strip.empty? &&
        ['p', 'div', 'ol', 'ul', 'table'].include?(node.name) &&
        !node.classes.any? { |c| ['shortdescription', 'metadata', 'hatnote', 'sistersitebox', 'navbox', 'navbox-styles', 'mw-heading'].include?(c) }

        scraped_node = TagScraper.scrape(node)
        scraped_node = simplify_array(scraped_node)
        next if [nil, "", []].include?(scraped_node)
        new_section[:content] << scraped_node
      end
    end

    def simplify_array(obj)
      return obj unless obj.is_a?(Array)

      if obj.size == 1
        simplify_array(obj.first)
      else
        obj.map { |e| simplify_array(e) }
      end
    end
  end
end