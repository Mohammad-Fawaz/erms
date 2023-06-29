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

/// <summary>
/// WF Order Class
/// </summary>
public partial class WFRoutingGroup_WFRoutingGroup : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;
        
    /// <summary>
    /// Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.lblStatus.Text = null;
        Int32 GroupID = 0;  
  
        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID; 

            //Get WF  ID
            String QSGroupID = Request.QueryString["GID"];
            if (!String.IsNullOrEmpty(QSGroupID))
            {
                GroupID = Convert.ToInt32(QSGroupID);
            }


            if (!IsPostBack)
            {
                InitializeFormHeaderFields();
                InitializeFormMemberFields();
                SetFormHeader(FORM_ON.View);  
                SetFormMember(FORM_ON.View);

                CheckFields();

                if (GroupID > 0)
                {
                    //WF Group Header
                    if (GetRecord(GroupID) > 0)
                    {
                        this.btnFind.AlternateText = "Find New Group";
                        this.btnNewEditSave.Text = "Edit";
                        this.btnCancel.Visible = false;
                        this.btnDelete.Visible = true;
                        this.btnAddSaveMember.Visible = true;

                        //WF Group Member
                        if (GetGroupMembers(GroupID) > 0)
                        {
                            Int32 _GroupMemberID = Convert.ToInt32(this.hdnGroupMemberID.Value);
                            GetMember(_GroupMemberID);
                        }
                    }
                    else
                    {
                        this.ddlGroupName.Visible = true;
                        //this.ddlGroupName.CssClass = "CtrlMediumValueEdit";
                        this.txtGroupName.Visible = false;                        
                        this.ddlGroupName.Focus();
                    }
                }
                else
                {
                    this.ddlGroupName.Visible = true;
                    //this.ddlGroupName.CssClass = "CtrlMediumValueEdit";
                    this.txtGroupName.Visible = false;
                    this.ddlGroupName.Focus();                    
                }
            }            
        }        
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage            
        }      
    }

    public void CheckFields()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);

        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.ShowFromGroupsData(17, RoleId)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ControlId"].ToString();
                if (txtDocIDs == "divGroupName") { divGroupName.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divGroupType") { divGroupType.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "divEmployee") { divEmployee.Visible = true; } //else { divRevision.Visible = false; }
                if (txtDocIDs == "divNameAlias") { divNameAlias.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "divEmail") { divEmail.Visible = true; }
                //For Buttons
                if (txtDocIDs == "btnFind") { btnFind.Visible = true; }
                if (txtDocIDs == "btnNewEditSave") { btnNewEditSave.Visible = true; }
                if (txtDocIDs == "btnCancel") { btnCancel.Visible = true; }
                if (txtDocIDs == "btnDelete") { btnDelete.Visible = true; }
                if (txtDocIDs == "btnAddSaveMember") { btnAddSaveMember.Visible = true; }


            }

        }

    }

    /// <summary>
    /// Cancel Template
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 _GroupID = 0;
            if (!String.IsNullOrEmpty(this.ddlGroupName.SelectedItem.Value))
            {
                _GroupID = Convert.ToInt32(this.ddlGroupName.SelectedItem.Value);
            }

            //Cancel On Edited Existing Group before Save
            if (this.btnFind.AlternateText =="Find New Group" && 
                (this.btnNewEditSave.Text =="Save" || this.btnNewEditSave.Text =="Update"))
            {
                if (_GroupID > 0)
                {
                    //WF Header
                    GetRecord(_GroupID);

                    //WF Members
                    if (GetGroupMembers(_GroupID) > 0)
                    {
                        Int32 _GroupMemberID = Convert.ToInt32(this.hdnGroupMemberID.Value);
                        GetMember(_GroupMemberID);
                    }

                    SetFormHeader(FORM_ON.View);
                    SetFormMember(FORM_ON.View);

                    this.btnNewEditSave.Text = "Edit";
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;
                    this.btnAddSaveMember.Visible = true; 
                }
            }

            //Cancel On New Group Creation before Save
            if (this.btnFind.AlternateText =="Find" && this.btnNewEditSave.Text =="Save")
            {
                InitializeFormHeaderFields();
                InitializeFormMemberFields();
                InitializeGrids();

                SetFormHeader(FORM_ON.View);
                SetFormMember(FORM_ON.View);

                this.ddlGroupName.Visible = true;
                //this.ddlGroupName.CssClass = "CtrlMediumValueEdit";
                this.txtGroupName.Visible = false;
                this.ddlGroupName.Focus();
                
                this.btnNewEditSave.Text ="New Group";
                this.btnCancel.Visible =false;
                this.btnDelete.Visible = false;
                this.btnAddSaveMember.Visible = false; 
                this.btnFind.Visible =true; 
            }


            //Cancel On Edited Existing Group before Adding New Member
            if (this.btnFind.AlternateText == "Find New Group" && this.btnAddSaveMember.Text == "Save Member" )
            {
                if (_GroupID > 0)
                {
                    //WF Header
                    GetRecord(_GroupID);

                    //WF Step
                    if (GetGroupMembers(_GroupID) > 0)
                    {
                        Int32 _GroupMemberID = Convert.ToInt32(this.hdnGroupMemberID.Value);
                        GetMember(_GroupMemberID);
                    }

                    SetFormHeader(FORM_ON.View);
                    SetFormMember(FORM_ON.View);

                    this.btnNewEditSave.Text = "Edit";
                    this.btnAddSaveMember.Text = "Add Member";
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;                    
                    this.btnNewEditSave.Visible = true;                    
                    this.btnAddSaveMember.Visible = true; 
                }
            }
        }        
        catch(Exception ex)
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
            Int32 _GroupID = 0;
            if (this.ddlGroupName.SelectedItem.Text != "-NONE-")
            {
                _GroupID = Convert.ToInt32(this.ddlGroupName.SelectedItem.Value);
            }
           
            if (this.btnFind.AlternateText =="Find")
            {
                //WF Group Header
                if (GetRecord(_GroupID) > 0)
                {
                    //WF Group Members
                    if (GetGroupMembers(_GroupID) > 0)
                    {
                        Int32 _GroupMemberID = Convert.ToInt32(this.hdnGroupMemberID.Value);
                        GetMember(_GroupMemberID);
                    }

                    SetFormHeader(FORM_ON.View);
                    SetFormMember(FORM_ON.View);

                    this.btnFind.AlternateText = "Find New Group";
                    this.btnNewEditSave.Text = "Edit";
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;
                    this.btnAddSaveMember.Visible = true; 
                }
                else
                {
                   InitializeFormHeaderFields();
                   InitializeFormMemberFields();
                   InitializeGrids();

                   SetFormHeader(FORM_ON.View);
                   SetFormMember(FORM_ON.View);

                   this.ddlGroupName.Visible = true;
                  // this.ddlGroupName.CssClass = "CtrlMediumValueEdit";
                   this.txtGroupName.Visible = false;
                   this.ddlGroupName.Focus();

                   lblStatus.Text = "A group could not be located or created.";
                }
            }
            else if (this.btnFind.AlternateText == "Find New Group")
            {
                InitializeFormHeaderFields();
                InitializeFormMemberFields();
                InitializeGrids();

                SetFormHeader(FORM_ON.View);
                SetFormMember(FORM_ON.View);

                this.ddlGroupName.Visible = true;
                //this.ddlGroupName.CssClass = "CtrlMediumValueEdit";
                this.txtGroupName.Visible = false;
                this.ddlGroupName.Focus();                     

                this.btnFind.AlternateText ="Find";
                this.btnNewEditSave.Text ="New Group";
                this.btnAddSaveMember.Text = "Add Member";

                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnAddSaveMember.Visible = false;
                this.btnNewEditSave.Visible = true;  
                this.btnFind.PostBackUrl = "WFRoutingGroup.aspx?SID=" + _SID + "&GID=0"; 
            }
        }       
        catch(Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }        
    }
    
    /// <summary>
    /// New / Edit / Save
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnNewEditSave_Click(object sender, EventArgs e)
    { 
        try
        {
            if (this.btnNewEditSave.Text == "New Group")
            {
                InitializeFormHeaderFields();
                InitializeFormMemberFields();

                SetFormHeader(FORM_ON.Edit);
                SetFormMember(FORM_ON.Edit);               
                 
                this.btnNewEditSave.Text = "Save";
                this.btnCancel.Visible = true;
                this.btnDelete.Visible = false;
                this.btnAddSaveMember.Visible = false; 
                this.btnFind.Visible = false;

                this.lblGroupMembers.Text = null;
            }
            else if (this.btnNewEditSave.Text == "Edit")
            {
                SetFormHeader(FORM_ON.Edit);
                SetFormMember(FORM_ON.Edit); 

                this.btnNewEditSave.Text = "Update";
                this.btnCancel.Visible = true;
                this.btnDelete.Visible = false;
                this.btnAddSaveMember.Visible = false; 
            }
            else if (this.btnNewEditSave.Text =="Save" || this.btnNewEditSave.Text == "Update")
            {
                SaveGroup(this.btnNewEditSave.Text);                
            }
        }        
        catch(Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }        
    }
    
    /// <summary>
    /// Save WorkFlow
    /// </summary>
    /// <param name="Action"></param>
    private void SaveGroup(String Action)
    {
        Int32 _GroupID = 0;        
        if (Action == "Update" || Action == "Save Member")
        {
            if (!String.IsNullOrEmpty(this.hdnGroupID.Value))
            {
                _GroupID = Convert.ToInt32(this.hdnGroupID.Value);             
            }
            if (_GroupID == 0)
            {
                throw new Exception("A [Group ID] could not be located or created. The record will not be saved.");
            }
        }

        String _GroupTypeCode = null;
        if (Action == "Save Member")
        {
            _GroupTypeCode = this.hdnGroupTypeCode.Value;
        }
        else
        {
            _GroupTypeCode = this.ddlGroupType.SelectedItem.Value;
        }

        if (String.IsNullOrEmpty(_GroupTypeCode))
        {
            //if (Utils.IsRequiredField("WFs", "ChStatus"))
            //{
            throw new Exception("A [Group Type] could not be located or created. The record will not be saved.");
            //}
        }
        
        String _WFGroupName = this.txtGroupName.Text;
        if (String.IsNullOrEmpty(_WFGroupName))
        {
            throw new Exception("A [Group Name] could not be located or created. The record will not be saved.");
        }                   
        
        /*** STEP MEMBER VALUES ***/

        Int32 _GroupMemberID = 0;
        if (Action == "Update")
        {            
            _GroupMemberID = Convert.ToInt32(this.hdnGroupMemberID.Value);
        }
            
        String _DefaultName = this.txtDefault.Text;
        String _eMail = this.txtEmail.Text;
        String _EmployeeName = null;        
                
        Int32 _EmployeeID = 0;
        if (this.ddlEmployee.SelectedItem.Text != "-NONE-")
        {
            _EmployeeID = Convert.ToInt32(this.ddlEmployee.SelectedItem.Value);
            _EmployeeName = this.ddlEmployee.SelectedItem.Text;
        }
        
        if(String.IsNullOrEmpty(_DefaultName))
        {
          _DefaultName = _EmployeeName;
        }
        
        //Update
        if (Action == "Update")
        {
            //Update Header
            DataAccess.ModifyRecords(DataQueries.UpdateWFGroups(_GroupTypeCode, _WFGroupName, _GroupID));

            if (!String.IsNullOrEmpty(_DefaultName) || _EmployeeID > 0)
            {
                //Update Member
                DataAccess.ModifyRecords(DataQueries.UpdateWFGroupMembs(_GroupID, _EmployeeID, _DefaultName, _eMail,_GroupMemberID));
            }
        }

        //Save
        if (Action == "Save" || Action == "Save Member")
        {

            if (Action == "Save")
            {
                //Insert Header
                DataAccess.ModifyRecords(DataQueries.InsertWFGroups(_GroupTypeCode, _WFGroupName));
                
                ////Get the ID               
                using (DataTable _tempNewID = DataAccess.GetRecords(DataQueries.GetWFGroupsMaxID()))
                {
                    _GroupID = Convert.ToInt32(_tempNewID.Rows[0]["MaxID"].ToString());
                }
            }


            if (!String.IsNullOrEmpty(_DefaultName) || _EmployeeID > 0)
            {
                ////Insert Member
                DataAccess.ModifyRecords(DataQueries.InsertWFGroupMembs(_GroupID, _EmployeeID, _DefaultName, _eMail));

                ////Get the ID               
                using (DataTable _tempNewID = DataAccess.GetRecords(DataQueries.GetWFGroupMembsMaxID()))
                {
                    _GroupMemberID = Convert.ToInt32(_tempNewID.Rows[0]["MaxID"].ToString());
                }
            }
        }
        
        //WF Header
        GetRecord(_GroupID);

        //WF Step
        if (GetGroupMembers(_GroupID) > 0)
        {            
            GetMember(_GroupMemberID);
        }

        SetFormHeader(FORM_ON.View);
        SetFormMember(FORM_ON.View);

        this.btnFind.AlternateText = "Find New Group";
        this.btnAddSaveMember.Text = "Add Member";
        this.btnNewEditSave.Text = "Edit";
        this.btnCancel.Visible = false;
        this.btnDelete.Visible = true;        
        this.btnNewEditSave.Visible = true;
        this.btnAddSaveMember.Visible = true; 
        this.btnFind.Visible = true; 
    }
    
    /// <summary>
    /// Add a New Step to the existing workflow
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAddSaveMember_Click(object sender, EventArgs e)
    {
        try
        {
            if (this.btnAddSaveMember.Text == "Save Member")
            {
                SaveGroup(this.btnAddSaveMember.Text);
            }
            else
            {
                InitializeFormMemberFields();
                SetFormMember(FORM_ON.Edit);              

                this.btnAddSaveMember.Text = "Save Member";
                this.btnCancel.Visible = true;
                this.btnDelete.Visible = false;
                this.btnNewEditSave.Visible = false;
                this.lblGroupMembers.Text = null;
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }  
    }
    
    /// <summary>
    /// Delete WF Template and Associated Records
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 _GroupID = Convert.ToInt32(this.hdnGroupID.Value);              
            String _WFGroupName = this.txtGroupName.Text;  

            Boolean _DeleteRecordsPref = false;
            String _DeletePreference = this.Request.Form["hdnDeleteUserPref"];
            if (!String.IsNullOrEmpty(_DeletePreference))
            {
                _DeleteRecordsPref = Convert.ToBoolean(_DeletePreference);
            }

            if (_DeleteRecordsPref)
            {
                DataAccess.ModifyRecords(DataQueries.DeleteWFGroupMembs(_GroupID));
                DataAccess.ModifyRecords(DataQueries.DeleteWFGroups(_GroupID));

                InitializeFormHeaderFields();
                InitializeFormMemberFields();
                InitializeGrids();

                SetFormHeader(FORM_ON.View);
                SetFormMember(FORM_ON.View);

                this.ddlGroupName.Visible = true;
                //this.ddlGroupName.CssClass = "CtrlMediumValueEdit";
                this.txtGroupName.Visible = false;
                this.ddlGroupName.Focus();

                this.btnNewEditSave.Text = "New Group";
                this.btnFind.AlternateText = "Find";
                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnAddSaveMember.Visible = false;
                this.btnFind.Visible = true;

                this.lblStatus.Text = "Success ! Group " + _WFGroupName + " and its associated members are deleted ";
            }
            else
            {
                GetGroupMembers(_GroupID); 
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage     
        }
    }

    /// <summary>
    /// On Employee Selection Changed
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlEmployee_SelectedIndexChanged(object sender, EventArgs e)
    {
        Int32 _EmployeeID = 0;
                
        try
        {
            if (this.ddlEmployee.SelectedItem.Text != "-NONE-")
            {
                 _EmployeeID = Convert.ToInt32(this.ddlEmployee.SelectedItem.Value);
                 this.txtDefault.Text = this.ddlEmployee.SelectedItem.Text;
            }

            Int32 _rowCount = 0;
            using (DataTable _tempEmpEmail = DataAccess.GetRecords(DataQueries.GetUserXRefEmail(_EmployeeID)))
            {
                _rowCount = _tempEmpEmail.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtEmail.Text = _tempEmpEmail.Rows[0]["eMail"].ToString();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }
    
    /// <summary>
    /// Get Record Values
    /// </summary>
    /// <param name="GroupID"></param>
    /// <returns></returns>
    private Int32 GetRecord(Int32 GroupID)
    {
        Int32 _rowCount = 0;
              
        try
        {
            using (DataTable _tempGroupHeader = DataAccess.GetRecords(DataQueries.GetViewWFGroupsByID(GroupID)))
            {
                _rowCount = _tempGroupHeader.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtGroupName.Text = _tempGroupHeader.Rows[0]["Group Name"].ToString();
                    this.txtGroupType.Text = _tempGroupHeader.Rows[0]["Type Name"].ToString();
                    this.hdnGroupTypeCode.Value = _tempGroupHeader.Rows[0]["Type Code"].ToString();                    
                    this.hdnGroupID.Value = GroupID.ToString();
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
    /// Get WF Step Record
    /// </summary>
    /// <param name="ActionID"></param>
    /// <returns></returns>
    private Int32 GetMember(Int32 GroupMemberID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempGroupMember = DataAccess.GetRecords(DataQueries.GetViewWFGMembsByID(GroupMemberID)))
            {
                _rowCount = _tempGroupMember.Rows.Count;

                if (_rowCount > 0)
                {   
                    this.txtEmployee.Text = _tempGroupMember.Rows[0]["Employee Name"].ToString();
                    this.txtDefault.Text =_tempGroupMember.Rows[0]["User Provided Name"].ToString();                                                                          
                    this.txtEmail.Text = _tempGroupMember.Rows[0]["User Provided Email"].ToString();
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
    /// Get WorkFlow Steps
    /// </summary>
    /// <param name="GroupID"></param>
    /// <returns></returns>
    private Int32 GetGroupMembers(Int32 GroupID)
    {
        Int32 _rowCount = 0;

         try
         {
             //this.gvGroupMembers.CssClass = "GridViewStyleView";
             //this.gvGroupMembers.HeaderStyle.CssClass = "GridViewStyleView";
             //this.gvGroupMembers.RowStyle.CssClass = "GridViewStyleView";
             this.gvGroupMembers.AutoGenerateDeleteButton = true;
             this.gvGroupMembers.AutoGenerateSelectButton = true;   
             this.gvGroupMembers.EnableViewState = false;
             this.gvGroupMembers.Controls.Clear();
             
             using (DataTable _tempWFMembers = DataAccess.GetRecords(DataQueries.GetViewWFGMembs(GroupID)))
             {
                 _rowCount = _tempWFMembers.Rows.Count;

                 if (_rowCount > 0)
                 {                     
                     this.gvGroupMembers.DataSource = _tempWFMembers;
                     this.gvGroupMembers.DataBind();
                     this.hdnGroupMemberID.Value = this.gvGroupMembers.Rows[0].Cells[1].Text;
                     this.lblGroupMembers.Text = null;
                 }
                 else
                 {
                     this.lblGroupMembers.Text = "Please add members to the selected group.";
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
    /// Group Members Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvGroupMembers_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Int32 _GroupID = Convert.ToInt32(this.hdnGroupID.Value);
        Int32 _GroupMemberID = 0;

        GetGroupMembers(_GroupID);

        if (gvGroupMembers.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {            
            _GroupMemberID = Convert.ToInt32(gvGroupMembers.Rows[e.RowIndex].Cells[1].Text);
            DataAccess.ModifyRecords(DataQueries.DeleteWFGroupMembsByID(_GroupMemberID));           
        }
                
        if (GetGroupMembers(_GroupID) > 0)
        {
            _GroupMemberID = Convert.ToInt32(this.hdnGroupMemberID.Value);
            GetMember(_GroupMemberID);
        }        
    }
    
    /// <summary>
    /// Group Members Row Select
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvGroupMembers_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        Int32 _colEmpRecordIDIndex = 1;        
        Int32 _selectedRowIndex = e.NewSelectedIndex;

        Int32 _GroupID = 0;
        if (this.ddlGroupName.SelectedItem.Text != "-NONE-")
        {
            _GroupID = Convert.ToInt32(this.ddlGroupName.SelectedItem.Value);
        }
        
        GetGroupMembers(_GroupID);

        if (gvGroupMembers.Rows.Count <= 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _EmpRecordID = Convert.ToInt32(gvGroupMembers.Rows[_selectedRowIndex].Cells[_colEmpRecordIDIndex].Text);
            this.hdnGroupMemberID.Value = _EmpRecordID.ToString();

            if (GetMember(_EmpRecordID) > 0)
            {
                SetFormHeader(FORM_ON.View);
                SetFormMember(FORM_ON.View);
            }
        }
    }    
    
    /// <summary>
    /// Group Members Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvGroupMembers_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colDeleteIndex = 0;
        Int32 _colSelectIndex = 0;
        Int32 _colEmpRecordIDIndex = 1;
        Int32 _colEmpIDIndex = 2;
        
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colEmpRecordIDIndex].Visible = false;
            e.Row.Cells[_colEmpIDIndex].Visible = false;  
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colEmpRecordIDIndex].Visible = false;
            e.Row.Cells[_colEmpIDIndex].Visible = false;   

            //Get Column Indexes
            DataRowView drvAMembers = (DataRowView)e.Row.DataItem;            
            Int32 _colUserProvName = drvAMembers.DataView.Table.Columns["User Provided Name"].Ordinal + 1;
            Int32 _colUserProvMail = drvAMembers.DataView.Table.Columns["User Provided eMail"].Ordinal + 1;
                                 
            //Delete Button
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }
                        
            //Align
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colUserProvName].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colUserProvMail].HorizontalAlign = HorizontalAlign.Left;                    
        }
    }   
        
    /// <summary>
    /// Initialize Header Form
    /// </summary>
    private void InitializeFormHeaderFields()
    {
        this.txtGroupName.Text = null;
        this.txtGroupType.Text = null;
               
        using (DataTable _tempGroupName = new DataTable())
        {
            _tempGroupName.Columns.Add("ID", Type.GetType("System.Int32"));
            _tempGroupName.Columns.Add("Description", Type.GetType("System.String"));
            _tempGroupName.Rows.Add(0, "-NONE-");
            _tempGroupName.Merge(DataAccess.GetRecords(DataQueries.GetWFGroups()), true);
            this.ddlGroupName.DataSource = _tempGroupName;
            this.ddlGroupName.DataTextField = "Description";
            this.ddlGroupName.DataValueField = "ID";
            this.ddlGroupName.DataBind();
        }
        
        using (DataTable _tempGroupType = new DataTable())
        {
            _tempGroupType.Columns.Add("Code", Type.GetType("System.String"));
            _tempGroupType.Columns.Add("Description", Type.GetType("System.String"));
            _tempGroupType.Rows.Add("-NONE-", "-NONE-");
            _tempGroupType.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsGroupType("WFGroupType", "EMP")), true);
            this.ddlGroupType.DataSource = _tempGroupType;
            this.ddlGroupType.DataTextField = "Description";
            this.ddlGroupType.DataValueField = "Code";
            this.ddlGroupType.DataBind();
        }
    }
    
    /// <summary>
    /// Initialize Step Form
    /// </summary>
    private void InitializeFormMemberFields()
    {
        try
        {
            this.lblStatus.Text = null;
            this.lblGroupMembers.Text = "Please select a group to view the members associated with it.";
            
            this.txtDefault.Text = null;
            this.txtEmployee.Text = null;
            this.txtEmail.Text = null;
            
            this.ddlEmployee.AutoPostBack = true;
            using (DataTable _tempEmployee = new DataTable())
            {
                _tempEmployee.Columns.Add("ID", Type.GetType("System.Int32"));
                _tempEmployee.Columns.Add("Description", Type.GetType("System.String"));
                _tempEmployee.Rows.Add(0, "-NONE-");
                _tempEmployee.Merge(DataAccess.GetRecords(DataQueries.GetUserXRef()), true);
                this.ddlEmployee.DataSource = _tempEmployee;
                this.ddlEmployee.DataTextField = "Description";
                this.ddlEmployee.DataValueField = "ID";
                this.ddlEmployee.DataBind();
            }

            //Register Script for Delete Button
            this.btnDelete.OnClientClick = "GetWFDeleteUserConf()";
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
            this.gvGroupMembers.EnableViewState = false;
            this.gvGroupMembers.Controls.Clear();
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);  
        } 
    }

    /// <summary>
    /// Set Header Form to Edit or View
    /// </summary>
    /// <param name="EditView"></param>
    private void SetFormHeader(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {
                //Apply View Style                
                //this.txtGroupName.CssClass = "CtrlMediumValueView";
                //this.txtGroupType.CssClass = "CtrlMediumValueView";
                                              
                //Set Read Only        
                this.txtGroupName.ReadOnly = true;
                this.txtGroupType.ReadOnly = true;
                
                //Hide Edit Controls 
                this.ddlGroupName.Visible = false;
                this.ddlGroupType.Visible = false;

                //Show View Controls                
                this.txtGroupName.Visible = true;
                this.txtGroupType.Visible = true;

            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
                //Apply Edit Style
                //this.txtGroupName.CssClass = "CtrlMediumValueEdit";
                //this.ddlGroupType.CssClass = "CtrlMediumValueEdit";
                                                
                //Reset the Read Only
                this.txtGroupName.ReadOnly = false;
                             
                //Hide View Controls      
                this.ddlGroupName.Visible = false;
                this.txtGroupType.Visible = false;               

                //Show Edit Controls
                this.txtGroupName.Visible = true;
                this.ddlGroupType.Visible = true;                

                //Initialize from View Controls                
                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlGroupType.Items.FindByText(this.txtGroupType.Text.Trim());
                this.ddlGroupType.SelectedIndex = this.ddlGroupType.Items.IndexOf(liSelectedItem);                
            } //end if - EDIT  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }   
    
    /// <summary>
    /// Set Step Form to Edit or View
    /// </summary>
    /// <param name="EditView"></param>
    private void SetFormMember(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {
                //Apply View Style                                               
                //this.txtDefault.CssClass = "CtrlMediumValueView";
                //this.txtEmployee.CssClass = "CtrlMediumValueView";
                //this.txtEmail.CssClass = "CtrlMediumValueView";
               
                //Set Read Only        
                this.txtDefault.ReadOnly = true;
                this.txtEmployee.ReadOnly = true;
                this.txtEmail.ReadOnly = true;
                                
                //Hide Edit Controls 
                this.ddlEmployee.Visible = false;
                                
                //Show View Controls              
                this.txtEmployee.Visible = true;                               
            }//end if - VIEW

            if (EditView ==FORM_ON.Edit)
            {
                //Apply Edit Style 
                //this.ddlEmployee.CssClass = "CtrlMediumValueEdit";
                //this.txtDefault.CssClass = "CtrlMediumValueEdit";
                //this.txtEmail.CssClass = "CtrlMediumValueEdit";
               
                //Reset the Read Only
                this.txtDefault.ReadOnly = false;                
                this.txtEmail.ReadOnly = false;
                                
                //Hide View Controls      
                this.txtEmployee.Visible = false;                
                
                //Show Edit Controls                                                                  
                this.ddlEmployee.Visible = true;
                
                //Initialize from View Controls                
                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlEmployee.Items.FindByText(this.txtEmployee.Text.Trim());
                this.ddlEmployee.SelectedIndex = this.ddlEmployee.Items.IndexOf(liSelectedItem);

            } //end if - EDIT  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }       
    }
    
}
                