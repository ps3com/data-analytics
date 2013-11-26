/* 	
$(document).ready(function(){
		//Hide (Collapse) the toggle containers on load
		$(".toggle_container").hide(); 
		$("div.trigger").addClass("jinactive");
		
		//Switch the "Open" and "Close" state per click
		$("div.trigger").toggle(function(){
			$(this).addClass("jactive");
			$(this).removeClass("jinactive");
			}, function () {
			$(this).addClass("jinactive");
			$(this).removeClass("jactive");
		});
	
		//Slide up and down on click
		$("div.trigger").click(function(){
			$(this).next().next(".toggle_container").slideToggle("slow");
		});
	});
 */	

initCollapseTables = function(viewId){
		//Hide (Collapse) the toggle containers on load
		$("div#toggle_container"+viewId).show(); 
		$("div#trigger"+viewId).addClass("jactive");
		
		//Switch the "Open" and "Close" state per click
		$("div#trigger"+viewId).toggle(function(){
			$(this).addClass("jinactive");
			$(this).removeClass("jactive");
			
			}, function () {
				$(this).addClass("jactive");
				$(this).removeClass("jinactive");
		});
	
		//Slide up and down on click
		$("div#trigger"+viewId).click(function(){
			$(this).next().next(".toggle_container").slideToggle("slow");
		});
	};

getCollapseCode = function(label, html, viewId){
		var markup='<div class="data table table-bordered table-condensed">';
		markup +=  '	<div id="trigger'+viewId+'" class="trigger jactive"></div>';
		markup +=  '	<div class="legend-name">'+label+'</div>';
		markup += '		<div id="toggle_container'+viewId+'" class="toggle_container" style="display: none;">';
		markup +='			<div class="block">';
		markup += html;
		markup += '			</div>';
		markup += '		</div>';
		markup += ' </div>';
		return markup;
 	}

function wait(tDiv){
	$('#'+tDiv).html("Searching, please wait");
}
