dom = require '../'
$ = require 'cheerio'
Story 'Nested objects replace nested content', ->
  Feature 'simple content gets content replaced', ->
    Given 'template with .key element', ->
      @template = dom($.load('<div class="title">title is <span class="text">content</span></div>' +
        '<div class="text">Some more text</div>'));
    Given 'data has property title', ->
      @data = {title: {text: 'neverland'}}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'title has content', ->
      @result.should.equal '<div class="title">title is <span class="text">neverland</span></div>' +
              '<div class="text">Some more text</div>'
