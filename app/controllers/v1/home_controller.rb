class V1::HomeController < ApplicationController
  def index
    # Redis からランキング上位から順に記事を取得する
    ids_and_points = ReccomendedBook.pluck(:id, :total_ranking).sort_by {|_k, v| v }.reverse
    books = ids_and_points.map{ |k, _v| ReccomendedBook.find(k) }
  end
end
