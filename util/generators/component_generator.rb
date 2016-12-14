require 'json'
require 'phantom/svg'

class ComponentGenerator
  attr_reader :source, :outdir, :bases, :bom, :number_generated, :status

  def initialize(source_path, outdir = "", show_debug_output = true)
    @status = "Initializing"
    @source = source_path
    @outdir = "#{source_path}/generated/"
    @debug = show_debug_output
    Dir.mkdir(@outdir) unless Dir.exist?(@outdir)
    if File.exist?("#{source_path}/bom.json")
      @bom = JSON.parse(File.read("#{source_path}/bom.json"), {:symbolize_names => true})
      _status "BOM loaded."

      generate_components
    else
      _status "No BOM found at [#{source_path}]."
    end
  end

  def generate_components
    _status "Generating..."
    @bom.each do |component|
      _status "Generating component [#{component[:name]}]."
      component[:materials].each do |material|
        if File.directory?("#{@source}/#{material}")
          _status "Processing material in #{@source}/#{material}"
          if File.exist?("#{@source}/#{material}/animation.json")
            _status "Generating animation for material in #{@source}/#{material}"
            anim_gen = Phantom::SVG::Base.new("#{@source}/#{material}/animation.json")
            anim_gen.save_svg("#{@source}/#{material}.svg")
          end
        end 
      end
    end
  end

  def _status(new_status)
    @status = new_status
    puts @status if @debug
  end
end
