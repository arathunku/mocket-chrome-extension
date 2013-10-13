node = document.getElementById('access_token')
node.value = localStorage.access_token || "no access_token"
save = document.getElementById('save')
save.addEventListener('click', ->
  localStorage.access_token = node.value
  chrome.runtime.getBackgroundPage (background) ->
    background.updateAccessToken()
,false)
