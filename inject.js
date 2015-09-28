// ==UserScript==
// @name        AdSweep
// @author      Charles
// @description AdSweep is an ad blocker
// @namespace   http://www.adsweep.org
// @version     0.4
// ==/UserScript==

// Special thanks to Duy K. Bui <owner@khuongduy.com>

function adsweep(){
  // Display on AdSweep homepage a notification that AdSweep is enabled on user's computer
  if((location == 'http://www.adsweep.org/') || (location == 'http://adsweep.org/')){
    document.getElementsByTagName("BODY")[0].innerHTML += '<div style="position:absolute;top:0;right:0;background:#c00;color:#fff;display:inline;padding:2px 5px">Your AdSweep is currently active</div>';
  }

  // List of sites that aren't trimmed by AdSweep
  var adsweep_exceptions=['mail.google.com'];
  var adsweep_cancel=false;
  for (var adsweep_e in adsweep_exceptions){
    if(top.location.hostname.indexOf(adsweep_exceptions[adsweep_e])!=-1){
      adsweep_cancel=true;
      break;
    }
  }

  // List of hostnames that have specific rules
  var adsweep_sites=new Array();
  adsweep_sites['360.yahoo.com']='#ymgl-north-wrapper,#ymgl-feedback,#ygma';
  adsweep_sites['arstechnica.com']='#Banner';
  adsweep_sites['diendan.hocmai.vn']='div.smallfont>a>img,div.header,div.page>div>table>tbody>tr>td>table>tbody>tr>td>embed,form>div.navbg,table.leftads';
  adsweep_sites['distrowatch.com']='table:nth-of-type(2),table[class="Logo"]:nth-of-type(3) td:nth-of-type(1) table[class="News"]:nth-of-type(1),table[class="Logo"]:nth-of-type(3) td:nth-of-type(1) br:nth-of-type(1),table[class="Logo"]:nth-of-type(3) td:nth-of-type(1) table[class="News"]:nth-of-type(2),table[class="Logo"]:nth-of-type(3) td:nth-of-type(1) br:nth-of-type(2),table[class="Logo"]:nth-of-type(3) td:nth-of-type(1) table[class="News"]:nth-of-type(3),table[class="Logo"]:nth-of-type(3) td:nth-of-type(1) br:nth-of-type(3),table[class="Logo"]:nth-of-type(3) td:nth-of-type(1) table:nth-of-type(6),table[class="Logo"]:nth-of-type(3) td:nth-of-type(1) br:nth-of-type(6),table[class="Logo"]:nth-of-type(3) td:nth-of-type(1) table[class="News"]:nth-of-type(10),table[class="Logo"]:nth-of-type(3) td:nth-of-type(1) br:nth-of-type(10),table[class="Logo"]:nth-of-type(3) td:nth-of-type(2) table:first-of-type tr:nth-of-type(3),table[class="Logo"]:nth-of-type(3) td:nth-of-type(3) table:first-of-type,table[class="Logo"]:nth-of-type(3) td:nth-of-type(3) br:first-of-type,table[class="Logo"]:nth-of-type(3) td:nth-of-type(3) table:nth-of-type(2),table[class="Logo"]:nth-of-type(3) td:nth-of-type(3) br:nth-of-type(2),table[class="Logo"]:nth-of-type(3) td:nth-of-type(3) table:nth-of-type(3),table[class="Logo"]:nth-of-type(3) td:nth-of-type(3) br:nth-of-type(3),table[class="Logo"]:nth-of-type(3) td:nth-of-type(3) table:nth-of-type(6),table[class="Logo"]:nth-of-type(3) td:nth-of-type(3) br:nth-of-type(5)';
  adsweep_sites['digg.com']='#block_ad_msft,.item_ad_image,.msad,#comments_ad_msft,.comments_ad_image';
  adsweep_sites['digitalspy.co.uk']='li.ez:nth-last-of-type(8),td[id^="td_post_"] div[style^="float:right"]:nth-of-type(2),div[id^="edit"]:first-child div:nth-of-type(2) table:nth-of-type(1) tr:nth-of-type(2) td table td:nth-of-type(3),div[id^="edit"]:first-child div:nth-of-type(2) tr:nth-of-type(2) div';
  adsweep_sites['gizmodo.']='#sideBarGoogleAnnounces';
  adsweep_sites['global-sms.de']='div[style*="width: 810px; height: 449px"]';
  adsweep_sites['google.']='#gsr div#tads,#gsr table#mbEnd';
  adsweep_sites['lifehacker.com']='img[alt$="Shop"],a[href*="amazon"],a[href*="auto-show"],#sidebartopstories ul';
  adsweep_sites['live.com']='.sb_adsW,.adB';
  adsweep_sites['mail.live.com']='.cAdBannerContainer,#RadAd_TodayPage_Banner,#adHeader,#RadAd_Banner,#CustComm_120x60,.c120x60CustomerCommContainer,.CustComm_120x60,td.dSideAds,#TodayTabSection,.cAdHeaderContainer,.AdHeaderContainer';
  adsweep_sites['meebo.com']='#welcomeWin';
  adsweep_sites['osnews.com']='div#header>div.ad,div#content>div#side>div#sidebar>script,div#content>div#side>div#sidebar>iframe,div#content>div#side>div#sidebar>p a[href^="http://www.puremobile"]';
  adsweep_sites['pcmag.com']='#w_header .leaderboard,#lenovo_resource_center,.spotlight_hdr,#informLogo,#w_graveyard,#product_spotlight,#homepageSubForm,*[id^="special_offers"],img[width="440"][height="56"],*[class^="mrktcell"],*[class^="AdModule_"],*[class^="sponsors"],.bestselling';
  adsweep_sites['readwriteweb.com']='#right_column_box';
  adsweep_sites['techcrunch.com']='div[id^="google_flash"],div#bugs,div#vertical_ads,div#seesmic_widget,div#header_medrec,ul.sponsor_units,ul#site_supporters';
  adsweep_sites['techradar.com']='#top_banner,#houseAd,#mpu,#skyscraperAd,#network_links,img[alt^="Future Publishing"]';
  adsweep_sites['techrepublic.com']='iframe.bidwar';
  adsweep_sites['sitepoint.com']='.industrybrains,table.tborder.product,.ad99';
  adsweep_sites['veggieboards.com']='div.page:nth-of-type(1) div:first-child center:first-child';
  adsweep_sites['vsa-nova.com']='table>tbody>tr>td>a>img,div.smallfont>a>img';
  adsweep_sites['webhostingtalk.com']='div#identity>div.container>div.controls>div.powered,div#content>div.container.single>div#leaderboard.advertisement,div#content>div.container.single>div#primary>div>div.page>div>table>tbody>tr>td>table.tborder>tbody>tr>td.vbsociable,div#resources>div.container>div.advertisement>p[style],div.container>div#sponsored,div.container>div#footerad,div#content>div.container.single>div#promotion,div.container>div#sponsored-clear,div#content>div.container.single>div#primary>div>div.page>div>table>tbody>tr>td>table.tborder>tbody>tr>td.alt1>script,div#content>div.container.single>div#primary>div>div.page>div>table>tbody>tr>td>table.tborder>tbody>tr>td.alt1>a[target="_blank"],div#content>div.container.single>div#primary>div>div.page>div>table>tbody>tr>td>table.tborder>tbody>tr>td script,div#content>div.container.single>div#primary>div>div.page>div>table>tbody>tr>td>table.tborder>tbody>tr>td embed,div#content>div.container.single>div#primary>div>div.page>div>table>tbody>tr>td>table.tborder>tbody>tr>td img';
  adsweep_sites['yahoo.com']='#sponsored-links,a[href*="thebestlife.com"],.ad_sidebar,.ad-links,.ad_slug_table,div[id^="dynamic-ad"]';
  //adsweep_sites['example.com']='';

  if(!adsweep_cancel){
    // Hide common ad patterns here; the following applies to every single web site not listed in exceptions list
    adsweep_hide('.ads,.Ads,*[class^="ad-"],*[class^="Ad-"],*[class^="ads-"],*[class^="Ads-"],*[class*="advert"],*[class*="Advert"],*[class^="ad_"],*[class^="Ad_"],*[class^="ads_"],*[class^="Ads_"],*[class$="-ad"],*[class$="-Ad"],*[class$="-ads"],*[class$="-Ads"],*[class$="_ad"],*[class$="_Ad"],*[class$="_ads"],*[class$="_Ads"],*[class~="ad"],*[class~="Ad"],#ad,#Ad,#ads,#Ads,*[id^="fm_delivery_frame"],*[id^="ad-"],*[id^="Ad-"],*[id^="ads-"],*[id^="Ads-"],*[id*="advert"],*[id*="Advert"],*[id^="ad_"],*[id^="Ad_"],*[id^="ads_"],*[id^="Ads_"],*[id$="-ad"],*[id$="-Ad"],*[id$="-ads"],*[id$="-Ads"],*[id$="_ad"],*[id$="_Ad"],*[id$="_ads"],*[id$="_Ads"],a[href^="http://ads."],a[href^="http://ad."],a[href*="doubleclick.net"],a[href*="adbrite.com/mb/commerce"],a[href*="googlesyndication"],a[href^="http://services.google.com/feedback/abg"],*[href*="fmpub.net"],*[src*="googlesyndication"],*[src*="fmpub.net"],*[src^="http://ads."],*[src^="http://ad."],*[src*="doubleclick.net"],iframe[src*="ads"],iframe[src*="ad-"],iframe[src*="-ad"],iframe[name*="ads"],iframe[name*="ad-"],iframe[name*="-ad"],iframe[name*="google"],*[width="88"][height="31"],*[width="120"][height="60"],*[width="120"][height="90"],*[width="120"][height="240"],*[width="120"][height="600"],*[width="125"][height="125"],*[width="160"][height="600"],*[width="180"][height="150"],*[width="234"][height="60"],*[width="240"][height="400"],*[width="250"][height="250"],*[width="300"][height="100"],*[width="300"][height="250"],*[width="300"][height="600"],*[width="336"][height="280"],*[width="468"],*[width="720"][height="300"],*[width="728"],html>body>div#aus,div.ib_unit,div.ib_title');

    // Hide advertisements on each web site
    for(var adsweep_i in adsweep_sites){
      if(top.location.hostname.indexOf(adsweep_i)!=-1){
        adsweep_hide(adsweep_sites[adsweep_i]);
        break;
      }
    }
    // Hide Javascript advertisements
    if(navigator.userAgent.indexOf("Opera")!=-1){
      window.opera.addEventListener (
                                     'BeforeScript',
                                     function (e) {
                                     if (e.element.src.match (/pagead/) || e.element.src.match (/adjuggler/) || e.element.src.match (/intellitxt/) || e.element.src.match (/quantserve/) || e.element.src.match (/industrybrains/) || e.element.text.match (/googlesyndication/) || e.element.text.match (/http:\/\/aj\./) || e.element.text.match (/AdBrite/) || e.element.text.match (/ib_title/)) e.preventDefault ();
                                     },
                                     false
                                     );
    }
  }

  // Override all rules for specific sites. If you have a site that generates a false positive, add it here and set its custom CSS code.
  var adsweep_sites_custom_css=new Array();
  adsweep_sites_custom_css['daniweb.com']='div.ad_txt{display:block !important;height:auto !important;}';
  adsweep_sites_custom_css['ohio.gov']='*[width="728"]{display:block !important;height:auto !important;}';

  // Inject custom CSS code into specific sites
  for(var adsweep_j in adsweep_sites_custom_css){
    if(top.location.hostname.indexOf(adsweep_j)!=-1){
      adsweep_inject_css(adsweep_sites_custom_css[adsweep_j]);
      break;
    }
  }

  function adsweep_hide(e){
    var elements = e.split(',');
    var style = document.createElement("style");
    document.getElementsByTagName("head")[0].appendChild(style);
    var sheet = style.sheet;
    for(var i in elements){
      sheet.insertRule(elements[i] + "{display:none !important;height:0px !important;}",sheet.cssRules.length);
    }
  }
  function adsweep_inject_css(e){
    var elements = e.split(',');
    var style = document.createElement("style");
    document.getElementsByTagName("head")[0].appendChild(style);
    var sheet = style.sheet;
    for(var i in elements){
      sheet.insertRule(elements[i],sheet.cssRules.length);
    }
  }
}


adsweep();

