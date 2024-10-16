require 'rails_helper'

RSpec.describe 'Archives' do
  describe 'Results page' do
    before do
      create(:page, :published, created_at: '2022-08-10')
    end

    it 'renders archives search results' do

      p "🤡"
      p "Starting test at #{Time.now}"
      p "Before test: #{Page.count} pages"

      current_session.visit root_path
      p "Visited root path at #{Time.now}"

      expect(current_session).to have_current_path(root_path)
      p "Verified current path at #{Time.now}"

      current_session.click_on 'August 2022'
      p "Clicked August 2022 at #{Time.now}"

      retries = 0
      max_retries = 3

      begin

        articles = current_session.find_all('article', wait: 10)
        p "Found #{articles.count} articles at #{Time.now}"

        expect(articles.count).to eq(1)

        current_session.within articles.first do
          expect(current_session).to have_css('h2', text: Page.first.title, wait: 10)
        end
        p "Verified article content at #{Time.now}"
        p "After test: #{Page.count} pages"
        p "🤡"

      rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
        p "Encount StaleElementReferenceError, retrying... (Attempt #{retries + 1})"
        retries += 1
        if retries < max_retries
          current_session.refresh
          sleep 2
          retry
        else
          raise e
        end
      end

      p "Test completed at #{Time.now}"
    end
  end
end

# retries = 0
# begin
#   expect(page).to have_css('h2', text: Page.first.title, wait: 5)
# rescue Selenium::WebDriver::Error::StaleElementReferenceError
#   retries += 1
#   retry if retries < 3
#   raise
# end
