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
      dest_root = site.config['destination']
      less_ext = /\.less$/i
      lessc_bin = site.config['lessc'] || 'lessc'

      sf = StaticFile.new(site, src_root, '_less', 'style.less')
      site.static_files.delete(sf)

      less_path = sf.path
      css_path = less_path
                  .gsub(less_ext, '.css')
                  .gsub(src_root, dest_root)
                  .gsub('_less', 'css')
      relative_dir = File.dirname(css_path).gsub(dest_root, '')
      file_name = File.basename(css_path)

      FileUtils.mkdir_p(File.dirname(css_path))

      begin
        command = [lessc_bin,
                   less_path,
                   css_path
                   ].join(' ')
        puts 'Compiling LESS: ' + command
        puts `#{command}`
        raise "LESS compilation error" if $?.to_i != 0
      end

      # Add this output file so it won't be "cleaned away"
      site.static_files << LessCssFile.new(
        site, site.source, relative_dir, file_name)
    end
  end
end

