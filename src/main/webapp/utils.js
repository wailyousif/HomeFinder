/**
 * Created by wailm.yousif on 3/17/17.
 */
function create_Relocate_Button(map)
{
    //map.getUiSettings().setMyLocationButtonEnabled(true);
    var centerControlDiv = document.createElement('div');
    //var centerControl = new CenterControl(centerControlDiv, map);

    var controlUI = document.createElement('div');
    //controlUI.style.backgroundColor = '#fff';
    controlUI.style.border = '2px solid #fff';
    controlUI.style.borderRadius = '3px';
    controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
    controlUI.style.cursor = 'pointer';
    controlUI.style.marginBottom = '22px';
    controlUI.style.textAlign = 'center';
    controlUI.title = 'Click to recenter the map';
    centerControlDiv.appendChild(controlUI);

    var controlText = document.createElement('div');
    controlText.style.color = 'rgb(25,25,25)';
    controlText.style.fontFamily = 'Roboto,Arial,sans-serif';
    controlText.style.fontSize = '16px';
    controlText.style.lineHeight = '38px';
    controlText.style.paddingLeft = '5px';
    controlText.style.paddingRight = '5px';
    controlText.innerHTML = 'Re-locate';
    controlUI.appendChild(controlText);

    centerControlDiv.index = 1;
    map.controls[google.maps.ControlPosition.RIGHT_TOP].push(centerControlDiv);

    return controlUI;
}


function create_LatLng_Div(map)
{
    var centerControlDiv = document.createElement('div');

    var controlUI = document.createElement('div');
    controlUI.style.textAlign = 'left';
    centerControlDiv.appendChild(controlUI);

    var controlText = document.createElement('div');
    controlText.style.color = 'rgb(25,25,25)';
    //controlText.style.fontFamily = 'Roboto,Arial,sans-serif';
    controlText.style.fontFamily = 'courier';
    controlText.style.fontSize = '11px';
    controlUI.appendChild(controlText);

    centerControlDiv.index = 1;
    map.controls[google.maps.ControlPosition.LEFT_TOP].push(centerControlDiv);

    return controlText;
}


function checked(controlId)
{
    var ctrl = document.getElementById(controlId);
    if (ctrl.checked)
        return true;
    return false;
}


function moneyToNumber(monetaryValue)
{
    var monetaryValueWoDollarSign = monetaryValue.replace('$', '');
    var strNumericValue = monetaryValueWoDollarSign.replace(/,/gi, "");

    if (strNumericValue === '')
        strNumericValue = '0';

    var numericValue = Number(strNumericValue);
    return numericValue;
}


function numberToMoney(currentValue)
{
    var strNumericValue = '';

    if (typeof currentValue == "string")
    {
        var currentValueWoDollarSign = currentValue.replace('$', '');
        strNumericValue = currentValueWoDollarSign.replace(/,/gi, '');
    }
    else if (typeof currentValue == "number")
    {
        strNumericValue = currentValue.toString();
    }

    var digitGrouped = '$';
    if (strNumericValue !== '')
    {
        var numericValue = Number(strNumericValue);
        digitGrouped = digitGrouped + numericValue.toLocaleString();
    }

    return digitGrouped;
}


function getPropTypeBinary()
{
    var ctrl = document.getElementById('propType');
    var options = ctrl.options;
    var propTypeBinary = 0;
    for (var i=0; i < options.length; i++)
    {
        if (options[i].selected)
        {
            if (options[i].value === 'STUDIO')
                propTypeBinary |= 1;
            else if (options[i].value === 'APARTMENT')
                propTypeBinary |= 2;
            else if (options[i].value === 'HOUSE')
                propTypeBinary |= 4;
        }
    }
    return propTypeBinary;
}