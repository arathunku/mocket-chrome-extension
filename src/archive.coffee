chrome.utils.d.log("History!")
chrome.archive = chrome.archive || {}
chrome.archive =
  storage: {elements: []}
  start: (songsHistory) ->
    chrome.archive.storage = songsHistory

  search: (string) ->
    for element in chrome.archive.storage.elements
      return true if element == string || element == escape(string)
    return false

  push: (string) ->
    debugger
    unless @search(string)
      chrome.archive.storage.elements.push(string)
      chrome.runtime.sendMessage({method:"pushToSongsHistory", search: string});

  sync: ->
    chrome.utils.d.log("sync")
