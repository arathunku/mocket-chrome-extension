chrome.utils.d.log("History!")
chrome.archive = chrome.archive || {}
chrome.archive =
  storage: {elements: []}
  start: (songsHistory) ->
    chrome.archive.storage = songsHistory

  search: (string) ->
    for element in chrome.archive.storage.elements
      return true if element == string
    return false

  push: (string) ->
    chrome.archive.storage.elements.push(string)
    chrome.runtime.sendMessage({method:"setSongsHistory", newData: chrome.archive.storage});

  sync: ->
    chrome.utils.d.log("sync")
