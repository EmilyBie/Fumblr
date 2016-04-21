//textarea 
// tinymce.init({ selector:'textarea' });

//check if browser supports file api and filereader features
if (window.File && window.FileReader && window.FileList && window.Blob) {
    
   //this is not completely neccesary, just a nice function I found to make the file size format friendlier
    //http://stackoverflow.com/questions/10420352/converting-file-size-in-bytes-to-human-readable
    function humanFileSize(bytes, si) {
        var thresh = si ? 1000 : 1024;
        if(bytes < thresh) return bytes + ' B';
        var units = si ? ['kB','MB','GB','TB','PB','EB','ZB','YB'] : ['KiB','MiB','GiB','TiB','PiB','EiB','ZiB','YiB'];
        var u = -1;
        do {
            bytes /= thresh;
            ++u;
        } while(bytes >= thresh);
        return bytes.toFixed(1)+' '+units[u];
    }


  //this function is called when the input loads an image
    function renderImage(file){
        var reader = new FileReader();
        reader.onload = function(event){
            the_url = event.target.result
      //of course using a template library like handlebars.js is a better solution than just inserting a string
            preview = document.getElementById("blog_body_preview")
            var oImg=document.createElement("img");
            oImg.setAttribute('src', the_url);
            oImg.setAttribute('height', '150px');
            oImg.setAttribute('width', '150px');
            preview.appendChild(oImg);
        }
    
    //when the file is read it triggers the onload event above.
        reader.readAsDataURL(file);
    }
  
  //watch for change on the 
    $( "#the-photo-file-field" ).change(function() {
        console.log("photo file has been chosen")
        //grab the first image in the fileList
        //in this example we are only loading one file.
        console.log(this.files[0].size)
        renderImage(this.files[0])

    });

} else {

  alert('The File APIs are not fully supported in this browser.');

}