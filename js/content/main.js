// Generated by CoffeeScript 1.10.0
(function() {
  var KEY, SELECTOR, diveInto, getCurrentViewIndex, jump, jumping, triggerMouseEvent;

  SELECTOR = {
    header: '.SiteHeader',
    viewItem: '.TopicFaqQuestionCard, .layout_3col_center .pagedlist_item, .feed .pagedlist_item',
    answer: '.WriteAnswer',
    more: '.more_link',
    comment: '.view_comments',
  };

  KEY = {
    j: 74,
    k: 75,
    enter: 13,
    esc: 27
  };

  jumping = false;

  triggerMouseEvent = function(node, eventType) {
    var clickEvent;
    clickEvent = document.createEvent('MouseEvents');
    clickEvent.initEvent(eventType, true, true);
    return node.dispatchEvent(clickEvent);
  };

  getCurrentViewIndex = function() {
    var $header, $views, currentIndex, headerBottom;
    $header = $(SELECTOR.header);
    headerBottom = $header.offset().top + $header.height();
    $views = $(SELECTOR.viewItem);
    currentIndex = null;
    $views.each(function(index) {
      var itemOffset;
      itemOffset = $(this).offset();
      if (itemOffset.top === headerBottom) {
        currentIndex = index;
        return false;
      } else if (itemOffset.top > headerBottom) {
        currentIndex = index - 1;
        return false;
      }
    });
    if (currentIndex === null) {
      currentIndex = $views.length - 1;
    }
    return currentIndex;
  };

  jump = function(direction) {
    var $header, $target, $views, currentIndex;
    if (jumping) {
      return;
    }
    $header = $(SELECTOR.header);
    $views = $(SELECTOR.viewItem);
    currentIndex = getCurrentViewIndex();
    if (direction === 'forward') {
      $target = $views.eq(currentIndex + 1);
    } else {
      if (currentIndex > 0) {
        $target = $views.eq(currentIndex - 1);
      }
    }
    if ($target != null ? $target.offset() : void 0) {
      jumping = true;
      return $('html, body').animate({
        scrollTop: $target.offset().top - $header.height()
      }, {
        duration: 'fast',
        complete: function() {
          return jumping = false;
        }
      });
    }
  };

  diveInto = function() {
    var $target, $view, currentIndex;
    currentIndex = getCurrentViewIndex();
    if (currentIndex < 0) {
      currentIndex = 0;
    }
    $view = $(SELECTOR.viewItem).eq(currentIndex);
    $target = $(SELECTOR.more, $view);
    if (!$target.is(':visible')) {
      $target = $(SELECTOR.comment, $view);
    }
    if (!$target.is(':visible')) {
      $target = $(SELECTOR.answer, $view);
    }
    if ($target.length && !$target.data('dived')) {
      triggerMouseEvent($target[0], 'click');
      triggerMouseEvent($target[0], 'mouseover');
      triggerMouseEvent($target[0], 'mouseup');
      $target.data('dived', true);
    }
  };

  $('html').keydown(function(evt) {
    var ref;
    if ($(evt.target).is('input')) {
      return;
    }
    if (((ref = evt.target.className) != null ? ref.indexOf('editor') : void 0) >= 0) {
      return;
    }
    if (evt.keyCode === KEY.j) {
      jump('forward');
    } else if (evt.keyCode === KEY.k) {
      jump('backward');
    } else if (evt.keyCode === KEY.enter) {
      diveInto();
    }
  });

}).call(this);