console.log('inserted...')

insertFunc = (data, textStatus)->
  MathJax.Hub.Config({
    showProcessingMessages: false,
    tex2jax: { inlineMath: [['$','$'],['\\(','\\)'], ["[math]","[/math]"]] }
    })
  latexCode = null;
  Preview =
    preview: null
    buffer: null
    mjRunning: false
    oldText: null

    Init: () ->
      this.preview = document.getElementById("MathPreview")
      this.buffer = document.getElementById("MathBuffer")

    SwapBuffers: ()->
      buffer = this.preview
      preview = this.buffer
      this.buffer = buffer
      this.preview = preview
      buffer.style.visibility = "hidden"
      # buffer.style.position = "absolute"
      # preview.style.position = ""
      preview.style.visibility = ""

    CreatePreview: ()->
      if (this.mjRunning || !latexCode || latexCode == this.oldText)
          return
      this.buffer.innerHTML = this.oldText = latexCode
      this.mjRunning = true
      MathJax.Hub.Queue(
        ["Typeset",MathJax.Hub,this.buffer],
        ["PreviewDone",this]
      )

    PreviewDone: ->
      this.mjRunning = false
      this.SwapBuffers()

  Preview.callback = MathJax.Callback(["CreatePreview",Preview])
  Preview.callback.autoReset = true
  Preview.Init()

  # el = document.getElementById("MathPreview")

  window.addEventListener "message", (event)->
    if event.data.type == 'update'
        latexCode = '$' + event.data.code + '$'
        console.log 'update:', latexCode
        Preview.callback()
        # el.innerHTML = "$" + latex + "$"
        # MathJax.Hub.Queue ["Typeset",MathJax.Hub,el]

if !window.MathJax?
  $.getScript("https://cdn.mathjax.org/mathjax/2.6-latest/MathJax.js?config=TeX-AMS_HTML,Safe").done insertFunc
else
  insertFunc()
