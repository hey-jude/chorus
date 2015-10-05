ChorusWorkfile.class_eval do

  def svg_data=(svg_data)
    # Note: This conversion upon assignment depends on the "file_name"
    # being populated--and that file_name is being assigned from the same
    # hash (during build_for)
    # So 'file_name' has to precede 'svg_data' in the params hash
    # providing this.
    transcoder = SvgToPng.new(svg_data)
    versions.build :contents => transcoder.fake_uploaded_file(file_name)
  end
end
