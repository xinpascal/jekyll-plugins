# Jekyll Archive Page Generator for Posts
#
# This jekyll plugin generates archive pages for all posts. 
#
# Source: http://github.com/xinpascal/jekyll_archivepage_generator
# License: MIT
#
# 
# This generator will create a series of archive pages under the archives directory
# for each month.
#     _site/archives/YYYY-MM/index.html
# These archive pages are using the archive.html layout.
#
# This example shows how to list these archive pages.
#
#     <ul>
#     {% assign months = '' %}
#     {% for post in site.posts %}
#       {% capture month %}{{ post.date | date: "%Y-%m" }}{% endcapture %}
#       {% unless months contains month %}
#         {% capture months %}{{ months }} {{ month }}{% endcapture %}
#         <li><a href="/archives/{{ month }}">{{ month }}</a></li>
#       {% endunless %}
#     {% endfor %}
#     </ul>
#
# Author: Xin Ouyang
# Site: http://xinpascal.github.io/ 
#
module Jekyll

  class ArchivePage < Page
    def initialize(site, base, dir, month, posts)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'archive.html')
      self.data = {
        'layout' => 'default',
        'type' => 'archive',
        'title' => "#{month}",
        'posts' => posts
      }
    end
  end

  class ArchiveGenerator < Generator
    safe true
 
    def generate(site)
      if site.layouts.key? 'archive'
        dir = site.config['archive_dir'] || 'archives'
        collate_by_month(site.posts).each do |month, posts|
          page = ArchivePage.new(site, site.source, File.join(dir, month), month, posts)
          site.pages << page
        end
      end
    end
 
    private
 
    def collate_by_month(posts)
      collated = {}
      posts.each do |post|
        #key = "#{post.date.year}-#{post.date.month}"
        key = sprintf("%04d-%02d", post.date.year, post.date.month)
        if collated.has_key? key
          collated[key] << post
        else
          collated[key] = [post]
        end
      end
      collated
    end
  end
end
