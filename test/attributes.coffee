dom = require '../'
$ = require 'cheerio'
Story 'Attribue values are bound', ->
  Feature 'simple content gets content replaced', ->
    Given 'template with .key element', ->
      @template = dom($.load('<a class="link" rel="rel" href="href">content</a>'));
    Given 'data has property title', ->
      @data = {link: {rel: 'index', href: "/neverland", ".": "neverland" }}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'title has content', ->
      @result.should.equal '<a class="link" rel="index" href="/neverland">neverland</a>'

  Feature 'function gets result of function', ->
    Given 'element with attribute', ->
      @template = dom($.load('<a rel="rel"></a>'));
    Given 'data has property as function', ->
      @data = {a: { rel: ()-> 'value' } };
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'title has content', ->
      @result.should.equal '<a rel="value"></a>'
