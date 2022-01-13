require 'rack/lobster'
  
map '/health' do
  health = proc do |env|
    [200, { "Content-Type" => "text/html" }, ["1"]]
  end
  run health
end

map '/lobster' do
  run Rack::Lobster.new
end

map '/headers' do
  headers = proc do |env|
    [200, { "Content-Type" => "text/plain" }, [
      env.select {|key,val| key.start_with? 'HTTP_'}
      .collect {|key, val| [key.sub(/^HTTP_/, ''), val]}
      .collect {|key, val| "#{key}: #{val}"}
      .sort
      .join("\n")
    ]]
  end
  run headers
end

map '/' do
  welcome = proc do |env|
    [200, { "Content-Type" => "text/html" }, [<<WELCOME_CONTENTS
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title>Welcome to UTCCP</title>


<style>

/*!
 * Bootstrap v3.0.0
 *
 * Copyright 2013 Twitter, Inc
 * Licensed under the Apache License v2.0
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Designed and built with all the love in the world @twitter by @mdo and @fat.
 */

  .logo {
    background-size: cover;
    height: 80px;
    width: 214px;
    margin-top: 6px;
    background-image: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjxzdmcKICAgd2lkdGg9IjIxMyIKICAgaGVpZ2h0PSI3OSIKICAgdmlld0JveD0iMCAwIDIxMyA3OSIKICAgdmVyc2lvbj0iMS4xIgogICBpZD0ic3ZnMTExMTYiCiAgIHNvZGlwb2RpOmRvY25hbWU9InRlbXBsYXRlLWJhc2U2NC1pbWcuc3ZnIgogICBpbmtzY2FwZTp2ZXJzaW9uPSIxLjEgKGNlNjY2M2IzYjcsIDIwMjEtMDUtMjUpIgogICB4bWxuczppbmtzY2FwZT0iaHR0cDovL3d3dy5pbmtzY2FwZS5vcmcvbmFtZXNwYWNlcy9pbmtzY2FwZSIKICAgeG1sbnM6c29kaXBvZGk9Imh0dHA6Ly9zb2RpcG9kaS5zb3VyY2Vmb3JnZS5uZXQvRFREL3NvZGlwb2RpLTAuZHRkIgogICB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciCiAgIHhtbG5zOnN2Zz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxkZWZzCiAgICAgaWQ9ImRlZnMxMTEyMCIgLz4KICA8c29kaXBvZGk6bmFtZWR2aWV3CiAgICAgaWQ9Im5hbWVkdmlldzExMTE4IgogICAgIHBhZ2Vjb2xvcj0iI2ZmZmZmZiIKICAgICBib3JkZXJjb2xvcj0iIzY2NjY2NiIKICAgICBib3JkZXJvcGFjaXR5PSIxLjAiCiAgICAgaW5rc2NhcGU6cGFnZXNoYWRvdz0iMiIKICAgICBpbmtzY2FwZTpwYWdlb3BhY2l0eT0iMC4wIgogICAgIGlua3NjYXBlOnBhZ2VjaGVja2VyYm9hcmQ9IjAiCiAgICAgc2hvd2dyaWQ9ImZhbHNlIgogICAgIGlua3NjYXBlOnpvb209IjcuMDI4MTY5IgogICAgIGlua3NjYXBlOmN4PSIxMDYuNSIKICAgICBpbmtzY2FwZTpjeT0iMzkuNTU1MTEiCiAgICAgaW5rc2NhcGU6d2luZG93LXdpZHRoPSIxOTIwIgogICAgIGlua3NjYXBlOndpbmRvdy1oZWlnaHQ9Ijk1NiIKICAgICBpbmtzY2FwZTp3aW5kb3cteD0iMCIKICAgICBpbmtzY2FwZTp3aW5kb3cteT0iMCIKICAgICBpbmtzY2FwZTp3aW5kb3ctbWF4aW1pemVkPSIxIgogICAgIGlua3NjYXBlOmN1cnJlbnQtbGF5ZXI9InN2ZzExMTE2IiAvPgogIDxnCiAgICAgZmlsbD0ibm9uZSIKICAgICBmaWxsLXJ1bGU9ImV2ZW5vZGQiCiAgICAgaWQ9ImcxMTExNCIKICAgICB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtOC43NDM4OTIyLDcuMzk3MzQ3MykiPgogICAgPHBhdGgKICAgICAgIGZpbGw9IiMwMDUwZmYiCiAgICAgICBkPSJtIDEyNS45MTYwMiwxMC44NDgzOTkgYyAxLjc2NDEyLDAgMi43MTcxMSwxLjExMzAzNyAyLjc2OTg2LDIuMjExNTIzIHYgMCBoIC0xLjQ2OTUgYyAtMC4wMjM2LC0wLjIxNDYwNSAtMC4yODAwOCwtMC45MDkzNDMgLTEuMjk0OTEsLTAuOTA5MzQzIC0wLjg0OTMyLDAgLTEuNDk2NzcsMC42Njc0NTggLTEuNDk2NzcsMS44MDk1OTMgMCwxLjAwMjA5NiAwLjY1MTA4LDEuNjY5NTU0IDEuNTE0OTYsMS42Njk1NTQgMC45MjU3MSwwIDEuMjM4NTMsLTAuNTI3NDE5IDEuMzI1ODIsLTEuMjE0ODgzIHYgMCBoIDEuNDY5NSBjIC0wLjA5ODIsMS40MzMxMjUgLTEuMDUzMDIsMi40ODc5NjMgLTIuODQyNjEsMi40ODc5NjMgLTEuNDQ0MDMsMCAtMi45OTM1NSwtMS4wNDU3NDQgLTIuOTkzNTUsLTIuOTY4MDk2IDAsLTEuOTIyMzUxIDEuMjExMjQsLTMuMDg2MzExIDMuMDE3MiwtMy4wODYzMTEgeiBtIC00Ni4yMTU1NDgsMC4xNDE0OTQgdiAzLjE1OTA1OCBjIDAsMC45NTI5OTIgMC40ODkyMjYsMS4zMjIxODUgMS4yOTg1NDIsMS4zMjIxODUgMC45NjU3MjIsMCAxLjI4NTgxMSwtMC40NDAxMjIgMS4yODU4MTEsLTEuMzY5NDcxIHYgLTMuMTExNzcyIGggMS42OTY4MzQgdiAzLjQyMjc2OCBjIDAsMS4wNTMwMTkgLTAuMzc4Mjg3LDIuNDg2MTQ0IC0yLjk5NTM3NiwyLjQ4NjE0NCBDIDc5LjA4MDMsMTYuODk4ODA1IDc4LDE2LjExMzEzMiA3OCwxNC41MjkwNTcgdiAtMy41MzkxNjQgeiBtIDE5LjEwNzg0NSwtMC4xMjE0ODggYyAxLjg1Njg4MywwIDMuMTIyNjgzLDEuMzQ3NjQ3IDMuMTIyNjgzLDMuMDA4MTA3IDAsMS42NjIyNzkgLTEuNDAwMzksMy4wMDk5MjYgLTMuMTIyNjgzLDMuMDA5OTI2IC0xLjcyNDExNSwwIC0zLjEyMjY4NCwtMS4zNDc2NDcgLTMuMTIyNjg0LC0zLjAwOTkyNiAwLC0xLjY2MDQ2IDEuMTgwMzI3LC0zLjAwODEwNyAzLjEyMjY4NCwtMy4wMDgxMDcgeiBtIC00LjA4NjQwNiwwLjEyMjAzNCB2IDUuNzc2MTQ3IGggLTEuNzA0MTA5IHYgLTUuNzc2MTQ3IHogbSAtNy41NjE3MzQsLTUuNDZlLTQgMi42ODA3NDQsMy41NTE4OTUgdiAtMy41NTE4OTUgaCAxLjU5ODYyNSB2IDUuNzc2MTQ4IEggODkuNzk3MjcyIEwgODcuMTI5MjU5LDEzLjIyMzI0IHYgMy41NDI4MDEgaCAtMS42MDQwODEgdiAtNS43NzYxNDggeiBtIDE3LjMxMTE2MywwIDIuNjgwNzUsMy41NTE4OTUgdiAtMy41NTE4OTUgaCAxLjYwMDQ0IHYgNS43NzYxNDggaCAtMS42NDQwOSBsIC0yLjY2ODAyLC0zLjU0MjgwMSB2IDMuNTQyODAxIGggLTEuNjA0MDggdiAtNS43NzYxNDggeiBtIDExLjA3NDM1LDAgdiAxLjIyNTc5NSBoIC0yLjAyMDU2IHYgNC41NTAzNTMgaCAtMS43MDA0OCB2IC00LjU0MzA3OCBoIC0yLjAyNzgzIHYgLTEuMjMzMDcgeiBtIDYuMzA2MTEsMCB2IDEuMjI1Nzk1IGggLTMuNTY2NDUgdiAwLjk5ODQ1OSBoIDMuMjc1NDYgdiAxLjE1ODUwMyBoIC0zLjI3NTQ2IHYgMS4xNjk0MTUgaCAzLjY0MjgzIHYgMS4yMjM5NzYgaCAtNS4zNDMzIHYgLTUuNzc2MTQ4IHogbSA5LjcwNTk2LDAgdiAyLjEyOTY4MiBoIDIuNTI0MzQgdiAtMi4xMjk2ODIgaCAxLjcwMDQ3IHYgNS43NzYxNDggaCAtMS43MDc3NCB2IC0yLjM5NzAyOSBoIC0yLjUxNzA3IHYgMi4zOTcwMjkgaCAtMS42OTg2NSB2IC01Ljc3NjE0OCB6IG0gLTMyLjc0OTQ0MywxLjM1NzEwNCBjIC0wLjc5NjU4NSwwIC0xLjQ0NDAzNywwLjYzNDcyMiAtMS40NDQwMzcsMS41MzEzMzQgMCwwLjg5NDc5NCAwLjY0NzQ1MiwxLjUzNDk3MSAxLjQ0NDAzNywxLjUzNDk3MSAwLjc5NDc2NiwwIDEuNDQyMjIzLC0wLjY0MDE3NyAxLjQ0MjIyMywtMS41MzQ5NzEgMCwtMC44OTY2MTIgLTAuNjQ3NDU3LC0xLjUzMTMzNCAtMS40NDIyMjMsLTEuNTMxMzM0IHoiCiAgICAgICBpZD0icGF0aDExMTA0IiAvPgogICAgPHBhdGgKICAgICAgIGZpbGw9IiMwMDUwZmYiCiAgICAgICBkPSJNIDg3LDEwLjk1MjIxIEMgODcsOS44NzI5Njk0IDg2LjEzNjE0OSw5IDg1LjA3MjI0Nyw5IEggMzAuOTI5NTcxIEMgMjkuODYzODUxLDkgMjksOS44NzI5Njk0IDI5LDEwLjk1MjIxIFYgMjcuMDQ1OTQ4IEMgMjksMjguMTI1MTg5IDI4LjEzNzk2NywyOSAyNy4wNzIyNDcsMjkgSCAxMC45Mjk1NzEgQyA5Ljg2Mzg1MTUsMjkgOSwyOS44NzI5NjkgOSwzMC45NTIyMSBWIDQ2LjA0Nzc5IEMgOSw0Ny4xMjUxODkgOS44NjM4NTE1LDQ4IDEwLjkyOTU3MSw0OCBIIDg1LjA3MjI0NyBDIDg2LjEzNjE0OSw0OCA4Nyw0Ny4xMjUxODkgODcsNDYuMDQ3NzkgWiIKICAgICAgIHRyYW5zZm9ybT0ibWF0cml4KC0xLDAsMCwxLDk2LDApIgogICAgICAgaWQ9InBhdGgxMTEwNiIgLz4KICAgIDxwYXRoCiAgICAgICBmaWxsPSIjMDA1MGZmIgogICAgICAgZD0iTSAyMDQsMTAuOTUyMjEgQyAyMDQsOS44NzI5Njk0IDIwMy4xMzYxNSw5IDIwMi4wNzIyNSw5IEggMTQ3LjkyOTU3IEMgMTQ2Ljg2Mzg1LDkgMTQ2LDkuODcyOTY5NCAxNDYsMTAuOTUyMjEgViAyNy4wNDU5NDggQyAxNDYsMjguMTI1MTg5IDE0NS4xMzc5NywyOSAxNDQuMDcyMjUsMjkgSCAxMjcuOTI5NTcgQyAxMjYuODYzODUsMjkgMTI2LDI5Ljg3Mjk2OSAxMjYsMzAuOTUyMjEgViA0Ni4wNDc3OSBDIDEyNiw0Ny4xMjUxODkgMTI2Ljg2Mzg1LDQ4IDEyNy45Mjk1Nyw0OCBoIDc0LjE0MjY4IEMgMjAzLjEzNjE1LDQ4IDIwNCw0Ny4xMjUxODkgMjA0LDQ2LjA0Nzc5IFoiCiAgICAgICBpZD0icGF0aDExMTA4IiAvPgogICAgPHRleHQKICAgICAgIGZpbGw9IiMwMDUwZmYiCiAgICAgICBmaWxsLXJ1bGU9Im5vbnplcm8iCiAgICAgICBmb250LWZhbWlseT0iU291cmNlSGFuU2Fuc1NDLU1lZGl1bSwgJ1NvdXJjZSBIYW4gU2FucyBTQyciCiAgICAgICBmb250LXNpemU9IjE4cHgiCiAgICAgICBmb250LXdlaWdodD0iNDAwIgogICAgICAgbGV0dGVyLXNwYWNpbmc9IjMuMyIKICAgICAgIGlkPSJ0ZXh0MTExMTIiPjx0c3BhbgogICAgICAgICB4PSIxMy42NSIKICAgICAgICAgeT0iNjkiCiAgICAgICAgIGlkPSJ0c3BhbjExMTEwIj7nu5/kv6HlrrnlmajkupHnrqHnkIblubPlj7A8L3RzcGFuPjwvdGV4dD4KICA8L2c+CiAgPHRleHQKICAgICB4bWw6c3BhY2U9InByZXNlcnZlIgogICAgIHN0eWxlPSJmb250LXN0eWxlOm5vcm1hbDtmb250LXZhcmlhbnQ6bm9ybWFsO2ZvbnQtd2VpZ2h0OmJvbGQ7Zm9udC1zdHJldGNoOm5vcm1hbDtmb250LXNpemU6OHB4O2xpbmUtaGVpZ2h0OjEuMjU7Zm9udC1mYW1pbHk6c2Fucy1zZXJpZjstaW5rc2NhcGUtZm9udC1zcGVjaWZpY2F0aW9uOidzYW5zLXNlcmlmLCBCb2xkJztmb250LXZhcmlhbnQtbGlnYXR1cmVzOm5vcm1hbDtmb250LXZhcmlhbnQtY2Fwczpub3JtYWw7Zm9udC12YXJpYW50LW51bWVyaWM6bm9ybWFsO3RleHQtYWxpZ246c3RhcnQ7bGV0dGVyLXNwYWNpbmc6MHB4O3dvcmQtc3BhY2luZzowcHg7d3JpdGluZy1tb2RlOmxyLXRiO3RleHQtYW5jaG9yOnN0YXJ0O2ZpbGw6IzAwMDAwMDtmaWxsLW9wYWNpdHk6MTtzdHJva2U6bm9uZSIKICAgICB4PSItMC4wODU2MTM2MzEiCiAgICAgeT0iNi44MzQ1MjY1IgogICAgIGlkPSJ0ZXh0MTI1MzIiPjx0c3BhbgogICAgICAgc29kaXBvZGk6cm9sZT0ibGluZSIKICAgICAgIGlkPSJ0c3BhbjEyNTMwIgogICAgICAgeD0iLTAuMDg1NjEzNjMxIgogICAgICAgeT0iNi44MzQ1MjY1IgogICAgICAgc3R5bGU9ImZvbnQtc3R5bGU6bm9ybWFsO2ZvbnQtdmFyaWFudDpub3JtYWw7Zm9udC13ZWlnaHQ6bm9ybWFsO2ZvbnQtc3RyZXRjaDpub3JtYWw7Zm9udC1zaXplOjhweDtmb250LWZhbWlseTpzYW5zLXNlcmlmOy1pbmtzY2FwZS1mb250LXNwZWNpZmljYXRpb246c2Fucy1zZXJpZjtmaWxsOiM2NjY2NjYiPkJ1aWxkIG9uPC90c3Bhbj48L3RleHQ+Cjwvc3ZnPgo=)
  }
.logo a {
  display: block;
  width: 100%;
  height: 100%;
}
*, *:before, *:after {
    -moz-box-sizing: border-box;
    box-sizing: border-box;
}
aside,
footer,
header,
hgroup,
section{
  display: block;
}
body {
  color: #404040;
  font-family: "Helvetica Neue",Helvetica,"Liberation Sans",Arial,sans-serif;
  font-size: 14px;
  line-height: 1.4;
}

html {
  font-family: sans-serif;
  -ms-text-size-adjust: 100%;
  -webkit-text-size-adjust: 100%;
}
ul {
    margin-top: 0;
}
.container {
  margin-right: auto;
  margin-left: auto;
  padding-left: 15px;
  padding-right: 15px;
}
.container:before,
.container:after {
  content: " ";
  /* 1 */

  display: table;
  /* 2 */

}
.container:after {
  clear: both;
}
.row {
  margin-left: -15px;
  margin-right: -15px;
}
.row:before,
.row:after {
  content: " ";
  /* 1 */

  display: table;
  /* 2 */

}
.row:after {
  clear: both;
}
.col-sm-6, .col-md-6, .col-xs-12 {
  position: relative;
  min-height: 1px;
  padding-left: 15px;
  padding-right: 15px;
}
.col-xs-12 {
  width: 100%;
}

@media (min-width: 768px) {
  .container {
    width: 750px;
  }
  .col-sm-6 {
    float: left;
  }
  .col-sm-6 {
    width: 50%;
  }
}

@media (min-width: 992px) {
  .container {
    width: 970px;
  }
  .col-md-6 {
    float: left;
  }
  .col-md-6 {
    width: 50%;
  }
}
@media (min-width: 1200px) {
  .container {
    width: 1170px;
  }
}

a {
  color: #069;
  text-decoration: none;
}
a:hover {
  color: #EA0011;
  text-decoration: underline;
}
hgroup {
  margin-top: 50px;
}
footer {
    margin: 50px 0 25px;
}
h1, h2, h3 {
  color: #000;
  line-height: 1.38em;
  margin: 1.5em 0 .3em;
}
h1 {
  font-size: 25px;
  font-weight: 300;
  border-bottom: 1px solid #fff;
  margin-bottom: .5em;
}
h1:after {
  content: "";
  display: block;
  width: 100%;
  height: 1px;
  background-color: #ddd;
}
h2 {
  font-size: 19px;
  font-weight: 400;
}
h3 {
  font-size: 15px;
  font-weight: 400;
  margin: 0 0 .3em;
}
p {
  margin: 0 0 2em;
  text-align: justify;
}
p + h2 {
  margin-top: 2em;
}
html {
  background: #f5f5f5;
  height: 100%;
}
code {
  background-color: white;
  border: 1px solid #ccc;
  padding: 1px 5px;
  color: #888;
}
pre {
  display: block;
  padding: 13.333px 20px;
  margin: 0 0 20px;
  font-size: 13px;
  line-height: 1.4;
  background-color: #fff;
  border-left: 2px solid rgba(120,120,120,0.35);
  white-space: pre;
  white-space: pre-wrap;
  word-break: normal;
  word-wrap: break-word;
  overflow: auto;
  font-family: Menlo,Monaco,"Liberation Mono",Consolas,monospace !important;
}

</style>

</head>
<body>

<section class='container'>
          <hgroup>
            <h1>Welcome to your Ruby application on UTCCP</h1>
          </hgroup>


        <div class="row">
          <section class='col-xs-12 col-sm-6 col-md-6'>
            <section>
              <h2>Deploying code changes</h2>
                <p>
                  The source code for this application is available to be forked from the <a href="https://www.github.com/utccp/ruby-ex">UTCCP GitHub repository</a>.
                  You can configure a webhook in your repository to make UTCCP automatically start a build whenever you push your code:
                </p>

<ol>
  <li>From the Web Console homepage, navigate to your project</li>
  <li>Click on Browse &gt; Builds</li>
  <li>From the view for your Build click on the button to copy your GitHub webhook</li>
  <li>Navigate to your repository on GitHub and click on repository settings &gt; webhooks</li>
  <li>Paste your webhook URL provided by UTCCP &mdash; that's it!</li>
</ol>
<p>After you save your webhook, if you refresh your settings page you can see the status of the ping that Github sent to OpenShift to verify it can reach the server.</p>
<p>Note: adding a webhook requires your UTCCP server to be reachable from GitHub.</p>

                <h3>Working in your local Git repository</h3>
                <p>If you forked the application from the OpenShift GitHub example, you'll need to manually clone the repository to your local system. Copy the application's source code Git URL and then run:</p>

<pre>$ git clone &lt;git_url&gt; &lt;directory_to_create&gt;

# Within your project directory
# Commit your changes and push to OpenShift

$ git commit -a -m 'Some commit message'
$ git push</pre>

<p>After pushing changes, you'll need to manually trigger a build if you did not setup a webhook as described above.</p>
      </section>
          </section>
          <section class="col-xs-12 col-sm-6 col-md-6">

                <h2>Managing your application</h2>

                <p>Documentation on how to manage your application from the Web Console or Command Line is available at the <a href="http://docs.okd.io/latest/dev_guide/overview.html">Developer Guide</a>.</p>

                <h3>Web Console</h3>
                <p>You can use the Web Console to view the state of your application components and launch new builds.</p>

                <h3>Command Line</h3>
                <p>With the <a href="http://docs.okd.io/latest/cli_reference/overview.html">UTCCP command line interface</a> (CLI), you can create applications and manage projects from a terminal.</p>

                <h2>Development Resources</h2>
                  <ul>
                    <li><a href="http://docs.okd.io/latest/welcome/index.html">UTCCP Documentation</a></li>
                    <li><a href="https://github.com/utccp/source-to-image">Source To Image GitHub</a></li>
                    <li><a href="http://docs.okd.io/latest/using_images/s2i_images/ruby.html">Getting Started with Ruby on OpenShift</a></li>
                    <li><a href="http://git-scm.com/documentation">Git documentation</a></li>
                  </ul>


          </section>
        </div>

        <footer>
          <div class="logo"><a href="https://www.uniontech.com/"></a></div>
        </footer>
</section>


</body>
</html>
WELCOME_CONTENTS
    ]]
  end
  run welcome
end
