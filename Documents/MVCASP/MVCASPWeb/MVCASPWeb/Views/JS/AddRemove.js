createElementToId("div", "createElfgdfgdfementToId", "dropdown")

Element.prototype.remove = function () {
    this.parentElement.removeChild(this);
}
NodeList.prototype.remove = HTMLCollection.prototype.remove = function () {
    for (var i = this.length - 1; i >= 0; i--) {
        if (this[i] && this[i].parentElement) {
            this[i].parentElement.removeChild(this[i]);
        }
    }
}

function removeElementById(id)
{
    document.getElementById(id).remove();
}

// or
function removeElementByClassName(name) {
    document.getElementsByClassName(name).remove();
}

// or
function removeElementByTagName(name) {
    document.getElementsByTagName(name).remove();
}

function removeId1(id) {
    return (elem = document.getElementById(id)).parentNode.removeChild(elem);
}

function removeId2(id) {
    var element = document.getElementById("element-id");
    element.outerHTML = "";
    delete element;
}

function createElementToId(element, textNode, id) {
    var a = window.screen;
    // create a new div element 
    // and give it some content 
    var newDiv = document.createElement(element);

    newDiv.setAttribute('rel', 'stylesheet');
    newDiv.setAttribute('type', 'text/css');

    if (a.width == "800" & a.height == "600") {
        alert("Your system resolution is:800 * 600");
        newDiv.setAttribute('href', '~/CSS/StyleSheet1.css');
    }
    else if (a.width == "1024" & a.height == "768") {
        alert("Your system resolution is: 1024*768");
        newDiv.setAttribute('href', '~/CSS/StyleSheet1.css');
    }
    else if (a.width == "1360" & a.height == "768") {
        alert("Your system resolution is:1360*768");
        newDiv.setAttribute('href', '~/CSS/StyleSheet1.css');
    } else {
      //  alert("Your system resolution is:1360*68");
        newDiv.setAttribute('href', '~/CSS/StyleSheet1.css');
    }

    var newContent = document.createTextNode(textNode);
    newDiv.appendChild(newContent); //add the text node to the newly created div. 
    //var currentElement = document.getElementById(id);
    var currentElement = document.getElementsByClassName(id)[0];
    currentElement.appendChild(newDiv);
}
