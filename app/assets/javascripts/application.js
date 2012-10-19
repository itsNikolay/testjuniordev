// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(document).ready(function() {
  PhotoSlider.init();
});

var PhotoSlider = {
    jThis: null,
    jSlides: null,
    jPrev: null,
    jNext: null,

    init: function() {
     this.jThis = $('.photo-slider');
     this.jSlides = $('.photo-slider .carousel li');
     this.jPrev = $('.photo-slider .prev');
     this.jNext = $('.photo-slider .next');

     this.previousIndex = 0;
     this.currentIndex = 0;

     this.jSlides.hide();
     this.jSlides.eq(this.currentIndex).show();

     this.jNext.click(this.nextSlide);
//     $(".prev").click(this.prevSlide);

     return true;
 },

    length: function() { return this.jSlides.length; },

    nextSlide: function() {
     //if (_this == undefined)
     var _this = PhotoSlider;

     _this.previousIndex = _this.currentIndex;

     if (_this.currentIndex < _this.length() - 1)
         _this.currentIndex++;
     else
         _this.currentIndex = 0;

     _this.switchSlides();
     return true;
 },
    prevSlide: function() {
        previousIndex = currentIndex;
        if(currentIndex < slides.length + 1) currentIndex--;
        else currentIndex = 0;
        switchSlides();
        return true;
    },

    switchSlides: function() {
        this.jSlides.eq(this.currentIndex).fadeIn(800);
        this.jSlides.eq(this.previousIndex).fadeOut(800);
        return true;
    }

};
//
//
//photoslider.init = function() {
//    var slides = $('.carousel li');
//    var previousIndex = 0, currentIndex = 0;
//    slides.hide();
//    slides.eq(currentIndex).show();
//
//    function nextSlide() {
//
//        previousIndex = currentIndex;
//
//        if (currentIndex < slides.length - 1)
//            currentIndex++;
//        else
//            currentIndex = 0;
//
//        switchSlides();
//    }
//    function prevSlide() {
//        previousIndex = currentIndex;
//        if(currentIndex < slides.length + 1) currentIndex--;
//        else currentIndex = 0;
//        switchSlides();
//    }
//    function switchSlides() {
//        slides.eq(currentIndex).fadeIn(800);
//        slides.eq(previousIndex).fadeOut(800);
//    }
//
//    $(".next").click(nextSlide);
//    $(".prev").click(prevSlide);
//}