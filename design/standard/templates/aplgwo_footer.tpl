{def $ConversionPages	=	fetch( content, tree, hash( parent_node_id, 2,
													    class_filter_type, include,
												        class_filter_array, array('gwo_conversion'),
                                                        sort_by, array(priority, true()),
                                                   		limit, 1 ))
	
	$GWOConversion = array()
    $GWOCOnversionUrls = array()
    $GWOConversionNode = ''
    $isConversion = false()
    $showDebug = false()
}

{if ezhttp_hasvariable( 'gwodebug', 'get' )}
	{if eq(ezhttp( 'gwodebug', 'get' ),'on')}
    	{set $showDebug = true()}
    {/if} 
{/if}

{if gt($ConversionPages|count,0)}
  {foreach $ConversionPages as $ConversionPage}
      {set $GWOConversion = $ConversionPage}
  {/foreach}
  
  {** Check for conversion pages in object relation **}
  {if $GWOConversion.data_map.conversion_objects.has_content} 
  	  {foreach $GWOConversion.data_map.conversion_objects.content.relation_list as $obj}
      	{set $GWOConversionNode = fetch(content,node,hash(node_id,$obj.node_id))}
        {** Determines current page type test/conversion**}
        {if $module_result.uri|contains($GWOConversionNode.url_alias)} 
        	{set $isConversion = true()}
            {break} 	
        {/if}
      {/foreach}
  {/if}     
  
  {** Check for conversion pages in page attrribute  **}
  {if $GWOConversion.data_map.conversion_pages.has_content} 
  	  {foreach $GWOConversion.data_map.conversion_pages.content.cells as $conversionUrl}
        {*** To prevent bug in package import ***} 
      	{if ne($conversionUrl,'')} 
          {** Determines current page type test/conversion**}
          {if $module_result.uri|contains($conversionUrl)} 
        	{set $isConversion = true()}
            {break} 	
          {/if}    
        {/if}
      {/foreach}
  {/if}
  
  {** Determines current page type test/conversion**}
  
  {if $isConversion}
      {include uri='design:aplgwo_conversion.tpl' showDebug=$showDebug}
  {else}
      {include uri='design:aplgwo_tracking.tpl' showDebug=$showDebug}
  {/if}
          
{/if}
{undef}
