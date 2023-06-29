<%@  language="VBScript" %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_info.asp" -->
<!-- #INCLUDE FILE="script/incl_wkflow.asp" -->
<html>

<head>
    <%
Dim sRT, sR, sT
Dim sWInfo
Dim sTInfo

sWInfo = ""
sTInfo = ""
'If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
If (Request.QueryString <> "") Then
	sT = Request.QueryString("T")
	sRT = Request.QueryString("RT")
	sR = Request.QueryString("R")
Else
	sT = ""
	sRT = ""
	sR = ""
End If

If ((sRT <> "") And (sR <> "")) Then sWInfo = GetWFInfo(sRT, sR)
If (sT <> "") Then
	sTInfo = GetWTask(sT)
End If

    %>
    <link rel="stylesheet" type="text/css" href="../pg_style.css">
    <link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
    <title>View Workflow</title>
    <style>
    	iframe#PageContent_frameQSearch {
    		height: 780px !important;
    	}

    	table {
    		width: 100% !important;
    		border: none !important;
    	}
    </style>
</head>

<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <table border="0" cellpadding="2" cellspacing="0" width="820">
                            <tr>
                                <td width="100%" colspan="2">
                                    <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
                                </td>
                            </tr>
                            <tr>
                                <!--<td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %>
                                </td>-->
                                <td width="635" valign="top"><font face="Verdana" size="5">ERMS Workflow</font>
                                    <% =sWInfo %>
                                    <% =sTInfo %>
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
</body>
</html>
