// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require('jquery')


document.addEventListener("turbolinks:load", function() {
    var frm = $('#day_form');

    if (frm){
        frm.submit(function(e){
            // console.log('Okay');
            e.preventDefault();
            $.ajax({
                type: frm.attr('method'),
                url: frm.attr('action'),
                data: frm.serialize(),
                success: function (data) {
                    // alert('ok');
                    // alert(data);
                    $('#check_day').removeAttr('disabled');
                    // var head = document.head || document.getElementsByTagName("head")[0];
                    // head.innerText(data);
                    // $('html').html(data);
                    var dayDataStart = data.indexOf('dayData');
                    var drawDayStart = data.indexOf('function drawDay');
                    var dayDataNew = data.substring(dayDataStart+22,drawDayStart-7);
                    // alert(dayDataNew);
                    dayData = JSON.parse(dayDataNew);

                    // var startScript = data.lastIndexOf("<script");
                    // var endScript = data.lastIndexOf("</script>");
                    // var scriptString = data.substring(startScript+25,endScript);
                    // // alert(scriptString);
                    // $('#graphScript').html(scriptString);

                    var startTable = data.lastIndexOf("<table");
                    var endTable = data.lastIndexOf("</table>");
                    var tabletString = data.substring(startTable+36,endTable);
                    $('#day_table').html(tabletString);

                    $('#day_chart').empty();

                    // var startBody = data.indexOf("<body>");
                    // var endBody = data.indexOf("</body>");
                    // var bodyString = data.substring(startBody+6,endBody);
                    // $('body').html(bodyString);

                    drawDayChart();
                    // if(data) {
                    //     $('')
                    //     drawDayChart();
                    // }
                }
            });
        });
    }
});


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
