dom = require '../'
$ = require 'cheerio'
Story 'Array of values replicates nodes', ->
  Feature 'simple content gets content replaced', ->
    Given 'template with .key element', ->
      @template = dom($.load('<div class="title">content goes here</div>'));
    Given 'data has property title', ->
      @data = {title: ['welcome to', 'neverland']}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'title has content', ->
      @result.should.equal '<div class="title">welcome to</div>' +
        '<div class="title">neverland</div>'

  Feature 'object content gets nested conventions', ->
    Given 'template with .key element', ->
      @template = dom($.load('<div class="content">'+
       '<span class="greetings">Hello</span>'+
       '<span class="location">Dolly</span></div>'));
    Given 'data has property title', ->
      @data = {content: [
        { greetings: 'welcome', location: 'to neverland' }
        { greetings: 'goodbye', location: 'world' }
      ]}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'title has content', ->
      @result.should.equal '<div class="content">' +
          '<span class="greetings">welcome</span><span class="location">to neverland</span>' +
        '</div><div class="content">' +
          '<span class="greetings">goodbye</span><span class="location">world</span>' +
        '</div>'

  Feature 'replication of nodes with .template doesnt remove node', ->
    Given 'template with .template', ->
      @template = dom($.load('<div class="title template">content goes here</div>'));
    Given 'data has property title', ->
      @data = {title: ['welcome to', 'neverland']}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'title has content', ->
      @result.should.equal '<div class="title template">content goes here</div>' +
      '<div class="title">welcome to</div>' +
      '<div class="title">neverland</div>'