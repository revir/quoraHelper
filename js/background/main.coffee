
# chrome.runtime.onMessage.addListener (request, sender, response)->
#     console.log 'insert'
#     chrome.tabs.executeScript(sender.tab.id, {file: "js/content/insert.js"});
#     response('ok')
