require VisChiasm::Engine.root + 'vendor/batik-all-1.7.jar'
require VisChiasm::Engine.root + 'vendor/xml-apis-ext-1.3.04.jar'

class SvgToPng
  InvalidSvgData = Class.new(StandardError)

  attr_reader :binary_data

  def initialize(svg_content)
    transcoder_class = org.apache.batik.transcoder.image.PNGTranscoder

    svg_content.gsub!(/&([^#])/, "&#038;#{$1}") if svg_content
    input = org.apache.batik.transcoder.TranscoderInput.new(org.jruby.util.IOInputStream.new(StringIO.new(svg_content)))

    ostream = java.io.ByteArrayOutputStream.new
    output = org.apache.batik.transcoder.TranscoderOutput.new(ostream)

    transcoder = transcoder_class.new
    transcoder.addTranscodingHint(transcoder_class::KEY_BACKGROUND_COLOR, java.awt.Color::WHITE)
    transcoder.addTranscodingHint(transcoder_class::KEY_USER_STYLESHEET_URI, "file://" + VisChiasm::Engine.root.join("public/svg_to_png_visualizations.css").to_s)
    transcoder.transcode(input, output)
    @binary_data = String.from_java_bytes(ostream.to_byte_array)
  rescue TypeError, org.apache.batik.transcoder.TranscoderException => e
    raise InvalidSvgData
  end

  def fake_uploaded_file(desired_file_name)
    file = FakeFileUpload.new(binary_data)
    file.content_type = 'image/png'
    file.original_filename = desired_file_name.present? ? desired_file_name : "my-visualization.png"
    file
  end
end