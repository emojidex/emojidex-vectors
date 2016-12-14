require 'json'
require 'phantom/svg'

class VariantGenerator
  attr_reader :source, :outdir, :status, :variants, :animation
  def initialize(source_path, outdir = "", enable_hacks = true, show_debug_output = true)
    @source = source_path
    @outdir = "generated/"
    @debug = show_debug_output
    @hacks = enable_hacks # currently: forces overlays on frames to prevent the final frame culling bug in FireFox
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
    out_path = variant[:dest] || @outdir
    if @animation.nil?
      if file.exist?("#{@source}/background.svg")
        image = Phantom::SVG::Base.new("#{@source}/background.svg")
        image.combine("#{@source}/#{variant[:base]}.svg")
      else
        image = Phantom::SVG::Base.new("#{@source}/#{variant[:base]}.svg")
      end
      image.combine("#{@source}/overlay.svg") if file.exist?("#{@source}/overlay.svg")
      image.save_svg("#{@source}/#{out_path}/#{variant[:code]}.svg")
    else
      dest = "#{@source}/#{out_path}/#{variant[:code]}"
      Dir.mkdir(dest) unless Dir.exist?(dest)
      @frame_num = 0
      @animation[:frames].each do |frame|
        if file.exist?("#{@source}/background.svg")
          image = Phantom::SVG::Base.new("#{@source}/background.svg")
          image.combine("#{@source}/#{variant[:base]}.svg")
        else
          image = Phantom::SVG::Base.new("#{@source}/#{variant[:base]}.svg")
        end
        image.combine("#{@source}/#{frame.keys.first}.svg")
        image.combine("#{@source}/overlay.svg") if file.exist?("#{@source}/overlay.svg")
        apply_hacks(image) if @hacks
        @frame_num += 1
        image.save_svg("#{dest}/#{frame.keys.first}.svg")
      end
      json_data = @animation.dup
      json_data[:name] = variant[:code]
      File.open("#{dest}/animation.json", "w") do |f|
        f.write(json_data.to_json)
      end
    end
  end

  def apply_hacks(image)
    _anti_cull_hack(image)
  end

  def _anti_cull_hack(image)
    image.combine("#{source}/../../components/overlays/#{@frame_num % 2}alpha.svg")
  end
end
