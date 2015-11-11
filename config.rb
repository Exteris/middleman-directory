activate :relative_assets

def slugify(s)
  s.downcase.delete("'").gsub(/[^a-z0-9]+/, '-')
end

# Generate v4 endpoints
ignore '/api/result.json'
data.templates.select { |t| t.supports_v4 }.each do |t|
  proxy "/api/#{t.slug || slugify(t.name)}.json", '/api/result.json', locals: { t: t }
end

activate :ember

configure :build do
  set :ember_variant, :production

  activate :minify_css
  activate :minify_javascript

  require 'uglifier'

  # easier to deubg with linebreaks intact
  set(:js_compressor, ::Uglifier.new(output: {
                                       beautify: true,
                                       indent_level: 0
                                     }))
end
