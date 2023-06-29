<%@  language="VBScript" %>
<!-- #INCLUDE FILE="script/incl_pgdef1a.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<html>

<head>
    <%
Dim sList

sList = GetSelect("BItemInfo", "")

    %>

    <link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
    <title>Modify BOM</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

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
                        <!-- Modify Bill of Materialn card-->
                        <div class="card mb-4">
                            <div class="card-header">Modify Bill of Material</div>
                            <div class="card-body">
                                <table border="0" cellpadding="2" cellspacing="0" width="780">
                                    <tr>
                                        <td width="100%" colspan="2">
                                            <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <!--<td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %></td>-->

                                        <td width="635" valign="top">
                                            <p><font face="Verdana" size="2">Select BOM item to view and modify:</font></p>
                                            <form method="POST" action="bom_addedit.asp">
                                                <input type="hidden" name="Mode" value="BM">
                                                <div>
                                                    <table border="0" cellpadding="2" cellspacing="0">
                                                        <tr>
                                                            <td align="right"><strong><font face="Verdana" size="2">Item Information:</font></strong></td>
                                                            <td>
                                                                <select name="BItemID" size="1" class="form-select">
                                                                    <% =sList %>
                                                                </select></td>
                                                            <td>
                                                                <input type="submit" class="btn btn-primary-soft" value="Continue" name="B1"></td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </form>
                                            <p>
                                                &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td width="100%" colspan="2">
                                            <!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
                                        </td>
                                    </tr>
                                </table>
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
