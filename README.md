# jekyll-var-to-js

Plugin to transfer Octopress (Jekyll) configuration variables to JavaScript

## Installation at Octopress

1. Copy `plugins/footnote_inline`
   to your `plugins` directory.

1. Add following line at the top of `<head>` section in **source/_includes/head.html**.

```html
{% if page.jekyll_var %}{{page.jekyll_var}}{% endif %}
```

## Configuration

If you don't have `jekyll_var` configuration in your **_config.yml**,
this plugin transfers all configuration variables of `site` and `page`
to JavaScript.

If you want to pass only selected variables,
use `jekyll_var: include/exclude`, like:

```yaml
jekyll_var:
  include:
    - title
    - url
    - author
    - lang
  exclude:
    - lang
```

If you have `include`, only listed variables are transfered.
If you have `exclude`, the variable is not transfered.

# How it works

The plugin produce a script like:

```html
<script>
  jekyll_var = function(i,j=null){
    if(j!="page" && i in jekyll_var.site)return jekyll_var.site[i];
    else if(j!="site" && i in jekyll_var.page)return jekyll_var.page[i];
    else return null;
  };
  jekyll_var["site"]={url:"http://example.com",title:"My Octopress Blog",author:"Your Name",};
  jekyll_var["page"]={title:"hoge",};
</script>
```

`site` related variables (defined in **_config.yml**) are stored in
`jekyll_var["site"]`,
and `page` related variables (defined in such YAML block) are stored in `jekyll_var["page"]`.

Note: Some variables, such `page.url`, can not be used
as it seems these variables are stored after Generator plugins.

## Usage

From your scripts, use like:

```javascript
if(! "jekyll_var" in window){
  var author = jekyll_var("author")||"AUTHOR";
}
```

`jekyll_var(arg)` searches corresponding variables first from `jekyll_var["site"]`,
then from `jekyll_var["page"]`.
If nothing is found, `null` is returned.

If you want the variable of `page` (such a title in above example),
call with `page` as the second argument:

```javascript
if(! "jekyll_var" in window){
  var title = jekyll_var("title", "page")||"TITLE";
}
```

