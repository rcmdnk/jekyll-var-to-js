require 'jekyll'

module Jekyll

  class JekyllVarToJs < Generator
    safe :true
    priority :lowest

    def parse(v)
      ret=""
      if Array === v
        ret="["
        for c in v
          ret+=parse(c)+','
        end
        ret+="]"
      elsif Hash === v
        ret="{"
        for k,c in v
          if (@include.size == 0 or @include.include?(k)) and \
              (@exclude.size == 0 or not @exclude.include?(k))
            ret+="#{k}:"+parse(c)+','
          end
        end
        ret+="}"
      else
        ret="\"#{v}\""
      end
      ret
    end

    def generate(site)
      if site.config.has_key?("jekyll_var") and site.config["jekyll_var"].has_key?("include")
        if String === site.config["jekyll_var"]["include"]
          @include =  site.config["jekyll_var"]["include"]
        else
          @include = site.config["jekyll_var"]["include"]
        end
      end
      if site.config.has_key?("jekyll_var") and site.config["jekyll_var"].has_key?("exclude")
        if String === site.config["jekyll_var"]["exclude"]
          @exclude = [site.config["jekyll_var"]["exclude"]]
        else
          @exclude = site.config["jekyll_var"]["exclude"]
        end
      end
      @include = @include== nil ? [] : @include
      @exclude = @exclude== nil ? [] : @exclude
      script="<script>jekyll_var=function(i,j=null){if(j!=\"page\" && i in jekyll_var.site)return jekyll_var.site[i];else if(j!=\"site\" && i in jekyll_var.page)return jekyll_var.page[i];else return null;};"
      script+="jekyll_var[\"site\"]="+parse(site.config)+";"
      site.posts.each { |page|
        s=script
        s+="jekyll_var[\"page\"]="+parse(page.data)+";</script>"
        page.data.merge!("jekyll_var" => s)
      }
      site.pages.each { |page|
        s=script
        s+="jekyll_var[\"page\"]="+parse(page.data)+";</script>"
        page.data.merge!("jekyll_var" => s)
      }
    end
  end
end