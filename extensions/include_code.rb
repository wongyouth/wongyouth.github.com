require 'pathname'

class IncludeCode < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    super

    app.set :code_dir, 'downloads/code'
  end

  helpers do
    def include_code(filename, title: nil, lang: nil)
      code_path = Pathname.new( __FILE__ + "../../../source/#{code_dir}/").expand_path
      file = code_path + filename
      filetype = lang

      if File.symlink?(code_path)
        return "Code directory '#{code_path}' cannot be a symlink"
      end

      unless file.file?
        return "File #{file} could not be found"
      end

      Dir.chdir(code_path) do
        code = file.read
        filetype = file.extname.sub('.','') if filetype.nil?
        title = title ? "#{title} (#{file.basename})" : file.basename
        url = "/#{code_dir}/#{filename}"
        source = "<figure class='code'><figcaption><span>#{title}</span> <a href='#{url}'>源码</a></figcaption>"
        source += "\n\n``` #{filetype}\n"
        source += code
        source += "\n```\n"
        source += "</firgure>"
      end
    end
  end
end

::Middleman::Extensions.register(:include_code, IncludeCode)
