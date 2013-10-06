host = 'http://mocket.in'
#host = 'http://localhost:3000'
access_token = localStorage.access_token
chrome.extension.onMessage.addListener (message, sender, sendResponse) ->
  if message.method == 'postSong'
    _mp.req(
      "#{host}/api/song",
      ->,
      "POST",
      {
        access_token: access_token,
        post: {search: unescape(message.data.search)}
      }
    )
chrome.extension.getBackgroundPage().updateAccessToken = (token) ->
  access_token = localStorage.access_token;

_mp = _mp || {};

_mp.req = (url, callbackFunction, requestType) ->
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
