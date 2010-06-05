jQuery.noConflict(); // Allow the test to run with other libs or jQuery's.

// load testswarm agent
(function() {
  isLocal = QUnit.isLocal = true;

  // var url = window.location.search;
  // url = decodeURIComponent( url.slice( url.indexOf("swarmURL=") + 9 ) );
  // if ( !url || url.indexOf("http") !== 0 ) {
  //  return;
  // }
  //
  // // (Temporarily) Disable Ajax tests to reduce network strain
  // isLocal = QUnit.isLocal = true;
  //
  // document.write("<scr" + "ipt src='http://swarm.jquery.org/js/inject.js?" + (new Date).getTime() + "'></scr" + "ipt>");
})();


var current_module = '';
var tests = [];
var errors = [];
jQuery.extend(QUnit, {
	done: function(failures, total) {
	  puts("\n\n")
	  for(var i = 0; i < errors.length; i++) { puts(errors[i]); }
	  // config.assertions.length
	  puts("\n" + tests.length + ' tests, ' + '?' + ' assertions, ' + errors.length + ' errors')
	},
	log: function(result, message) {
	  if(result) {
	    print('.');
	  } else {
	    print('F');
	    errors.push('(' + current_module + ') ' + tests[tests.length - 1] + ': ' + message)
    }
	},
	testStart: function(name) {
	  tests.push(name);
	},
	testDone: function(name, failures, total) {},
	moduleStart: function(name, testEnvironment) {
	  current_module = name
	},
	moduleDone: function(name, failures, total) {}
});