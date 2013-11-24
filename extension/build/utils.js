// Generated by CoffeeScript 1.6.3
(function() {
  chrome.utils = chrome.utils || {};

  chrome.utils = {
    req: function(url, callbackFunction, requestType) {
      var data, req;
      this.bindFunction = function(caller, object) {
        return function() {
          return caller.apply(object, [object]);
        };
      };
      this.stateChange = function(object) {
        if (this.request.readyState === 4) {
          return this.callbackFunction(this.request.responseText, this.request.status);
        }
      };
      this.getRequest = function() {
        if (window.ActiveXObjec) {
          return new ActiveXObject('Microsoft.XMLHTTP');
        } else if (window.XMLHttpRequest) {
          return new XMLHttpRequest();
        } else {
          return false;
        }
      };
      data = arguments[3] || "";
      this.postBody = JSON.stringify(data);
      this.callbackFunction = callbackFunction;
      url = url;
      this.url = url;
      this.request = this.getRequest();
      if (this.request) {
        req = this.request;
        req.onreadystatechange = this.bindFunction(this.stateChange, this);
        if (this.postBody !== "") {
          req.open(requestType, url, true);
          req.setRequestHeader('Content-type', 'application/json');
        } else {
          req.open("GET", url, true);
        }
        return req.send(this.postBody);
      }
    },
    d: {
      log: function(string) {
        if (true) {
          return console.log(string);
        }
      },
      dir: function(obj) {
        if (true) {
          return console.dir(string);
        }
      }
    },
    observeDOM: (function() {
      var MutationObserver, eventListenerSupported;
      MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
      eventListenerSupported = window.addEventListener;
      return function(obj, classes, callback) {
        var obs;
        if (MutationObserver) {
          obs = new MutationObserver(function(mutations, observer) {
            var node, _i, _len, _ref;
            if (mutations[0].addedNodes.length) {
              _ref = mutations[0].addedNodes;
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                node = _ref[_i];
                if (node.nodeName === "DIV") {
                  return callback(obs);
                }
              }
            }
          });
          return obs.observe(obj, {
            childList: true,
            subtree: true
          });
        } else if (eventListenerSupported) {
          obj.addEventListener('DOMNodeInserted', callback, false);
          return obj.addEventListener('DOMNodeRemoved', callback, false);
        }
      };
    })(),
    on: function(evnt, elem, func) {
      var bind;
      bind = function(e) {
        if (e.addEventListener) {
          return e.addEventListener(evnt, func, false);
        } else {
          if (e.attachEvent) {
            return e.attachEvent("on" + evnt, func);
          } else {
            return e[evnt] = func;
          }
        }
      };
      return bind(elem);
    }
  };

}).call(this);
