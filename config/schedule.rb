# 参考記事
# https://qiita.com/Esfahan/items/e7a924f7078faf3294f2

require "active_support/core_ext/time"
require File.expand_path(File.dirname(__FILE__) + "/environment")


rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env


# 時刻の文字列を日本時間で解釈して、UTCに変換
def jst(time)
  Time.zone = "Asia/Tokyo"
  Time.zone.parse(time).localtime("+00:00")
end


every 1.day, at: jst("1:00 am") do
  set :output, { error: "log/qiita_api_error.log", standard: "log/qiita_api_success.log" }
  runner "QiitaApi.execute"
end

every 5.day, at: jst("5:00 am") do
  set :output, { error: "log/calculate_ranking_error.log", standard: "log/calculate_ranking_success.log" }
  runner "CalculateRanking.execute"
end

every 15.day, at: jst("2:00 pm") do
  set :output, { error: "log/technical_book_search_api_error.log", standard: "log/technical_book_search_api_success.log" }
  runner "TechnicalBooksSearchApi.execute"
end
