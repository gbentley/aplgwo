function AddEventListener(element, eventType, handler, capture)
{
	if (element.addEventListener)
		element.addEventListener(eventType, handler, capture);
	else if (element.attachEvent)
		element.attachEvent("on" + eventType, handler);
}

window.onload = function()
{
	AddEventListener(document.getElementById("buttonRegister"), "click", function(e)
	{
		alert('click');
		
		ConversionCount();
		
		if (e.preventDefault) e.preventDefault();
		else e.returnResult = false;
		if (e.stopPropagation) e.stopPropagation();
		else e.cancelBubble = true;
	}, false);
};
