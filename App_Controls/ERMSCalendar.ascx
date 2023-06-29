<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ERMSCalendar.ascx.cs" Inherits="ERMSCalendar" %>
<asp:TextBox ID="uctxtDate" runat="server" CssClass="datepicker"></asp:TextBox><input id="ucbtnDate" placeholder="mm/dd/yyyy" type="button" runat="server" value="..."/>
<asp:Panel ID="ucpnlDate" runat="server" style="POSITION: absolute">    
    <asp:calendar id="uccldrDate" CssClass="removeDefaultCalender" runat="server" CellPadding="4" 
      BorderColor="#999999" Font-Names="Verdana" Font-Size="8pt" 
      Height="150px" ForeColor="Black" DayNameFormat="FirstLetter" 
      Width="140px" BackColor="#CCCCCC" ShowGridLines="True" 
      EnableTheming="False" OnSelectionChanged="uccldrDate_SelectionChanged" OnVisibleMonthChanged="uccldrDate_VisibleMonthChanged">
      <TitleStyle Font-Bold="True" BorderColor="Black" BackColor="#999999"></TitleStyle>      
      <DayHeaderStyle Font-Size="7pt" Font-Bold="True"></DayHeaderStyle>
      <WeekendDayStyle BackColor="#999999"></WeekendDayStyle>
      <TodayDayStyle Font-Size="8pt" Font-Bold="True" ForeColor="Black"></TodayDayStyle>
      <SelectedDayStyle Font-Bold="True" ForeColor="White"></SelectedDayStyle>
      <OtherMonthDayStyle ForeColor="Gray"></OtherMonthDayStyle>
    </asp:calendar>
</asp:Panel>
