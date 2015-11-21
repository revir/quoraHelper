SELECTOR =
    header: '.SiteHeader'
    topicCard: '.TopicFaqQuestionCard'

KEY =
    j: 74
    k: 75

jump = (direction)->
    $header = $(SELECTOR.header)
    headerBottom = $header.offset().top + $header.height()
    $views = $(SELECTOR.topicCard)

    currentIndex = null
    $views.each (index)->
        itemOffset = $(this).offset()
        if itemOffset.top is headerBottom
            currentIndex = index
            return false
        else if itemOffset.top > headerBottom
            currentIndex = index - 1
            return false
    if currentIndex is null
        currentIndex = $views.length - 1

    if direction is 'forward'
        $target = $views.eq(currentIndex+1)
    else
        if currentIndex > 0
            $target = $views.eq(currentIndex-1)

    if $target?.offset()
        $('html, body').animate scrollTop: $target.offset().top - $header.height()

$('html').keydown (evt)->
    if $(evt.target).is('input')
        return
    if evt.keyCode is KEY.j
        jump('forward')
    else if evt.keyCode is KEY.k
        jump('backward')
