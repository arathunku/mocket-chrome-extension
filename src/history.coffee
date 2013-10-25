chrome.utils.d.log("History!")
chrome.archive = chrome.archive || {}
chrome.archive =
  background: chrome.extension.getBackgroundPage()
  start: ->
    storage = @background.localStorage.getItem('songsHistory')
    if !storage?
      @background.localStorage.setItem('songsHistory', JSON.stringify({elements: []}))
  storage: ->
    storage = @background.localStorage.getItem('songsHistory')
    JSON.parse(storage)
  search: (string)->
    for element in @storage().elements
      return true if element == string
    return null
  push: (string)->
    json = @storage()
    unless @search(string)
      json.elements.push(string)
      @background.localStorage.setItem('songsHistory', JSON.stringify(json))
  sync: ->
    chrome.utils.d.log("sync")

chrome.archive.start()
