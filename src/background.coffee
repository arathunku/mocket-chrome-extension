#host = 'http://mocket.in'
host = 'http://localhost:3000'
console.log("Extension loaded.")

injectScript = (tabId, file)->
  tabId = tabId
  file = file
  chrome.tabs.executeScript tabId, {file:"build/utils.js"}, ->
    chrome.tabs.executeScript tabId, {file:"build/#{file}.js"}
    chrome.tabs.executeScript tabId, { code: "var isLoaded = true;" }

chrome.runtime.onMessage.addListener (message, sender, sendResponse) ->
  rapi.postSong(message.data) if message.method == 'postSong'
  sendResponse(chrome.archive.search(message.data)) if message.method == 'searchHistory'
  if message.method == 'inject' && message.loaded == false
    injectScript(message.tabId, message.file)

chrome.runtime.getBackgroundPage (background) ->
  background.updateAccessToken = (token) ->
    access_token = localStorage.access_token;

chrome.tabs.onUpdated.addListener (tabId, changeInfo, tab) ->
  if changeInfo.status == 'complete'
    chrome.tabs.query {'active': true, 'lastFocusedWindow': true}, (tabs) ->
      return if tabs.length <= 0
      url = tabs[0].url;
      file = "facebook" if url.match(/\.facebook\./)
      if file?
        chrome.tabs.executeScript(tabId, {
          code: "if(isLoaded){isLoaded=isLoaded}else{ var isLoaded=false;}
            chrome.runtime.sendMessage({
            loaded: isLoaded || false,
            method: 'inject',
            tabId: "+tabId+",
            file: '"+file+"' });"
        });

rapi =
  postSong: (data)->
    chrome.archive.push(unescape(data.search))
    chrome.utils.req(
      "#{host}/api/song",
      ->,
      "POST",
      {
        access_token: localStorage.access_token,
        post: {search: unescape(data.search)}
      }
    )
