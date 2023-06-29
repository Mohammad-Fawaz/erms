<%@  language="VBScript" %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->

<html>
<head>
    <%
Dim sItem

 sItem = GetHTML("SuppDocs", "", "", "")
 
    %>

    <link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
    <title>Help Files &amp; Documentation</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

    <!--webbot bot="Include" endspan i-checksum="42909" -->

</body>
<div id="layoutSidenav_content">
    <main>
        <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
            <div class="container-xl px-4">
                <div class="page-header-content">
                    <div class="row align-items-center justify-content-between pt-3">
                        <div class="col-auto mb-3">
                            <h1 class="page-header-title">
                                <div class="page-header-icon"><i data-feather="user"></i></div>
                                <font face="Verdana" size="5">Help Files &amp; Documentation</font>
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
                        <div class="card-header">Help Files &amp; Documentation</div>
                        <div class="card-body">
                            <table>

                                <tr>
                                    <!--<td width="145" valign="top" bgcolor="#FFFFC8"><%' =sMenu %></td>
                                    <td width="635" valign="top">
                                        <p>
                                            <font face="Verdana" size="2"><% =sItem %></font>
                                            </p>
                                    </td>-->
                                    <td width="100%">
                                        <h3>How To Documents</h3>
                                    </td>
                                </tr>
                                <tr>
                                    <!--<td width="100%" colspan="2">
                                        webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" startspan 
                                    </td>-->
                                    <td width="100%">
                                        <ul>
                                            <li class="mb-2">
                                                <a href="#">Finding a Document</a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#">Creating a Change Request</a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#">Creating an IT Help Desk Ticket</a>
                                            </li>
                                            <li>
                                                <a href="#">Monitoring My Tasks</a>
                                            </li>
                                        </ul>
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
</html>
