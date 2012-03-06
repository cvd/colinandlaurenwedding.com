(function($){

  $.fn.fancy = function(options){

    var defaults = {
      slideDuration: 500,
      slideEasing: "swing"
    };

    options = $.extend(defaults, options);

    var tabs = [ "welcome", "about-us", "our-story",
                    "ceremony-reception", "travel-info",
                    "registry"]

    function slide(element, event){
      event.preventDefault();
      $("#nav a").removeClass("active");
      var currentTab = element.attr("href").replace("#","");
      $("#nav ."+currentTab).addClass("active");
      animateView(currentTab);
    }

    // Updates the view with animation
    function animateView(currentTab){
      var tabIndex = indexOf(tabs, currentTab),
      windowWidth = $(window).width(),
      slideSize = (0 - tabIndex * windowWidth);

      $(".main .inner").animate({ marginLeft : slideSize },
        defaults.slideDuration,
        defaults.slideEasing,
        tabSwitched(currentTab)
      );
    }

    // Updates the view without the animation, used on pageload
    function updateView(currentTab){
      var tabIndex = indexOf(tabs, currentTab),
      windowWidth = $(window).width(),
      slideSize = (0 - tabIndex * windowWidth);
      $(".main .inner").css({ marginLeft : slideSize });
      tabSwitched(currentTab);
    }

    // indexOf util (because IE doesn't have Array#indexOf, thanks IE)
    function indexOf(arr, item){
      for(var i=0,l=arr.length;i<l;i++){
        if(arr[i] === item) return i;
      }
    }

    function tabSwitched(currentTab){
      // return function that has currentTab in its scope
      return function(){
        window.location.hash = "/" + currentTab;
        $(".section").css("height", "1px");
        $("#" + currentTab).css("height", "auto");
      }
    }

    //Bind controls
    $("#nav").delegate("a", "click", function(event){
      var element = $(this);
      slide(element, event);
    });

    (function(){
      //Load page to a specific section
      if(window.location.hash) {
        var currentTab = window.location.hash.replace(/#*\//g,"");
        updateView(currentTab);
        $("#nav a").removeClass("active");
        $("." + currentTab).addClass("active");
      }
      else {
        $(".section").css("height","1px");
        $("#welcome").css("height","auto");
      }
    })();

  };

})(jQuery);

//Instantiate plugin
$(document).ready(function() {
  $(document).fancy();
});
