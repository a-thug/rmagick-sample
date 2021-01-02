# frozen_string_literal: true

require 'rmagick'

class RmagickExtractColor
  # この百分率未満は非表示
  RATE_MIN = 0.05

  attr :hist, :summarized_hist

  def initialize(image_to_path)
    # アニメーション GIF が考慮されて画像は配列で読み込まれるので、
    # 配列の先頭画像を取得する。
    @img = Magick::Image.read(image_to_path).first

    # ピクセル数
    @px_x = @img.columns       # 横
    @px_y = @img.rows          # 縦
    @px_total = @px_x * @px_y  # トータル
  end

  # カラーヒストグラムを取得
  def hist # rubocop:disable Lint/DuplicateMethods
    @hist ||= begin
      # 画像の Depth を取得
      img_depth = @img.depth

      # カラーヒストグラムを取得してハッシュで集計
      histogram = @img.color_histogram.each_with_object({}) do |key_val, hash|
        # 各ピクセルの色を16進で取得
        color = key_val[0].to_color(Magick::AllCompliance, false, img_depth, true)
        # Hash に格納
        hash[color] ||= 0
        hash[color] += key_val[1]
      end

      # ヒストグラムのハッシュを値の大きい順にソート
      histogram.sort { |a, b| b[1] <=> a[1] }
    end
  rescue StandardError => e
    warn "[ERROR][#{self.class.name}.compile] #{e}"
    exit 1
  end

  # 取得したカラーヒストグラムをサマる(#XAYBZC → #XYZのようにする)
  def summarized_hist
    @summarized_hist ||= begin
      summarized_histgram = hist.each_with_object({}) do |key_val, hash|
        color = key_val[0][1] + key_val[0][3] + key_val[0][5]

        hash[color] ||= 0
        hash[color] += key_val[1]
      end

      # ヒストグラムのハッシュを値の大きい順にソート
      summarized_histgram.sort { |a, b| b[1] <=> a[1] }
    end
  end

  # 結果表示
  def display
    hist.each do |color, count|
      rate = (count / @px_total.to_f) * 100
      break if rate < RATE_MIN

      puts "#{color} => #{count} px ( #{format('%2.4f', rate)} % )"
    end
    puts
    puts "Image Size: #{@px_x} px * #{@px_y} px"
    puts "TOTAL     : #{@px_total} px, #{@hist.size} colors"
  rescue StandardError => e
    warn "[ERROR][#{self.class.name}.display] #{e}"
    exit 1
  end

  # サマライズしたヒストグラムの結果表示
  def summarized_hist_display
    summarized_hist.each do |color, count|
      rate = (count / @px_total.to_f) * 100
      break if rate < RATE_MIN

      puts "#{color} => #{count} px ( #{format('%2.4f', rate)} % )"
    end
    puts
    puts "Image Size: #{@px_x} px * #{@px_y} px"
    puts "TOTAL     : #{@px_total} px, #{@hist.size} colors"
  rescue StandardError => e
    warn "[ERROR][#{self.class.name}.display] #{e}"
    exit 1
  end
end
