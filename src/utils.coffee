chrome.utils = chrome.utils || {}

chrome.utils =
  req: (url, callbackFunction, requestType) ->
    @bindFunction = (caller, object) ->
      return ->
        return caller.apply(object, [object]);
    @stateChange = (object) ->
      if @request.readyState == 4
        @callbackFunction(@request.responseText, @request.status);
    @getRequest =  ->
      if window.ActiveXObjec
        new ActiveXObject('Microsoft.XMLHTTP');
      else if (window.XMLHttpRequest)
        new XMLHttpRequest();
      else
        false;
    data = arguments[3] || "";
    @postBody = JSON.stringify(data);
    @callbackFunction = callbackFunction;
    url = url;
    @url = url;
    @request = @getRequest();
    if @request
      req = this.request;
      req.onreadystatechange = @bindFunction(@stateChange, this);
      if @postBody != ""
        req.open(requestType, url, true);
        req.setRequestHeader('Content-type', 'application/json');
      else
        req.open("GET", url, true);
      req.send(this.postBody);
  d:
    log: (string) ->
      console.log(string) if true
    dir: (obj) ->
      console.dir(string) if true

  qa: (arg) ->
    document.querySelectorAll(arg)

  q: (arg) ->
    document.querySelector(arg)

  setStyle: ( node, propertyObject ) ->
    for key in Object.keys(propertyObject)
      node.style[key] = propertyObject[key]

  observeDOM: (->
    MutationObserver = window.MutationObserver || window.WebKitMutationObserver
    eventListenerSupported = window.addEventListener;
    return (obj, classes, callback) ->
      if MutationObserver
        obs = new MutationObserver( (mutations, observer) ->
          if mutations[0].addedNodes.length
            for node in mutations[0].addedNodes
              if node.nodeName == "DIV"
                return callback(obs)
              # for klass in classes
                # if (node.className||'').match(new RegExp(klass, 'gi'))
        )
        obs.observe( obj, { childList:true, subtree: true});
      else if eventListenerSupported
        obj.addEventListener('DOMNodeInserted', callback, false);
        obj.addEventListener('DOMNodeRemoved', callback, false);
    )()

  on: (evnt, elem, func) ->
    bind = (e) ->
      if e.addEventListener
        e.addEventListener(evnt, func, false);
      else
        if e.attachEvent
          e.attachEvent("on" + evnt, func);
        else
          e[evnt] = func;
    bind(elem)
