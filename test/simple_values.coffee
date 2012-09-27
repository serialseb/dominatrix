dom = require '../'
$ = require 'cheerio'
Story 'Simple key values are replaced by convention', ->
  Feature 'replace matching element name', ->
    Given 'template with html element', ->
      @template = dom($.load('<title>content goes here</title>'));
    Given 'data has property title', ->
      @data = {title: 'welcome to neverland'}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'title has content', ->
      @result.should.equal '<title>welcome to neverland</title>'

  Feature 'replace matching element class', ->
    Given 'template with element @class', ->
      @template = dom($.load('<div class="title">content goes here</div>'));
    Given 'data has property title', ->
      @data = {title: 'welcome to neverland'}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'element has content', ->
      @result.should.equal '<div class="title">welcome to neverland</div>'


  Feature 'replace matching element id', ->
    Given 'template with element #id', ->
      @template = dom($.load('<div id="title">content goes here</div>'));
    Given 'data has property title', ->
      @data = {title: 'welcome to neverland'}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'element has content', ->
      @result.should.equal '<div id="title">welcome to neverland</div>'

  Feature 'replace matching element name', ->
    Given 'template with html element', ->
      @template = dom($.load('<title>content goes here</title>'));
    Given 'data has property title', ->
      @data = {title: 'welcome to neverland'}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'title has content', ->
      @result.should.equal '<title>welcome to neverland</title>'

  Feature 'values as strings containing html are escaped', ->
    Given 'template with html element', ->
      @template = dom($.load('<title>content goes here</title>'));
    Given 'data has property title', ->
      @data = {title: '<b>welcome to neverland</b>'}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'title has content', ->
      @result.should.equal '<title>&lt;b&gt;welcome to neverland&lt;/b&gt;</title>'

  Feature 'values as node lists are injected as html', ->
    Given 'template with html element', ->
      @document = $.load('<title>content goes here</title>');
      @template = dom(@document);
    Given 'data has property title', ->
      @data = {title: @document('<b>welcome to neverland</b>')}
    When 'binding template', ->
      @result = @template.bind(@data);
    Then 'title has content', ->
      @result.should.equal '<title><b>welcome to neverland</b></title>'
