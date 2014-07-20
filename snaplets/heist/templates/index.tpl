<apply template="base">

  <div class="row">
    <div class="col-lg-12">
      <h1 class="page-header">All
        <small>of them</small>
      </h1>
    </div>
  </div>

  <allPosts>
    <div class="row">

      <div class="col-lg-6 col-lg-6">
        <div class="col-lg-5 col-lg-offset-5">
          <a href="/posts/${category}/${key}">
            <img class="img-responsive" src="/static/images/${category}/${key}/headshot.png" alt="">
          </a>
        </div>
      </div>

      <div class="col-lg-6 col-lg-6">
        <h3><author /></h3>
        <h4><title /></h4>
        <h3><small> <subheading /></small></h3>
        <p><bio /></p>
        <a class="btn btn-primary" href="/posts/${category}/${key}">Read <span class="glyphicon glyphicon-chevron-right"></span></a>
      </div>

    </div>

    <div class="row">
      <div class="col-lg-12 col-lg-12">
        <hr />
      </div>
    </div>
  </allPosts>

</apply>
