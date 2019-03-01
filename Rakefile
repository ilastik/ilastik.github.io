multitask default: %w[gallery_thumbs counting_figs]

desc 'Generate thumbnails for the gallery'
task :gallery_thumbs do |t|
  sh 'mogrify -path gallery/thumb -thumbnail 300x300 -format jpg -quality 70 gallery/full/*.{png,jpg}'
end

desc 'Generate figures for the counting workflow page'
task :counting_figs do |t|
  sh 'mogrify -format jpg documentation/counting/fig/*.png'
end
