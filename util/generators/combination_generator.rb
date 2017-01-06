require 'json'
require 'fileutils'
require 'phantom/svg'

# Generates all combinations for the base emoji of a ZWJ combinable emoji
class CombinationGenerator
  attr_reader :source, :outdir, :bases, :components, :number_generated, :status

  def initialize(source_path, outdir = nil, copy_src = true, show_debug_output = true)
    @source = source_path
    if outdir == nil || outdir == ""
      @outdir = "#{source_path}/generated/"
    else
      @outdir = outdir
    end
    @debug = show_debug_output
    Dir.mkdir(@outdir) unless Dir.exist?(@outdir)
    if (File.exist?("#{source_path}/components.json") && File.exist?("#{source_path}/bases.json"))
      @components = JSON.parse(File.read("#{source_path}/components.json"), {:symbolize_names => true})
      @bases = JSON.parse(File.read("#{source_path}/bases.json"), {:symbolize_names => true})

      generate_bases()
      copy_components() if copy_src
    else
      @status = 'No base info found. Bases not generated.'
      puts @status if @debug
    end
  end

  private
  def generate_bases()
    puts "⚙ Generating base images..." if @debug
    @number_generated = 0
    @status = "Generating..."
    @bases.each do |base|
      puts "⚙⚙ Generating bases for #{base[:code]}..." if @debug
      generate(base)
    end
    @status = "Base generation completed."
  end

  def get_component_set(base)
    @components.each do |component_set|
      return component_set if base[:combination_base] == component_set[:code]
    end
    
    puts "Component set net found in Components" if @debug
    @components.first # This shouldn't happen?
  end

  def get_components_in_order(base, component_set)
    return base[:components] if (!(component_set.has_key? :component_layer_order) ||
                                 component_set[:component_layer_order].nil? ||
                                 component_set[:component_layer_order].length == 0)
    component_set[:component_layer_order].map { |order| base[:combination][order] }
  end

  def generate(base)
    component_set = get_component_set(base)
    order = get_components_in_order(base, component_set)

    image = nil

    for i in 0..order.length - 1 do
      if image == nil
        image = Phantom::SVG::Base.new("#{@source}/#{i}/#{order[i]}.svg")
      else
        if order[i] != ""
          image.combine("#{@source}/#{i}/#{order[i]}.svg")
        end
      end
    end

    out_path = "#{@outdir}/#{base[:code]}.svg"
    puts base
    if base.include?(:moji) && (base[:moji] != "")
      puts "HAS KEY"
      out_path = "#{@source}/../../../emoji/utf/#{base[:code]}.svg"
    else
      puts "NO KEY"
      out_path = "#{@source}/../../../emoji/extended/#{base[:code]}.svg"
    end

    puts "Saving #{out_path}..." if @debug
    image.save_svg(out_path)
  end

  def copy_components
    FileUtils.cp_r(@source, File.expand_path("#{@source}/../../../emoji/utf/#{@source.match(/[^\/]+(?=\/$|$)/)}"), {remove_destination: true})
  end
end
