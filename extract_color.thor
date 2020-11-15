require 'thor'
require './rmagick_extract_color'

class ExtractColor < Thor
  namespace :color

  desc "extract_from_image", "show top color histogram from image"
  def extract_from_image(path_to_image)
    obj = RmagickExtractColor.new(path_to_image)
    obj.display
    obj.summarized_hist_display
  end

  desc "extract_from_directory", "show top color histogram of all image at target directory"
  def extract_from_directory(path)
    @path = path
    file_name = File.basename(path)
    name, ext = /\A(.+?)((?:\.[^.]+)?)\z/.match(file_name, &:captures)
    if ext =='.zip'
      `rm -rf ./temp` if Dir.exist?('temp')
      `unzip -d temp #{name}`
      @path = "./temp/#{Dir.children("temp").first}"
    end

    Dir::foreach(@path) do |path_to_image|
      next unless %w(.jpeg .jpg .png).include?(File.extname(path_to_image))

      obj = RmagickExtractColor.new(path_to_image)
      obj.display
      obj.summarized_hist_display
    end

    if ext =='.zip'
      `rm -rf ./temp`
    end
  end
end
