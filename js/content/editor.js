// Generated by CoffeeScript 1.10.0
(function() {
  var $editor, debouncedEditHandler, editHandler, injectScript;

  $editor = $('.rteditor [contenteditable]');

  if (1) {
    $('body').append('<div id="MathPreview"></div> <div id="MathBuffer" style="visibility:hidden;"></div> ');
    injectScript = function(file) {
      var defer, s;
      defer = $.Deferred();
      s = document.createElement('script');
      s.src = chrome.extension.getURL(file);
      s.onload = function() {
        this.parentNode.removeChild(this);
        return defer.resolve();
      };
      (document.head || document.documentElement).appendChild(s);
      return defer;
    };
    injectScript('bower_components/jquery/dist/jquery.js').done(function() {
      return injectScript('js/content/insert.js');
    });
    editHandler = function(evt) {
      var $math, $target, code, offset;
      $target = $(evt.target);
      $math = $target.find('.section .math.active .content');
      if (evt.keyCode === 27) {
        $('#MathPreview, #MathBuffer').hide();
      } else if ($math.length && $target.is('.doc')) {
        code = $math.text();
        console.log('code: ', code);
        offset = $target.caret('offset');
        $('#MathPreview, #MathBuffer').show();
        $('#MathPreview, #MathBuffer').css({
          'top': offset.top + 120 - $(document).scrollTop()
        });
        if (code) {
          window.postMessage({
            type: "update",
            code: code
          }, "*");
        }
      } else {
        $('#MathPreview, #MathBuffer').hide();
      }
    };
    debouncedEditHandler = _.debounce(editHandler, 1000);
    $('html').keydown(debouncedEditHandler);
  }

}).call(this);
