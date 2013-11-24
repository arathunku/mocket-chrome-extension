facebook =
  after_click: ' · Mocketed!'
  before_click: ' · Mocket it!'
  observe: ->
    unless @observer
      chrome.utils.observeDOM(document.body, [], (obs) =>
        @observer = obs
        @refresh()
      )

  start: ->
    chrome.utils.d.log('FB START')
    @refresh()
    @observe()

  refresh: ->
    chrome.utils.d.log('Facebook refresh')
    nodes = document.querySelectorAll('*[data-timestamp]')
    nodes = document.querySelectorAll('.mainWrapper') unless nodes.length
    for node in nodes
      if !@alreadyAdded(node)
        element = @getSpotify(node) || @getYoutube(node)
        if element
          if chrome.archive.search(element)
            @createMocketNode(node, '', @after_click)
          else
            @appendAdder(node, element) if !@alreadyAdded(node)

  createMocketNode: (node, element, text) ->
    action = node.querySelector('.livetimestamp').parentNode.parentNode
    if action
      action.insertAdjacentHTML(
        'beforeend',
        '<a class="mocketLink" style="color: #6D84B4;"
          data-searchstring="'+escape(element)+'">'+text+'</a>')

  appendAdder: (node, element) ->
    @createMocketNode(node, element, @before_click)
    @bindAdder(node.querySelector('.mocketLink'))

  bindAdder: (node) ->
    chrome.utils.on('click', node, (evt) =>
      evt.preventDefault();
      e = evt.toElement
      return if e.innerText == @after_click
      search = e.getAttribute('data-searchstring')
      e.innerText = @after_click
      chrome.archive.push(search)
      chrome.runtime.sendMessage({
        method: "postSong",
        data: {search: search}
      });
    )

  alreadyAdded: (obj)->
    obj.innerHTML.match(/Mocket\b/ig) || obj.innerHTML.match(/Mocketed/ig)

  inHistory: (string, callback) ->
    chrome.runtime.sendMessage({
      method: "searchHistory",
      data: string
    }, callback);

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
      e = obj.querySelector('.fwb') ||
        obj.querySelector('.uiAttachmentTitle')
      return e.innerText if e
    return null

chrome.utils.d.log('Facebook')
facebook.start()
