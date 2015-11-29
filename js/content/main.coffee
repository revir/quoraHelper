SELECTOR =
    header: '.SiteHeader'
    viewItem: '.TopicFaqQuestionCard, .layout_3col_center .pagedlist_item, .layout_2col_main .pagedlist_item, .feed .pagedlist_item'
    answer: '.WriteAnswer'
    more: '.more_link'
    comment: '.view_comments'
    topicHeader: '.PinnedTopicHeader.fixable_fixed'

KEY =
    j: 74
    k: 75
    enter: 13
    esc: 27

jumping = false

triggerMouseEvent = (node, eventType) ->
    clickEvent = document.createEvent('MouseEvents')
    clickEvent.initEvent(eventType, true, true)
    node.dispatchEvent(clickEvent)

getHeaderHeight = ->
    return $(SELECTOR.header).outerHeight() + $(SELECTOR.topicHeader).outerHeight()

getCurrentViewIndex = ->
    $header = $(SELECTOR.header)
    headerBottom = $header.offset().top + getHeaderHeight()
    $views = $(SELECTOR.viewItem)

    currentIndex = null
    $views.each (index)->
        return if this.scrollHeight is 0
        itemOffset = $(this).offset()
        if Math.abs(itemOffset.top - headerBottom) < 3
            currentIndex = index
            return false
        else if itemOffset.top >= (headerBottom + 3)
            currentIndex = index - 1
            return false
    if currentIndex is null
        currentIndex = $views.length - 1
    return currentIndex

jump = (direction)->
    return if jumping
    $views = $(SELECTOR.viewItem)
    currentIndex = getCurrentViewIndex()
    posTop = null

    if direction is 'forward'
        $target = $views.eq(currentIndex+1)
    else
        if currentIndex > 0
            $target = $views.eq(currentIndex-1)
        else if currentIndex is 0
            posTop = 0

    if $target?.offset()
        posTop = $target.offset().top - getHeaderHeight()

    if posTop?
        jumping = true
        $('html, body').animate {
                scrollTop: posTop
            }, {
                duration: 'fast',
                complete: -> jumping = false
            }

diveInto = () ->
    currentIndex = getCurrentViewIndex()
    currentIndex = 0 if currentIndex < 0
    $view = $(SELECTOR.viewItem).eq(currentIndex)
    $target = $(SELECTOR.more, $view)
    if not $target.is(':visible')
        $target = $(SELECTOR.comment, $view)
    if not $target.is(':visible')
        $target = $(SELECTOR.answer, $view)

    if $target.length and not $target.data('dived')
        triggerMouseEvent($target[0], 'click')
        triggerMouseEvent($target[0], 'mouseover')
        triggerMouseEvent($target[0], 'mouseup')
        $target.data('dived', true)
        return

$('html').keydown (evt)->
    if $(evt.target).is('input')
        return
    if evt.target.className?.indexOf('editor') >=0
        return
    if evt.keyCode is KEY.j
        jump('forward')
    else if evt.keyCode is KEY.k
        jump('backward')
    else if evt.keyCode is KEY.enter
        diveInto()

    return
