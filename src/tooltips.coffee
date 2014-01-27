tooltips =
  currentNode: null
  added: false
  watching: []
  after_click: 'Mocketed!'
  before_click: 'Mocket!'
  observe: ->
    unless @observer
      chrome.utils.observeDOM(document.body, [], (obs) =>
        @observer = obs
        @refresh()
      )

  start: ->
    chrome.utils.d.log('Tooltips START')
    return if chrome.utils.q('.mocket-tooltip')
    node = document.createElement('div')
    css =
      'text-align': 'center'
      'background': '#E7E7E7'
      'width': '100px'
      'position': 'absolute'
      'line-height': '20px'
      'z-index': 9999

    node.className = 'mocket-tooltip'
    chrome.utils.setStyle(node, css)
    node.innerHTML = '<span style="color: #6D84B4;padding-right: 5px" class="mocket-add">Mocket!</span><a class="close"></a>'
    @tooltip = node
    @tooltipAdd = node.querySelector('.mocket-add')
    closeNode = node.querySelector('.close')
    closeCSS =
      'background-image': 'url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAAA3NCSVQICAjb4U/gAAAABlBMVEX////dzHd5vQnAAAAAAnRSTlMA/1uRIrUAAAAJcEhZcwAACxIAAAsSAdLdfvwAAAAcdEVYdFNvZnR3YXJlAEFkb2JlIEZpcmV3b3JrcyBDUzVxteM2AAAAFUlEQVQImWM4zPCcoY7BBgjrgKzDACZQBMlbvpNAAAAAAElFTkSuQmCC)'
      'width': '8px'
      'height': '8px'
      'float': 'right'
      'margin': '6px 5px 7px 7px'
      'cursor': 'pointer'
    chrome.utils.setStyle(closeNode, closeCSS)
    closeNode.addEventListener 'click', =>
      @hide()
    @refresh()
    @observe()

  refresh: ->
    nodesOfNodes = []
    nodesOfNodes.push(chrome.utils.qa('[data-expanded-url^="http://www.youtu"'))
    nodesOfNodes.push(chrome.utils.qa('[data-expanded-url^="http://youtu"'))
    nodesOfNodes.push(chrome.utils.qa('[data-expanded-url^="http://spoti.fi"'))
    nodesOfNodes.push(chrome.utils.qa('[href^="http://youtu"'))
    for nodes in nodesOfNodes
      for node in nodes
        if @watching.indexOf(node) == -1
          @bindHover(node)
          @watching.push(node)

  bindHover: (node) ->
    node.addEventListener "click", (e) =>
      if node != @currentNode
        @currentNode = node
        e.preventDefault()
        $element = e.target
        searchString = node.getAttribute('data-expanded-url') || node.getAttribute('href')
        @showTooltip(@getPos($element), searchString)

  getPos: (node) ->
    _x = 0
    _y = 0
    rect = node.getBoundingClientRect();
    scrollTop = if document.documentElement.scrollTop then document.documentElement.scrollTop else document.body.scrollTop;
    scrollLeft = if document.documentElement.scrollLeft then document.documentElement.scrollLeft else document.body.scrollLeft;
    _y = rect.top + scrollTop
    _x = rect.left + scrollLeft
    return { top: _y, left: _x }

  showTooltip: (pos, searchString) ->
    @addTooltip()
    offsetTop = 20
    @tooltip.style.display = 'block'
    @tooltip.style.top = pos.top-offsetTop + "px"
    @tooltip.style.left = pos.left + "px"
    if chrome.archive.search(searchString)
      @tooltipAdd.removeAttribute('data-searchstring')
      @tooltipAdd.innerText = @after_click
      @tooltipAdd.style.cursor = "initial"
      setTimeout =>
        @hide()
      , 5000
    else
      @tooltipAdd.innerText = @before_click
      @tooltipAdd.setAttribute('data-searchstring', searchString)
      @tooltipAdd.style.cursor = "pointer"

  hide: () ->
    @currentNode = null
    @tooltip.style.display = 'none'
  addTooltip: () ->
    unless @added
      @added = true
      chrome.utils.q('body').appendChild(@tooltip)
      chrome.utils.on('click', @tooltipAdd, (evt) =>
        evt.preventDefault();
        return unless search = @tooltipAdd.getAttribute('data-searchstring')
        @tooltipAdd.removeAttribute('data-searchstring')
        @tooltipAdd.innerText = @after_click
        @tooltipAdd.style.cursor = "initial"
        setTimeout =>
          @hide()
        , 5000
        chrome.archive.push(search)
        chrome.runtime.sendMessage({
          method: "postSong",
          data: {search: search}
        });
      )

  inHistory: (string, callback) ->
    chrome.runtime.sendMessage({
      method: "searchHistory",
      data: string
    }, callback);

chrome.utils.d.log('toolips')
tooltips.start()
