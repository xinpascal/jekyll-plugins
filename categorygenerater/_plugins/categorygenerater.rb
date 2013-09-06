# Jekyll Category Page Generator for Posts
#
# This jekyll plugin generates category pages for all posts.
#
# Source: http://github.com/xinpascal/jekyll_categorypage_generator
# License: MIT
#
#
# This generator will create a series of category pages under the archives directory
# for each category.
#     _site/categories/category_name/index.html
# These category pages are using the category.html layout.
#
# This example shows how to list these category pages.
#
#     <ul>
#     {% for category in site.categories %}
#        <li><a href="/categories/{{ category | first }}">{{ category | first }}</a></li>
#     {% endfor %}
#     </ul>
#
# Author: Xin Ouyang
# Site: http://xinpascal.github.io/
#
module Jekyll

  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category.html')
      self.data['category'] = category

      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'category'
        dir = site.config['category_dir'] || 'categories'
        site.categories.keys.each do |category|
          site.pages << CategoryPage.new(site, site.source, File.join(dir, category), category)
        end
      end
    end
  end

end
