facebook =
  start: ->
    chrome.utils.d.log('FB START')
    chrome.utils.observeDOM(document.querySelector('body'), =>
      @refresh()
    )
    @refresh()
  refresh: ->
    chrome.utils.d.log('Facebook refresh')
    nodes = document.getElementsByClassName('mainWrapper');
    start = 0
    end = nodes.length-1
    for i in [start..end]
      node = nodes[i]
      if !@alreadyAdded(node)
        element = @getSpotify(node) || @getYoutube(node)
        if element
          action = node.getElementsByClassName('UIActionLinks')[0];
          action.insertAdjacentHTML(
            'beforeend',
            '<a class="mocketLink" data-searchstring="'+escape(element)+'">Mocket It!</a> ·')
          link = node.getElementsByClassName('mocketLink')[0]
          chrome.utils.on('click', link, (evt)->
            evt.preventDefault();
            after_click = 'Mocketed!'
            e = evt.toElement
            return if e.innerText == after_click
            search = e.getAttribute('data-searchstring')
            e.innerText = after_click
            chrome.runtime.sendMessage({
              method: "postSong",
              data: {search: search}
            });
          )

  alreadyAdded: (obj)->
    done = obj.innerHTML.match('Mocket It')
    not_yet = obj.innerHTML.match('Mocketed!')
    done && done.length > 0 || not_yet && not_yet.length > 0

  getSpotify: (obj) ->
    if obj instanceof Node
      v = obj.getElementsByClassName('featured_song')[0]
      return v.innerText if v
    return null

  getYoutube: (obj) ->
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

chrome.utils.d.log('Facebook')
facebook.start()
