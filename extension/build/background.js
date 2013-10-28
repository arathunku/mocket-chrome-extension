// Generated by CoffeeScript 1.6.3
(function() {
  var host, injectScript, rapi, start;

  host = 'http://mocket.in';

  console.log("Extension loaded.");

  start = function() {
    if (!localStorage.getItem('songsHistory')) {
      return localStorage.setItem('songsHistory', JSON.stringify({
        elements: []
      }));
    }
  };

  injectScript = function(tabId, file) {
    tabId = tabId;
    file = file;
    return chrome.tabs.executeScript(tabId, {
      file: "build/utils.js"
    }, function() {
      return chrome.tabs.executeScript(tabId, {
        file: "build/archive.js"
      }, function() {
        var songsHistory;
        songsHistory = localStorage.getItem('songsHistory');
        return chrome.tabs.executeScript(tabId, {
          code: "chrome.archive.start(" + songsHistory + ")"
        }, function() {
          chrome.tabs.executeScript(tabId, {
            file: "build/" + file + ".js"
          });
          return chrome.tabs.executeScript(tabId, {
            code: "var isLoaded = true;"
          });
        });
      });
    });
  };

  chrome.runtime.onMessage.addListener(function(message, sender, sendResponse) {
    if (message.method === 'postSong') {
      rapi.postSong(message.data);
    }
    if (message.method === 'inject' && message.loaded === false) {
      injectScript(message.tabId, message.file);
    }
    if (message.method === 'setSongsHistory') {
      return localStorage.setItem("songsHistory", JSON.stringify(message.newData));
    }
  });

  chrome.runtime.getBackgroundPage(function(background) {
    return background.updateAccessToken = function(token) {
      var access_token;
      return access_token = localStorage.access_token;
    };
  });

  chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab) {
    if (changeInfo.status === 'complete') {
      return chrome.tabs.query({
        'active': true,
        'lastFocusedWindow': true
      }, function(tabs) {
        var file, url;
        if (tabs.length <= 0) {
          return;
        }
        url = tabs[0].url;
        if (url.match(/\.facebook\./)) {
          file = "facebook";
        }
        if (file != null) {
          return chrome.tabs.executeScript(tabId, {
            code: "if(isLoaded){isLoaded=isLoaded}else{ var isLoaded=false;}            chrome.runtime.sendMessage({            loaded: isLoaded || false,            method: 'inject',            tabId: " + tabId + ",            file: '" + file + "' });"
          });
        }
      });
    }
  });

  rapi = {
    postSong: function(data) {
      chrome.archive.push(unescape(data.search));
      return chrome.utils.req("" + host + "/api/song", function() {}, "POST", {
        access_token: localStorage.access_token,
        post: {
          search: unescape(data.search)
        }
      });
    }
  };

  start();

}).call(this);
