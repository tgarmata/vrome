root = exports ? window

root.Post = (tab, message) ->
  chrome.tabs.sendMessage tab.id, message, (response) ->

root.runScript = (msg) ->
  chrome.tabs.executeScript msg.tab.id, code: msg.code

# Notify new version
root.checkNewVersion = ->
  $.get(chrome.extension.getURL("manifest.json")).done (data) ->
    data = JSON.parse data
    openOptions "changelog" if Settings.get("version") isnt data.version
    Settings.add version: data.version

root.openHelpWebsite = -> root.openOrSelectUrl "https://github.com/jinzhu/vrome#readme"
root.openChromeStore = -> root.openOrSelectUrl "https://chrome.google.com/webstore/detail/godjoomfiimiddapohpmfklhgmbfffjj/details"
root.openIssuesPage = -> root.openOrSelectUrl "https://github.com/jinzhu/vrome/issues"
root.openSourcePage = -> root.openOrSelectUrl "https://github.com/jinzhu/vrome"
root.openOptions = (params) ->
  url = "background/options.html#{if params then "##{params}" else ""}"
  root.openOrSelectUrl chrome.extension.getURL(url)

root.openOrSelectUrl = (msg) ->
  if typeof msg is 'string'
    msg = {url: msg, newTab: true, active: true}

  chrome.tabs.query windowId: chrome.windows.WINDOW_ID_CURRENT, (tabs) ->
    for tab in tabs
      return chrome.tabs.update tab.id, active: true if tab.url is msg.url
      msg.tab = tab if tab.active
    Tab.openUrl msg

window.addEventListener "error", ((err) -> Debug err), false
Settings.init checkNewVersion
