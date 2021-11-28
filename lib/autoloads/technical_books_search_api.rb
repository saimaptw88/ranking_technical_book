require "uri"

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
        TechnicalBooksSearchApi.update_book(url: url)
        start_index += max_results
      end
    end
  end

  # https://medium.com/@akramhelil/google-books-api-with-rails-or-ruby-a931cece427a
  def self.update_book(url:)
    # responce = HTTParty.get(url)
    # results = responce.parsed_response["items"]

    # return if results.blank?

    # results.each do |result|
    #   next if result.blank?

    #   result = result["volumeInfo"]

    #   next if result.blank?

    #   title = result["title"]

    #   next if ReccomendedBook.pluck(:title).include?(title)

    #   isbn = if !(res = result["industryIdentifiers"]).nil? && res.select {|i| i.values.include?("ISBN_13") }.present?
    #            res.select {|i|
    #              i.values.include?("ISBN_13")
    #            } [0]["identifier"].to_i
    #          else
    #            nil
    #          end
    #   image = TechnicalBooksSearchApi.image_params(params: result)

    #   book = ReccomendedBook.create!(amazon_affiliate: AmazonAffiliate.create,
    #                                  isbn: isbn,
    #                                  title: title)
    #   book.amazon_affiliate.update!(author: result["authors"],
    #                                 publication_data: result["publishedDate"],
    #                                 explanation: result["description"],
    #                                 thumbnail_url: image)
    # end
  end

  def self.image_params(params:)
    image = params["imageLinks"]

    if image.present?
      image["thumbnail"].presence || image["smallThumbnail"]
    else
      nil
    end
  end

  def self.destroy_all
    ReccomendedBook.each(&:destroy!)
  end
end
