class TechnicalBooksSearchApi
  # キーワードを検索し isbn を取得する
  # isbn から 書籍名 などを取得しデータベースに登録する

  def self.execute
    # keyword = "rails"
  end

  # https://medium.com/@akramhelil/google-books-api-with-rails-or-ruby-a931cece427a
  def self.update_reccomended_book(keyword:)
    url = "https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=1&key=#{ENV["GCP_API_KEY"]}"

    response = HTTParty.get(url)
    results = response.parsed_response["items"]

    results.each do |result|
      # binding.pry
      isbn = result["volumeInfo"]["industryIdentifiers"][0]["identifier"].to_i
      title = result["volumeInfo"]["title"]

      # if ReccomendedBook.pluck(:isbn).find(isbn).nil?
      ReccomendedBook.create!(title: title, isbn: isbn)
    end
  end
end
