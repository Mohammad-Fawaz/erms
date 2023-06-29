<html>
<body>
<%
dim cc
dim i
dim strSession
dim ots
set cc=server.createobject("ClientClassDemo.Interaction")
set ots=server.CreateObject("ClientClassDemo.OutputTypes")
cc.GetSessionID("Glovia Reports")
strSession=cc.SessionID
cc.GetReports
%>
<form name="ReportList" method=post action="http://intranet/GloviaReports/runreport.asp">
<input type="hidden" value="5" name="OutputType">
<input type="hidden" name="SelectedReport" name="BOM">
<input type="hidden" name="SessionID" value="<%=strSession%>">
<input type="submit" name="Name" value="Run Report">
<%
set cc=nothing
set ots=nothing
%>
</form>
</body>
</html>