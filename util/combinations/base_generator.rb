require 'json'
require 'phantom/svg'

class ComboEmojiGenerator
  def initialize(source_path, outdir, max_renderers = 4, show_debug_output = true)
    @outdir = "./generated"
    Dir.mkdir(@outdir) unless Dir.exist?(@outdir)
    @emoji = JSON.parse(File.read('components.json'), {:symbolize_names => true})
    @count = 0
    @num_renderers = 0
    @max_renderers = max_renderers

    generate_all()
  end

  def generate_all()
    @running = true
    @last_renderd = "⚙"
    Thread.start { _status_output() }
    _get_total()
    print "Generating #{@total} images..."
    components = @emoji[:components].dup
    generate([], components.shift, components)
    @running = false
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
