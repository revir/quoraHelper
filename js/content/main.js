// Generated by CoffeeScript 1.10.0
(function() {
  var KEY, SELECTOR, jump;

  SELECTOR = {
    header: '.SiteHeader',
    topicCard: '.TopicFaqQuestionCard'
  };

  KEY = {
    j: 74,
    k: 75
  };

  jump = function(direction) {
    var $header, $target, $views, currentIndex, headerBottom;
    $header = $(SELECTOR.header);
    headerBottom = $header.offset().top + $header.height();
    $views = $(SELECTOR.topicCard);
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
    if (direction === 'forward') {
      $target = $views.eq(currentIndex + 1);
    } else {
      if (currentIndex > 0) {
        $target = $views.eq(currentIndex - 1);
      }
    }
    if ($target != null ? $target.offset() : void 0) {
      return $('html, body').animate({
        scrollTop: $target.offset().top - $header.height()
      });
    }
  };

  $('html').keydown(function(evt) {
    if ($(evt.target).is('input')) {
      return;
    }
    if (evt.keyCode === KEY.j) {
      return jump('forward');
    } else if (evt.keyCode === KEY.k) {
      return jump('backward');
    }
  });

}).call(this);
