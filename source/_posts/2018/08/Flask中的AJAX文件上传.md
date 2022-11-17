---
title: Flask中的AJAX文件上传
date: 2018-08-22 20:33:15
en_title: Flask Upload File With AJAX
tags: [Python Web, Flask, AJAX]
---

<h3>表单：</h3>

<pre><code class="html">&lt;form method="post" enctype=multipart/form-data id='form1'&gt;
    &lt;input class="form-control" id="image" name="image" required type="file"&gt;
    &lt;button type="submit" class="btn btn-default" id='submit1'&gt;提交&lt;/button&gt;
&lt;/form&gt;
</code></pre>

<h3>JS:</h3>

<pre><code class="javascript">&lt;script&gt;
$('#image').change(function(){
    var form_data = new FormData($('#form1')[0]);

    $.ajax({
        url: '/signup/',
        type: 'post',
        data: form_data,
        contentType: false,
        processData: false,
        success: function(length){
            console.log('success');
        },
    });
})
&lt;/script&gt;
</code></pre>

<h3>Flask:</h3>

<pre><code class="python">@app.route('/signup/', methods=['POST'])
def get_file():
    content = request.files.get('image1') 
</code></pre>