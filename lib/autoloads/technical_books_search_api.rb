require "uri"

class TechnicalBooksSearchApi
  # command bundle exec rails runner TechnicalBooksSearchApi.execute
  def self.execute
    start_index = 0
    max_results = 15
    keyword = "プログラミング"
    keyword = URI.encode_www_form_component(keyword)

    url = "https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=#{max_results}&startIndex=#{start_index}&printType=books&key=#{ENV["GCP_API_KEY"]}"
    TechnicalBooksSearchApi.update_book(url: url)

    # while(10) do
    #   url = "https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=#{max_results}&startIndex=#{start_index}&printType=books&key=#{ENV["GCP_API_KEY"]}"
    #   TechnicalBooksSearchApi.update_book(url: url)
    #   start_index += max_results
    # end
  end

  # https://medium.com/@akramhelil/google-books-api-with-rails-or-ruby-a931cece427a
  def self.update_book(url:)
    responce = HTTParty.get(url)
    results = responce.parsed_response["items"]

    results.each do |result|
      break if result.blank?

      result = result["volumeInfo"]

      title = result["title"]

      next if ReccomendedBook.pluck(:title).include?(title)

      isbn = (res = result["industryIdentifiers"]).nil? ? nil : res.select {|i| i.values.include?("ISBN_13") } [0]["identifier"].to_i

      book = ReccomendedBook.create!(amazon_affiliate: AmazonAffiliate.create,
                                     isbn: isbn,
                                     title: title)
      book.amazon_affiliate.update!(author: result["authors"],
                                    publication_data: result["publishedDate"],
                                    explanation: result["description"],
                                    thumbnail_url: result["imageLinks"]["thumbnail"],
                                    thumbnail_url_small: result["imageLinks"]["smallThumbnail"])
    end
  end

  def self.destroy_all
    ReccomendedBook.each(&:destroy!)
  end
end
