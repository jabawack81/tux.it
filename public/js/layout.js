/* (c) 2010 Kalamun.org - GPL3 */

var urlInput=null;
function initLayout() {
	urlInput=document.getElementById('url');
	var tmp=document.createElement('SPAN');
	tmp.id='tmpDiv';
	document.body.appendChild(tmp);
	enlargeInput();
	urlInput.onkeyup=enlargeInput;
	}
function enlargeInput() {
	tmp=document.getElementById('tmpDiv');
	try { tmp.removeChild(tmp.childNodes[0]); } catch(err) { null; };
	tmp.appendChild(document.createTextNode(urlInput.value));
	tmp.offsetWidth<800?urlInput.style.width=(tmp.offsetWidth>100?tmp.offsetWidth+20:100)+'px':urlInput.style.width='800px';
	}
function removePlaceholder(inp) {
	if(!inp.getAttribute("placeholder")) inp.setAttribute("placeholder",inp.value);
	if(inp.value==inp.getAttribute("placeholder")) {
		inp.value="";
		inp.style.color="#000";
		}
	}
function setPlaceholder(inp) {
	if(inp.value=="") {
		inp.value=inp.getAttribute("placeholder");
		inp.style.color="#aaa";
		}
	}
	
window.onload=initLayout;
