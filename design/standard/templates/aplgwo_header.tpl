{def $ConversionPages	=	fetch( content, tree, hash( parent_node_id, 2,
													    class_filter_type, include,
												        class_filter_array, array('gwo_conversion'),
                                                        sort_by, array(priority, true()),
                                                   		limit, 1 ))
    
	$GWOConversion = array()
    $GWOExperiment = array()
    $GWOABVariations = array()
    $isMV = False()
    $isAB = false()
    $showHeaderTrackCode = false()
    $GWOTrackerNumber = ''
    $GWOExperimentNumber = ''
    $OriginalNodeID = ''
    $VariationNodeIDArray = ''
    $SitewideTest = ''
	$CurrentNodeID = ''
	$header_variation = ''
    $experimentIsEnabled = ''
    $isTestPage = false()
    $GWOtestPage = ''
    $showDebug = false()
    $variation = ''
}

{if ezhttp_hasvariable( 'gwodebug', 'get' )}
	{if eq(ezhttp( 'gwodebug', 'get' ),'on')}
    	{set $showDebug = true()}
    {/if} 
{/if}

{if gt($ConversionPages|count,0)}
    {***** Get Conversion Object ***}
    {foreach $ConversionPages as $ConversionPage}
        {set $GWOConversion = $ConversionPage}
    {/foreach}
    
    {*** Get Related experiment ***}
    {if $GWOConversion.data_map.experiment.has_content}
        {set $GWOExperiment = fetch(content,object,hash(object_id,$GWOConversion.data_map.experiment.content.id))}
    {/if}    

	{set $experimentIsEnabled = $GWOExperiment.data_map.enabled.content}
    
    {if $experimentIsEnabled}
    	
        {* $GWOExperiment|attribute(show,1) *}
        
        {*** Gets Experiment ID and Tracker Number ***}
        {set $GWOTrackerNumber = $GWOExperiment.data_map.google_tracking_id.data_text}
        {set $GWOExperimentNumber = $GWOExperiment.data_map.google_experiment_id.data_text}
        
        {**** Check experiment type ****}
        {if eq($GWOExperiment.class_identifier,'gwo_multivariate_experiment')}
            
            {set $SitewideTest = $GWOExperiment.data_map.sitewide_experiment.content}
            
            {**** Check sitewide condition *****}
            {if $SitewideTest} {** Sitewide Multivariate Test **}
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
                
                {set $header_variation = $GWOExperiment.data_map.header_page_sections.content}
                <!-- GWO Custom Styles -->
                {foreach $header_variation.cells as $zone}
                    {literal}
                    <script>utmx_section("{/literal}{$zone}{literal}")</script>
                        <style type="text/css"><!-- Css variation here --></style>
                    </noscript>
                    {/literal}			
                {/foreach}
                <!-- End GWO Custom Styles -->
                {if $showDebug}
                    <div style="background-color:#FFFF00; color:#333333;">
                        <p>Multivariate Sitewide Experiment - Enabled - Variations {$header_variation.cells|count}</p>
                    </div>
                {/if}
            {else} {** Normal Multivariate Test **}
                {** Determines if the current page is a test page **}
                
                {if $GWOExperiment.data_map.experiment_object.has_content}
            		{set $GWOtestPage = concat('/',$GWOExperiment.data_map.experiment_object.content.main_node.url_alias)}
                    {if eq($GWOtestPage,$module_result.uri)}
                        {set $showHeaderTrackCode = true()} 
                    {/if}
                {/if}
                
                {foreach $GWOExperiment.data_map.gwo_experiment_page.content.cells as $testUrl}
                    {if ne($testUrl,'')}
                    	{if eq($testUrl,$module_result.uri)}
                        	{set $showHeaderTrackCode = true()} 
                        	{break}
                        {/if}
                    {/if}
                {/foreach}
                
                {*** Determines if the current page is the conversion page ***}
                {foreach $GWOConversion.data_map.conversion_pages.content.cells as $testUrl}
                    {if eq($module_result.uri,$testUrl)}
                        {set $showHeaderTrackCode = true()} 
                        {break}
                     {/if}
                {/foreach}
                
                {set $isMV = true()}
                
                {if $showDebug}
                    <div style="background-color:#FFFF00; color:#333333;">
                        <p>Multivariate Normal Experiment - Enabled</p>
                    </div>
                {/if}
            {/if}    	
        {elseif eq($GWOExperiment.class_identifier,'gwo_ab_experiment')}
            
            {**** Get AB Test Original page ***}
            {if $GWOExperiment.data_map.ab_original_object.has_content}
            	{set $GWOtestPage = concat('/',$GWOExperiment.data_map.ab_original_object.content.main_node.url_alias)}
            {else}
            	{set $GWOtestPage = $GWOExperiment.data_map.ab_original_page.data_text}
            {/if}
            	    
            {if ne($GWOtestPage,'')}
                {*** Determines if the current page is a test page ***}
                {if eq($GWOtestPage,$module_result.uri)}
                    {set $showHeaderTrackCode = true()}
                {/if}
            {else}    
                <div style="background-color:#FFFF00; color:#333333;">
                    <p>Please set the original AB Test page.</p>
                </div>
            {/if}
            
            
            {set $isAB = true()}
            
            {if $showDebug}
                <div style="background-color:#FFFF00; color:#333333;">
                    <p>AB Experiment - Enabled</p>
                </div>
            {/if}
        {/if}    
    {/if}    
{/if}

{***** Displays Control Script *****}
<!-- aplGwoHeader -->
{if $showHeaderTrackCode}
    {if $showDebug}
       <div style="background-color:#FFFF00; color:#333333;">
           <p>Header Tracking code on</p>
       </div>
    {/if}     
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
    {if $isAB}
    	<script>utmx("url",'A/B');</script>
    {/if}
    {if $isMV}
    	<!-- GWO Custom Styles -->
        {foreach $GWOExperiment.data_map.header_page_sections.content.cells as $zone}
            {literal}
            <script>utmx_section("{/literal}{$zone}{literal}")</script>
                <style type="text/css"><!-- Css variation here --></style>
            </noscript>
            {/literal}			
        {/foreach}
        <!-- End GWO Custom Styles -->	
    {/if}
{else}
	{if $showDebug}
       <div style="background-color:#FFFF00; color:#333333;">
           <p>Header Tracking code off</p>
       </div>
    {/if}     
{/if}
<!-- aplGwoHeader : End -->
