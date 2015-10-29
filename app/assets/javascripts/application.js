// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require turbolinks

autosave_timeout = null
$(function () {
    enable_autosave();
});


function enable_autosave(form) {
    if (form != undefined) {
        form.find('input, textarea, select').on('change', function () {

            auto_submit_this($(this));
        });
    }

    else {
        $('form[data-autosave=true]').find('input, textarea, select').on('change', function () {
            auto_submit_this($(this));
        });
    }
}

function auto_submit_this(el) {
    can_submit = true;
    rel = el.attr('rel');
    $.each( $("input[rel=" + rel + "]"), function( key, value ) {
        if ($(this).val() == "") {
            can_submit = false;
        }
    });
    if(can_submit){
        clearTimeout(autosave_timeout);
        autosave_timeout = setTimeout(function () {
            //SHOW_LOADING = false;
            loadingContainer.show();
            if (el.submit())
                setTimeout(function () {
                    loadingContainer.hide();
                    //SHOW_LOADING = true;
                }, 500);
        }, 1);
    }
}