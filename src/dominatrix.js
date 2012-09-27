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
  };

  var replaceContent = function(nodes, value){
    if (_.isFunction(value)) {
      value = value();
    }
    
    if (isHtml(value)) {
      nodes.empty().append(value);
    } else if (isTextContent(value)) {
      nodes.text(value);
    }
  };














  var elementSelectorConvention = function(template, $, templateNode, key, value) {
//    if (!isHtml(value) && !isTextContent(value)) { return; }
    var selector = key + ", ." + key + ", #" + key;
    var $nodes = templateNode.find(selector);
    if ($nodes.length === 0) { return;}
    $nodes.each(function(index,element){
      var $node = $(element);
      template.applyConventions($, $node, value);
    });
//    replaceContent($nodes, value);
  };




  var attributeConvention = function(template, $, templateNode, key, value) {
    if (!isTextContent(value) && !_.isFunction(value)) { return; }

    if (templateNode.attr(key)) {
      var injectableValue = _.isFunction(value) ? value() : value;

      templateNode.attr(key, injectableValue);
    }
  };








  var dotContentConvention = function(template, $, templateNode, key, value) {
    if (key !== '.') { return; }
    replaceContent(templateNode, value);
  };










  var nestedObjectConvention = function(template, $, templateNode, key, value) {
    if (!_.isObject(value)) { return; }
    var selector = "." + key + ", #" + key;
    var $nodes = templateNode.find(selector);
    if ($nodes.length === 0) { return; }
    $nodes.each(function(index, element) {
      var $node = $(element);
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


    this.conventions = [
      elementSelectorConvention,
      arrayConvention,
      nestedObjectConvention,
      attributeConvention,
      dotContentConvention];
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
      var apply = function(key, value) {
        _.each(self.conventions, function(convention) {
          convention(self, self.document, $currentNode, key, value);
        });
      };
      if (isTextContent(data) || isHtml(data) || _.isFunction(data)) {
        apply('.', data)
      } else {
        _.each(data, function(value, key) {
          apply(key, value, data);
        })
      }
    }
  };

  return function(document) {
    return new Template(document);
  };
});