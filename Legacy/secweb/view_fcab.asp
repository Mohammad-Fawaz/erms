<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head><%
Dim sFCab
Dim sCurSelection
'Dim cnFCab

If (Request.QueryString("FC") <> "") Then
	sCurSelection = Request.QueryString("FC")
	'Set cnFCab = GetConn()
	'sFCab = GetFCab(sCurSelection, cnFCab)
	sFCab = GetFCab(sCurSelection)
Else
	sCurSelection = "START"
	'sFCab = GetFCab(sCurSelection, Nothing)
	sFCab = GetFCab(sCurSelection)
End If

%>

<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>System File Cabinet</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <!--<td width="145" valign="top" bgcolor="#FFFFC8"><% '=sMenu %></td>-->
    <td width="635" valign="top"><font face="Verdana" size="5">System File Cabinet</font><p><strong><font face="Verdana" size="2">Please select from the available options...</font><font face="Verdana" size="3"><br>
    </font></strong><font face="Verdana" size="1">Subsequent selections are displayed
    heirarchically. Links are provided in order to view information <strong>[INFO]</strong>,
    and where available, to view available documents or resources <strong>[VIEW]</strong>.</font></p>
    <hr noshade color="#0075FF">
<% =sFCab %>
    <!-- <strong><font face="Verdana" size="2">Current Position: <a href="view_fcab.asp?<% =SVars & "&FC=PROJ" %>">Projects</a>:<a href="view_fcab.asp?<% =SVars & "&FC=PROJ:ACT" %>">Active</a>:[Project]:Documents</font></strong>    <hr noshade color="#808000">    <ul>      <li><font face="Verdana"><strong><a href="view_fcab.asp?<% =SVars & "&FC=PROJ" %>">PROJECTS</a></strong></font><ul>          <li><font face="Verdana" size="2"><a href="view_fcab.asp?<% =SVars & "&FC=PROJ:ACT" %>">ACT            - ACTIVE</a></font><ul>              <li><font face="Verdana" size="2">Project <strong>[INFO]</strong></font><ul>                  <li><strong><font face="Verdana" size="2">Documents</font></strong><ul>                      <li><font face="Verdana" size="2">[DocID] - Desc... <strong>[INFO]</strong> <strong>[VIEW]</strong></font></li>                    </ul>                  </li>                  <li><strong><font face="Verdana" size="2">Change Orders</font></strong><ul>                      <li><font face="Verdana" size="2">[CO] - Desc... <strong>[INFO]</strong></font></li>                    </ul>                  </li>                  <li><strong><font face="Verdana" size="2">Tasks</font></strong><ul>                      <li><font face="Verdana" size="2">[TaskID] - Desc... <strong>[INFO]</strong></font></li>                    </ul>                  </li>                  <li><strong><font face="Verdana" size="2">Material Dispositions</font></strong><ul>                      <li><font face="Verdana" size="2">[MDispID] - Desc... [INFO]</font></li>                    </ul>                  </li>                  <li><strong><font face="Verdana" size="2">Quality Actions</font></strong><ul>                      <li><font face="Verdana" size="2">[ActionType] - Desc.</font><ul>                        <li><font face="Verdana" size="2">[RefNum] - Desc... <strong>[INFO]</strong></font></li>                        </ul>                      </li>                    </ul>                  </li>                </ul>              </li>            </ul>          </li>        </ul>      </li>      <li><font face="Verdana"><strong>DOCUMENTS</strong></font><ul>          <li><strong><font face="Verdana" size="2">Released</font></strong><ul>              <li><font face="Verdana" size="2">[DocID] - Desc... <strong>[INFO]</strong> <strong>[VIEW]</strong></font></li>            </ul>          </li>          <li><font face="Verdana" size="2"><strong>Not Released</strong></font><ul>              <li><font face="Verdana" size="2">[DocStatus] - Desc.</font><ul>                  <li><font face="Verdana" size="2">[DocID] - Desc... <strong>[INFO]</strong> <strong>[VIEW]</strong></font></li>                </ul>              </li>            </ul>          </li>          <li><strong><font face="Verdana" size="2">Document Type</font></strong><ul>              <li><font face="Verdana" size="2">[DocType] - Desc.</font><ul>                  <li><font face="Verdana" size="2">[DocID] - Desc... <strong>[INFO]</strong> <strong>[VIEW]</strong></font></li>                </ul>              </li>            </ul>          </li>        </ul>      </li>      <li><font face="Verdana"><strong>CHANGE ORDERS</strong></font><ul>          <li><strong><font face="Verdana" size="2">Released</font></strong><ul>              <li><font face="Verdana" size="2">[CO] - Desc... <strong>[INFO]</strong></font></li>            </ul>          </li>          <li><strong><font face="Verdana" size="2">Not Released</font></strong><ul>              <li><font face="Verdana" size="2">[ChStatus] - Desc.</font><ul>                  <li><font face="Verdana" size="2">[CO] - Desc... <strong>[INFO]</strong></font></li>                </ul>              </li>            </ul>          </li>          <li><strong><font face="Verdana" size="2">Change Type</font></strong><ul>              <li><font face="Verdana" size="2">[ChType] - Desc.</font><ul>                  <li><font face="Verdana" size="2">[CO] - Desc... [INFO]</font></li>                </ul>              </li>            </ul>          </li>        </ul>      </li>      <li><font face="Verdana"><strong>TASKS</strong></font><ul>          <li><font face="Verdana" size="2"><strong>Open</strong></font><ul>              <li><font face="Verdana" size="2">[TaskID] - Desc... <strong>[INFO]</strong></font></li>            </ul>          </li>          <li><font face="Verdana" size="2"><strong>Not Open</strong></font><ul>              <li><font face="Verdana" size="2">[TaskStatus] - Desc.</font><ul>                  <li><font face="Verdana" size="2">[TaskID] - Desc... <strong>[INFO]</strong></font></li>                </ul>              </li>            </ul>          </li>          <li><strong><font face="Verdana" size="2">Task Type</font></strong><ul>              <li><font face="Verdana" size="2">[TaskType] - Desc.</font><ul>                  <li><font face="Verdana" size="2">[TaskID] - Desc... <strong>[INFO]</strong></font></li>                </ul>              </li>            </ul>          </li>        </ul>      </li>      <li><font face="Verdana"><strong>MATERIAL DISPOSITIONS</strong></font><ul>          <li><strong><font face="Verdana" size="2">Open</font></strong><ul>              <li><font face="Verdana" size="2">[MDispID] - Desc... <strong>[INFO]</strong></font></li>            </ul>          </li>          <li><strong><font face="Verdana" size="2">Not Open</font></strong><ul>              <li><font face="Verdana" size="2">[DispStatus] - Desc.</font><ul>                  <li><font face="Verdana" size="2">[MDispID] - Desc... <strong>[INFO]</strong></font></li>                </ul>              </li>            </ul>          </li>          <li><strong><font face="Verdana" size="2">Disposition Type</font></strong><ul>              <li><font face="Verdana" size="2">[DispType] - Desc.</font><ul>                  <li><font face="Verdana" size="2">[MDispID] - Desc... [INFO]</font></li>                </ul>              </li>            </ul>          </li>        </ul>      </li>      <li><font face="Verdana"><strong>QUALITY ACTIONS</strong></font><ul>          <li><strong><font face="Verdana" size="2">Open</font></strong><ul>              <li><font face="Verdana" size="2">[ActionType][RefNum] - Desc... <strong>[INFO]</strong></font></li>            </ul>          </li>          <li><strong><font face="Verdana" size="2">Not Open</font></strong><ul>              <li><font face="Verdana" size="2">[ActionStatus] - Desc.</font><ul>                  <li><font face="Verdana" size="2">[ActionType][RefNum] - Desc... <strong>[INFO]</strong></font></li>                </ul>              </li>            </ul>          </li>          <li><strong><font face="Verdana" size="2">ActionType</font></strong><ul>              <li><font face="Verdana" size="2">[ActionType] - Desc.</font><ul>                  <li><font face="Verdana" size="2">[RefNum] - Desc... <strong>[INFO]</strong></font></li>                </ul>              </li>            </ul>          </li>        </ul>      </li>    </ul>    &nbsp; --></td>
  </tr>
  <tr>
    <td width="100%" colspan="2" align="center"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>
