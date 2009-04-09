<!-- aplGwoHeader -->

{def $GWOTrackerNumber = ezini('ExperimentSettings','GWOTrackerNumber','aplgwo.ini') 
     $GWOExperimentNumber = ezini('ExperimentSettings','GWOExperimentNumber','aplgwo.ini') 
     $OriginalNodeID = ezini('ExperimentSettings','OriginalNodeID','aplgwo.ini') 
     $ConversionNodeID = ezini('ExperimentSettings','ConversionNodeID','aplgwo.ini') 
     $VariationNodeIDArray = ezini('ExperimentSettings','VariationNodeID','aplgwo.ini') 
     
     $CurrentNodeID = $module_result.node_id
}

{if eq($CurrentNodeID, $ConversionNodeID)}
<!-- Conversion Node --> 
{literal}<script type="text/javascript">
if(typeof(_gat)!='object')document.write('<sc'+'ript src="http'+
(document.location.protocol=='https:'?'s://ssl':'://www')+
'.google-analytics.com/ga.js"></sc'+'ript>')</script>
<script type="text/javascript">
try {
var pageTracker=_gat._getTracker("{/literal}{$GWOTrackerNumber}{literal}");
pageTracker._trackPageview("/{/literal}{$GWOExperimentNumber}{literal}/goal");
}catch(err){}</script>
{/literal}


{elseif eq($CurrentNodeID,$OriginalNodeID)}

<!-- Original GWO Footer Code -->
{literal}
<script type="text/javascript">
if(typeof(_gat)!='object')document.write('<sc'+'ript src="http'+
(document.location.protocol=='https:'?'s://ssl':'://www')+
'.google-analytics.com/ga.js"></sc'+'ript>')</script>
<script type="text/javascript">
try {
var pageTracker=_gat._getTracker("{/literal}{$GWOTrackerNumber}{/literal}");
pageTracker._trackPageview("/{/literal}{$GWOExperimentNumber}{literal}/test");
}catch(err){}</script>
{/literal}

{elseif $VariationNodeIDArray|contains($CurrentNodeID) }

<!--  Variation GWO Footer Code -->

{literal}<script type="text/javascript">
if(typeof(_gat)!='object')document.write('<sc'+'ript src="http'+
(document.location.protocol=='https:'?'s://ssl':'://www')+
'.google-analytics.com/ga.js"></sc'+'ript>')</script>
<script type="text/javascript">
try {
var pageTracker=_gat._getTracker("{/literal}{$GWOTrackerNumber}{literal}");
pageTracker._trackPageview("/{/literal}{$GWOExperimentNumber}{literal}/test");
}catch(err){}</script>
{/literal}
{/if}

<!-- aplGwoHeader : End -->
