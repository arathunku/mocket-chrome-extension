node = document.getElementById('access_token')
node.value = localStorage.access_token || ""
if node.value == ""
  document.getElementById('access-token-alert').className = ""

save = document.getElementById('save')
save.addEventListener('click', ->
  localStorage.access_token = node.value
  chrome.runtime.getBackgroundPage (background) ->
    background.updateAccessToken()
  if node.value == ""
    document.getElementById('access-token-alert').className = ""
  else
    document.getElementById('access-token-alert').className = "hide"

,false)

document.querySelector('#exit').addEventListener('click', ->
  open(location, '_self').close();
,false)
