<!-- aplGwoFooter -->
{def $ConversionPages	=	fetch( content, tree, hash( parent_node_id, 2,
													    class_filter_type, include,
												        class_filter_array, array('gwo_conversion'),
                                                        sort_by, array(priority, true()),
                                                   		limit, 1 ))
	
	$GWOExperiment = array()
    $GWOConversion = array()
    $GWOTrackerNumber = ''
    $GWOExperimentNumber = ''
    $GWOConversionType = ''
    $showConversionCode = false()
    $GWOConversionTimeOut = 0
    $showDebug = ''
}
 
{foreach $ConversionPages as $ConversionPage}
	{set $GWOConversion = $ConversionPage}
{/foreach}

{if ezhttp_hasvariable( 'gwodebug', 'get' )}
	{if eq(ezhttp( 'gwodebug', 'get' ),'on')}
    	{set $showDebug = true()}
    {/if} 
{/if}

{if $showDebug}
    <div style="background-color:#FFFF00; color:#333333;">
        <p>Conversion</p>
    </div>
{/if}      

{if $GWOConversion.data_map.experiment.has_content}
	{set $GWOExperiment = fetch(content,object,hash(object_id,$GWOConversion.data_map.experiment.content.id))}
    
    {*** If experiment is enabled ***}
    {if $GWOExperiment.data_map.enabled.content}
    	
        {*** Gets Experiment ID and Tracker Number ***}
        {set $GWOTrackerNumber = $GWOExperiment.data_map.google_tracking_id.data_text}
        {set $GWOExperimentNumber = $GWOExperiment.data_map.google_experiment_id.data_text}
         
        {set $GWOConversionType = $GWOConversion.data_map.type.data_text}
        
        {if $showDebug}
            <div style="background-color:#FFFF00; color:#333333;">
                <p>Experiment ID: {$GWOExperimentNumber} - TrackerNumber: {$GWOTrackerNumber} - Conversion Type: {$GWOConversionType}</p>
            </div>
        {/if}   
            
        {**** Switch experiment conversion ****}
        {switch match=$GWOConversionType}
            {case match='0'} 
                {set $showConversionCode = true()}
            {/case}
            {case match='1'} 
                {if $GWOConversion.data_map.time_limit.has_content}
                    {set $GWOConversionTimeOut = $GWOConversion.data_map.time_limit.data_text}
                    {include uri='design:aplgwo_conversion_time.tpl' time=$GWOConversionTimeOut}
                    {if $showDebug}
                        <div style="background-color:#FFFF00; color:#333333;">
                            <p>TimeOut: {$GWOConversionTimeOut}</p>
                        </div>
                    {/if} 
                {else}
                	<div style="background-color:#FFFF00; color:#333333;">
                        <p>Please select a conversion time.</p>
                    </div>
                {/if}    
            {/case}
            {case match='2'} 
                {if $GWOConversion.data_map.conversion_element_id.has_content}
                    {foreach $GWOConversion.data_map.conversion_element_id.content.cells as $conversionElement}
                        {include uri='design:aplgwo_evenListener.tpl' element=$conversionElement}
                    {/foreach}
                    {if $showDebug}
                        <div style="background-color:#FFFF00; color:#333333;">
                            <p>Conversion Element Id: {$conversionElement}</p>
                        </div>
                    {/if} 
                {else}
                	<div style="background-color:#FFFF00; color:#333333;">
                        <p>Please select a conversion element.</p>
                    </div>
                {/if}
            {/case}
        {/switch}
    {else}
    	<div style="background-color:#FFFF00; color:#333333;">
        	<p>This experimet is disabled.</p>
        </div>    
    {/if}
{/if}

{if $showConversionCode}
  {literal}
      <script type="text/javascript">
      if(typeof(_gat)!='object')document.write('<sc'+'ript src="http'+
      (document.location.protocol=='https:'?'s://ssl':'://www')+
      '.google-analytics.com/ga.js"></sc'+'ript>')</script>
      <script type="text/javascript">
      try {
      var pageTracker=_gat._getTracker("{/literal}{$GWOTrackerNumber}{literal}");
      pageTracker._trackPageview("/{/literal}{$GWOExperimentNumber}{literal}/goal");
      }catch(err){}</script>
  {/literal}
{/if}
<!-- aplGwoFooter : End -->
