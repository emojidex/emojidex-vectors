require 'json'
require 'phantom/svg'

class VariantGenerator
  attr_reader :source, :outdir, :status, :variants, :animation
  def initialize(source_path, outdir = "", show_debug_output = true)
    @source = source_path
    @outdir = "#{source_path}/generated/"
    @debug = show_debug_output
    Dir.mkdir(@outdir) unless Dir.exist?(@outdir)
    if (File.exist?("#{source_path}/variants.json"))
      @variants = JSON.parse(File.read("#{source_path}/variants.json"), {:symbolize_names => true})
      @animation = nil
      if (File.exist?("#{source_path}/animation.json"))
        @animation = JSON.parse(
          File.read("#{source_path}/animation.json"), {:symbolize_names => true})
      end

      generate_variants()
    else
      @status = 'No variant info found. Variants not generated.'
      puts @status if @debug
    end
  end

  private

  def generate_variants()
    @variants.each do |variant|
      @status = "Generating #{variant[:code]} ..."
      puts @status if @debug

      generate(variant)
    end
    @status = "Variant generation completed."
  end

  def generate(variant)
    if @animation.nil?
      image = Phantom::SVG::Base.new("#{@source}/#{variant[:base]}.svg")
      image.combine("#{@source}/overlay.svg")
      image.save_svg("#{@outdir}/#{variant[:code]}.svg")
    else
      dest = "#{@outdir}/#{variant[:code]}"
      Dir.mkdir(dest) unless Dir.exist?(dest)
      @animation[:frames].each do |frame|
        image = Phantom::SVG::Base.new("#{@source}/#{variant[:base]}.svg")
        image.combine("#{@source}/#{frame.keys.first}.svg")
        image.save_svg("#{dest}/#{frame.keys.first}.svg")
      end
      json_data = @animation.dup
      json_data[:code] = variant[:code]
      File.open("#{dest}/animation.json", "w") do |f|
        f.write(json_data.to_json)
      end
    end
  end
end
