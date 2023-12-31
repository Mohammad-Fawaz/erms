﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data;


public partial class DashBoard : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;
    public int _EmpId;
    Int32 ReportID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        _SessionUser = this.Master.UserName;
        _SID = this.Master.SID;
        _EmpId = this.Master.EmpID;

        if (!Page.IsPostBack)
        {
            //LoadWorkFlowTasks();
            LoadChangeOrders();
            LoadDocuments();
            LoadProjects();
            LoadReports();
            LoadHelpTickets();
            LoadWorkFlowTasks();
        }
    }

    private void LoadWorkFlowTasks()
    {
        DataTable _dt = null;

        string query = @"SELECT WATID, TaskID, RefType,WATStatus, RefNum, Priority, TaskDesc, BFinish, WATType, WFAssnTo FROM ViewWFTasks WHERE(WFActive <> 0) AND(WATActive <> 0) AND (AssignTo = " + _EmpId + ") AND WATStatus ='ACTIVE' ORDER BY BFinish, TaskID";
        _dt = DataAccess.GetRecords(query);

        lblInBoxCount.Text = _dt.Rows.Count.ToString();
        if (_dt.Rows.Count > 0)
        {
            this.grdMyTasks.DataSource = _dt;
            this.grdMyTasks.DataBind();
        }
    }

    private void LoadChangeOrders()
    {
        DataTable _dt = null;

        string query = @"SELECT CO, ChDue, Priority, ChangeDesc FROM ViewChanges WHERE (ChStatus <> 'CLS') AND (ChStatus <> 'REL') AND (ChStatus <> 'REJ') AND (ChAssignTo = '" + _SessionUser.ToString() + "')";
        _dt = DataAccess.GetRecords(query);
        lblChangeOrders.Text = _dt.Rows.Count.ToString();

        if (_dt.Rows.Count > 0)
        {
            this.grdChangeOrders.DataSource = _dt;
            this.grdChangeOrders.DataBind();
        }
    }

    private void LoadDocuments()
    {
        DataTable _dt = null;

        string query = @"SELECT DocID, DocDesc, ProjNum, DocReqDate, Status FROM ViewDocs WHERE (DocStatus = 'CREQ') AND (DocReqBy = '" + _SessionUser.ToString() + "')";
        _dt = DataAccess.GetRecords(query);
        lblDocuuments.Text = _dt.Rows.Count.ToString();

        if (_dt.Rows.Count > 0)
        {
            this.grdDocuments.DataSource = _dt;
            this.grdDocuments.DataBind();
        }
    }

    private void LoadProjects()
    {
        DataTable _dt = null;
        string query = string.Empty;
        if (Utils.IsAdmin(_SID))
        {
            query = @"SELECT ProjNum, ProjName, Status, ActualStart, PlannedFinish FROM ViewProjects WHERE ProjStatus NOT IN ('CLS') ORDER BY PlannedFinish DESC";
        }
        else
        {
            query = @"SELECT ProjNum, ProjName, Status, ActualStart, PlannedFinish FROM ViewProjects WHERE ProjStatus NOT IN ('CLS') AND AssignTo=" + Session["UserID"] + " ORDER BY PlannedFinish DESC";
        }
        _dt = DataAccess.GetRecords(query);
        lblProjects.Text = _dt.Rows.Count.ToString();

        if (_dt.Rows.Count > 0)
        {
            this.grdProjects.DataSource = _dt;
            this.grdProjects.DataBind();
        }
    }
    private void LoadReports()
    {
        String QSReportID = Request.QueryString["ReportID"];
        if (!String.IsNullOrEmpty(QSReportID))
        {
            ReportID = Convert.ToInt32(QSReportID);
        }

        Int32 _rowCount = 0;

        try
        {
            this.gvReports.CssClass = "dataTable-table";
            this.gvReports.HeaderStyle.CssClass = "GridViewStyleView";
            this.gvReports.RowStyle.CssClass = "GridViewStyleView";
            this.gvReports.AutoGenerateDeleteButton = true;
            this.gvReports.AutoGenerateSelectButton = true;
            this.gvReports.EnableViewState = true;
            this.gvReports.Controls.Clear();

            using (DataTable _tempMyReports = DataAccess.GetRecords(DataQueries.GetMyReports(ReportID, _EmpId, Utils.IsAdmin(_SID))))
            {
                _rowCount = _tempMyReports.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvReports.DataSource = _tempMyReports;
                    this.gvReports.DataBind();
                }
                else
                {
                    this.lblStatus.Text = "No Report found";
                }
                lblReports.Text = _rowCount.ToString(); ;
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage            
        }


    }

    private void LoadHelpTickets()
    {
        Int32 _rowCount = 0;
        Int32 COID = 0; //for check---
        try
        {
            //this.gvNotes.CssClass = "GridViewStyleView";
            //this.gvNotes.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvNotes.RowStyle.CssClass = "GridViewStyleView";
            //this.gvNotes.AutoGenerateDeleteButton = true;
            this.gvNotes.EnableViewState = false;
            this.gvNotes.Controls.Clear();



            using (DataTable _tempAddedNotes = DataAccess.GetRecords(DataQueries.getDashBoardDataHelpDesk(_SessionUser)))

            {
                _rowCount = _tempAddedNotes.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvNotes.DataSource = _tempAddedNotes;
                    this.gvNotes.DataBind();
                }

                lblHelpTickets.Text = _rowCount.ToString();
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }

    }

    private void LoadGrid()
    {
        string actionType = HfActionType.Value;
        string query = "";
        DataTable _dt = null;
        if (actionType == "Projects")
        {
            query = @"SELECT '' as Action,ProjNum, ProjName, Status, ActualStart, PlannedFinish FROM ViewProjects 
                    WHERE ProjStatus NOT IN ('CLS') ORDER BY PlannedFinish DESC";
            _dt = DataAccess.GetRecords(query);
            lblProjects.Text = _dt.Rows.Count.ToString();
        }
        else if (actionType == "Tasks")
        {
            query = @"SELECT '' as Action,TaskID, Priority, TaskDesc, BFinish, ResourceName FROM ViewTasks WHERE (TaskStatus <> 'CLS') AND (TaskCostType <> 'P') AND 
                        (ResourceName = '" + Session["_UserName"].ToString() + "') ORDER BY BFinish, TaskID";
            _dt = DataAccess.GetRecords(query);
            //lblEngItemsBom.Text = _dt.Rows.Count.ToString();
        }
        else if (actionType == "WorkFlowTask")
        {
            //sSQL = "SELECT WATID, TaskID, RefType, RefNum, Priority, TaskDesc, BFinish, WATType, WFAssnTo FROM ViewWFTasks WHERE (WFActive <> 0) AND (WATActive <> 0) ORDER BY BFinish, TaskID"
            query = @"SELECT '' as Action,WATID, TaskID, RefType, RefNum, Priority, TaskDesc, BFinish, WATType, WFAssnTo FROM ViewWFTasks WHERE(WFActive <> 0) 
AND(WATActive <> 0) AND(WFAssnTo = " + Session["_empId"] + ") ORDER BY BFinish, TaskID";
            _dt = DataAccess.GetRecords(query);

            lblInBoxCount.Text = _dt.Rows.Count.ToString();
            if (_dt.Rows.Count > 0)
            {
                this.grdMyTasks.DataSource = _dt;
                this.grdMyTasks.DataBind();
            }

        }
        else if (actionType == "Changes")
        {
            query = @"SELECT '' as Action,CO, ChDue, Priority, ChangeDesc FROM ViewChanges WHERE (ChStatus <> 'CLS') AND (ChStatus <> 'REL') AND (ChStatus <> 'REJ') 
 AND (ChAssignTo = '" + Session["_UserName"].ToString() + "')";
            _dt = DataAccess.GetRecords(query);
            lblChangeOrders.Text = _dt.Rows.Count.ToString();
        }
        else if (actionType == "Documents")
        {
            query = @"SELECT '' as Action,DocID, DocDesc, ProjNum, DocReqDate, Status FROM ViewDocs 
WHERE (DocStatus = 'CREQ') AND (DocReqBy = '" + Session["_UserName"].ToString() + "')";
            _dt = DataAccess.GetRecords(query);
            lblDocuuments.Text = _dt.Rows.Count.ToString();
        }
        else if (actionType == "ChangesRequested")
        {
        }



    }

    protected void grdMyTasks_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            HyperLink lnk = (HyperLink)e.Row.FindControl("hlkAction");
            HiddenField HfRefType = (HiddenField)e.Row.FindControl("HfRefType");
            HiddenField HfRefNum = (HiddenField)e.Row.FindControl("HfRefNum");
            HiddenField HfWATID = (HiddenField)e.Row.FindControl("HfWATID");

            lnk.NavigateUrl = "WorkFlowManagement/WFTaskInformation.aspx?SID=" + _SID.ToString() + "&RFTP=" + HfRefType.Value + "&RFID=" + HfRefNum.Value + "&TID=" + HfWATID.Value + "";
            lnk.Target = "_top";

            HyperLink lnkView = (HyperLink)e.Row.FindControl("hlkView");
            lnkView.NavigateUrl = "WorkFlowManagement/WFTaskInformationReview.aspx?SID=" + _SID.ToString() + "&RFTP=" + HfRefType.Value + "&RFID=" + HfRefNum.Value + "&TID=" + HfWATID.Value + "";
            lnkView.Target = "_top";
        }
    }

    protected void grdChangeOrders_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            HyperLink lnk = (HyperLink)e.Row.FindControl("hlkAction");
            HiddenField HfCOID = (HiddenField)e.Row.FindControl("HfCOID");

            lnk.NavigateUrl = "ChangeManagement/ChangeOrders.aspx?SID=" + _SID.ToString() + "&COID=" + HfCOID.Value + "";
            lnk.Target = "_top";


        }
    }

    protected void grdDocuments_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            HyperLink lnk = (HyperLink)e.Row.FindControl("hlkAction");
            HiddenField HfDocID = (HiddenField)e.Row.FindControl("HfDocID");

            lnk.NavigateUrl = "DocumentManagement/DocInformation.aspx?SID=" + _SID.ToString() + "&DOCID=" + HfDocID.Value + "";
            lnk.Target = "_top";


        }
    }
    protected void gvNotes_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            HyperLink lnk = (HyperLink)e.Row.FindControl("hlkAction");
            HiddenField HfDocID = (HiddenField)e.Row.FindControl("HfDocID");

            lnk.NavigateUrl = "ChangeManagement/Helpdesk.aspx?SID=" + _SID.ToString() + "&COID=" + HfDocID.Value + "";
            lnk.Target = "_top";


        }
    }


    protected void grdProjects_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            HyperLink lnk = (HyperLink)e.Row.FindControl("hlkAction");
            HiddenField HfProjNum = (HiddenField)e.Row.FindControl("HfProjNum");

            lnk.NavigateUrl = "ProjectManagement/ProjectInformation.aspx?SID=" + _SID.ToString() + "&PID=" + HfProjNum.Value + "";
            lnk.Target = "_top";


        }
    }

    protected void gvReports_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        String _ReportID = gvReports.Rows[e.NewSelectedIndex].Cells[1].Text;
        Server.Transfer("MyReportsResults.aspx?SID=" + _SID + "&RepID=" + _ReportID);
    }

    protected void gvReports_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Int32 _colReportIDIndex = 1;

        Int32 ReportID = 0;

        if (gvReports.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            ReportID = Convert.ToInt32(gvReports.Rows[e.RowIndex].Cells[_colReportIDIndex].Text);
            Int32 _StatusCheck = DataAccess.ModifyRecords(DataQueries.DeleteMyReportsByID(ReportID));
            if (_StatusCheck > 0)
            {
                //this.lblStatus.Text = "Success ! Report was deleted";
            }
        }

        //GetMyReports(0);
    }


    protected void gvReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colDeleteIndex = 0;
        Int32 _colReportIDIndex = 1;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            // Report ID
            e.Row.Cells[_colReportIDIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colReportIDIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvReports = (DataRowView)e.Row.DataItem;

            Int32 _colReportNameIndex = drvReports.DataView.Table.Columns["Report Name"].Ordinal + 1;
            Int32 _colReportDescIndex = drvReports.DataView.Table.Columns["Report Desc"].Ordinal + 1;

            //Delete Button
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=App_Themes/delete.gif />";
            }

            //Select Button
            using (LinkButton lbSelect = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[2])
            {
                lbSelect.Text = "<img height=15 width=15 border=0 src=App_Themes/find.gif />";
            }

            //Align
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colDeleteIndex].Width = 60;
            e.Row.Cells[_colReportNameIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colReportDescIndex].HorizontalAlign = HorizontalAlign.Left;
        }
    }



}