<apply template="base">

  <div class="row">
    <div class="col-lg-12">
      <h1 class="page-header">
        <category /> <small>with <author /></small>
      </h1>
    </div>
  </div>

  <div class="row">
    <div class="col-lg-10 col-lg-offset-1">
      <post />
    </div>
  </div>


  <div class="row">
    <div class="col-lg-10 col-lg-offset-1">
      <hr />
    </div>
  </div>


  <div class="row">
    <div class="col-lg-6 col-lg-6">
      <div class="col-lg-5 col-lg-offset-5">
        <img class="img-responsive" src="/static/images/${category}/${keySplice}/headshot.png" alt="">
      </div>
    </div>

    <div class="col-lg-6 col-lg-6">
      <h3><author /></h3>
      <h4><titleSplice /></h4>
      <h3><small> <subheadingSplice /></small></h3>
      <p><bioSplice /></p>
    </div>
  </div>

</apply>
