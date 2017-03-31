/**
 * Created by wailm.yousif on 3/16/17.
 */
function GMapOverlay(latlng, map, args) {
    this.latlng = latlng;
    this.args = args;
    this.setMap(map);

    this.infoWin = null;
    this.infoWinOpened = 0;
}

GMapOverlay.prototype = new google.maps.OverlayView();

GMapOverlay.prototype.draw = function() {

    var self = this;

    var div = this.div;

    if (!div) {

        div = this.div = document.createElement('div');

        div.className = self.args.class_name;

        div.style.position = 'absolute';
        div.style.cursor = 'pointer';
        div.style.background = self.args.background_color;
        div.style.color = self.args.font_color;
        div.style.fontSize = '130%';

        if (self.args.class_name === 'property')
        {
            div.innerHTML = self.args.price;
        }
        else if (self.args.class_name === 'place')
        {
            div.innerHTML = self.args.place_type_abbr;
        }
        div.innerHTML = div.innerHTML + '&nbsp;';    //space for readability

        div.style.border = '3px solid #fff';
        div.style.zIndex = '5';

        if (typeof(self.args.object_id) !== 'undefined') {
            div.dataset.object_id = self.args.object_id;
        }

        google.maps.event.addDomListener(div, "mouseover", function(event) {
            div.style.zIndex = '10';
            /*
            if (self.args.class_name === 'property')
            {
                div.style.zIndex = '10';
            }
            else
            {
                div.style.zIndex = '9';
            }
            */
        });

        google.maps.event.addDomListener(div, "mouseout", function(event) { div.style.zIndex = '5'; });

        var panes = this.getPanes();
        panes.overlayImage.appendChild(div);

        google.maps.event.addDomListener(div, "click", function(event) {

            if (!self.infoWin)
            {
                self.infoWin = new google.maps.InfoWindow();
                if (self.args.class_name === 'property')
                {
                    self.infoWin.setContent('<br /><div id="\'' + self.args.object_id + '\'" onmouseover="showUp(\'' + self.args.object_id + '\')" onmouseout="hideBelow(\'' + self.args.object_id + '\')">' +
                        self.args.property_name + '<br />' +
                        self.args.address + '<br /><br /><img src=\'' + self.args.pic +
                        '\' style=\'width: 70%\' /><br />' +
                        'Rooms:' + self.args.rooms + '&nbsp;&nbsp;&nbsp;' + 'Baths:' + self.args.baths + '<br />' +
                        '<br />' +
                        self.args.contactName + '<br />' + self.args.contactPhone + '<br />' +
                        '<a href="mailto:' + self.args.contactEmail + '" target="_top">' + self.args.contactEmail + '</a>' +
                        '</div>');
                }
                else if (self.args.class_name === 'place')
                {
                    self.infoWin.setContent('<div>' + self.args.place_type + '<br />' +
                        self.args.place_name + '<br />Rating:' + self.args.place_rating +
                        '</div>');
                }
                self.infoWin.setPosition(self.latlng);
                self.infoWin.open(self.map);
                self.infoWinOpened = 1;
                //self.infoWin.style.zIndex = '5';


                if (self.args.class_name === 'property')
                {
                    showPlaces(self.args.object_index);
                }


                /*
                google.maps.event.addListener(self.infoWin,'mouseover',function(){
                    alert('came to mouseover');
                    self.infoWin.style.zIndex = '10';
                });

                google.maps.event.addListener(self.infoWin,'mouseout',function(){
                    alert('came to mouseout');
                    self.infoWin.style.zIndex = '5';
                });
                */

                google.maps.event.addListener(self.infoWin,'closeclick',function(){
                    self.infoWin.close();
                    self.infoWin = null;
                    self.infoWinOpened = 0;
                });

                google.maps.event.addListener(self.infoWin,'close',function(){
                    self.infoWin.close();
                    self.infoWin = null;
                    self.infoWinOpened = 0;
                });

            }
        });

    }
    else
    {
        div.style.background = self.args.background_color;
        div.style.color = self.args.font_color;
    }

    var point = this.getProjection().fromLatLngToDivPixel(this.latlng);

    if (point) {
        div.style.left = (point.x - div.clientWidth/2) + 'px';
        div.style.top = (point.y - div.clientHeight/2) + 'px';
    }
};


GMapOverlay.prototype.onRemove = function() {
    if (this.div) {
        this.div.parentNode.removeChild(this.div);
        this.div = null;
    }

    //if (this.infoWinOpened == 1)
    if (this.infoWin)
    {
        this.infoWin.close();
        this.infoWin = null;
        this.infoWinOpened = 0;
    }
};

GMapOverlay.prototype.getPosition = function() {
    return this.latlng;
};

function showUp(controlId)
{
    /*
    alert('came showUp for ' + controlId);
    var elem = document.getElementById(controlId);
    elem.style.zIndex = 100;
    */
    /*
    self.infoWin.close();
    this.infoWin = null;
    self.infoWin.open(self.map);
    */
}

function hideBelow(controlId)
{
    /*
    alert('came hideBelow for ' + controlId);
    var elem = document.getElementById(controlId);
    elem.style.zIndex = 5;
    */
}