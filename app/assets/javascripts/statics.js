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