class ImageDownloadsController < ApplicationController

  # TODO Curran / Mike Souza: figure out how to pass the Chiasm generated SVG in here
  def download_chart
    transcoder = SvgToPng.new(params[:svg])
    send_data transcoder.binary_data, :type => 'image/png', :filename => "#{params["chart-name"]}-#{params["chart-type"]}.png"
  rescue SvgToPng::InvalidSvgData
    head 400
  end
end