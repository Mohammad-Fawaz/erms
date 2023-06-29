<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1a.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<html>

<head>
<link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
<title>BOM Reports</title>
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
                        <!-- BOM Reports card-->
                        <div class="card mb-4">
                            <div class="card-header">BOM Reports</div>
                            <div class="card-body">                       
                                <table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2">
        <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
    </td>
  </tr>
  <tr>
    <!--<td width="145" valign="top" bgcolor="#FFFFC8"><%'=sMenu %>-->
</td>
    <td width="635" valign="top"><p><font face="Verdana" size="2">Please select a report format and specify an item to report on.
    The report will be displayed in a separate browser window allowing it to be printed
    directly though the browser interface.</font></p>
    <form method="POST" action="bom_printrpt.asp" target="_blank">
      <div align="center"><center><table border="0" cellpadding="2" cellspacing="0">
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>Report Format:</strong></font></td>
          <td><select name="RFmt" size="1" class="form-select">
            <option value="StdBOM">Standard BOM Report</option>
            <option value="BItemEff">BOM Item Effectivity Report</option>
            <option value="CostBOM">Standard Costed BOM Report</option>
          </select></td>
        </tr>
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>BOM Item:</strong></font></td>
          <td><select name="BItemID" size="1" class="form-select">
<% =GetSelect("BItemInfo", "") %>
          </select></td>
        </tr>
        <tr>
            <td></td>
          <td align="left"><input type="submit" class="btn btn-primary-soft" value="Get Report" name="B1"></td>
        </tr>
      </table>
      </center></div>
    </form>
    <p>&nbsp;</td>
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
