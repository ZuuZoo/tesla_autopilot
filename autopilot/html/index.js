$(function() {
    function display(bool) {
        if (bool) {
            $("body").show();
        } else {
            $("body").hide();
        }        
    }
    display(false)

    window.addEventListener("message", function(event) {
        var item = event.data;
        if(item.type == "ui"){        
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }         
        }
        if(item.type == "angleinfo"){     
            if(item.angle > 0) {
                var c = document.getElementById("canvas");
                var ctx = c.getContext("2d");
                ctx.save();
                ctx.clearRect(0, 0, c.width, c.height);
                ctx.beginPath();
                ctx.moveTo(780+item.angle*1.1, 20+(item.angle*-1)/3);
                ctx.quadraticCurveTo(465-(item.angle*-1)/5, 350+(item.angle*-1)/5, 125, 700);
                ctx.strokeStyle = '#e6e6e6';
                ctx.lineWidth = 7;
                ctx.stroke();
                ctx.restore();       
                var d = document.getElementById("canvas2");
                var ctxd = d.getContext("2d");
                ctxd.save();
                ctxd.clearRect(0, 0, c.width, c.height);
                ctxd.beginPath();
                ctxd.moveTo(260+item.angle*1.1, 20+(item.angle)/3);
                ctxd.quadraticCurveTo(600+(item.angle*-1)/10, 350-(item.angle*-1)/5, 995, 700);        
                ctxd.strokeStyle = '#e6e6e6';
                ctxd.lineWidth = 7;
                ctxd.stroke();  
                ctxd.restore();
            } 
            if(item.angle < 0) {
                var c = document.getElementById("canvas");
                var ctx = c.getContext("2d");
                ctx.save();
                ctx.clearRect(0, 0, c.width, c.height);
                ctx.beginPath();
                ctx.moveTo(780+item.angle*1.1, 20+(item.angle*-1)/2.1);
                ctx.quadraticCurveTo(480+(item.angle*-1)/5, 350+(item.angle*-1)/5, 125, 700);
                ctx.strokeStyle = '#e6e6e6';
                ctx.lineWidth = 7;
                ctx.stroke();
                ctx.restore();       
                var d = document.getElementById("canvas2");
                var ctxd = d.getContext("2d");
                ctxd.save();
                ctxd.clearRect(0, 0, c.width, c.height);
                ctxd.beginPath();
                ctxd.moveTo(260+item.angle*1.1, 20+(item.angle)/3);
                ctxd.quadraticCurveTo(600+(item.angle*-1)/10, 350-(item.angle*-1)/5, 995, 700);        

                ctxd.strokeStyle = '#e6e6e6';
                ctxd.lineWidth = 7;
                ctxd.stroke();  
                ctxd.restore();
            }          
        }
        
    })     

})