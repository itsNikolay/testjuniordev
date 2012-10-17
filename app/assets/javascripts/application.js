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
    slideShow();
});

function slideShow() {
    var slides = $('.carousel li');
    var previousIndex = 0, currentIndex = 0, timer;
    slides.hide().removeClass('is-showing').eq(currentIndex).show().addClass('is-showing');

    function nextSlide() {
        previousIndex = currentIndex;
        if(currentIndex < slides.length - 1) currentIndex++;
        else currentIndex = 0;
        switchSlides();
    }
    function prevSlide() {
        previousIndex = currentIndex;
        if(currentIndex < slides.length + 1) currentIndex--;
        else currentIndex = 0;
        switchSlides();
    }
    function switchSlides() {
        slides.eq(previousIndex).removeClass('is-showing').fadeOut(800, function(){
            slides.eq(currentIndex).addClass('is-showing').fadeIn(800);
            autoRotate();
        });
    }
    function autoRotate() {
        clearTimeout(timer);
        timer = setTimeout(nextSlide, 5000);
    }

    autoRotate();
    $(".next").click(nextSlide);
    $(".prev").click(prevSlide);
}