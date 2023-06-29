<%@  language="VBScript" %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head>
    <!--<link rel="stylesheet" type="text/css" href="../pg_style.css">-->
    <title>System Search Tools</title>
    <!--<style type="text/css">
        .auto-style1 {
            height: 36px;
        }
        .auto-style2 {
            height: 29px;
        }
    </style>-->
    <link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
</head>

<body>
    <div id="layoutSidenav_content">
        <main>
            <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                <div class="container-xl px-4">
                    <div class="page-header-content">
                        <div class="row align-items-center justify-content-between pt-3">
                            <div class="col-auto mb-3">
                                <h1 class="page-header-title">
                                    <div class="page-header-icon"><i data-feather="user"></i></div>
                                    Advance Search
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
                        <!-- System Search Tools card-->
                        <div class="card mb-4">
                            <div class="card-header">System Search Tools</div>
                            <div class="card-body">
                                <form method="POST" action="ret_search.asp">
                                    <input type="hidden" name="A" value="Set">
                                    <div>
                                        <table border="0">
                                            <tr>
                                                <td>Search on...</td>
                                                <td>
                                                    <select class="form-select" name="SearchBase" size="1">
                                                        <option value="Change Orders">Change Orders</option>
                                                        <option value="ControlLists">Control Lists</option>
                                                        <option value="Documents">Documents</option>
                                                        <option value="Orders">Orders</option>
                                                        <option value="Parts">Parts</option>
                                                        <option value="Projects">Projects</option>
                                                        <option value="Quality Actions">Quality Actions</option>
                                                        <option value="Reports">Reports</option>
                                                        <option value="Restrictions">Restrictions</option>
                                                        <option value="Tasks">Tasks</option>
                                                    </select></td>
                                                <td>
                                                    <input type="submit" class="btn btn-primary-soft" value="Begin Search" name="B1"></td>

                                            </tr>
                                        </table>
                                        <br />
                                        <table>
                                            <tr>
                                                <td style="background-color: #FFFFFF; color: #0075FF; font-family: 'Arial Black';"><font face="Verdana" size="4" font-bold="true">SEARCHING THE SYSTEM</font><font face="Verdana" size="2"></font></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <hr noshade color="#00000">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><font face="Verdana" size="2">Please make an initial selection
    to perform a search on a specific set of records. On the following screen you will be
    provided with a form to select from the available search fields and provide specific
    values for your search.</font></td>
                                            </tr>
                                        </table>
                                    </div>
                                </form>
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
