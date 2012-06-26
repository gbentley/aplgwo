{def $GWOExperiment = array()
     $GWOTrackerNumber = ''
     $GWOExperimentNumber = ''
     $showTrackerCode = false()
     $SitewideTest = ''
     $GWOtestPage = ''
     $GWOABVariations = array()
     $showDebug = false()
     $variation = ''
    
}

{if ezhttp_hasvariable( 'gwodebug', 'get' )}
	{if eq(ezhttp( 'gwodebug', 'get' ),'on')}
    	{set $showDebug = true()}
    {/if} 
{/if}

{*** Get Related experiment ***}
{if $GWOConversion.data_map.experiment.has_content}
	{set $GWOExperiment = fetch(content,object,hash(object_id,$GWOConversion.data_map.experiment.content.id))}
    
    {*** If experiment is enabled ***}
    {if $GWOExperiment.data_map.enabled.content}
    	
        {*** Gets Experiment ID and Tracker Number ***}
        {set $GWOTrackerNumber = $GWOExperiment.data_map.google_tracking_id.data_text}
        {set $GWOExperimentNumber = $GWOExperiment.data_map.google_experiment_id.data_text}
         
       
        {**** Check experiment type ****}
        {if eq($GWOExperiment.class_identifier,'gwo_multivariate_experiment')}
        	{set $SitewideTest = $GWOExperiment.data_map.sitewide_experiment.content}
            
            {**** Check sitewide condition *****}
            {if $SitewideTest} {** Sitewide Multivariate Test **}
            	{set $showTrackerCode = true()}    
            {else}
            	{*** Determines if the current page is a test page ***}
                  
              	{set $GWOtestPage = concat('/',$GWOExperiment.data_map.experiment_object.content.main_node.url_alias)}
              	{if eq($GWOtestPage,$module_result.uri)}
                    {set $showHeaderTrackCode = true()} 
              	{/if}
              
              	{foreach $GWOExperiment.data_map.gwo_experiment_page.content.cells as $testUrl}
                  {if ne($testUrl,'')}
                    {if eq($module_result.uri,$testUrl)}
                        {set $showTrackerCode = true()} 
                        {break}
                    {/if}
                  {/if}
              	{/foreach}
            {/if}
        {elseif eq($GWOExperiment.class_identifier,'gwo_ab_experiment')}
        	{if $showDebug}
                <div style="background-color:#FFFF00; color:#333333;">
                    <p>AB Test Footer</p>
                </div>
            {/if}
            
            {**** Get AB Test Original page ***}
            {if $GWOExperiment.data_map.ab_original_object.has_content}
            	{set $GWOtestPage = concat('/',$GWOExperiment.data_map.ab_original_object.content.main_node.url_alias)}
                {if $showDebug}
                    <div style="background-color:#FFFF00; color:#333333;">
                        <p>Original page set by object</p>
                    </div>
                {/if}
            {else}
            	{set $GWOtestPage = $GWOExperiment.data_map.ab_original_page.data_text}
                {if $showDebug}
                    <div style="background-color:#FFFF00; color:#333333;">
                        <p>Original page set by url</p>
                    </div>
                {/if}
            {/if}
            	    
            {if ne($GWOtestPage,'')}
                {*** Determines if the current page is a test page ***}
                {if eq($GWOtestPage,$module_result.uri)}
                    {if $showDebug}
                        <div style="background-color:#FFFF00; color:#333333;">
                            <p>This is the original AB test page.</p>
                        </div>
                    {/if}
                    {set $showTrackerCode = true()} 
                {/if}
            {/if}
            
            
            {*** Determines if the current page is an A/B test page ***}
            {**** Get AB variations pages ***}
            {if $GWOExperiment.data_map.ab_variation_objects.has_content}
                {foreach $GWOExperiment.data_map.ab_variation_objects.content.relation_list as $obj}
                	{set $variation = fetch( 'content', 'node', hash( 'node_id', $obj.node_id ) )} 
                    {set $GWOABVariations = $GWOABVariations|append(concat('/',$variation.url_alias))}
                {/foreach}
            {/if}
            
            {if $GWOExperiment.data_map.ab_variation_pages.has_content}
            	{foreach $GWOExperiment.data_map.ab_variation_pages.content.cells as $page}
                	{if ne($page,'')}
                    	{set $GWOABVariations = $GWOABVariations|append($page)}
                    {/if}
                {/foreach}
            {/if}
            
            {*** Determines if the current page is an A/B test page ***}
            {foreach $GWOABVariations as $testUrl}
            	{if eq($module_result.uri,$testUrl) }
                	{set $showTrackerCode = true()} 
                    {break}
                {/if}	
            {/foreach}
        {/if}
    {else}
    	<div style="background-color:#FFFF00; color:#333333;">
        	<p>This experimet is disabled.</p>
        </div>    
    {/if}
{else}
	<div style="background-color:#FFFF00; color:#333333;">
        <p>You have to choose an experiment to relate to the conversion object.</p>
    </div>     
{/if}

<!-- aplGwoTrackingCode -->
{if $showTrackerCode}
  {if $showDebug}
       <div style="background-color:#FFFF00; color:#333333;">
           <p>Footer Tracking code on</p>
       </div>
  {/if}     
  {literal}
	<!-- Tracking Conversion script --> 
	<script type="text/javascript">
    if(typeof(_gat)!='object')document.write('<sc'+'ript src="http'+
    (document.location.protocol=='https:'?'s://ssl':'://www')+
    '.google-analytics.com/ga.js"></sc'+'ript>')</script>
    <script type="text/javascript">
    try {
    var pageTracker=_gat._getTracker("{/literal}{$GWOTrackerNumber}{literal}");
    pageTracker._trackPageview("/{/literal}{$GWOExperimentNumber}{literal}/test");
    }catch(err){}</script>
    <!-- End Tracking Conversion script --> 
  {/literal}
{else}
	{if $showDebug}
       <div style="background-color:#FFFF00; color:#333333;">
           <p>Footer Tracking code off</p>
       </div>
    {/if}     
{/if}
<!-- aplGwoFooter : End -->
