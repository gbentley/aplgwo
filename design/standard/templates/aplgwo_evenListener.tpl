{literal}
<script type="text/javascript">
function AddEventListener(element, eventType, handler, capture)
{
	if (element.addEventListener)
		element.addEventListener(eventType, handler, capture);
	else if (element.attachEvent)
		element.attachEvent("on" + eventType, handler);
}

window.onload = function()
{
	AddEventListener(document.getElementById("{/literal}{$element}{literal}"), "click", function(e)
	{
		ConversionCount();
		
		if (e.preventDefault) e.preventDefault();
		else e.returnResult = false;
		if (e.stopPropagation) e.stopPropagation();
		else e.cancelBubble = true;
	}, false);
};
</script>

<script type="text/javascript">
if(typeof(_gat)!='object')document.write('<sc'+'ript src="http'+
(document.location.protocol=='https:'?'s://ssl':'://www')+
'.google-analytics.com/ga.js"></sc'+'ript>')</script>

<script type="text/javascript">
<!--
function ConversionCount()
{
	//alert('set conversion');
	try {
	var pageTracker =_gat._getTracker("{/literal}{$GWOTrackerNumber}{literal}");
	pageTracker._trackPageview("/{/literal}{$GWOExperimentNumber}{literal}/goal");
	}catch(err){}
}
// -->
</script>



{/literal}