(function($){

  $.fn.fancy = function(options){

    var defaults = {
      slideDuration: 500,
      slideEasing: "swing"
    };

    options = $.extend(defaults, options);

    this.each(function(){


      //Bind controls
      $("#nav").delegate("a", "click", function(event){
        element = $(this);
        slide(element, event);
      });

      //Functions
      function slide(element, event){
        event.preventDefault();
        $("#nav a").removeClass("active");
        currentTab = element.attr("href").replace("#","");
        $("#nav ."+currentTab).addClass("active");
        animate(currentTab);
      }

      function animate(currentTab){

        slideSize = 0;

        if(currentTab == "welcome") {
          slideSize = "0";
        }

        if(currentTab == "about-us") {
          slideSize = "-" + $(window).width() + "px";
        }

        if(currentTab == "our-story") {
          slideSize = "-" + $(window).width() * 2 + "px";
        }

        if(currentTab == "ceremony-reception") {
          slideSize = "-" + $(window).width() * 3 + "px";
        }

        if(currentTab == "travel-info") {
          slideSize = "-" + $(window).width() * 4 + "px";
        }
        if(currentTab == "registry") {
          slideSize = "-" + $(window).width() * 5 + "px";
        }

        $(".main .inner").animate({
          marginLeft : slideSize
        }, defaults.slideDuration, defaults.slideEasing, function(){
          window.location.hash = "/" + currentTab;
          $(".section").css("height","1px");
          $("#"+currentTab).css("height","auto");
        });


      }

      (function(){

        //Load page to a specific section
        if(window.location.hash) {
          currentTab = window.location.hash.replace(/#*\//g,"");
          animate(currentTab);
          $("#nav a").removeClass("active");
          $("." + currentTab).addClass("active");
        }
        else {
          $(".section").css("height","1px");
          $("#welcome").css("height","auto");
        }

      })();

    });

  };

})(jQuery);

//Instantiate plugin
$(document).ready(function() {
  $(document).fancy();
});
