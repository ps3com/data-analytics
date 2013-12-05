var isfirst = true;

/*
var tableInputBinding = new Shiny.InputBinding();
  $.extend(tableInputBinding, {
    find: function(scope) {
    	console.log(scope)
    	//alert(scope)
     // return scope.find('.handsonTable-output');
    },
    getValue: function(el) {

      var data_encoded = $(el).handsontable('getData');
      return JSON.stringify(data_encoded);
    },
    setValue: function(el) {
    
    },
    subscribe: function(el, callback) {
      $(el).on('change.tableInputBinding', function(e) { callback(); });
    },
    unsubscribe: function(el) {
      $(el).off('.tableInputBinding')
    }
  });
  Shiny.inputBindings.register(tableInputBinding);
*/

/*
var inputBinding = new Shiny.InputBinding();
  $.extend(inputBinding, {
    find: function(scope) {
    //	console.log(scope)
    	//alert(scope)
     // return scope.find('.handsonTable-output');
    },
    getValue: function(el) {

      var data_encoded = $(el).handsontable('getData');
      return JSON.stringify(data_encoded);
    },
    setValue: function(el) {
    
    },
    subscribe: function(el, callback) {
      $(el).on('change.tableInputBinding', function(e) { callback(); });
    },
    unsubscribe: function(el) {
      $(el).off('.tableInputBinding')
    }
  });
  Shiny.inputBindings.register(inputBinding);
*/

var bookmarksOutputBinding = new Shiny.OutputBinding();
  $.extend(bookmarksOutputBinding, {
    find: function(scope) {
      return scope.find('.bookmarkDataset-output');
    },
    renderValue: function(el, data) {
    	$('.bookmarkTermsDataset-output').css('visibility','hidden');
    	if(data=='null'){
    		return;
    	}
    	// hide the previous bookmarks topics

    	var text = '<table class="data table table-bordered table-condensed">';
    	text +='<tbody>';
    	
    	if ((data.split("[").length - 1) == 1){
    		data = "[" + data + "]"
    	} 
    	
    	var bookmarks = jQuery.parseJSON(data);
    	
    	//console.log(bookmarks)
    	
    	$.each(bookmarks, function() {
    		$desc = "";
    		$url = "";
    		//console.log("\nthis[0]="+this[0] + "\nthis=" +this+"\nthis[1]="+this[1]);
       		if(this[0]==""){
    			$url =  '<div class="item-error">' + "No URL set in data" + '</div>'; 
    		}else{
    			$url = '<div class=""><a target="new" href="'+ this[0] + '">'+ this[0] + '</a></div>'; 
    		}
    		if(this[1]==""){
    			$desc = '<div class="item-warning">' + "No description given for URL" + '</div>'; 
    		}else{
    			$desc = '<div class="">' + this[1] + '</div>'; 
    		}
    		text +=  '<tr>';
    		text += '	<td>';
    		text += $desc;
    		text += $url;
    	    text += '	</td>';
    		text += '</tr>';
        });
    	text += '</table>';
    	
    	var m = getCollapseCode("Bookmarked locations", text, "bookmarkDataset-output");
    	
    	$(el).html(m);
    	initCollapseTables("bookmarkDataset-output");
    	$('#bookmarkvisuals').css('visibility','hidden');
    }
  });

Shiny.outputBindings.register(bookmarksOutputBinding, "bookmarkDataset-output");


var bookmarkTermsOutputBinding = new Shiny.OutputBinding();
$.extend(bookmarkTermsOutputBinding, {
  find: function(scope) {
    return scope.find('.bookmarkTermsDataset-output');
  },
  renderValue: function(el, data) {

  		//if ((data.split("[").length - 1) == 1){
  			//data = "[" + data + "]"
  		//}
	  //console.log("raw: "+data)
	  	var bookmarks = jQuery.parseJSON(data);
	  	if(bookmarks.length == 0){
	  		return;
	  	}
	  	if(bookmarks[0].length == 0){
	  		return;
	  	}
	  	var text = '<table class="data table table-bordered table-condensed">';
	  	text +='<tbody>';
	  	$.each(bookmarks, function() {
	  		$topics = "";
	  		//console.log("@@"+this);
	  		// JSON function in R sometimes wraps each string in its own array - test for this
	  		try{
	  			$topics = this.replace(/[\"\']/g,"");
	  		}catch(err){
	  			console.log("problem applying regex - trying next index");
	  			$topics = this[0].replace(/[\"\']/g,"");
	  		}
	  		//$topics = this;
	  		text +=  '<tr>';
	  		text += '	<td>';
	  		text += '	<a href="#" onclick="updateSearchTerms(\''+ $topics +'\')">';
	  		text += $topics;
	  		text += '	</a>';
	  	    text += '	</td>';
	  		text += '</tr>';
	  		
	      });
	  	text += '</table>';
	   	var m = getCollapseCode("Topics", text, "bookmarkTermsDataset-output");
		
		$(el).html(m);
		$('#bookmarkTermsLegend').html("");
		initCollapseTables("bookmarkTermsDataset-output");
		if(isfirst){
			//initCollapseTables("_wordcloud_bookmark");
			isfirst = false;
		}
		$('.bookmarkTermsDataset-output').css('visibility','visible');
		$('#bookmarkvisuals').css('visibility','visible');
	  }
});

Shiny.outputBindings.register(bookmarkTermsOutputBinding, "bookmarkTermsDataset-output");

var searchResultsOutputBinding = new Shiny.OutputBinding();
$.extend(searchResultsOutputBinding, {
  find: function(scope) {
    return scope.find('.searchResultDataset-output');
  },
  renderValue: function(el, data) {
	//console.log("**********  search results callback");
  	var bookmarks = jQuery.parseJSON(data);
  	if(bookmarks.length == 0){
  		return;
  	}

  	var text = '<table class="data table table-bordered table-condensed">';
  	text +='<tbody>';
  	$.each(bookmarks, function() {
  		$url = "";
  		$title = "";
  		$desc = "";
  		
     	if(this[0]==""){
  			$url =  '<div class="item-error">' + "No URL set in data" + '</div>'; 
  		}else{
  			$url = '<div class=""><a target="new" href="'+ this[0] + '">'+ this[0] + '</a></div>'; 
  		}
  		if(this[1]==""){
  			$title = '<div class="item-warning">' + "(No Title) " + '</div>'; 
  		}else{
  			$title = '<div class="">' + this[1] + '</div>'; 
  		}
  		if(this[2]==""){
  			$desc = '<div class="item-warning search-description">' + "(No description)" + '</div>'; 
  		}else{
  			$desc = '<div class="search-description">' + this[2] + '</div>'; 
  		}
  		text +=  '<tr>';
  		text += '	<td>';
  		text += $title;
  		text += $desc;
  		text += $url;
  	    
  	    text += '	</td>';
  		text += '</tr>';
  		
      });
  	text += '</table>';
   	var m = getCollapseCode("Search Results", text, "searchResultDataset-output");
   	$('#searchLegend').html("");
	$(el).html(m);
	initCollapseTables("searchResultDataset-output");
	$('#goSearchTopics').css('visibility','visible');
  }
});

Shiny.outputBindings.register(searchResultsOutputBinding, "searchResultDataset-output");


var searchTermsOutputBinding = new Shiny.OutputBinding();
$.extend(searchTermsOutputBinding, {
  find: function(scope) {
    return scope.find('.searchTermsDataset-output');
  },
  renderValue: function(el, data) {

	  	var bookmarks = jQuery.parseJSON(data);
	  	if(bookmarks.length == 0){
	  		return;
	  	}

	  	var text = '<table class="data table table-bordered table-condensed">';
	  	text +='<tbody>';
	  	$.each(bookmarks, function() {
	  		$topics = "";
	  		$topics = this.replace(/[\"\']/g,"");
	  		//$topics = this;
	  		text +=  '<tr>';
	  		text += '	<td>';
	  		text += '	<a href="#" onclick="updateSearchTerms(\''+ $topics +'\')">';
	  		text += $topics;
	  		text += '	</a>';
	  	    text += '	</td>';
	  		text += '</tr>';
	  		
	      });
	  	text += '</table>';
	   	var m = getCollapseCode("Topics", text, "searchTermsDataset-output");
	   	$('#searchTermsLegend').html("");
		$(el).html(m);
		initCollapseTables("searchTermsDataset-output");
		$('.searchTermsDataset-output').css('visibility','visible');
		$('#searchvisuals').css('visibility','visible');
	  }
});

Shiny.outputBindings.register(searchTermsOutputBinding, "searchTermsDataset-output");