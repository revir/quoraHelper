$editor = $('.rteditor [contenteditable]')
if 1
    $('body').append('<div id="MathPreview"></div> <div id="MathBuffer" style="visibility:hidden;"></div> ')

    injectScript = (file)->
        defer = $.Deferred()
        s = document.createElement('script')
        s.src = chrome.extension.getURL(file)
        s.onload = ()->
            this.parentNode.removeChild(this)
            defer.resolve()

        (document.head || document.documentElement).appendChild(s)
        return defer

    # modifyCss = ()->
    #     $('.layout_3col_center, .layout_3col_right').css({
    #         'width': '100% !important'
    #         'margin-left': '0 !important'
    #         })

    #     $('.rteditor .doc').css({
    #         'min-height': '800px !important'
    #         })

    injectScript('bower_components/jquery/dist/jquery.js').done ()->
        injectScript('js/content/insert.js')

    editHandler = (evt)->
        $target = $(evt.target)
        $math = $target.find('.section .math.active .content')
        if (evt.keyCode == 27)  # escape key maps to keycode `27`
            $('#MathPreview, #MathBuffer').hide()
        else if $math.length && $target.is('.doc')
            code = $math.text()
            console.log('code: ', code)
            offset = $target.caret('offset')
            $('#MathPreview, #MathBuffer').show()
            $('#MathPreview, #MathBuffer').css({
                'top': offset.top + 120 - $(document).scrollTop()
                })
            if code
                window.postMessage({
                    type: "update",
                    code: code
                }, "*")
        else
            $('#MathPreview, #MathBuffer').hide()
        return

    debouncedEditHandler = _.debounce editHandler, 1000

    $('html').keydown debouncedEditHandler



