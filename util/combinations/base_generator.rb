require 'json'
require 'phantom/svg'

# Generates all combinations for the base emoji of a ZWJ combinable emoji
class ComboEmojiBaseGenerator
  attr_readable :source, :outdir, :bases, :components, :number_generated, :status

  def initialize(source_path, outdir = "", show_debug_output = true)
    @source = source_path
    @outdir = "#{source_path}/generated/"
    @debug = show_debug_output
    Dir.mkdir(@outdir) unless Dir.exist?(@outdir)
    @components = JSON.parse(File.read('components.json'), {:symbolize_names => true})
    @bases = JSON.parse(File.read('components.json'), {:symbolize_names => true})

    generate_bases()
  end

  private
  def generate_bases()
    print "⚙ Generating base images..." if @debug
    @number_generated = 0
    @status = "generating"
    @bases.each do |base|
      print "⚙⚙ Generating bases for #{base.code}..." if @debug
    end
    #components = @emoji[:components].dup
    #generate([], components.shift, components)
    @status = "completed"
  end

  def generate(super_components, component, sub_components)
    generators = []
    component.each do |part|
      until @num_renderers < @max_renderers
        sleep(1)
      end
      th = Thread.new do
        render(super_components.dup.push(part))
        if sub_components.length != 0
          sub_sub = sub_components.dup
          generate(super_components.dup.push(part), sub_sub.shift, sub_sub)
        end
      end
      generators.push th
    end
    generators.each {|t| t.join}
  end

  def render(parts)
    return if parts.length == 0 || parts[0] == ""
    @num_renderers += 1

    filename = "#{@emoji[:code]}("
    base = nil

    for i in 0..parts.length - 1 do
      if parts[i] == "" 
        filename = "#{filename}()" if i != (parts.length - 1)
      else
        if base == nil
          base = Phantom::SVG::Base.new("./#{i}/#{parts[i]}.svg")
        else
          base.combine("./#{i}/#{parts[i]}.svg")
        end
        filename = "#{filename}(#{parts[i]})"
      end
    end

    base.save_svg("./generated/#{filename}).svg") unless base == nil
    @count += 1
    @last_rendered = "#{@emoji[:code]} #{parts}"
    @num_renderers -= 1
  end

  def _get_total()
    @total = 1
    @emoji[:components].each { |c| @total = @total * c.length }
  end

  def _status_output()
    while @running
      print "\r"
      $stdout.flush
      print "Rendered #{@last_rendered} (#{@count}/#{@total}) Renderers: #{@num_renderers}/#{@max_renderers}"
      sleep(1)
    end
  end

end


CustomEmojiGenerator.new
