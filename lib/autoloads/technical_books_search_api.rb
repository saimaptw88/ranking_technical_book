require "uri"

# url = "https://www.googleapis.com/books/v1/volumes?q=rails&maxResults=1&startIndex=1&printType=books&key=#{ENV["GCP_API_KEY"]}"
class TechnicalBooksSearchApi
  # command bundle exec rails runner TechnicalBooksSearchApi.execute
  def self.execute
    max_results = 40
    keywords = ["プログラミング", "Ruby", "Javascript", "Python", "HTML", "CSS", "PHP", "Swift", "java", "C", "C++", "C#", "AWS", "GCP"]

    keywords.each do |keyword|
      start_index = 0
      keyword = URI.encode_www_form_component(keyword)

      1000.times do
        url = "https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=#{max_results}&startIndex=#{start_index}&printType=books&key=#{ENV["GCP_API_KEY"]}"
        break if TechnicalBooksSearchApi.update_book(url: url).nil?

        start_index += max_results
      end
    end
  end

  # command bundle exec rails runner TechnicalBooksSearchApi.destroy_all
  def self.destroy_all
    ReccomendedBook.each(&:destroy!)
  end

  # -----------------------------------------------------------
  #
  #                     private methods
  #
  # -----------------------------------------------------------


  def self.update_book(url:)
    responce = HTTParty.get(url)

    return nil if (results = responce.parsed_response["items"]).blank?

    results.each do |result|
      break unless result.present? && (result = result["volumeInfo"]).present?

      TechnicalBooksSearchApi.title_present?(result: result) ? title = result["title"] : next

      next if TechnicalBooksSearchApi.title_registered?(title: title)

      TechnicalBooksSearchApi.isbn_present?(result: result) ? isbn = TechnicalBooksSearchApi.isbn13(result: result) : next
      image = TechnicalBooksSearchApi.thumbnail_image_url(result: result)

      book = ReccomendedBook.create!(amazon_affiliate: AmazonAffiliate.create,
                                     isbn: isbn,
                                     title: title)
      book.amazon_affiliate.update!(author: result["authors"],
                                    publication_data: result["publishedDate"],
                                    explanation: result["description"],
                                    thumbnail_url: image)
    end
  end

  def self.title_present?(result:)
    result["title"].present? && result["title"].length >= 6
  end

  def self.thumbnail_image_url(result:)
    image = result["imageLinks"]
    image.present? ? image["thumbnail"] || image["smallThumbnail"] : nil
  end

  def self.title_registered?(title:)
    ReccomendedBook.pluck(:title).include?(title)
  end

  def self.isbn_present?(result:)
    result["industryIdentifiers"].present? && TechnicalBooksSearchApi.isbn13(result: result).present?
  end

  def self.isbn13(result:)
    result["industryIdentifiers"].select {|i| i.values.include?("ISBN_13") }
  end
end
