require 'wikipedia_scraper'

RSpec.describe WikipediaScraper::Page do
  %w[Chechen_language Dzhokhar_Dudayev The_Off-Season].each do |html_name|
    context "scraping #{html_name}" do
      let(:doc) {Nokogiri::HTML(fixture("#{html_name}.html"))}
      let(:scraped_html) {described_class.new(doc)}
      let(:expected_output) {fixture_json("#{html_name}.json")}

      it 'gets the correct title from html' do
        expect(scraped_html.title).to eq(expected_output[:title])
      end

      it 'gets the expected short description from html' do
        expect(scraped_html.short_description).to eq(expected_output[:short_description])
      end

      it 'gets the expected url from html' do
        expect(scraped_html.url).to eq(expected_output[:url])
      end

      it 'gets the correct data' do
        expect(scraped_html.to_h).to eq(expected_output)
      end
    end
  end
end
