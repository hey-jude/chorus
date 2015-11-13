module FileHelper
  def test_file(name = "small1.gif", mime = "image/gif")
    file = File.expand_path("../../fixtures/#{name}", __FILE__)
    Rack::Test::UploadedFile.new(file, mime)
  end
end
