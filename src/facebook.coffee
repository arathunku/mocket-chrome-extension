facebook =
  classes: ['uiUnifiedStory', 'uiStreamStory']
  observe: ->
    unless @observer
      chrome.utils.observeDOM(document.body, @classes, (obs) =>
        @observer = obs
        @refresh()
      )

  start: ->
    chrome.utils.d.log('FB START')
    @refresh()
    @observe()

  refresh: ->
    chrome.utils.d.log('Facebook refresh')
    nodes = document.getElementsByClassName('mainWrapper');
    for node in nodes
      if !@alreadyAdded(node)
        element = @getSpotify(node) || @getYoutube(node)
        if element
          console.log("papeaisdpoa")
          if chrome.archive.search(element)
            @createMocketNode(node, '', "Mocketed!")
          else
            @appendAdder(node, element) if !@alreadyAdded(node)

  createMocketNode: (node, element, text) ->
    action = node.getElementsByClassName('UIActionLinks')[0]
    if action
      action.insertAdjacentHTML(
        'beforeend',
        '<a class="mocketLink" data-searchstring="'+escape(element)+'">'+text+'</a> ·')

  appendAdder: (node, element) ->
    @createMocketNode(node, element, 'Mocket it!')
    @bindAdder(node.getElementsByClassName('mocketLink')[0])

  bindAdder: (node) ->
    chrome.utils.on('click', node, (evt)->
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
      e = obj.getElementsByClassName('uiAttachmentTitle')[0]
      return e.innerText if e
    return null

chrome.utils.d.log('Facebook')
facebook.start()
