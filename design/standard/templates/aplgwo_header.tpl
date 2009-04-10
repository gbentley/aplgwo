<!-- aplGwoHeader -->

{def $GWOTrackerNumber = ezini('ExperimentSettings','GWOTrackerNumber','aplgwo.ini') 
     $GWOExperimentNumber = ezini('ExperimentSettings','GWOExperimentNumber','aplgwo.ini') 
     $OriginalNodeID = ezini('ExperimentSettings','OriginalNodeID','aplgwo.ini') 
     $ConversionNodeID = ezini('ExperimentSettings','ConversionNodeID','aplgwo.ini') 
     $VariationNodeIDArray = ezini('ExperimentSettings','VariationNodeID','aplgwo.ini')
     $SitewideTest = ezini('ExperimentSettings','SitewideTest','aplgwo.ini') 
     
     $CurrentNodeID = $module_result.node_id
}

{if eq($CurrentNodeID, $ConversionNodeID)}
 <!-- Conversion Node --> 

{elseif eq($CurrentNodeID,$OriginalNodeID)}
 <!-- Original GWO Code -->
{literal}
<script>
function utmx_section(){}function utmx(){}
(function(){var k='{/literal}{$GWOExperimentNumber}{literal}',d=document,l=d.location,c=d.cookie;function f(n){
if(c){var i=c.indexOf(n+'=');if(i>-1){var j=c.indexOf(';',i);return c.substring(i+n.
length+1,j<0?c.length:j)}}}var x=f('__utmx'),xx=f('__utmxx'),h=l.hash;
d.write('<sc'+'ript src="'+
'http'+(l.protocol=='https:'?'s://ssl':'://www')+'.google-analytics.com'
+'/siteopt.js?v=1&utmxkey='+k+'&utmx='+(x?x:'')+'&utmxx='+(xx?xx:'')+'&utmxtime='
+new Date().valueOf()+(h?'&utmxhash='+escape(h.substr(1)):'')+
'" type="text/javascript" charset="utf-8"></sc'+'ript>')})();
</script><script>utmx("url",'A/B');</script>
{/literal}


{/if}



	
{if eq($SitewideTest,'true')}
{literal}
<script>
function utmx_section(){}function utmx(){}
(function(){var k='{/literal}{$GWOExperimentNumber}{literal}',d=document,l=d.location,c=d.cookie;function f(n){
if(c){var i=c.indexOf(n+'=');if(i>-1){var j=c.indexOf(';',i);return c.substring(i+n.
length+1,j<0?c.length:j)}}}var x=f('__utmx'),xx=f('__utmxx'),h=l.hash;
d.write('<sc'+'ript src="'+
'http'+(l.protocol=='https:'?'s://ssl':'://www')+'.google-analytics.com'
+'/siteopt.js?v=1&utmxkey='+k+'&utmx='+(x?x:'')+'&utmxx='+(xx?xx:'')+'&utmxtime='
+new Date().valueOf()+(h?'&utmxhash='+escape(h.substr(1)):'')+
'" type="text/javascript" charset="utf-8"></sc'+'ript>')})();
</script>
{/literal}


	{include uri='design:aplgwo_sitewide.tpl'}
	
 	<!-- GWO Custom Styles -->
	
	  <script>utmx_section("sitewide_styles")</script>
	  <style type="text/css">
	  <!-- include custom styles here eg. h1, b-->
	  </style> 
	  </noscript>
	  
	 
	  
	{include uri='design:aplgwo_custom_styles.tpl'}
{/if}
	
	<!-- End GWO Custom Styles -->


<!-- aplGwoHeader : End -->
