<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>How I Start.</title>

    <!-- Bootstrap core CSS -->
    <link href="/static/css/readable.min.css" rel="stylesheet">

    <!-- Custom CSS for the 'Thumbnail Gallery' Template -->
    <link href="/static/css/1-col-portfolio.css" rel="stylesheet">
    <style type="text/css">code{white-space: pre;}</style>
    <style type="text/css">
      table.sourceCode, tr.sourceCode, td.lineNumbers, td.sourceCode {
      margin: 0; padding: 0; vertical-align: baseline; border: none; }
      table.sourceCode { width: 100%; line-height: 100%; }
      td.lineNumbers { text-align: right; padding-right: 4px; padding-left: 4px; color: #aaaaaa; border-right: 1px solid #aaaaaa; }
      td.sourceCode { padding-left: 5px; }
      code > span.kw { color: #007020; font-weight: bold; }
      code > span.dt { color: #902000; }
      code > span.dv { color: #40a070; }
      code > span.bn { color: #40a070; }
      code > span.fl { color: #40a070; }
      code > span.ch { color: #4070a0; }
      code > span.st { color: #4070a0; }
      code > span.co { color: #60a0b0; font-style: italic; }
      code > span.ot { color: #007020; }
      code > span.al { color: #ff0000; font-weight: bold; }
      code > span.fu { color: #06287e; }
      code > span.er { color: #ff0000; font-weight: bold; }
    </style>
</head>

<body>
    <nav class="navbar navbar-fixed-top navbar-inverse" role="navigation">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="/">How I Start.</a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse navbar-ex1-collapse">
              <ul class="nav navbar-nav">
                <categories>
                  <li class="category"><a href="/posts/${category}"><category /></a></li>
                </categories>
              </ul>
              <ul class="nav navbar-nav navbar-right">
                <li><a href="/about">About</a></li>
              </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

    <div id="content">
      <apply-content />
    </div>

    <!-- JavaScript -->
    <script src="/static/js/jquery-1.10.2.js"></script>
    <script src="/static/js/bootstrap.js"></script>

</body>

</html>
