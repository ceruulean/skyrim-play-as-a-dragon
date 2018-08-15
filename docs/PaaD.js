var scrollTopPos
var TitleBannerPos
var idTitleBanner = document.getElementById("TitleBanner");
var idTitleBannerHolder = document.getElementById("TitleBannerHolder");

var TitleBannerHeight

var dBackground1 = document.getElementById("dBackground1");
var dBackground2 = document.getElementById("dBackground2");
var dBackground3 = document.getElementById("dBackground3");
var YoutubeToggle = document.getElementById("YoutubeToggle");

var event_figuretoggle;

var Main1 = document.getElementById("Main1");
var Main2 = document.getElementById("Main2");
var Main3 = document.getElementById("Main3");
var Main4 = document.getElementById("Main4");

var idNav = document.getElementById("nav");
var idNavIcon = document.getElementById("NavClicker");

var svgNavIcon = document.getElementById("svgNavIcon")
var idNavIconBars = document.getElementById("g3806")
var idNavIconBG = document.getElementById("NavIconBG")

var NavUl = document.getElementById("NavUl");

var bBannerStick
var bNavActive
var bBGimg1
var bBGimg2;

window.onload = function() {Initialize()};
window.onscroll = function() {TitleBannerStick()};
window.onresize = function() {TitleBannerHeight = idTitleBanner.getBoundingClientRect().height
			idTitleBannerHolder.setAttribute("style","height:" + TitleBannerHeight + "px;")};

function Initialize() {
scrollTopPos = window.pageYOffset || document.documentElement.scrollTop;
TitleBannerPos = idTitleBanner.getBoundingClientRect().top + scrollTopPos;
TitleBannerHeight = idTitleBanner.getBoundingClientRect().height
bBannerStick = false;
bNavActive = false;
idNavIcon.addEventListener("click", function(){NavToggle();});
YoutubeToggle.addEventListener("click", function(){ToggleFigure(document.getElementById("figTrailer"), "block", "https://www.youtube.com/embed/e781Hx94VzM");});
document.getElementById("ScrollTopTrigger").addEventListener("click", function(){ScrollTo(0);});

document.getElementById("a_About").addEventListener("click", function(){ScrollTo($("#Main1").offset().top - TitleBannerHeight);});
document.getElementById("a_Install").addEventListener("click", function(){ScrollTo($("#Main2").offset().top - TitleBannerHeight);});
document.getElementById("a_Settings").addEventListener("click", function(){ScrollTo($("#Main3").offset().top - TitleBannerHeight);});
document.getElementById("a_Perks").addEventListener("click", function(){ScrollTo($("#Main4").offset().top - TitleBannerHeight);});
document.getElementById("a_Changelog").addEventListener("click", function(){ScrollTo($("#Main5").offset().top - TitleBannerHeight);});

bNavActive = sessionStorage.getItem('bNavActive');
TitleBannerStick();
NavToggle(bNavActive);

}

function TitleBannerStick() {
scrollTopPos = window.pageYOffset || document.documentElement.scrollTop
/*	alert(TitleBannerPos) */
	if ((TitleBannerPos <= scrollTopPos) && bBannerStick === false) {
/*TitleBannerPos = idTitleBanner.getBoundingClientRect().top + scrollTopPos
					alert(TitleBannerPos);*/
			idTitleBannerHolder.setAttribute("style","height:" + TitleBannerHeight + "px;")
			idTitleBanner.className = "cBannerPosFixed";
			bBannerStick = true;
} else if ((TitleBannerPos > scrollTopPos) && bBannerStick === true) {
		/*	alert("unstick" + TitleBannerPos);*/
			idTitleBanner.className = "cBannerPosRelative";
			bBannerStick = false;
	}
	
Check1();
Check2();
}

function Check1(){
			var height1 = Main1.getBoundingClientRect().height;
var check1 = dBackground3.getBoundingClientRect().bottom + (height1);
//alert(scrollTopPos + "and" + check1);
	if (scrollTopPos <= check1) {
		BGimg1 = true;
		var shit = (scrollTopPos / check1) - 0.2;
		var opacityfactor = 1 - shit;
		dBackground3.setAttribute("style","opacity:" + opacityfactor + ";");
	} else {
		bBGimg1 = false;
		dBackground3.setAttribute("style","opacity:0;visibility:hidden;");
}

}

function Check2(){
		var bottom1 = Main1.getBoundingClientRect().bottom;
		var height1 = Main1.getBoundingClientRect().height;
var check2 = (window.pageYOffset + (bottom1 - height1 / 2));

var bottom3 = Main3.getBoundingClientRect().bottom;
var height3 = Main3.getBoundingClientRect().height;
var check3 = check2 + (bottom3 - height3 / 2);
//alert("2: " + check2 + "3: " + check3);
if ((scrollTopPos > check2) && (scrollTopPos < check3)){
	bBGimg2 = true;
	var bb = 1 - (bottom1 / (height1 / 2))
	dBackground2.setAttribute("style","opacity:" + bb + ";");
//	alert(bottom1);
}else if (scrollTopPos > check3) {
	var bbb = bottom3 / height3
	bBGimg2 = false;
	dBackground2.setAttribute("style","opacity:" + bbb + ";");
} else{
		dBackground2.setAttribute("style","display:none;");
}
Check3(check3, bottom3, height3);
}

function Check3(checkk, botto3, heigh3){

	if (scrollTopPos > checkk){
	var bb = 1 - (botto3 / (heigh3 / 2))
	dBackground1.setAttribute("style","opacity:" + bb + ";");
//	alert(bottom1);
}else {
	dBackground1.setAttribute("style","display:none;");
}
}

/*
function OpacityScroll(startpos, stoppos, itemtoreveal, holdinterval){
	if (scrollTopPos > startpos) && (scrollTopPos < stoppos) {
			var bb = 1 - ((scrollTopPos - startpos) / (stoppos - startpos - holdinterval) / 2);
	}
}*/

function NavToggle(force) {
if (force === 'true'){
		bNavActive = "false";}
else if (force === 'false') {
		bNavActive = "true";
		}
	if (bNavActive === 'false') {
		idNavIconBG.setAttributeNS(null, "class", "cNavIconActive");
		idNavIconBars.style.fill = "#000";
		idNav.setAttribute("style", "display:block;");
		SetNavLiClass("cNavShowLi");
		bNavActive = "true";
	} else {
		idNavIconBG.setAttributeNS(null, 'class', "");
		idNavIconBars.style.fill = "#FFF";
		SetNavLiClass("cNavHideLi");
		bNavActive = "false";
	};
sessionStorage.setItem('bNavActive', bNavActive);
	}

function SetNavLiClass(stringstyle) {
/*	var ii = 0;
	var endd = NavList.length;
	while (ii < endd) { NavList[ii].className = stringstyle; //NavList[ii].setAttribute("style", stringstyle);
	ii ++;}*/
	
	idNav.className = stringstyle
}

function ToggleFigure(figg, displaystring, url) {
		this.figure = figg;
		this.display = displaystring;
		event_figuretoggle = function(){ToggleFigure(figg, "none");};
	if (figg.style.display == "none"){
		figg.querySelector("iframe").setAttribute("src", url);
		figg.style.display = displaystring;
		figg.addEventListener("click", event_figuretoggle);
	} else {figg.style.display = "none"
	figg.querySelector("iframe").setAttribute("src", "");
	figg.removeEventListener("click", event_figuretoggle);
}
}

function ScrollTo(destination){
	$('html, body').animate({scrollTop: destination}, 1000);
}

function OpacityFactor(amount, total){
	var op = 1 - (amount / total);
	if (op < 0) {
		op = 0;
	} else if (op > 1) {
		op = 1
	}
return op
}