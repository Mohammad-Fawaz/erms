<%@  language="VBScript" %>
<!-- #INCLUDE FILE="script/incl_pgdef1a.asp" -->
<html>

<head>
    <link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
    <!--<link rel="stylesheet" type="text/css" href="../pg_style.css">-->
    <title>Create BOM</title>
</head>

<body class="nav-fixed">
    <div id="layoutSidenav_content">
        <main>
            <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                <div class="container-xl px-4">
                    <div class="page-header-content">
                        <div class="row align-items-center justify-content-between pt-3">
                            <div class="col-auto mb-3">
                                <h1 class="page-header-title">
                                    <div class="page-header-icon"><i data-feather="user"></i></div>
                                    Bill of Material
                                        </h1>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <!-- Main page content-->
            <div class="container-xl px-4 mt-4">
                <div class="row">
                    <div class="col-xl-12">
                        <!-- Task information card-->
                        <div class="card mb-4">
                            <div class="card-header">Create Bill of Material</div>
                            <div class="card-body">                               
                                            <p><font face="Verdana" size="2">Provide Item Number for BOM Header Information:<br><i>(Do not use wildcard characters)</i></font></p>
                                            <form method="POST" action="bom_createh2.asp">
                                                <input type="hidden" name="Mode" value="HN">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                <label class="small mb-1" for="BOMItem">Item Number</label>                                                   
                                                 <input type="text" name="BOMItem" class="form-control" size="20">                          
                                                    </div>
                                                </div>
                                                 <div class="row mt-2">
                                                    <div class="col-md-6">
                                               <input type="submit" class="btn btn-primary-soft" value="Continue" name="B1">                      
                                                    </div>
                                                </div>
                                                <div>                                                    
                                                </div>
                                            </form>
                                            <p>
                                                <font face="Verdana" size="2">Partial or unmatched numbers will return a selectable
                                                    listing of item numbers to choose from. If no information is provided a complete listing
                                                    of available item numbers will be returned, but this may lead to slower loading of the
                                                    page.</font>
                                            </p>                                            
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>

</body>
</html>
