function isFrame() {
  try {
    return true;
    return window.frameElement;
  }catch (e) { return true; }
}

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

//console.log('have body' + document + " : " + document.body);
//
if (isFrame()) {
  setInterval(function(){
      var images = document.getElementsByTagName('img');
      for(var i = 0; i < images.length; i++) {
        var img = images[i];
        if (!img.src) continue;
        var src = img.orig_src || '';

        if (img.src.indexOf('nytimes.com') > -1) continue;
              
        if (img.src.indexOf('goog') < 0 &&
            !img.orig_src) {
          continue;
        }

              src = img.src;
              //img.src = '';
              img.orig_src = src;

        if (src.length > 1) {
             // console.log("trying: " + src);
              window.webkit.messageHandlers.interop.postMessage(src);
        }
      }
  }, 5000);
}

//
//override(document, 'createElement', compose(function(obj) {
//
//    if (!ran && isFrame()) {
//    ran = 1;
//
//    function callback() {
//      //document.body.style.visibility = 'hidden';
//   //   document.body.style.display = 'none';
//      var images = document.getElementsByTagName('img');
//      for(var i = 0; i < images.length; i++) {
//      //  images[i].orig_src = images[i].src;
//      //  images[i].src = '';
//      }
//    }
//
//     document.addEventListener('DOMNodeInserted', callback, true);
//     document.addEventListener('DOMSubtreeModified', callback, true);
//
//     document.addEventListener('DOMAttrModified', callback, true);
//
//     document.addEventListener('DOMCharacterDataModified', callback, true);
//     document.addEventListener('DOMNodeRemoved', callback, true);
//    }
//
//    //if (window.frameElement) {
//     //console.log("------------------======================");
//    //}
//
//    if (!(obj instanceof HTMLIFrameElement)) {
//      return obj;
//    }
//                                            //obj.style.visibility = 'hidden';
//                                           // obj.style.display = 'none';
//     obj.watch('src', function(prop, old, newval) {
//       if (this.id.indexOf('google') > -1 && newval.length > 0) {
//      }
//       return newval; 
//     });
//     return obj;  
//}));


if (isFrame()) {

    var hash = location.hash;
  setInterval(function() {
            if (!location.hash) return;
              console.log(frameElement.id);
            console.log('message received:  ' + location.hash);
              var src = location.hash.substr(1);
            var images = document.getElementsByTagName('img');
            for(var i = 0; i < images.length; i++) {
              var img = images[i];
              if (img.orig_src === src) {
                img.src = src;
              }
            }
              location.hash = '';
    }, 1000);
}



function replace_src(srcname) {
//  console.log('post message:' + srcname);
//  setTimeout(function() {
//  document.getElementById('google_ads_iframe_/29390238/NYT/homepage/us_1').src = '#' + srcname;
//             }, 500);
//             return;
  var items = document.getElementsByTagName('iframe');
  for(var i = 0; i < items.length; i++) {
    var frame = items[i];
    if (frame.src.indexOf("#") == 0) {
      continue;
    }
    frame.src = '#' + srcname;
  }
}
