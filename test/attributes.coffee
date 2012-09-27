dom = require '../'
$ = require 'cheerio'
Story 'Nested objects replace nested content', ->
  Feature 'simple content gets content replaced', ->
    Given 'template with .key element', ->
      @template = dom($.load('<a class="link" rel="rel" href="href">content</a>'));
    Given 'data has property title', ->
      @data = {link: {rel: 'index', href: "/neverland", ".": "neverland" }}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'title has content', ->
      @result.should.equal '<a class="link" rel="index" href="/neverland">neverland</a>'

