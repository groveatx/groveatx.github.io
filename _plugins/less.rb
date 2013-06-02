module Jekyll

  class LessCssFile < StaticFile
    def write(dest)
      # do nothing
    end
  end

  class LessJsGenerator < Generator
    safe true
    priority :low

    def generate(site)
      src_root = site.config['source']
      less_ext = /\.less$/i
      lessc_bin = site.config['lessc'] || 'lessc'

      sf = StaticFile.new(site, src_root, '_less', 'style.less')

      css_path = sf.path
                  .gsub(less_ext, '.css')
                  .gsub(src_root + '/', '')
                  .gsub('_less', 'css')
      file_name = File.basename(css_path)

      FileUtils.mkdir_p(File.dirname(css_path))

      begin
        command = [lessc_bin, sf.path, css_path].join(' ')
        puts 'Compiling LESS: ' + command
        puts `#{command}`
        raise "LESS compilation error" if $?.to_i != 0
      end
    end
  end
end

