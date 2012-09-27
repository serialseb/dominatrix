if (typeof define !== 'function') {
  var define = require('amdefine')(module);
}

define(function (require){
  var _ = require('underscore');
















  var isTextContent = function(value) {
    return _.isString(value) ||
      _.isNumber(value) ||
      _.isDate(value) ||
      _.isBoolean(value);
  };
  var isHtml = function(value) {
    return value.html;
  }

  var replaceContent = function(nodes, value){
    if (isHtml(value)) {
      nodes.empty().append(value);
    } else if (isTextContent(value)) {
      nodes.text(value);
    }
  };














  var simpleValuesConvention = function(template, $, templateNode, key, value) {
    if (!isHtml(value) && !isTextContent(value)) { return; }
    var selector = key + ", ." + key + ", #" + key;
    var nodesToInject = templateNode.find(selector);

    replaceContent(nodesToInject, value);
  };










  var nestedObjectConvention = function(template, $, templateNode, key, value) {
    if (!_.isObject(value)) { return; }
    var selector = "." + key + ", #" + key;
    var $nodes = templateNode.find(selector);

    $nodes.each(function(index, element) {
      var $node = $(element);
      console.log('recursively applying convention');
      template.applyConventions($, $node, value);
    });
  };














  var arrayConvention = function(template, $, templateNode, key, values){
    if (!_.isArray(values)) { return; }

    var $nodesToRepeat = templateNode.find('.' + key + ',#' + key);
    $nodesToRepeat.each(function(index, element){
      var $node = $(element);
      _.each(values, function(value){
        var $newNode = $node.clone();
        if ($node.hasClass('template')) {
          $newNode.removeClass('template');
        } else {
          $node.remove();
        }
        templateNode.append($newNode);
        if (isTextContent(value) || isHtml(value)){
          replaceContent($newNode, value);
        } else {
          template.applyConventions($, $newNode, value);
        }
      });
    });
  };




























  var Template = function(document){
    this.document = document;


    this.conventions = [simpleValuesConvention, arrayConvention, nestedObjectConvention];
  };

  Template.prototype = {
    bind: function(data) {

      var $templateNode = this.document('<div />');
      $templateNode.append(this.document.html());

      this.applyConventions(this.document, $templateNode, data);
      return $templateNode.html();
    },
    applyConventions: function($, $currentNode, data){
      var self = this;
      _.each(data, function(value, key) {

        _.each(self.conventions, function(convention) {
          convention(self, self.document, $currentNode, key, value);
        });
      });
    }
  };

  return function(document) {
    return new Template(document);
  };
});