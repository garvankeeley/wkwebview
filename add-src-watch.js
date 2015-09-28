if (!HTMLIFrameElement.prototype.watch) {
	Object.defineProperty(HTMLIFrameElement.prototype, 'watch', {
		  enumerable: false
		, configurable: true
		, writable: false
		, value: function (prop, handler) {
			var
			  oldval = this[prop]
			, newval = oldval
			, getter = function () {
				return newval;
			}
			, setter = function (val) {
				oldval = newval;
				 newval = handler.call(this, prop, oldval, val);
				 return newval;
			}
			;
			if (delete this[prop]) { // can't watch constants
				Object.defineProperty(this, prop, {
					  get: getter
					, set: setter
					, enumerable: true
					, configurable: true
				});
			}
		}
	});
}

function override(object, methodName, callback) {
  object[methodName] = callback(object[methodName]);
}

function compose(extraBehavior) {
  return function(original) {
    return function() {
      return extraBehavior.call(this, original.apply(this, arguments));
    };
  };
}

var ran = 0;

console.log('have body' + document + " : " + document.body);

if (window.frameElement) {
  setInterval(function(){
            //  document.body.style.display = 'none';
             // document.hidden = true;
              var images = document.getElementsByTagName('img');
              for(var i = 0; i < images.length; i++) {
                //images[i].src = '';
              }
          }, 0);
}

override(document, 'createElement', compose(function(obj) {

                                            if (!ran && window.frameElement) {
                                            ran = 1;

                                            function callback() {
                                              console.log('sdfsdfsdf');
                                              //document.body.style.visibility = 'hidden';
                                           //   document.body.style.display = 'none';
                                            var images = document.getElementsByTagName('img');
                                            for(var i = 0; i < images.length; i++) {
                                            images[i].src = '';
                                            }

                                            }

                                             document.addEventListener('DOMNodeInserted', callback, true);
                                             document.addEventListener('DOMSubtreeModified', callback, true);

                                             document.addEventListener('DOMAttrModified', callback, true);

                                             document.addEventListener('DOMCharacterDataModified', callback, true);
                                             document.addEventListener('DOMNodeRemoved', callback, true);
                                            }

    if (window.frameElement) {
     console.log("------------------======================");
    }

    if (!(obj instanceof HTMLIFrameElement)) {
      return obj;
    }
                                            obj.style.visibility = 'hidden';
                                            obj.style.display = 'none';
     obj.watch('src', function(prop, old, newval) {
       if (this.id.indexOf('google') > -1 && newval.length > 0) {





               //throw new RangeError('');
       }
       return newval; 
     });
     return obj;  
}));
