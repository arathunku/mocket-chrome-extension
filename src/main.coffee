d =
  log: (string) ->
    console.log(string) if true
  dir: (obj) ->
    console.dir(string) if true

observeDOM = ( ->
  MutationObserver = window.MutationObserver || window.WebKitMutationObserver
  eventListenerSupported = window.addEventListener;

  return (obj, callback) ->
    if MutationObserver
      obs = new MutationObserver( (mutations, observer) ->
        if mutations[0].addedNodes.length || mutations[0].removedNodes.length
          callback();
      )
      obs.observe( obj, { childList:true, subtree:true });
    else if  eventListenerSupported
      obj.addEventListener('DOMNodeInserted', callback, false);
      obj.addEventListener('DOMNodeRemoved', callback, false);
)();

facebook = document.location.origin.match('www.facebook')
if facebook && facebook.length > 0
  observeDOM(
    document.getElementsByClassName('UIStream')[0],
    ->
      appendFacebook()
  )

appendFacebook = ->
  @counter ||= 0
  nodes = document.getElementsByClassName('mainWrapper');
  start = 0 + @counter
  end = nodes.length-1
  for i in [start..end]
    node = nodes[i]
    element = getSpotify(node) || getYoutube(node)
    if !alreadyAdded(node) && element
      action = node.getElementsByClassName('UIActionLinks')[0];
      action.insertAdjacentHTML(
        'beforeend',
        '<a class="mocketLink" data-searchstring="'+escape(element)+'">Mocket It!</a> ·')
      link = node.getElementsByClassName('mocketLink')[0]
      _mp.on('click', link, (evt)->
        evt.preventDefault();
        after_click = 'Mocketed!'
        e = evt.toElement
        return if e.innerText == after_click
        search = e.getAttribute('data-searchstring')
        e.innerText = after_click
        chrome.extension.sendMessage({
          method: "postSong",
          data: {search: search}
        });
      )

  @counter = end if end > 0
  return

alreadyAdded = (obj)->
  v = obj.innerHTML.match('Mocket It')
  v && v.length > 0

getSpotify = (obj) ->
  if obj instanceof Node
    v = obj.getElementsByClassName('featured_song')[0]
    return v.innerText if v
  return null

getYoutube = (obj) ->
  # regexp = /https?:\/\/(?:[0-9A-Z-]+\.)?(?:youtu\.be\/|youtube\.com\S*[^\w\-\s])([\w\-]{11})(?=[^\w\-]|$)(?![?=&+%\w.-]*(?:['"][^<>]*>|<\/a>))[?=&+%\w.-]*/ig;
  regexp = /youtube\.\S*/ig
  string = ''
  if obj instanceof Node
    string = obj.innerText
  match = string.match(regexp)
  if match && match.length > 0
    e = obj.getElementsByClassName('uiAttachmentTitle')[0]
    return e.innerText if e
  return null


_mp = _mp || {};

_mp.on = (evnt, elem, func) ->
  bind = (e) ->
    if e.addEventListener
      e.addEventListener(evnt, func, false);
    else
      if e.attachEvent
        e.attachEvent("on" + evnt, func);
      else
        e[evnt] = func;
  bind(elem)
