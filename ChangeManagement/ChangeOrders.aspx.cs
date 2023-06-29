using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Drawing;
using System.Globalization;
using System.Collections.Generic;
using System.IO;

/// <summary>
/// Change Order Class
/// </summary>
public partial class ChangeManagement_ChangeOrders : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;
    private Boolean _IsEditAllow = true;
    public static string currentPageName = "";
    public Boolean IsEditAllow
    {
        get { return _IsEditAllow; }
        set { _IsEditAllow = value; }
    }

    /// <summary>
    /// Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.lblStatus.Text = null;
        Int32 ChangeID = 0;
        currentPageName = Path.GetFileName(Request.Url.AbsolutePath);
        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;
            //CheckFields();
            CheckDropdownVisible();
            CheckdropsdownView();
            EnabledDropsDown();
            //Get Change Order ID
            String QSChangeID = Request.QueryString["COID"];
            if (!String.IsNullOrEmpty(QSChangeID))
            {
                ChangeID = Convert.ToInt32(QSChangeID);
            }

            if (!IsPostBack)
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);
                if (ChangeID > 0)
                {
                    //Change Record
                    if (GetRecord(ChangeID) > 0)
                    {

                        this.btnFind.AlternateText = "Find New Change Request";
                        //this.btnNewEditSave.Text = "Edit";
                        this.btnEdit.Visible = IsEditAllow;// true;
                        this.btnNew.Visible = false;
                        this.btnCancel.Visible = false;
                        this.btnDelete.Visible = true;

                        GetGrids(ChangeID);
                        SetLinkURLs(ChangeID);
                    }
                    else
                    {
                        //this.txtChangeID.CssClass = "CtrlShortValueEdit";
                        this.txtChangeID.ReadOnly = false;
                        this.txtChangeID.Focus();
                    }
                }
                else
                {
                    //this.txtChangeID.CssClass = "CtrlShortValueEdit";
                    this.txtChangeID.ReadOnly = false;
                    this.txtChangeID.Focus();
                }
                CheckFields();
                this.btnCancel.Visible = false;
            }

        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage            
        }
    }
    public void CheckFields()
    {
        //Set All the Control to Visible False
        divtxtChangeID.Visible = false;
        divtxtStatus.Visible = false;
        divtxtStartDate.Visible = false;
        divtxtChangeClass.Visible = false;
        divtxtChangeType.Visible = false;
        divtxtPriority.Visible = false;
        divtxtProject.Visible = false;
        divtxtDescription.Visible = false;
        divtxtRequestedBy.Visible = false;
        divtxtDateRequestedBy.Visible = false;
        divtxtJustification.Visible = false;
        divtxtApprovedBy.Visible = false;
        divtxtDateApprovedBy.Visible = false;
        divtxtAssignedTo.Visible = false;
        divtxtReleasedBy.Visible = false;
        divtxtDateReleasedBy.Visible = false;
        divtxtDateAssignedTo.Visible = false;
        divtxtCompletedBy.Visible = false;
        divtxtLastModifiedBy.Visible = false;
        divtxtDateLastModifiedBy.Visible = false;
        divtxtDateCompletedBy.Visible = false;
        divChargeNumber.Visible = false;
        btnFind.Visible = false;
        //btnNewEditSave.Visible = false;
        //this.btnEdit.Visible = false;
        this.btnNew.Visible = false;
        btnCancel.Visible = false;
        btnDelete.Visible = false;
        IsEditAllow = false;

        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);

        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.GetAssignedFormFieldsData(2, RoleId)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["Controlid"].ToString();
                if (txtDocIDs == "divtxtChangeID") { divtxtChangeID.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divtxtStatus") { divtxtStatus.Visible = true; } //else { divStatus.Visible = false; }
                /* if (txtDocIDs == "divtxtStartDate") { divtxtEndDate.Visible = true; }*/ //else { divRevision.Visible = false; }
                if (txtDocIDs == "divtxtStartDate") { divtxtStartDate.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "divtxtChangeClass") { divtxtChangeClass.Visible = true; }
                if (txtDocIDs == "divtxtChangeType") { divtxtChangeType.Visible = true; }
                if (txtDocIDs == "divtxtPriority") { divtxtPriority.Visible = true; }
                if (txtDocIDs == "divtxtProject") { divtxtProject.Visible = true; }
                if (txtDocIDs == "divtxtDescription") { divtxtDescription.Visible = true; }
                if (txtDocIDs == "divtxtRequestedBy") { divtxtRequestedBy.Visible = true; }
                if (txtDocIDs == "divtxtDateRequestedBy") { divtxtDateRequestedBy.Visible = true; }
                if (txtDocIDs == "divtxtJustification") { divtxtJustification.Visible = true; }
                if (txtDocIDs == "divtxtApprovedBy") { divtxtApprovedBy.Visible = true; }
                if (txtDocIDs == "divtxtDateApprovedBy") { divtxtDateApprovedBy.Visible = true; }

                if (txtDocIDs == "divtxtAssignedTo") { divtxtAssignedTo.Visible = true; }
                if (txtDocIDs == "divtxtReleasedBy") { divtxtReleasedBy.Visible = true; }
                if (txtDocIDs == "divtxtDateReleasedBy") { divtxtDateReleasedBy.Visible = true; }
                if (txtDocIDs == "divtxtDateAssignedTo") { divtxtDateAssignedTo.Visible = true; }

                if (txtDocIDs == "divtxtCompletedBy") { divtxtCompletedBy.Visible = true; }
                if (txtDocIDs == "divtxtLastModifiedBy") { divtxtLastModifiedBy.Visible = true; }
                if (txtDocIDs == "divtxtDateLastModifiedBy") { divtxtDateLastModifiedBy.Visible = true; }

                if (txtDocIDs == "divtxtDateCompletedBy") { divtxtDateCompletedBy.Visible = true; }
                if (txtDocIDs == "divChargeNumber") { divChargeNumber.Visible = true; }
                //For Buttons
                if (txtDocIDs == "btnFind") { btnFind.Visible = true; }
                //if (txtDocIDs == "btnNewEditSave")
                //{
                //    //btnNewEditSave.Visible = true;
                //    btnNew.Visible = true;

                //}
                if (txtDocIDs == "btnNew") { btnNew.Visible = true; }
                if (txtDocIDs == "btnEdit")
                {
                    IsEditAllow = true;
                }
                if (txtDocIDs == "btnCancel") { btnCancel.Visible = true; }
                if (txtDocIDs == "btnDelete") { btnDelete.Visible = true; }


            }

        }

    }
    public void CheckDropdownVisible()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.ShowDropdowns(RoleId, 2)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["MasterID"].ToString();
                if (txtDocIDs == "divhlnkAssocDoc") { divhlnkAssocDoc.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divhlnkAttachFiles") { divhlnkAttachFiles.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "divhlnkNotes") { divhlnkNotes.Visible = true; } //else { divRevision.Visible = false; }

                if (txtDocIDs == "divhlnkChangeImpact") { divhlnkChangeImpact.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "divhlnkMaterialDisposition") { divhlnkMaterialDisposition.Visible = true; }
                if (txtDocIDs == "divhlnkWFTasks") { divhlnkWFTasks.Visible = true; }
                if (txtDocIDs == "divhlnkWFCustom") { divhlnkWFCustom.Visible = true; }
            }
        }

    }
    public void CheckdropsdownView()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.visibleDropDown(RoleId, 2)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ChildID"].ToString();
                if (txtDocIDs == "hlnkAssocDoc") { hlnkAssocDoc.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "hlnkAttachFiles") { hlnkAttachFiles.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "hlnkNotes") { hlnkNotes.Visible = true; } //else { divRevision.Visible = false; }

                if (txtDocIDs == "hlnkChangeImpact") { hlnkChangeImpact.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "hlnkMaterialDisposition") { hlnkMaterialDisposition.Visible = true; }
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Visible = true; }
                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Visible = true; }
                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Visible = true; }






            }

        }
    }
    public void EnabledDropsDown()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.EnabledDropDown(RoleId, 2)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ChildID"].ToString();
                if (txtDocIDs == "hlnkAssocDoc") { hlnkAssocDoc.Enabled = true; hfd_gvAssociatedDocs.Value = "1"; }
                // else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "hlnkAttachFiles") { hlnkAttachFiles.Enabled = true; hfd_gvAttachedFiles.Value = "1"; } //else { divStatus.Visible = false; }

                if (txtDocIDs == "hlnkNotes") { hlnkNotes.Enabled = true; hfd_gvNotes.Value = "1"; } //else { divRevision.Visible = false; }

                if (txtDocIDs == "hlnkChangeImpact") { hlnkChangeImpact.Enabled = true; hfd_gvChangeImpact.Value = "1"; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "hlnkMaterialDisposition") { hlnkMaterialDisposition.Enabled = true; hfd_gvMaterialDispositionInfo.Value = "1"; }
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Enabled = true; hfd_gvWFTasks.Value = "1"; }
                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Enabled = true; hfd_gvAttachedFiles.Value = "1"; }
                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Enabled = true; hfd_gvAttachedFiles.Value = "1"; }
            }

        }

    }
    /// <summary>
    /// Set all Navigation URLs
    /// </summary>
    private void SetLinkURLs(Int32 ChangeID)
    {
        hlnkAssocDoc.NavigateUrl = "~/ChangeManagement/AssociateDocs.aspx?SID=" + _SID + "&COID=" + ChangeID;
        hlnkAttachFiles.NavigateUrl = "~/ChangeManagement/AttachFiles.aspx?SID=" + _SID + "&COID=" + ChangeID + "&IsChangeModule=true";
        hlnkNotes.NavigateUrl = "~/ChangeManagement/AddNotes.aspx?SID=" + _SID + "&COID=" + ChangeID;
        hlnkChangeImpact.NavigateUrl = "~/ChangeManagement/ChangeImpact.aspx?SID=" + _SID + "&COID=" + ChangeID;
        hlnkMaterialDisposition.NavigateUrl = "~/ChangeManagement/AddDispositions.aspx?SID=" + _SID + "&COID=" + ChangeID;
        hlnkWFTasks.NavigateUrl = "~/WorkFlowManagement/WFAssignment.aspx?SID=" + _SID + "&RFTP=CO&RFID=" + ChangeID;
        hlnkWFCustom.NavigateUrl = "~/Common/Custom.aspx?SID=" + _SID + "&COID=" + ChangeID;

        hlnkViewChange.NavigateUrl = "../Legacy/secweb/ret_selitem.asp?SID=" + _SID + "&Listing=Change&Item=" + ChangeID;
        //hlnkPrintableFormate.NavigateUrl = "../Legacy/secweb/pnt_selitem.asp?SID=" + _SID + "&Listing=Change&Item=" + ChangeID;
        hlnkPrintableFormate.NavigateUrl = "../Legacy/secweb/ret_selitem.asp?SID=" + _SID + "&Listing=Change&Item=" + ChangeID;
        hlnkPrintableChangeRequest.NavigateUrl = "../Legacy/secweb/pnt_chgreq.asp?SID=" + _SID + "&Listing=Change&Item=" + ChangeID;
        hlnkPrintableWaiver.NavigateUrl = "../Legacy/secweb/pnt_dev.asp?SID=" + _SID + "&Listing=Change&Item=" + ChangeID;
    }

    /// <summary>
    /// Cancel Order
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 ChangeID = 0;
            String _ChangeID = this.txtChangeID.Text;
            if (!String.IsNullOrEmpty(_ChangeID))
            {
                ChangeID = Convert.ToInt32(_ChangeID);
            }

            //Cancel On Edited Existing Order before Save
            //if (this.btnFind.AlternateText == "Find New Change Request" &&
            //    (this.btnNewEditSave.Text == "Save" || this.btnNewEditSave.Text == "Update"))
            //if (this.btnFind.AlternateText == "Find New Change Request" &&
            //    (this.btnNew.Text == "Save" || this.btnEdit.Text == "Update"))
            //{
            //    if (ChangeID > 0)
            //    {
            //        GetRecord(ChangeID);
            //        GetGrids(ChangeID);
            //        SetLinkURLs(ChangeID);

            //        SetForm(FORM_ON.View);
            //        //this.btnNewEditSave.Text = "Edit";
            //        this.btnCancel.Visible = false;
            //        this.btnDelete.Visible = true;
            //    }
            //}

            ////Cancel On New Order Creation before Save
            ////if (this.btnFind.AlternateText == "Find" && this.btnNewEditSave.Text == "Save")
            //else 
            if ((this.btnFind.AlternateText == "Find" && (this.btnNew.Text == "Save" || this.btnEdit.Text == "Update"))
                || (this.btnFind.AlternateText == "Find New Change Request" && this.btnNew.Text == "New Change Request"))
            {

                InitializeFormFields();
                InitializeGrids();
                SetForm(FORM_ON.View);
                if ((this.btnFind.AlternateText == "Find New Change Request" && this.btnNew.Text == "New Change Request"))
                {
                    this.btnFind.AlternateText = "Find";
                }

                //this.txtChangeID.CssClass = "CtrlShortValueEdit";
                this.txtChangeID.ReadOnly = false;
                this.txtChangeID.Focus();

                //this.btnNewEditSave.Text = "New Change Request";
                this.btnNew.Text = "New Change Request";
                this.btnNew.Visible = true;
                this.btnEdit.Visible = false;

                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.Visible = true;

                if (this.btnEdit.Text == "Update")
                {
                    this.btnEdit.Visible = false;
                    this.btnEdit.Text = "Edit";
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage       
        }
    }

    /// <summary>
    /// Find Records
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnFind_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 ChangeID = 0;
            String _ChangeID = this.txtChangeID.Text;
            if (!String.IsNullOrEmpty(_ChangeID))
            {
                ChangeID = Convert.ToInt32(_ChangeID);
            }

            if (this.btnFind.AlternateText == "Find")
            {
                //Change Record 
                if (GetRecord(ChangeID) > 0)
                {
                    SetForm(FORM_ON.View);
                    this.btnFind.AlternateText = "Find New Change Request";
                    //this.btnNewEditSave.Text = "Edit";
                    this.btnEdit.Visible = IsEditAllow;//true;
                    this.btnNew.Visible = false;
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;

                    GetGrids(ChangeID);
                    SetLinkURLs(ChangeID);
                }
                else
                {
                    InitializeFormFields();
                    InitializeGrids();

                    SetForm(FORM_ON.View);
                    //this.txtChangeID.CssClass = "CtrlShortValueEdit";
                    this.txtChangeID.ReadOnly = false;
                    this.txtChangeID.Focus();

                    lblStatus.Text = "A Change Order " + (ChangeID) + "could not be located or created.";
                }
            }
            else if (this.btnFind.AlternateText == "Find New Change Request")
            {
                InitializeFormFields();
                InitializeGrids();

                SetForm(FORM_ON.View);
                //this.txtChangeID.CssClass = "CtrlShortValueEdit";
                this.txtChangeID.ReadOnly = false;
                this.txtChangeID.Focus();

                this.btnFind.AlternateText = "Find";
                //this.btnNewEditSave.Text = "New Change Request";
                this.btnNew.Text = "New Change Request";
                this.btnEdit.Visible = false;
                this.btnNew.Visible = true;
                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.PostBackUrl = "ChangeOrders.aspx?SID=" + _SID + "&COID=0";
            }
            CheckFields();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// New / Edit / Save
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    #region "Save"
    //protected void btnNewEditSave_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        if (this.btnNewEditSave.Text == "New Change Request")
    //        {
    //            InitializeFormFields();
    //            this.txtChangeID.Text = Utils.GetChangeOrderNewID().ToString();
    //            this.txtStatus.Text = "REQUESTED";
    //            this.txtRequestedBy.Text = _SessionUser;

    //            SetForm(FORM_ON.Edit);

    //            this.txtStartDate.Text = DateTime.Now.ToString("MM-dd-yyyy");
    //            this.txtDateRequestedBy.Text = DateTime.Now.ToString("MM-dd-yyyy");
    //            //this.txtChangeID.CssClass = "CtrlShortValueView";
    //            this.txtChangeID.ReadOnly = false;

    //            this.btnNewEditSave.Text = "Save";
    //            this.btnCancel.Visible = true;
    //            this.btnDelete.Visible = false;
    //            this.btnFind.Visible = false;
    //            divhlnkMaterialDisposition.Visible = false;
    //            divhlnkWFTasks.Visible = false;
    //            divhlnkWFCustom.Visible = false;
    //        }
    //        else if (this.btnNewEditSave.Text == "Edit")
    //        {
    //            SetForm(FORM_ON.Edit);
    //            this.btnNewEditSave.Text = "Update";
    //            this.btnCancel.Visible = true;
    //            this.btnDelete.Visible = false;
    //        }
    //        else if (this.btnNewEditSave.Text == "Save" || this.btnNewEditSave.Text == "Update")
    //        {

    //            Int32 ChangeID = 0;
    //            String _ChangeID = this.txtChangeID.Text;
    //            if (!String.IsNullOrEmpty(_ChangeID))
    //            {
    //                ChangeID = Convert.ToInt32(_ChangeID);
    //            }

    //            if (ChangeID == 0)
    //            {
    //                throw new Exception("A [CO Number] could not be located or created. The record will not be saved.");
    //            }

    //            DateTime StartDate;
    //            if (!String.IsNullOrEmpty(this.txtStartDate.Text))
    //            {
    //                StartDate = Convert.ToDateTime(this.txtStartDate.Text);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChEffDate"))
    //                {
    //                    throw new Exception("A [Start Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    StartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            DateTime EndDate;
    //            if (!String.IsNullOrEmpty(this.txtEndDate.Text))
    //            {

    //                // EndDate = DateTime.ParseExact(this.txtEndDate.Text, "MM-dd-yyyy", CultureInfo.InvariantCulture);
    //                EndDate = Convert.ToDateTime(txtEndDate.Text);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChDue"))
    //                {
    //                    throw new Exception("A [Due Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    EndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            String ChangeStatus = null;
    //            if (this.ddlStatus.SelectedItem.Text != "-NONE-")
    //            {
    //                ChangeStatus = this.ddlStatus.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChStatus"))
    //                {
    //                    throw new Exception("A [Status] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String Description = null;
    //            if (!String.IsNullOrEmpty(this.txtDescription.Text))
    //            {
    //                Description = this.txtDescription.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChangeDesc"))
    //                {
    //                    throw new Exception("A [Description] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String Project = null;
    //            if (this.ddlProject.SelectedItem.Text != "-NONE-")
    //            {
    //                Project = this.ddlProject.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ProjNum"))
    //                {
    //                    throw new Exception("A [Project] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String ChangeClass = null;
    //            if (this.ddlChangeClass.SelectedItem.Text != "-NONE-")
    //            {
    //                ChangeClass = this.ddlChangeClass.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChangeClass"))
    //                {
    //                    throw new Exception("A [Change Class] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String ChangeType = null;
    //            if (this.ddlChangeType.SelectedItem.Text != "-NONE-")
    //            {
    //                ChangeType = this.ddlChangeType.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChangeType"))
    //                {
    //                    throw new Exception("A [Change Type] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String Priority = null;
    //            if (this.ddlPriority.SelectedItem.Text != "-NONE-")
    //            {
    //                Priority = this.ddlPriority.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChPriority"))
    //                {
    //                    throw new Exception("A [Priority] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String Justification = null;
    //            if (this.ddlJustification.SelectedItem.Text != "-NONE-")
    //            {
    //                Justification = this.ddlJustification.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChJustification"))
    //                {
    //                    throw new Exception("A [Justification] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String ChangeRequestedBy = null;
    //            if (this.ddlRequestedBy.SelectedItem.Text != "-NONE-")
    //            {
    //                ChangeRequestedBy = this.ddlRequestedBy.SelectedItem.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChReqBy"))
    //                {
    //                    throw new Exception("The person [Requested By] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime ChangeRequestedDate;
    //            if (!String.IsNullOrEmpty(this.txtDateRequestedBy.Text) &&
    //                !String.IsNullOrEmpty(ChangeRequestedBy) && ChangeRequestedBy != "-NONE-")
    //            {
    //                ChangeRequestedDate = Convert.ToDateTime(this.txtDateRequestedBy.Text);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChReqDate"))
    //                {
    //                    throw new Exception("A [Requested Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    ChangeRequestedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            String ChangeApprovedBy = null;
    //            if (this.ddlApprovedBy.SelectedItem.Text != "-NONE-")
    //            {
    //                ChangeApprovedBy = this.ddlApprovedBy.SelectedItem.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChApprBy"))
    //                {
    //                    throw new Exception("The person [Approved By] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime ChangeApprovedDate;
    //            if (!String.IsNullOrEmpty(this.txtDateApprovedBy.Text) &&
    //                !String.IsNullOrEmpty(ChangeApprovedBy) && ChangeApprovedBy != "-NONE-")
    //            {
    //                ChangeApprovedDate = Convert.ToDateTime(this.txtDateApprovedBy.Text);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChApprDate"))
    //                {
    //                    ChangeApprovedDate = DateTime.Now;
    //                    //throw new Exception("An [Approved Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    ChangeApprovedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            String ChangeAssignedTo = null;
    //            if (this.ddlAssignedTo.SelectedItem.Text != "-NONE-")
    //            {
    //                ChangeAssignedTo = this.ddlAssignedTo.SelectedItem.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChAssignTo"))
    //                {
    //                    throw new Exception("The person [Assigned To] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime ChangeAssignedDate;
    //            if (!String.IsNullOrEmpty(this.txtDateAssignedTo.Text) &&
    //                !String.IsNullOrEmpty(ChangeAssignedTo) && ChangeAssignedTo != "-NONE-")
    //            {
    //                if (txtDateAssignedTo.Text != "")
    //                {
    //                    ChangeAssignedDate = Convert.ToDateTime(this.txtDateAssignedTo.Text);
    //                }
    //                else
    //                {
    //                    ChangeAssignedDate = DateTime.Now;
    //                }
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChAssignDate"))
    //                {
    //                    ChangeAssignedDate = DateTime.Now;
    //                    //throw new Exception("An [Assigned Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    ChangeAssignedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            String ChangeCompletedBy = null;
    //            if (this.ddlCompletedBy.SelectedItem.Text != "-NONE-")
    //            {
    //                ChangeCompletedBy = this.ddlCompletedBy.SelectedItem.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChCompletedBy"))
    //                {
    //                    throw new Exception("The person [Completed By] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime ChangeCompletedDate;
    //            if (!String.IsNullOrEmpty(this.txtDateCompletedBy.Text) &&
    //                !String.IsNullOrEmpty(ChangeCompletedBy) && ChangeCompletedBy != "-NONE-")
    //            {
    //                ChangeCompletedDate = Convert.ToDateTime(this.txtDateCompletedBy.Text);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChCompletedDate"))
    //                {
    //                    ChangeCompletedDate = DateTime.Now;
    //                    throw new Exception("A [Completed Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    ChangeCompletedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            String ChangeReleasedBy = null;
    //            if (this.ddlReleasedBy.SelectedItem.Text != "-NONE-")
    //            {
    //                ChangeReleasedBy = this.ddlReleasedBy.SelectedItem.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Changes", "ChReleasedBy"))
    //                {
    //                    throw new Exception("The person [Released By] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime ChangeReleasedDate;
    //            if (!String.IsNullOrEmpty(this.txtDateReleasedBy.Text) &&
    //                !String.IsNullOrEmpty(ChangeReleasedBy) && ChangeReleasedBy != "-NONE-")
    //            {
    //                ChangeReleasedDate = Convert.ToDateTime(this.txtDateReleasedBy.Text);
    //            }
    //            else
    //            {

    //                ChangeReleasedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //            }

    //            String LastModifiedBy = _SessionUser;
    //            DateTime LastModifiedDate = DateTime.Now;
    //            EndDate = DateTime.Now;
    //            ChangeReleasedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //            //}
    //            //Save 
    //            if (this.btnNewEditSave.Text == "Update")
    //            {
    //                DataAccess.ModifyRecords(DataQueries.UpdateChangesRequest(ChangeID, Constants.ChangeReferenceType, ChangeStatus, EndDate, StartDate, ChangeClass,
    //                                                                           ChangeType, Description, Project, Priority, Justification,
    //                                                                           ChangeRequestedBy, ChangeApprovedBy, ChangeAssignedTo,
    //                                                                           ChangeCompletedBy, ChangeReleasedBy, LastModifiedBy,
    //                                                                           ChangeRequestedDate, ChangeApprovedDate, ChangeAssignedDate,
    //                                                                           ChangeCompletedDate, ChangeReleasedDate, LastModifiedDate, Convert.ToInt32(TextBox1.Text.Trim())));
    //            }


    //            if (this.btnNewEditSave.Text == "Save")
    //            {

    //                if (txtStartDate.Text == "")
    //                {
    //                    DateTime startdate = DateTime.Now;
    //                }
    //                DataAccess.ModifyRecords(DataQueries.InsertChangesRequest(ChangeID, Constants.ChangeReferenceType, ChangeStatus, EndDate, StartDate, ChangeClass,
    //                                                                           ChangeType, Description, Project, Priority, Justification,
    //                                                                           ChangeRequestedBy, ChangeApprovedBy, ChangeAssignedTo,
    //                                                                           ChangeCompletedBy, ChangeReleasedBy, LastModifiedBy,
    //                                                                           ChangeRequestedDate, ChangeApprovedDate, ChangeAssignedDate,
    //                                                                           ChangeCompletedDate, ChangeReleasedDate, LastModifiedDate, !String.IsNullOrEmpty(TextBox1.Text) ? Convert.ToInt32(TextBox1.Text.Trim()) : 0));

    //            }

    //            GetRecord(ChangeID);
    //            GetGrids(ChangeID);
    //            SetLinkURLs(ChangeID);

    //            SetForm(FORM_ON.View);
    //            this.btnFind.AlternateText = "Find New Change Request";
    //            this.btnNewEditSave.Text = "Edit";
    //            this.btnCancel.Visible = false;
    //            this.btnDelete.Visible = true;
    //            this.btnFind.Visible = true;
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        lblStatus.Text = ex.Message; //Log the messsage    
    //    }
    //}
    #endregion

    /// <summary>
    /// Delete Change Order and Associated Records
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 ChangeID = 0;
            String _ChangeID = this.txtChangeID.Text;
            if (!String.IsNullOrEmpty(_ChangeID))
            {
                ChangeID = Convert.ToInt32(_ChangeID);
            }

            Boolean _DeleteRecordsPref = false;
            String _DeletePreference = this.Request.Form["hdnDeleteUserPref"];
            if (!String.IsNullOrEmpty(_DeletePreference))
            {
                _DeleteRecordsPref = Convert.ToBoolean(_DeletePreference);
            }

            if (_DeleteRecordsPref)
            {
                DataAccess.ModifyRecords(DataQueries.DeleteAttRefsByID(Constants.ChangeFileReferenceType, _ChangeID));
                DataAccess.ModifyRecords(DataQueries.DeleteNotesByRefIDType(_ChangeID, Constants.ChangeReferenceType));
                DataAccess.ModifyRecords(DataQueries.DeleteChangesByID(Constants.ChangeReferenceType, ChangeID));

                InitializeFormFields();
                InitializeGrids();

                SetForm(FORM_ON.View);
                //this.txtChangeID.CssClass = "CtrlShortValueEdit";
                this.txtChangeID.ReadOnly = false;
                this.txtChangeID.Focus();

                this.btnFind.AlternateText = "Find";
                //this.btnNewEditSave.Text = "New Change Request";
                btnNew.Text = "New Change Request";
                this.btnEdit.Visible = false;
                this.btnNew.Visible = true;

                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.PostBackUrl = "ChangeOrders.aspx?SID=" + _SID + "&COID=0";

                this.lblStatus.Text = "Success ! Change Order " + _ChangeID + " and its associated records are deleted ";
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage     
        }
    }

    /// <summary>
    /// On Change of Approved By 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlApprovedBy_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtDateApprovedBy.Text = DateTime.Now.ToShortDateString();
    }

    /// <summary>
    /// On Change of Assigned To
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlAssignedTo_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtDateAssignedTo.Text = DateTime.Now.ToShortDateString();
    }

    /// <summary>
    /// On Change of Completed By
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlCompletedBy_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtDateCompletedBy.Text = DateTime.Now.ToShortDateString();
    }

    /// <summary>
    /// On Change of Released BY
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlReleasedBy_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtDateReleasedBy.Text = DateTime.Now.ToString();
    }

    /// <summary>
    /// Get Record Values
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetRecord(Int32 COID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewChanges = DataAccess.GetRecords(DataQueries.GetViewChangesByID(COID)))
            using (DataTable _tempgetchargeno = DataAccess.GetRecords(DataQueries.getchargeno(COID)))
            {
                _rowCount = _tempViewChanges.Rows.Count;


                if (_rowCount > 0)
                {
                    this.txtChangeID.Text = _tempViewChanges.Rows[0]["Change ID"].ToString();
                    this.txtStatus.Text = _tempViewChanges.Rows[0]["Change Status"].ToString();
                    this.txtChangeClass.Text = _tempViewChanges.Rows[0]["Change Class"].ToString();
                    this.txtChangeType.Text = _tempViewChanges.Rows[0]["Change Type"].ToString();

                    String _StartDate = _tempViewChanges.Rows[0]["Start Date"].ToString();
                    if (!String.IsNullOrEmpty(_StartDate) && Constants.DateTimeMinimum != _StartDate)
                    {
                        //this.txtStartDate.Text = Convert.ToDateTime(_StartDate).ToShortDateString();
                        this.txtStartDate.Text = Convert.ToDateTime(_StartDate).ToString("MM-dd-yyyy");
                    }

                    String _EndDate = _tempViewChanges.Rows[0]["End Date"].ToString();
                    if (!String.IsNullOrEmpty(_EndDate) && Constants.DateTimeMinimum != _EndDate)
                    {
                        this.txtEndDate.Text = Convert.ToDateTime(_EndDate).ToString("MM-dd-yyyy");
                    }

                    this.txtPriority.Text = _tempViewChanges.Rows[0]["Priority"].ToString();
                    this.txtJustification.Text = _tempViewChanges.Rows[0]["Justification"].ToString();
                    this.txtProject.Text = _tempViewChanges.Rows[0]["Project"].ToString();
                    this.txtDescription.Text = _tempViewChanges.Rows[0]["Change Description"].ToString();
                    this.txtRequestedBy.Text = _tempViewChanges.Rows[0]["Change Requested By"].ToString();
                    this.txtApprovedBy.Text = _tempViewChanges.Rows[0]["Change Approved By"].ToString();
                    this.txtAssignedTo.Text = _tempViewChanges.Rows[0]["Change Assigned To"].ToString();
                    this.txtCompletedBy.Text = _tempViewChanges.Rows[0]["Change Completed By"].ToString();
                    this.txtReleasedBy.Text = _tempViewChanges.Rows[0]["Change Released By"].ToString();
                    this.txtLastModifiedBy.Text = _tempViewChanges.Rows[0]["Last Modified By"].ToString();

                    String _DateRequestedBy = _tempViewChanges.Rows[0]["Change Requested Date"].ToString();
                    if (!String.IsNullOrEmpty(_DateRequestedBy) && Constants.DateTimeMinimum != _DateRequestedBy)
                    {
                        this.txtDateRequestedBy.Text = Convert.ToDateTime(_DateRequestedBy).ToString("yyyy-MM-dd");
                    }

                    String _DateApprovedBy = _tempViewChanges.Rows[0]["Change Approved Date"].ToString();
                    if (!String.IsNullOrEmpty(_DateApprovedBy) && Constants.DateTimeMinimum != _DateApprovedBy)
                    {
                        this.txtDateApprovedBy.Text = Convert.ToDateTime(_DateApprovedBy).ToString("yyyy-MM-dd");
                    }

                    String _DateAssignedTo = _tempViewChanges.Rows[0]["Change Assigned Date"].ToString();
                    if (!String.IsNullOrEmpty(_DateAssignedTo) && Constants.DateTimeMinimum != _DateAssignedTo)
                    {
                        this.txtDateAssignedTo.Text = Convert.ToDateTime(_DateAssignedTo).ToShortDateString();
                    }

                    String _DateCompletedBy = _tempViewChanges.Rows[0]["Change Completed Date"].ToString();
                    if (!String.IsNullOrEmpty(_DateCompletedBy) && Constants.DateTimeMinimum != _DateCompletedBy)
                    {
                        this.txtDateCompletedBy.Text = Convert.ToDateTime(_DateCompletedBy).ToShortDateString();
                    }

                    String _DateReleasedBy = _tempViewChanges.Rows[0]["Change Released Date"].ToString();
                    if (!String.IsNullOrEmpty(_DateReleasedBy) && Constants.DateTimeMinimum != _DateReleasedBy)
                    {
                        this.txtDateReleasedBy.Text = Convert.ToDateTime(_DateReleasedBy).ToString("yyyy-MM-dd");
                    }
                    String DateLastModifiedBy = _tempViewChanges.Rows[0]["Last Modified Date"].ToString();
                    this.txtDateLastModifiedBy.Text = Convert.ToDateTime(DateLastModifiedBy).ToString("yyyy-MM-dd");
                }
                _rowCount = _tempgetchargeno.Rows.Count;
                if (_rowCount > 0)
                {
                    this.TextBox1.Text = _tempgetchargeno.Rows[0]["ChargeNo"].ToString();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Get Associated Doc 
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetAssociatedDocs(Int32 COID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvAssociatedDocs.CssClass = "GridViewStyleView";
            //this.gvAssociatedDocs.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvAssociatedDocs.RowStyle.CssClass = "GridViewStyleView";
            this.gvAssociatedDocs.AutoGenerateDeleteButton = true;
            this.gvAssociatedDocs.EnableViewState = false;
            this.gvAssociatedDocs.Controls.Clear();

            using (DataTable _tempAssocDocs = DataAccess.GetRecords(DataQueries.GetViewAssocDocsByID(COID)))
            {
                _rowCount = _tempAssocDocs.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvAssociatedDocs.DataSource = _tempAssocDocs;
                    this.gvAssociatedDocs.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    ///  Associated Doc Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAssociatedDocs_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        if (hfd_gvAssociatedDocs.Value == "1")
        {
            Int32 ChangeID = 0;
            String _ChangeID = this.txtChangeID.Text;
            if (!String.IsNullOrEmpty(_ChangeID))
            {
                ChangeID = Convert.ToInt32(_ChangeID);
            }

            GetAssociatedDocs(ChangeID);

            if (gvAssociatedDocs.Rows.Count < 1)
            {
                e.Cancel = true;
            }
            else
            {
                String _Revision = null;
                Int32 _StatusCheck = 0;
                String DocumentID = gvAssociatedDocs.Rows[e.RowIndex].Cells[1].Text;

                //Get Revision
                using (DataTable _dtRevisions = DataAccess.GetRecords(DataQueries.GetRevisionsByID(ChangeID, DocumentID)))
                {
                    _Revision = _dtRevisions.Rows[0]["Old Revision"].ToString();
                    if (String.IsNullOrEmpty(_Revision))
                    {
                        using (DataTable _dtDocRevision = DataAccess.GetRecords(DataQueries.GetDocumentsByID(DocumentID)))
                        {
                            _Revision = _dtDocRevision.Rows[0]["Current Revision"].ToString();
                        }
                    }
                }

                //Check Revision and Remove
                if (!String.IsNullOrEmpty(_Revision))
                {
                    String _docStatus = "REL";
                    String _LastModifiedBy = "REMOVED FROM CO :" + ChangeID;

                    _StatusCheck = DataAccess.ModifyRecords(DataQueries.RemoveRevisionsByID(ChangeID, DocumentID));
                    if (_StatusCheck > 0)
                    {
                        this.lblStatus.Text = "Success ! Document " + ChangeID + " removed from Change Order " + ChangeID;
                    }

                    _StatusCheck = DataAccess.ModifyRecords(DataQueries.UpdateDocumentByID(DocumentID, _docStatus, _Revision,
                                                                                            _LastModifiedBy, DateTime.Now));
                }
            }

            GetGrids(ChangeID);
        }
    }

    /// <summary>
    /// Associated Doc Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAssociatedDocs_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //_SessionUser = this.Master.UserName;
        //_SID = this.Master.SID;
        Int32 _colDeleteIndex = 0;

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //Get Column Indexes
            DataRowView drvADocs = (DataRowView)e.Row.DataItem;

            Int32 _colDocIDIndex = drvADocs.DataView.Table.Columns["Document ID"].Ordinal + 1;
            Int32 _colORevIndex = drvADocs.DataView.Table.Columns["Old Revision"].Ordinal + 1;
            Int32 _colCRevIndex = drvADocs.DataView.Table.Columns["Current Revision"].Ordinal + 1;
            Int32 _colNRevIndex = drvADocs.DataView.Table.Columns["New Revision"].Ordinal + 1;
            Int32 _colStatusIndex = drvADocs.DataView.Table.Columns["Status"].Ordinal + 1;
            Int32 _colDescriptionIndex = drvADocs.DataView.Table.Columns["Description"].Ordinal + 1;
            Int32 _colDocTypeIndex = drvADocs.DataView.Table.Columns["Document Type"].Ordinal + 1;
            Int32 _colLastModifiedByIndex = drvADocs.DataView.Table.Columns["Last Modified By"].Ordinal + 1;
            Int32 _colDateModifiedIndex = drvADocs.DataView.Table.Columns["Date Modified"].Ordinal + 1;

            //HyperLink Button
            if (hfd_gvAssociatedDocs.Value == "1")
            {
                HyperLink hlControl = new HyperLink();
                hlControl.Text = e.Row.Cells[_colDocIDIndex].Text;
                hlControl.NavigateUrl = "../DocumentManagement/DocInformation.aspx?DOCID=" + e.Row.Cells[_colDocIDIndex].Text + "&SID=" + _SID;
                e.Row.Cells[_colDocIDIndex].Controls.Add(hlControl);
                //Delete Button
                using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
                {
                    lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
                }
            }
            else
            {
                using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
                {
                    lbDelete.Text = "<img height=15 width=15 border=0 class='cell' src=../App_Themes/bin.png />";
                }
            }



            //Format            
            String _ModDate = e.Row.Cells[_colDateModifiedIndex].Text;
            if (!String.IsNullOrEmpty(_ModDate))
            {
                e.Row.Cells[_colDateModifiedIndex].Text = Convert.ToDateTime(_ModDate).ToShortDateString();
            }

            //Align
            e.Row.Cells[_colDocIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colORevIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colCRevIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colNRevIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colDescriptionIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colDocTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colLastModifiedByIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colDateModifiedIndex].HorizontalAlign = HorizontalAlign.Center;
        }
    }

    /// <summary>
    /// Get Attached Files
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetAttachedFiles(Int32 COID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvAttachedFiles.CssClass = "GridViewStyleView";
            //this.gvAttachedFiles.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvAttachedFiles.RowStyle.CssClass = "GridViewStyleView";
            this.gvAttachedFiles.AllowPaging = false;
            this.gvAttachedFiles.AutoGenerateDeleteButton = true;
            this.gvAttachedFiles.EnableViewState = false;
            this.gvAttachedFiles.Controls.Clear();

            using (DataTable _tempAttachFiles = DataAccess.GetRecords(DataQueries.GetViewAttachByTypeAndID(Constants.ChangeFileReferenceType, COID)))
            {
                _rowCount = _tempAttachFiles.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvAttachedFiles.DataSource = _tempAttachFiles;
                    this.gvAttachedFiles.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Files Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAttachedFiles_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Int32 ChangeID = 0;
        String _ChangeID = this.txtChangeID.Text;
        if (!String.IsNullOrEmpty(_ChangeID))
        {
            ChangeID = Convert.ToInt32(_ChangeID);
        }
        GetAttachedFiles(ChangeID);

        if (gvAttachedFiles.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 AttachID = Convert.ToInt32(gvAttachedFiles.Rows[e.RowIndex].Cells[1].Text);
            Int32 _StatusCheck = DataAccess.ModifyRecords(DataQueries.DeleteAttRefsByID(AttachID));
            if (_StatusCheck > 0)
            {
                this.lblStatus.Text = "Success ! File was detached";
            }
        }

        GetGrids(ChangeID);
    }

    /// <summary>
    /// Files Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAttachedFiles_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //Hide ID Column
        Int32 _colDeleteIndex = 0;
        Int32 _colIDIndex = 1;

        //QuickFix
        Int32 _colFLinkIndex = 6;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colIDIndex].Visible = false;

            //QuickFix 
            e.Row.Cells[_colFLinkIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colIDIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvAttachedFiles = (DataRowView)e.Row.DataItem;
            _colIDIndex = drvAttachedFiles.DataView.Table.Columns["ID"].Ordinal + 1;
            Int32 _colFNameIndex = drvAttachedFiles.DataView.Table.Columns["File Name"].Ordinal + 1;
            Int32 _colFDescriptionIndex = drvAttachedFiles.DataView.Table.Columns["File Description"].Ordinal + 1;
            Int32 _colFTypeIndex = drvAttachedFiles.DataView.Table.Columns["File Type"].Ordinal + 1;
            Int32 _colFLocationIndex = drvAttachedFiles.DataView.Table.Columns["Location"].Ordinal + 1;

            //QuickFix 
            //Int32 _colFLinkIndex = drvAttachedFiles.DataView.Table.Columns["HyperLink"].Ordinal + 1;


            Int32 _colFPszeIndex = drvAttachedFiles.DataView.Table.Columns["Print Size"].Ordinal + 1;
            Int32 _colPLocationIndex = drvAttachedFiles.DataView.Table.Columns["Print Location"].Ordinal + 1;
            Int32 _colWebViewIndex = drvAttachedFiles.DataView.Table.Columns["View"].Ordinal + 1;

            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Align    
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colFNameIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFDescriptionIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFLocationIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFLinkIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFPszeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colPLocationIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colWebViewIndex].HorizontalAlign = HorizontalAlign.Left;

            //Quick Fix
            e.Row.Cells[_colFLocationIndex].Text = e.Row.Cells[_colFLocationIndex].Text.Replace(@"\", @" \");
            e.Row.Cells[_colFLinkIndex].Visible = false;
        }
    }

    /// <summary>
    /// Get Notes
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetAddedNotes(Int32 COID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvNotes.CssClass = "GridViewStyleView";
            //this.gvNotes.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvNotes.RowStyle.CssClass = "GridViewStyleView";
            this.gvNotes.AutoGenerateDeleteButton = true;
            this.gvNotes.EnableViewState = false;
            this.gvNotes.Controls.Clear();

            using (DataTable _tempAddedNotes = DataAccess.GetRecords(DataQueries.GetViewNotesByTypeAndID(Constants.ChangeReferenceType, COID.ToString())))
            {
                _rowCount = _tempAddedNotes.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvNotes.DataSource = _tempAddedNotes;
                    this.gvNotes.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Notes Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvNotes_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Int32 ChangeID = 0;
        String _ChangeID = this.txtChangeID.Text;
        if (!String.IsNullOrEmpty(_ChangeID))
        {
            ChangeID = Convert.ToInt32(_ChangeID);
        }
        GetAddedNotes(ChangeID);

        if (gvNotes.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _NoteID = Convert.ToInt32(gvNotes.Rows[e.RowIndex].Cells[1].Text);
            Int32 _StatusCheck = DataAccess.ModifyRecords(DataQueries.DeleteNotesByIDType(_NoteID, Constants.ChangeReferenceType));
            if (_StatusCheck > 0)
            {
                this.lblStatus.Text = "Success ! Note was removed";
            }
        }

        GetGrids(ChangeID);
    }

    /// <summary>
    /// Notes Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvNotes_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //Hide ID Column
        Int32 _colDeleteIndex = 0;
        Int32 _colIDIndex = 1;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colIDIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colIDIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvNotes = (DataRowView)e.Row.DataItem;
            _colIDIndex = drvNotes.DataView.Table.Columns["Note ID"].Ordinal + 1;
            Int32 _colDateIndex = drvNotes.DataView.Table.Columns["Date"].Ordinal + 1;
            Int32 _colTypeIndex = drvNotes.DataView.Table.Columns["Type"].Ordinal + 1;
            Int32 _colCreatedByIndex = drvNotes.DataView.Table.Columns["Created By"].Ordinal + 1;
            Int32 _colSubjectIndex = drvNotes.DataView.Table.Columns["Subject"].Ordinal + 1;

            //Delete Button
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Format  
            String _NoteDate = e.Row.Cells[_colDateIndex].Text;
            if (!String.IsNullOrEmpty(_NoteDate))
            {
                e.Row.Cells[_colDateIndex].Text = Convert.ToDateTime(_NoteDate).ToShortDateString();
            }

            //Align    
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colCreatedByIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colSubjectIndex].HorizontalAlign = HorizontalAlign.Left;
        }
    }

    /// <summary>
    /// Get Change Impact
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetChangeImpact(Int32 COID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvChangeImpact.CssClass = "GridViewStyleView";
            //this.gvChangeImpact.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvChangeImpact.RowStyle.CssClass = "GridViewStyleView";            
            this.gvChangeImpact.EnableViewState = false;
            this.gvChangeImpact.Controls.Clear();

            using (DataTable _tempChangeImpact = DataAccess.GetRecords(DataQueries.GetViewImpactSavedByID(COID)))
            {
                _rowCount = _tempChangeImpact.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvChangeImpact.DataSource = _tempChangeImpact;
                    this.gvChangeImpact.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Change Impact Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvChangeImpact_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        //if (gvChangeImpact.Rows.Count < 1)
        //{
        //    e.Cancel = true;
        //}
        //else
        //{
        //    lblStatus.Text = gvChangeImpact.Rows[e.RowIndex].Cells[1].Text;
        //    
        //}
    }

    /// <summary>
    /// Change Impact Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvChangeImpact_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //Hide ID Column  
        Int32 _colOrderIDIndex = 1;
        Int32 _colLineItemIDIndex = 2;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colOrderIDIndex].Visible = false;
            e.Row.Cells[_colLineItemIDIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colOrderIDIndex].Visible = false;
            e.Row.Cells[_colLineItemIDIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvChangeImpact = (DataRowView)e.Row.DataItem;
            Int32 _colOrdTypeIndex = drvChangeImpact.DataView.Table.Columns["Order Type"].Ordinal;
            Int32 _colOrdNumIndex = drvChangeImpact.DataView.Table.Columns["Order Number"].Ordinal;
            Int32 _colOrdStatusIndex = drvChangeImpact.DataView.Table.Columns["Order Status"].Ordinal;
            Int32 _colLineItemIndex = drvChangeImpact.DataView.Table.Columns["Line Item"].Ordinal;
            Int32 _colPartNumIndex = drvChangeImpact.DataView.Table.Columns["Part Number"].Ordinal;
            Int32 _colRevStatusIndex = drvChangeImpact.DataView.Table.Columns["Revision Status"].Ordinal;
            Int32 _colPartRevIndex = drvChangeImpact.DataView.Table.Columns["Part Revision"].Ordinal;
            Int32 _colPEffDateIndex = drvChangeImpact.DataView.Table.Columns["Part Effective Date"].Ordinal;
            Int32 _colPDescIndex = drvChangeImpact.DataView.Table.Columns["Part Description"].Ordinal;
            Int32 _colUnitIndex = drvChangeImpact.DataView.Table.Columns["Unit"].Ordinal;
            Int32 _colQtyIndex = drvChangeImpact.DataView.Table.Columns["Qty"].Ordinal;
            Int32 _colCostIndex = drvChangeImpact.DataView.Table.Columns["Cost"].Ordinal;

            //Format   
            String _EffDate = e.Row.Cells[_colPEffDateIndex].Text;
            if (!String.IsNullOrEmpty(_EffDate))
            {
                e.Row.Cells[_colPEffDateIndex].Text = Convert.ToDateTime(_EffDate).ToShortDateString();
            }

            String _Cost = e.Row.Cells[_colCostIndex].Text;
            if (!String.IsNullOrEmpty(_Cost))
            {
                e.Row.Cells[_colCostIndex].Text = Convert.ToDecimal(_Cost).ToString("c");
            }

            //Align 
            e.Row.Cells[_colOrdTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colOrdNumIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colOrdStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colLineItemIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colPartNumIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colRevStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colPartRevIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colPEffDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colPDescIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colUnitIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colQtyIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colCostIndex].HorizontalAlign = HorizontalAlign.Right;
        }
    }

    /// <summary>
    /// Get Material Disposition
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetMaterialDispositionInfo(Int32 COID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvMaterialDispositionInfo.CssClass = "GridViewStyleView";
            //this.gvMaterialDispositionInfo.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvMaterialDispositionInfo.RowStyle.CssClass = "GridViewStyleView";            
            this.gvMaterialDispositionInfo.AutoGenerateDeleteButton = true;
            this.gvMaterialDispositionInfo.EnableViewState = false;
            this.gvMaterialDispositionInfo.Controls.Clear();

            using (DataTable _tempMDInfo = DataAccess.GetRecords(DataQueries.GetViewMatDispByCOID(COID)))
            {
                _rowCount = _tempMDInfo.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvMaterialDispositionInfo.DataSource = _tempMDInfo;
                    this.gvMaterialDispositionInfo.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Material Disposition Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvMaterialDispositionInfo_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Int32 ChangeID = 0;
        String _ChangeID = this.txtChangeID.Text;
        if (!String.IsNullOrEmpty(_ChangeID))
        {
            ChangeID = Convert.ToInt32(_ChangeID);
        }
        GetMaterialDispositionInfo(ChangeID);

        if (gvMaterialDispositionInfo.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            //Delete the record.
            Int32 _MatDispID = Convert.ToInt32(gvMaterialDispositionInfo.Rows[e.RowIndex].Cells[1].Text);

            //Remove Notes
            DataAccess.ModifyRecords(DataQueries.DeleteNotesByRefIDType(_MatDispID.ToString(), Constants.MaterialDispReferenceType));

            //Remove Tasks
            //justs made this change to see if it will fix request / changes 6/1/2020
            //  DataAccess.ModifyRecords(DataQueries.DeleteTasksByRefIDType(Constants.MaterialDispReferenceType, _MatDispID.ToString()));  

            //Remove Material Disposition
            Int32 _StatusCheck = DataAccess.ModifyRecords(DataQueries.DeleteMatDispByID(_MatDispID));
            if (_StatusCheck > 0)
            {
                this.lblStatus.Text = "Success ! Material Dispositions was removed";
            }
        }

        GetGrids(ChangeID);
    }

    /// <summary>
    /// Material Disposition Row Bound 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvMaterialDispositionInfo_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //Hide ID Column
        Int32 _colDeleteIndex = 0;
        Int32 _colIDIndex = 1;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colIDIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colIDIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvMDisp = (DataRowView)e.Row.DataItem;
            Int32 _colBatchIndex = drvMDisp.DataView.Table.Columns["Batch"].Ordinal + 1;
            Int32 _colDueDateIndex = drvMDisp.DataView.Table.Columns["Due Date"].Ordinal + 1;
            Int32 _colEffDateIndex = drvMDisp.DataView.Table.Columns["Effective Date"].Ordinal + 1;
            Int32 _colStatusIndex = drvMDisp.DataView.Table.Columns["Status"].Ordinal + 1;
            Int32 _colRevTypeIndex = drvMDisp.DataView.Table.Columns["Impact Area"].Ordinal + 1;
            Int32 _colDispTypeIndex = drvMDisp.DataView.Table.Columns["Disp Type"].Ordinal + 1;
            Int32 _colCostIndex = drvMDisp.DataView.Table.Columns["Cost"].Ordinal + 1;
            Int32 _colAssignedToIndex = drvMDisp.DataView.Table.Columns["Assigned To"].Ordinal + 1;

            //Set Delete Image
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Format            
            String _DueDate = e.Row.Cells[_colDueDateIndex].Text;
            if (!String.IsNullOrEmpty(_DueDate))
            {
                e.Row.Cells[_colDueDateIndex].Text = Convert.ToDateTime(_DueDate).ToShortDateString();
            }

            String _EffDate = e.Row.Cells[_colEffDateIndex].Text;
            if (!String.IsNullOrEmpty(_EffDate))
            {
                e.Row.Cells[_colEffDateIndex].Text = Convert.ToDateTime(_EffDate).ToShortDateString();
            }

            String _Cost = e.Row.Cells[_colCostIndex].Text;
            if (!String.IsNullOrEmpty(_Cost))
            {
                e.Row.Cells[_colCostIndex].Text = Convert.ToDecimal(_Cost).ToString("c");
            }

            //Align
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colBatchIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colDueDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colEffDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colRevTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colDispTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colCostIndex].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Cells[_colAssignedToIndex].HorizontalAlign = HorizontalAlign.Left;
        }
    }

    /// <summary>
    /// Get WF Tasks
    /// </summary>
    /// <param name="HeaderReferenceType"></param>
    /// <param name="HeaderReferenceID"></param>
    /// <returns></returns>
    private Int32 GetWFTasks(String HeaderReferenceType, String HeaderReferenceID)
    {
        Int32 _rowCount = 0;

        try
        {
            //Set Grid
            //this.gvWFTasks.CssClass = "GridViewStyleView";
            //this.gvWFTasks.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvWFTasks.RowStyle.CssClass = "GridViewStyleView";
            this.gvWFTasks.AutoGenerateDeleteButton = true;
            this.gvWFTasks.AutoGenerateSelectButton = true;
            this.gvWFTasks.EnableViewState = false;
            this.gvWFTasks.Controls.Clear();

            using (DataTable _tempWFTasks = DataAccess.GetRecords(DataQueries.GetViewWFTasksReference(HeaderReferenceID, HeaderReferenceType)))
            {
                _rowCount = _tempWFTasks.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvWFTasks.DataSource = _tempWFTasks;
                    this.gvWFTasks.DataBind();
                    this.lblWFTasks.Text = null;
                }
                else
                {
                    this.lblWFTasks.Text = "Currently there are no tasks assigned for the selected reference item.";
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// WF Tasks  Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFTasks_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        String _RefID = this.txtChangeID.Text;
        String _RefTypeCode = Constants.ChangeReferenceType;

        GetWFTasks(_RefTypeCode, _RefID);

        if (gvWFTasks.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _TaskID = Convert.ToInt32(gvWFTasks.Rows[e.RowIndex].Cells[3].Text);

            DataAccess.ModifyRecords(DataQueries.DeleteTasksByID(_TaskID));
            DataAccess.ModifyRecords(DataQueries.DeleteWFlowTasksByID(_TaskID));

            lblStatus.Text = "Success ! Task " + _TaskID + " was deleted.";
        }

        GetWFTasks(_RefTypeCode, _RefID);
    }

    /// <summary>
    /// WF Tasks Select
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFTasks_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        String _RefID = this.txtChangeID.Text;
        String _RefTypeCode = Constants.ChangeReferenceType;

        GetWFTasks(_RefTypeCode, _RefID);
        String _TaskID = gvWFTasks.Rows[e.NewSelectedIndex].Cells[1].Text;

        Server.Transfer("~/WorkFlowManagement/WFTaskInformation.aspx?SID=" + _SID + "&RFTP=" + _RefTypeCode
                                                + "&RFID=" + _RefID + "&TID=" + _TaskID);
    }

    /// <summary>
    /// WF Tasks Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFTasks_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colDeleteIndex = 0;
        Int32 _colSelectIndex = 0;
        Int32 _colTemplateTaskIndex = 1;
        Int32 _colTemplateIndex = 2;
        Int32 _colTaskIndex = 3;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colTemplateTaskIndex].Visible = false;
            e.Row.Cells[_colTemplateIndex].Visible = false;
            e.Row.Cells[_colTaskIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colTemplateTaskIndex].Visible = false;
            e.Row.Cells[_colTemplateIndex].Visible = false;
            e.Row.Cells[_colTaskIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvWFTasks = (DataRowView)e.Row.DataItem;

            Int32 _colStepIndex = drvWFTasks.DataView.Table.Columns["Step"].Ordinal + 1;
            Int32 _colANameIndex = drvWFTasks.DataView.Table.Columns["Action Name"].Ordinal + 1;
            Int32 _colNStepIndex = drvWFTasks.DataView.Table.Columns["Next Step"].Ordinal + 1;
            Int32 _colAssnToIndex = drvWFTasks.DataView.Table.Columns["Assigned To"].Ordinal + 1;
            Int32 _colBStepIndex = drvWFTasks.DataView.Table.Columns["Back Step"].Ordinal + 1;
            Int32 _colATypeIndex = drvWFTasks.DataView.Table.Columns["Action Type"].Ordinal + 1;
            Int32 _colTStatusIndex = drvWFTasks.DataView.Table.Columns["Task Status"].Ordinal + 1;

            //Delete Button
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Align
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colANameIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colNStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colAssnToIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colBStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colATypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colTStatusIndex].HorizontalAlign = HorizontalAlign.Left;
        }
    }

    /// <summary>
    /// Get Custom Fields
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetCustomFieldsInfo(String COID)
    {
        Int32 _rowCount = 0;
        String strHtml = "";
        String[] arrCustomLabels = new String[10];
        String strLabel = "";
        Int32 rowOrderCnt = 0;
        String strValue = "";

        try
        {
            using (DataTable _tempCustomLabels = DataAccess.GetRecords(DataQueries.GetCustomLabels("CM")))
            {
                for (Int32 i = 1; i <= 10; i++)
                {
                    strLabel = "UDFLbl" + i;
                    _rowCount = _tempCustomLabels.Rows.Count;
                    if (_rowCount > 0)
                    {
                        arrCustomLabels[i - 1] = _tempCustomLabels.Rows[0][strLabel].ToString();
                    }

                }
            }

            lblAssign.Text = "Assign Custom Fields Value";

            using (DataTable _tempCustomInfo = DataAccess.GetRecords(DataQueries.GetCustomValues(COID, "CO")))
            {
                _rowCount = _tempCustomInfo.Rows.Count;

                if (_rowCount > 0)
                {
                    strHtml = "<table class=\"Table\" cellspacing=\"0\" cellpadding=\"2\" border=\"1\">";
                    for (Int32 i = 1; i <= 10; i++)
                    {
                        if (_tempCustomInfo.Rows[0]["UDF" + i].ToString() != null && _tempCustomInfo.Rows[0]["UDF" + i].ToString().Length > 0 &&
                            arrCustomLabels[i - 1] != null && arrCustomLabels[i - 1].Length > 0)
                        {

                            if (rowOrderCnt == 2)
                            {
                                strHtml = strHtml + "</tr>";
                                rowOrderCnt = 0;
                            }
                            if (rowOrderCnt == 0)
                            {
                                strHtml = strHtml + "<tr>";
                            }
                            rowOrderCnt = rowOrderCnt + 1;

                            if (i < 7)
                            {
                                strValue = _tempCustomInfo.Rows[0]["UDF" + i].ToString();
                            }
                            else
                            {
                                strValue = _tempCustomInfo.Rows[0]["UDF" + i] != null && _tempCustomInfo.Rows[0]["UDF" + i].ToString().Equals("True") ? "Applicable" : "Not Applicable";
                            }

                            strHtml = strHtml + "<td class=\"FieldHeaderNew\">";
                            strHtml = strHtml + arrCustomLabels[i - 1] + ":</td> <td colspan=\"2\" class=\"FieldContent\">";
                            strHtml = strHtml + strValue + "</td>";

                            lblAssign.Text = "Modify Custom Fields Value";
                        }

                    }
                    strHtml = strHtml + "</tr></table>";

                }


            }

            if (strHtml != null && strHtml.Length > 0)
            {
                CustomLiteral.Text = strHtml;
            }

        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Get Change Related Grids
    /// </summary>
    /// <param name="COID"></param>
    private void GetGrids(Int32 COID)
    {
        GetAssociatedDocs(COID);
        GetAttachedFiles(COID);
        GetAddedNotes(COID);
        GetChangeImpact(COID);
        GetMaterialDispositionInfo(COID);
        GetWFTasks(Constants.ChangeReferenceType, COID.ToString());
        GetCustomFieldsInfo(COID.ToString());

    }

    /// <summary>
    /// Initialize Page
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {
            this.lblStatus.Text = null;
            this.txtChangeID.Text = null;
            this.txtStatus.Text = null;

            this.txtDescription.Text = null;
            this.txtDescription.TextMode = TextBoxMode.MultiLine;
            this.txtDescription.Height = 50;

            this.txtChangeClass.Text = null;
            this.txtChangeType.Text = null;
            this.txtPriority.Text = null;
            this.txtJustification.Text = null;
            this.txtProject.Text = null;

            this.txtRequestedBy.Text = null;
            this.txtApprovedBy.Text = null;
            this.txtAssignedTo.Text = null;
            this.txtCompletedBy.Text = null;
            this.txtReleasedBy.Text = null;
            this.txtLastModifiedBy.Text = null;

            this.txtDateRequestedBy.Text = null;
            this.txtDateApprovedBy.Text = null;
            this.txtDateAssignedTo.Text = null;
            this.txtDateCompletedBy.Text = null;
            this.txtDateReleasedBy.Text = null;
            this.txtDateLastModifiedBy.Text = null;


            //this.ucDateReleasedBy.SelectedDate = null;

            using (DataTable _tempStatus = new DataTable())
            {
                _tempStatus.Columns.Add("Code", Type.GetType("System.String"));
                _tempStatus.Columns.Add("Description", Type.GetType("System.String"));
                _tempStatus.Rows.Add("-NONE-", "-NONE-");
                _tempStatus.Merge(DataAccess.GetRecords(DataQueries.GetQChStatus()), true);
                this.ddlStatus.DataSource = _tempStatus;
                this.ddlStatus.DataTextField = "Description";
                this.ddlStatus.DataValueField = "Code";
                this.ddlStatus.DataBind();
            }

            using (DataTable _tempProject = new DataTable())
            {
                _tempProject.Columns.Add("ID", Type.GetType("System.String"));
                _tempProject.Columns.Add("Description", Type.GetType("System.String"));
                _tempProject.Rows.Add("-NONE-", "-NONE-");
                _tempProject.Merge(DataAccess.GetRecords(DataQueries.GetQProjectByStatus("ACT", "PLN")), true);
                this.ddlProject.DataSource = _tempProject;
                this.ddlProject.DataTextField = "Description";
                this.ddlProject.DataValueField = "ID";
                this.ddlProject.DataBind();
            }

            using (DataTable _tempChangeClass = new DataTable())
            {
                _tempChangeClass.Columns.Add("Code", Type.GetType("System.String"));
                _tempChangeClass.Columns.Add("Description", Type.GetType("System.String"));
                _tempChangeClass.Rows.Add("-NONE-", "-NONE-");
                _tempChangeClass.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("ChClass")), true);
                this.ddlChangeClass.DataSource = _tempChangeClass;
                this.ddlChangeClass.DataTextField = "Description";
                this.ddlChangeClass.DataValueField = "Code";
                this.ddlChangeClass.DataBind();
            }

            using (DataTable _tempChangeType = new DataTable())
            {
                _tempChangeType.Columns.Add("Code", Type.GetType("System.String"));
                _tempChangeType.Columns.Add("Description", Type.GetType("System.String"));
                _tempChangeType.Rows.Add("-NONE-", "-NONE-");
                _tempChangeType.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("ChangeType")), true);
                this.ddlChangeType.DataSource = _tempChangeType;
                this.ddlChangeType.DataTextField = "Description";
                this.ddlChangeType.DataValueField = "Code";
                this.ddlChangeType.DataBind();
            }

            using (DataTable _tempPriority = new DataTable())
            {
                _tempPriority.Columns.Add("Code", Type.GetType("System.String"));
                _tempPriority.Columns.Add("Description", Type.GetType("System.String"));
                _tempPriority.Rows.Add("-NONE-", "-NONE-");
                _tempPriority.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("Priority")), true);
                this.ddlPriority.DataSource = _tempPriority;
                this.ddlPriority.DataTextField = "Description";
                this.ddlPriority.DataValueField = "Code";
                this.ddlPriority.DataBind();
            }

            using (DataTable _tempJustification = new DataTable())
            {
                _tempJustification.Columns.Add("Code", Type.GetType("System.String"));
                _tempJustification.Columns.Add("Description", Type.GetType("System.String"));
                _tempJustification.Rows.Add("-NONE-", "-NONE-");
                _tempJustification.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("Justification")), true);
                this.ddlJustification.DataSource = _tempJustification;
                this.ddlJustification.DataTextField = "Description";
                this.ddlJustification.DataValueField = "Code";
                this.ddlJustification.DataBind();
            }

            using (DataTable _tempUserInfo = new DataTable())
            {
                _tempUserInfo.Columns.Add("User ID", Type.GetType("System.String"));
                _tempUserInfo.Columns.Add("User Name", Type.GetType("System.String"));
                _tempUserInfo.Rows.Add("-NONE-", "-NONE-");
                _tempUserInfo.Merge(DataAccess.GetRecords(DataQueries.GetQUserInfo()), true);

                this.ddlRequestedBy.DataSource = _tempUserInfo;
                this.ddlRequestedBy.DataTextField = "User Name";
                this.ddlRequestedBy.DataValueField = "User ID";
                this.ddlRequestedBy.DataBind();

                this.ddlApprovedBy.DataSource = _tempUserInfo;
                this.ddlApprovedBy.DataTextField = "User Name";
                this.ddlApprovedBy.DataValueField = "User ID";
                this.ddlApprovedBy.DataBind();

                this.ddlAssignedTo.DataSource = _tempUserInfo;
                this.ddlAssignedTo.DataTextField = "User Name";
                this.ddlAssignedTo.DataValueField = "User ID";
                this.ddlAssignedTo.DataBind();

                this.ddlCompletedBy.DataSource = _tempUserInfo;
                this.ddlCompletedBy.DataTextField = "User Name";
                this.ddlCompletedBy.DataValueField = "User ID";
                this.ddlCompletedBy.DataBind();

                this.ddlReleasedBy.DataSource = _tempUserInfo;
                this.ddlReleasedBy.DataTextField = "User Name";
                this.ddlReleasedBy.DataValueField = "User ID";
                this.ddlReleasedBy.DataBind();
            }

            //Register Script for Delete Button
            this.btnDelete.OnClientClick = "GetChangeDeleteUserConf()";
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// Initialize Grid Views
    /// </summary>
    private void InitializeGrids()
    {
        try
        {
            this.gvAssociatedDocs.EnableViewState = false;
            this.gvAssociatedDocs.Controls.Clear();

            this.gvAttachedFiles.EnableViewState = false;
            this.gvAttachedFiles.Controls.Clear();

            this.gvNotes.EnableViewState = false;
            this.gvNotes.Controls.Clear();

            this.gvChangeImpact.EnableViewState = false;
            this.gvChangeImpact.Controls.Clear();

            this.gvMaterialDispositionInfo.EnableViewState = false;
            this.gvMaterialDispositionInfo.Controls.Clear();

        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }

    /// <summary>
    /// Set Page to Edit or View
    /// </summary>
    /// <param name="EditView"></param>
    private void SetForm(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {

                //Set Read Only        
                this.txtChangeID.ReadOnly = true;
                this.txtStatus.ReadOnly = true;
                this.txtChangeClass.ReadOnly = true;
                this.txtChangeType.ReadOnly = true;


                this.txtStartDate.ReadOnly = true;
                this.txtEndDate.ReadOnly = true;


                this.txtPriority.ReadOnly = true;
                this.txtJustification.ReadOnly = true;
                this.txtProject.ReadOnly = true;
                this.txtDescription.ReadOnly = true;

                this.txtRequestedBy.ReadOnly = true;
                this.txtApprovedBy.ReadOnly = true;
                this.txtAssignedTo.ReadOnly = true;
                this.txtCompletedBy.ReadOnly = true;
                this.txtReleasedBy.ReadOnly = true;
                this.txtLastModifiedBy.ReadOnly = true;

                this.txtDateRequestedBy.ReadOnly = true;
                this.txtDateApprovedBy.ReadOnly = true;
                this.txtDateAssignedTo.ReadOnly = true;
                this.txtDateCompletedBy.ReadOnly = true;
                this.txtDateReleasedBy.ReadOnly = true;
                this.txtDateLastModifiedBy.ReadOnly = true;


                //Hide Edit Controls    
                this.ddlStatus.Visible = false;


                this.ddlChangeClass.Visible = false;
                this.ddlChangeType.Visible = false;
                this.ddlProject.Visible = false;
                this.ddlPriority.Visible = false;
                this.ddlJustification.Visible = false;

                this.ddlRequestedBy.Visible = false;
                this.ddlApprovedBy.Visible = false;
                this.ddlAssignedTo.Visible = false;
                this.ddlCompletedBy.Visible = false;
                this.ddlReleasedBy.Visible = false;


                //this.ucDateReleasedBy.Visible = false;

                //Show View Controls
                this.txtStatus.Visible = true;
                this.txtStartDate.Visible = true;
                this.txtEndDate.Visible = true;
                this.txtChangeClass.Visible = true;
                this.txtChangeType.Visible = true;
                this.txtProject.Visible = true;
                this.txtPriority.Visible = true;
                this.txtJustification.Visible = true;

                this.txtRequestedBy.Visible = true;
                this.txtApprovedBy.Visible = true;
                this.txtAssignedTo.Visible = true;
                this.txtCompletedBy.Visible = true;
                this.txtReleasedBy.Visible = true;

                this.txtDateRequestedBy.Visible = true;
                this.txtDateApprovedBy.Visible = true;
                this.txtDateAssignedTo.Visible = true;
                this.txtDateCompletedBy.Visible = true;
                this.txtDateReleasedBy.Visible = true;

            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
                string changeType = ddlChangeType.SelectedValue;
                //Reset the Read Only        
                this.txtChangeID.ReadOnly = false;
                this.txtDescription.ReadOnly = false;
                var recordTable = DataAccess.GetRecords(DataQueries.GetTemplateByRequestId(currentPageName, changeType));
                if (recordTable.Rows.Count > 0)
                {
                    var data = recordTable.Rows[0];
                    this.txtDescription.Text = data.Field<string>("TemplateData");
                }

                this.txtStartDate.ReadOnly = false;
                this.txtEndDate.ReadOnly = false;
                this.txtDateRequestedBy.ReadOnly = false;
                this.txtDateApprovedBy.ReadOnly = false;
                this.txtDateAssignedTo.ReadOnly = false;
                this.txtDateCompletedBy.ReadOnly = false;
                this.txtDateReleasedBy.ReadOnly = false;
                this.txtDateLastModifiedBy.ReadOnly = false;


                //Hide View Controls
                this.txtStatus.Visible = false;

                //this.txtEndDate.Visible = false;                
                this.txtChangeClass.Visible = false;
                this.txtChangeType.Visible = false;
                this.txtProject.Visible = false;
                this.txtPriority.Visible = false;
                this.txtJustification.Visible = false;

                this.txtRequestedBy.Visible = false;
                this.txtApprovedBy.Visible = false;
                this.txtAssignedTo.Visible = false;
                this.txtCompletedBy.Visible = false;
                this.txtReleasedBy.Visible = false;

                //this.txtDateRequestedBy.Visible = false;
                //this.txtDateApprovedBy.Visible = false;
                //this.txtDateAssignedTo.Visible = false;
                //this.txtDateCompletedBy.Visible = false;
                //this.txtDateReleasedBy.Visible = false;

                //Show Edit Controls
                this.ddlStatus.Visible = true;

                this.ddlChangeClass.Visible = true;
                this.ddlChangeType.Visible = true;
                this.ddlProject.Visible = true;
                this.ddlPriority.Visible = true;
                this.ddlJustification.Visible = true;

                this.ddlRequestedBy.Visible = true;
                this.ddlApprovedBy.Visible = true;
                this.ddlAssignedTo.Visible = true;
                this.ddlCompletedBy.Visible = true;
                this.ddlReleasedBy.Visible = true;


                //this.ucDateReleasedBy.Visible = true;

                //Initialize from View Controls



                //this.ucDateReleasedBy.SelectedDate = this.txtDateReleasedBy.Text;

                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlStatus.Items.FindByText(this.txtStatus.Text.Trim());
                this.ddlStatus.SelectedIndex = this.ddlStatus.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlChangeClass.Items.FindByText(this.txtChangeClass.Text.Trim());
                this.ddlChangeClass.SelectedIndex = this.ddlChangeClass.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlChangeType.Items.FindByText(this.txtChangeType.Text.Trim());
                this.ddlChangeType.SelectedIndex = this.ddlChangeType.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlProject.Items.FindByText(this.txtProject.Text.Trim());
                this.ddlProject.SelectedIndex = this.ddlProject.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlPriority.Items.FindByText(this.txtPriority.Text.Trim());
                this.ddlPriority.SelectedIndex = this.ddlPriority.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlJustification.Items.FindByText(this.txtJustification.Text.Trim());
                this.ddlJustification.SelectedIndex = this.ddlJustification.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlRequestedBy.Items.FindByText(this.txtRequestedBy.Text.Trim());
                this.ddlRequestedBy.SelectedIndex = this.ddlRequestedBy.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlApprovedBy.Items.FindByText(this.txtApprovedBy.Text.Trim());
                this.ddlApprovedBy.SelectedIndex = this.ddlApprovedBy.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlAssignedTo.Items.FindByText(this.txtAssignedTo.Text.Trim());
                this.ddlAssignedTo.SelectedIndex = this.ddlAssignedTo.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlCompletedBy.Items.FindByText(this.txtCompletedBy.Text.Trim());
                this.ddlCompletedBy.SelectedIndex = this.ddlCompletedBy.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlReleasedBy.Items.FindByText(this.txtReleasedBy.Text.Trim());
                this.ddlReleasedBy.SelectedIndex = this.ddlReleasedBy.Items.IndexOf(liSelectedItem);

            } //end if - EDIT                      

        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    protected void btnNew_Click(object sender, EventArgs e)
    {
        if (this.btnNew.Text == "New Change Request")
        {
            InitializeFormFields();
            this.txtChangeID.Text = Utils.GetChangeOrderNewID().ToString();
            this.txtStatus.Text = "REQUESTED";
            this.txtRequestedBy.Text = _SessionUser;

            SetForm(FORM_ON.Edit);

            this.txtStartDate.Text = DateTime.Now.ToString("MM-dd-yyyy");
            this.txtDateRequestedBy.Text = DateTime.Now.ToString("MM-dd-yyyy");
            this.txtChangeID.ReadOnly = false;

            this.btnNew.Text = "Save";
            this.btnCancel.Visible = true;
            this.btnDelete.Visible = false;
            this.btnFind.Visible = false;
            divhlnkMaterialDisposition.Visible = false;
            divhlnkWFTasks.Visible = false;
            divhlnkWFCustom.Visible = false;
        }
        else if (this.btnNew.Text == "Save")
        {
            SaveUpdateRecords("Save");
        }
    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        if (this.btnEdit.Text == "Edit")
        {
            SetForm(FORM_ON.Edit);
            //this.btnNewEditSave.Text = "Update";
            this.btnEdit.Text = "Update";
            this.btnNew.Visible = false;
            this.btnEdit.Visible = IsEditAllow;//true;
            this.btnCancel.Visible = true;
            this.btnDelete.Visible = false;
        }
        else if (this.btnEdit.Text == "Update")
        {
            SaveUpdateRecords("Update");
        }

    }
    protected void SaveUpdateRecords(string action)
    {
        try
        {

            Int32 ChangeID = 0;
            String _ChangeID = this.txtChangeID.Text;
            if (!String.IsNullOrEmpty(_ChangeID))
            {
                ChangeID = Convert.ToInt32(_ChangeID);
            }

            #region "Validatation"
            if (ChangeID == 0)
            {
                throw new Exception("A [CO Number] could not be located or created. The record will not be saved.");
            }

            DateTime StartDate;
            if (!String.IsNullOrEmpty(this.txtStartDate.Text))
            {
                StartDate = Convert.ToDateTime(this.txtStartDate.Text);
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChEffDate"))
                {
                    throw new Exception("A [Start Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    StartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            DateTime EndDate;
            if (!String.IsNullOrEmpty(this.txtEndDate.Text))
            {

                // EndDate = DateTime.ParseExact(this.txtEndDate.Text, "MM-dd-yyyy", CultureInfo.InvariantCulture);
                EndDate = Convert.ToDateTime(txtEndDate.Text);
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChDue"))
                {
                    throw new Exception("A [Due Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    EndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            String ChangeStatus = null;
            if (this.ddlStatus.SelectedItem.Text != "-NONE-")
            {
                ChangeStatus = this.ddlStatus.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChStatus"))
                {
                    throw new Exception("A [Status] could not be located or created. The record will not be saved.");
                }
            }

            String Description = null;
            if (!String.IsNullOrEmpty(this.txtDescription.Text))
            {
                Description = this.txtDescription.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChangeDesc"))
                {
                    throw new Exception("A [Description] could not be located or created. The record will not be saved.");
                }
            }

            String Project = null;
            if (this.ddlProject.SelectedItem.Text != "-NONE-")
            {
                Project = this.ddlProject.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ProjNum"))
                {
                    throw new Exception("A [Project] could not be located or created. The record will not be saved.");
                }
            }

            String ChangeClass = null;
            if (this.ddlChangeClass.SelectedItem.Text != "-NONE-")
            {
                ChangeClass = this.ddlChangeClass.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChangeClass"))
                {
                    throw new Exception("A [Change Class] could not be located or created. The record will not be saved.");
                }
            }

            String ChangeType = null;
            if (this.ddlChangeType.SelectedItem.Text != "-NONE-")
            {
                ChangeType = this.ddlChangeType.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChangeType"))
                {
                    throw new Exception("A [Change Type] could not be located or created. The record will not be saved.");
                }
            }

            String Priority = null;
            if (this.ddlPriority.SelectedItem.Text != "-NONE-")
            {
                Priority = this.ddlPriority.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChPriority"))
                {
                    throw new Exception("A [Priority] could not be located or created. The record will not be saved.");
                }
            }

            String Justification = null;
            if (this.ddlJustification.SelectedItem.Text != "-NONE-")
            {
                Justification = this.ddlJustification.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChJustification"))
                {
                    throw new Exception("A [Justification] could not be located or created. The record will not be saved.");
                }
            }

            String ChangeRequestedBy = null;
            if (this.ddlRequestedBy.SelectedItem.Text != "-NONE-")
            {
                ChangeRequestedBy = this.ddlRequestedBy.SelectedItem.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChReqBy"))
                {
                    throw new Exception("The person [Requested By] could not be located or created. The record will not be saved.");
                }
            }

            DateTime ChangeRequestedDate;
            if (!String.IsNullOrEmpty(this.txtDateRequestedBy.Text) &&
                !String.IsNullOrEmpty(ChangeRequestedBy) && ChangeRequestedBy != "-NONE-")
            {
                ChangeRequestedDate = Convert.ToDateTime(this.txtDateRequestedBy.Text);
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChReqDate"))
                {
                    throw new Exception("A [Requested Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    ChangeRequestedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            String ChangeApprovedBy = null;
            if (this.ddlApprovedBy.SelectedItem.Text != "-NONE-")
            {
                ChangeApprovedBy = this.ddlApprovedBy.SelectedItem.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChApprBy"))
                {
                    throw new Exception("The person [Approved By] could not be located or created. The record will not be saved.");
                }
            }

            DateTime ChangeApprovedDate;
            if (!String.IsNullOrEmpty(this.txtDateApprovedBy.Text) &&
                !String.IsNullOrEmpty(ChangeApprovedBy) && ChangeApprovedBy != "-NONE-")
            {
                ChangeApprovedDate = Convert.ToDateTime(this.txtDateApprovedBy.Text);
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChApprDate"))
                {
                    ChangeApprovedDate = DateTime.Now;
                    //throw new Exception("An [Approved Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    ChangeApprovedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            String ChangeAssignedTo = null;
            if (this.ddlAssignedTo.SelectedItem.Text != "-NONE-")
            {
                ChangeAssignedTo = this.ddlAssignedTo.SelectedItem.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChAssignTo"))
                {
                    throw new Exception("The person [Assigned To] could not be located or created. The record will not be saved.");
                }
            }

            DateTime ChangeAssignedDate;
            if (!String.IsNullOrEmpty(this.txtDateAssignedTo.Text) &&
                !String.IsNullOrEmpty(ChangeAssignedTo) && ChangeAssignedTo != "-NONE-")
            {
                if (txtDateAssignedTo.Text != "")
                {
                    ChangeAssignedDate = Convert.ToDateTime(this.txtDateAssignedTo.Text);
                }
                else
                {
                    ChangeAssignedDate = DateTime.Now;
                }
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChAssignDate"))
                {
                    ChangeAssignedDate = DateTime.Now;
                    //throw new Exception("An [Assigned Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    ChangeAssignedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            String ChangeCompletedBy = null;
            if (this.ddlCompletedBy.SelectedItem.Text != "-NONE-")
            {
                ChangeCompletedBy = this.ddlCompletedBy.SelectedItem.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChCompletedBy"))
                {
                    throw new Exception("The person [Completed By] could not be located or created. The record will not be saved.");
                }
            }

            DateTime ChangeCompletedDate;
            if (!String.IsNullOrEmpty(this.txtDateCompletedBy.Text) &&
                !String.IsNullOrEmpty(ChangeCompletedBy) && ChangeCompletedBy != "-NONE-")
            {
                ChangeCompletedDate = Convert.ToDateTime(this.txtDateCompletedBy.Text);
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChCompletedDate"))
                {
                    ChangeCompletedDate = DateTime.Now;
                    throw new Exception("A [Completed Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    ChangeCompletedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            String ChangeReleasedBy = null;
            if (this.ddlReleasedBy.SelectedItem.Text != "-NONE-")
            {
                ChangeReleasedBy = this.ddlReleasedBy.SelectedItem.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Changes", "ChReleasedBy"))
                {
                    throw new Exception("The person [Released By] could not be located or created. The record will not be saved.");
                }
            }

            DateTime ChangeReleasedDate;
            if (!String.IsNullOrEmpty(this.txtDateReleasedBy.Text) &&
                !String.IsNullOrEmpty(ChangeReleasedBy) && ChangeReleasedBy != "-NONE-")
            {
                ChangeReleasedDate = Convert.ToDateTime(this.txtDateReleasedBy.Text);
            }
            else
            {
                ChangeReleasedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
            }
            #endregion

            String LastModifiedBy = _SessionUser;
            DateTime LastModifiedDate = DateTime.Now;
            EndDate = DateTime.Now;
            ChangeReleasedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
            //}
            //Save 
            if (action == "Update")
            {
                DataAccess.ModifyRecords(DataQueries.UpdateChangesRequest(ChangeID, Constants.ChangeReferenceType, ChangeStatus, EndDate, StartDate, ChangeClass,
                                                                           ChangeType, Description, Project, Priority, Justification,
                                                                           ChangeRequestedBy, ChangeApprovedBy, ChangeAssignedTo,
                                                                           ChangeCompletedBy, ChangeReleasedBy, LastModifiedBy,
                                                                           ChangeRequestedDate, ChangeApprovedDate, ChangeAssignedDate,
                                                                           ChangeCompletedDate, ChangeReleasedDate, LastModifiedDate, !String.IsNullOrEmpty(TextBox1.Text) ? Convert.ToInt32(TextBox1.Text.Trim()) : 0));
            }


            if (action == "Save")
            {

                if (txtStartDate.Text == "")
                {
                    DateTime startdate = DateTime.Now;
                }
                DataAccess.ModifyRecords(DataQueries.InsertChangesRequest(ChangeID, Constants.ChangeReferenceType, ChangeStatus, EndDate, StartDate, ChangeClass,
                                                                           ChangeType, Description, Project, Priority, Justification,
                                                                           ChangeRequestedBy, ChangeApprovedBy, ChangeAssignedTo,
                                                                           ChangeCompletedBy, ChangeReleasedBy, LastModifiedBy,
                                                                           ChangeRequestedDate, ChangeApprovedDate, ChangeAssignedDate,
                                                                           ChangeCompletedDate, ChangeReleasedDate, LastModifiedDate, !String.IsNullOrEmpty(TextBox1.Text) ? Convert.ToInt32(TextBox1.Text.Trim()) : 0));

            }

            GetRecord(ChangeID);
            GetGrids(ChangeID);
            SetLinkURLs(ChangeID);

            SetForm(FORM_ON.View);
            this.btnFind.AlternateText = "Find New Change Request";
            //this.btnNewEditSave.Text = "Edit";
            this.btnEdit.Text = "Edit";
            this.btnEdit.Visible = IsEditAllow;//true;
            this.btnNew.Visible = false;
            this.btnCancel.Visible = false;
            this.btnDelete.Visible = true;
            this.btnFind.Visible = true;
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    protected void ddlChangeType_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        string changeType = ddlChangeType.SelectedValue;

        var recordTable = DataAccess.GetRecords(DataQueries.GetTemplateByRequestId(currentPageName, changeType));
        if (recordTable.Rows.Count > 0)
        {
            var data = recordTable.Rows[0];
            this.txtDescription.Text = data.Field<string>("TemplateData");
        }
        else
        {
            this.txtDescription.Text = "";
        }
    }
}
