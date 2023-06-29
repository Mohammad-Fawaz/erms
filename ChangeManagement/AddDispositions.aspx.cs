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

public partial class ChangeManagement_AddDisposition : System.Web.UI.Page
{    
    public String _SID;
    public String _SessionUser;
    public Int32 _COID;   
     
    protected void Page_Load(object sender, EventArgs e)
    {
        this.lblStatus.Text = null;      

        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID; 

            if (Request.QueryString["COID"] !=null)
            {
                _COID =Convert.ToInt32(Request.QueryString["COID"]);
            }

            if (!IsPostBack)
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);
            }

            GetAddDispositionInfo(_COID);
            this.hlnkReturnLink.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + _COID;
        }      
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }      
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
            if (this.btnNewEditSave.Text == "Save" || this.btnNewEditSave.Text == "Edit")
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);
                this.btnNewEditSave.Text = "Add Item";
                this.btnCancel.Visible = false;
            }

            if (this.btnNewEditSave.Text == "Update")
            {
                Int32 _MatDispID = Convert.ToInt32(this.hdnMDID.Value);
                if (GetRecord(_MatDispID) > 0)
                {
                    SetForm(FORM_ON.View);
                    this.btnNewEditSave.Text = "Edit";                                        
                }
            }
         
            GetAddDispositionInfo(_COID);
        }        
        catch(Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }        
    }
    
    /// <summary>
    /// Edit / Save
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnNewEditSave_Click(object sender, EventArgs e)
    {
        try
        {
            if(this.btnNewEditSave.Text == "Add Item") 
            {
                InitializeFormFields();
                SetForm(FORM_ON.Edit);                
                this.btnNewEditSave.Text ="Save";
                this.btnCancel.Visible =true;
            }
            else if (this.btnNewEditSave.Text == "Edit")
            {                
                SetForm(FORM_ON.Edit); 
                this.btnNewEditSave.Text ="Update";
                this.btnCancel.Visible =true;  
            }
            else if (this.btnNewEditSave.Text == "Save" || this.btnNewEditSave.Text == "Update")
            {
                Int32 _MatDispID = 0;
                if (this.btnNewEditSave.Text == "Update")
                {
                    _MatDispID = Convert.ToInt32(this.hdnMDID.Value);
                    if (_MatDispID == 0)
                    {
                        throw new Exception("An [ID] could not be located or created. The record will not be saved.");
                    }
                }
                
                if (_COID == 0)
                {
                    throw new Exception("A referencing [CO Number] could not be located. The record will not be saved.");                                
                }
   
                String PartID = this.txtPartID.Text;
                if(String.IsNullOrEmpty(PartID))
                {
                    throw new Exception("You must provide a [Part/Lot/Serial No] in order to save the record."); 
                }
                                
                String DispStatus = null;
                if (this.ddlDispStatus.SelectedItem.Text != "-NONE-")
                {
                    DispStatus = this.ddlDispStatus.SelectedItem.Value;
                }

                String ImpactArea = null;
                if (this.ddlImpactArea.SelectedItem.Text != "-NONE-")
                {
                    ImpactArea = this.ddlImpactArea.SelectedItem.Value;
                }

                String DispositionType = null;
                if (this.ddlDispType.SelectedItem.Text != "-NONE-")
                {
                    DispositionType = this.ddlDispType.SelectedItem.Value; ;
                }
                
                Int32 DispAssignedTo = 0;
                if (this.ddlAssigned.SelectedItem.Text != "-NONE-")
                {
                    DispAssignedTo = Convert.ToInt32(this.ddlAssigned.SelectedItem.Value);
                }

                DateTime StartDate;
                if (!String.IsNullOrEmpty(this.ucDateStart.SelectedDate))
                {
                    StartDate = Convert.ToDateTime(this.ucDateStart.SelectedDate);
                }
                else
                {
                    StartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }

                DateTime EndDate;
                if (!String.IsNullOrEmpty(this.ucDateEnd.SelectedDate))
                {
                    EndDate = Convert.ToDateTime(this.ucDateEnd.SelectedDate);
                }
                else
                {
                    EndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
                                
                Decimal DispCost = 0;
                if (!String.IsNullOrEmpty(this.txtDispCost.Text))
                {                    
                    DispCost = Convert.ToDecimal(this.txtDispCost.Text);
                }

                Int32 _StatusID = 0;
                if (this.btnNewEditSave.Text == "Save")
                {
                    _StatusID = DataAccess.ModifyRecords(DataQueries.InsertMatDisp(_COID, PartID, DispStatus, StartDate, EndDate, 
                                                                                   ImpactArea, DispositionType, DispAssignedTo, DispCost));
                    if (_StatusID > 0)
                    {
                        lblStatus.Text = "New Item Added !";

                        using (DataTable _dtIdentity = DataAccess.GetRecords(DataQueries.GetMaxMatDispID()))
                        {
                            _MatDispID = Convert.ToInt32(_dtIdentity.Rows[0]["ID"].ToString());
                            this.hdnMDID.Value = _dtIdentity.Rows[0]["ID"].ToString();
                        }
                    }
                }

                if (this.btnNewEditSave.Text == "Update")
                {
                    _StatusID = DataAccess.ModifyRecords(DataQueries.UpdateMatDisp(_COID, PartID, DispStatus, StartDate, EndDate, 
                                                                                    ImpactArea, DispositionType, DispAssignedTo, DispCost,
                                                                                    _MatDispID));
                    if (_StatusID > 0)
                    {
                        lblStatus.Text = "Changes Updated !";
                    }
                }                
 
                InitializeFormFields();
                this.btnNewEditSave.Text = "Add Item";
                this.btnCancel.Visible = false;                
                SetForm(FORM_ON.View);                               
                
            }//if Save or Update
           
            GetAddDispositionInfo(_COID); 
        }        
        catch(Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }       
    }

    /// <summary>
    /// Get Record by Disp ID
    /// </summary>
    /// <param name="_MDID"></param>
    /// <returns></returns>
    private Int32 GetRecord(Int32 MDID)
    {
        Int32 _rowCount = 0;
        
        try
        {
            using (DataTable _tempMaterial = DataAccess.GetRecords(DataQueries.GetViewMatDispByMDID(MDID)))
            {
                _rowCount = _tempMaterial.Rows.Count;

                if (_rowCount > 0)
                {
                    this.hdnMDID.Value = MDID.ToString();
                    this.txtPartID.Text = _tempMaterial.Rows[0]["Batch"].ToString();

                    if (!String.IsNullOrEmpty(_tempMaterial.Rows[0]["Cost"].ToString()))
                    {
                        this.txtDispCost.Text = _tempMaterial.Rows[0]["Cost"].ToString();
                    }
                    else 
                    {
                        this.txtDispCost.Text = "0.00";
                    }

                    this.txtDispStatus.Text = _tempMaterial.Rows[0]["Status"].ToString();
                    this.txtDispType.Text = _tempMaterial.Rows[0]["Disp Type"].ToString();                    
                    this.txtImpactArea.Text = _tempMaterial.Rows[0]["Rev Type"].ToString();                    
                    this.txtAssigned.Text = _tempMaterial.Rows[0]["Assigned To"].ToString();

                    String _StartDate = _tempMaterial.Rows[0]["Effective Date"].ToString();
                    if (!String.IsNullOrEmpty(_StartDate) && Constants.DateTimeMinimum != _StartDate)
                    {
                        this.txtStartDate.Text = Convert.ToDateTime(_StartDate).ToShortDateString();
                    }

                    String _EndDate = _tempMaterial.Rows[0]["Due Date"].ToString();
                    if (!String.IsNullOrEmpty(_EndDate) && Constants.DateTimeMinimum != _EndDate)
                    {
                        this.txtEndDate.Text = Convert.ToDateTime(_EndDate).ToShortDateString();
                    }

                    this.txtDescription.Text = _tempMaterial.Rows[0]["Rev Type"].ToString();                    
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
    /// Material Disposition Row Select
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAddDispositionInfo_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        if (gvAddDispositionInfo.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _selectedRowIndex = e.NewSelectedIndex;
            Int32 _MatID = Convert.ToInt32(gvAddDispositionInfo.Rows[_selectedRowIndex].Cells[1].Text);

            if (GetRecord(_MatID) > 0)
            {
                SetForm(FORM_ON.View);
                this.btnNewEditSave.Text = "Edit";
                this.btnCancel.Visible = true; 
            }
        }

        GetAddDispositionInfo(_COID);      
    }    
    
    /// <summary>
    /// Material Disposition Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAddDispositionInfo_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            Int32 _colSelectIndex = 0;
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
                //Int32 _colRevTypeIndex = drvMDisp.DataView.Table.Columns["Rev Type"].Ordinal + 1;
                Int32 _colDispTypeIndex = drvMDisp.DataView.Table.Columns["Disp Type"].Ordinal + 1;
                Int32 _colCostIndex = drvMDisp.DataView.Table.Columns["Cost"].Ordinal + 1;
                Int32 _colAssignedToIndex = drvMDisp.DataView.Table.Columns["Assigned To"].Ordinal + 1;
                                
                //Format            
                e.Row.Cells[_colDueDateIndex].Text = DateTime.Parse(e.Row.Cells[_colDueDateIndex].Text).ToShortDateString();
                e.Row.Cells[_colEffDateIndex].Text = DateTime.Parse(e.Row.Cells[_colEffDateIndex].Text).ToShortDateString();
                e.Row.Cells[_colCostIndex].Text = Double.Parse(e.Row.Cells[_colCostIndex].Text).ToString("c");

                //Align
                e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
                e.Row.Cells[_colBatchIndex].HorizontalAlign = HorizontalAlign.Center;
                e.Row.Cells[_colDueDateIndex].HorizontalAlign = HorizontalAlign.Center;
                e.Row.Cells[_colEffDateIndex].HorizontalAlign = HorizontalAlign.Center;
                e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Left;
                //e.Row.Cells[_colRevTypeIndex].HorizontalAlign = HorizontalAlign.Left;
                e.Row.Cells[_colDispTypeIndex].HorizontalAlign = HorizontalAlign.Left;
                e.Row.Cells[_colCostIndex].HorizontalAlign = HorizontalAlign.Right;
                e.Row.Cells[_colAssignedToIndex].HorizontalAlign = HorizontalAlign.Left;
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }       
    }

    /// <summary>
    /// Get Material Disposition
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetAddDispositionInfo(int COID)
    {
        Int32 _rowCount = 0;

        try
        {
               
            this.gvAddDispositionInfo.AutoGenerateSelectButton = true;
            this.gvAddDispositionInfo.EnableViewState = false;
            this.gvAddDispositionInfo.Controls.Clear();

            using (DataTable _tempMDInfo = DataAccess.GetRecords(DataQueries.GetViewMatDispByCOID(COID)))
            {
                _rowCount = _tempMDInfo.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvAddDispositionInfo.DataSource = _tempMDInfo;
                    this.gvAddDispositionInfo.DataBind();
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
    /// Initialize Page
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {
            this.ucDateEnd.SelectedDate = null;
            this.ucDateStart.SelectedDate = null;   
            this.txtPartID.Text = null;
            this.txtAssigned.Text = null;
            this.txtDispCost.Text = null;
            this.txtDispStatus.Text = null;
            this.txtDispType.Text = null;
            this.txtEndDate.Text = null;
            this.txtImpactArea.Text = null;
            this.txtStartDate.Text = null;

            this.txtDescription.Text = null;
            this.txtDescription.TextMode = TextBoxMode.MultiLine;
            this.txtDescription.Height = 50;

            this.hdnMDID.Value = null;

            //Assigned To
            DataTable _tempAssignedTo = new DataTable();
            _tempAssignedTo.Columns.Add("ID", Type.GetType("System.Int32"));
            _tempAssignedTo.Columns.Add("Description", Type.GetType("System.String"));
            _tempAssignedTo.Rows.Add(0, "-NONE-");
            _tempAssignedTo.Merge(DataAccess.GetRecords(DataQueries.GetUserXRef()), true);
            this.ddlAssigned.DataSource = _tempAssignedTo;
            this.ddlAssigned.DataTextField = "Description";
            this.ddlAssigned.DataValueField = "ID";
            this.ddlAssigned.DataBind();

            //Disposition Status
            DataTable _tempDispStatus = new DataTable();
            _tempDispStatus.Columns.Add("Code", Type.GetType("System.String"));
            _tempDispStatus.Columns.Add("Description", Type.GetType("System.String"));
            _tempDispStatus.Rows.Add("-NONE-", "-NONE-");
            _tempDispStatus.Merge(DataAccess.GetRecords(DataQueries.GetQDispStatus()), true);
            this.ddlDispStatus.DataSource = _tempDispStatus;
            this.ddlDispStatus.DataTextField = "Description";
            this.ddlDispStatus.DataValueField = "Code";
            this.ddlDispStatus.DataBind();

            //Disposition Type
            DataTable _tempDispType = new DataTable();
            _tempDispType.Columns.Add("Code", Type.GetType("System.String"));
            _tempDispType.Columns.Add("Description", Type.GetType("System.String"));
            _tempDispType.Rows.Add("-NONE-", "-NONE-");
            _tempDispType.Merge(DataAccess.GetRecords(DataQueries.GetQDispType()), true);
            this.ddlDispType.DataSource = _tempDispType;
            this.ddlDispType.DataTextField = "Description";
            this.ddlDispType.DataValueField = "Code";
            this.ddlDispType.DataBind();

            //Impact Area
            DataTable _tempImpactArea = new DataTable();
            _tempImpactArea.Columns.Add("Code", Type.GetType("System.String"));
            _tempImpactArea.Columns.Add("Description", Type.GetType("System.String"));
            _tempImpactArea.Rows.Add("-NONE-", "-NONE-");
            _tempImpactArea.Merge(DataAccess.GetRecords(DataQueries.GetQImpactArea()), true);
            this.ddlImpactArea.DataSource = _tempImpactArea;
            this.ddlImpactArea.DataTextField = "Description";
            this.ddlImpactArea.DataValueField = "Code";
            this.ddlImpactArea.DataBind();
            
            this.gvAddDispositionInfo.EnableViewState = false;
            this.gvAddDispositionInfo.Controls.Clear();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
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
                this.txtPartID.ReadOnly = true;                
                this.txtDispStatus.ReadOnly =true;
                this.txtDispType.ReadOnly =true;
                this.txtStartDate.ReadOnly = true;
                this.txtEndDate.ReadOnly =true;
                this.txtImpactArea.ReadOnly =true;
                this.txtAssigned.ReadOnly = true;
                this.txtDispCost.ReadOnly = true;
                this.txtDescription.ReadOnly = true;
                
                //Hide Edit Controls
                this.ddlDispStatus.Visible = false;
                this.ddlDispType.Visible = false;
                this.ucDateStart.Visible = false;
                this.ucDateEnd.Visible = false;
                this.ddlImpactArea.Visible = false;
                this.ddlAssigned.Visible =false; 

                //Show View Controls
                this.txtDispStatus.Visible = true;
                this.txtDispType.Visible = true;
                this.txtStartDate.Visible = true;
                this.txtEndDate.Visible = true;
                this.txtImpactArea.Visible = true;
                this.txtAssigned.Visible = true;

            }//end if - VIEW

            if (EditView ==FORM_ON.Edit)
            {               

                //Reset the Read Only
                this.txtPartID.ReadOnly = false;
                this.txtDispCost.ReadOnly = false;
                this.txtDescription.ReadOnly = false;

                //Hide View Controls
                this.txtDispStatus.Visible = false;
                this.txtDispType.Visible = false;
                this.txtStartDate.Visible = false;
                this.txtEndDate.Visible = false;
                this.txtImpactArea.Visible = false;
                this.txtAssigned.Visible = false;               

                //Show Edit Controls
                this.ddlDispStatus.Visible = true;
                this.ddlDispType.Visible = true;
                this.ucDateStart.Visible = true;
                this.ucDateEnd.Visible = true;
                this.ddlImpactArea.Visible = true;
                this.ddlAssigned.Visible = true;
               
                //Initialize from View Controls
                this.ucDateStart.SelectedDate = this.txtStartDate.Text;
                this.ucDateEnd.SelectedDate = this.txtEndDate.Text;

                ListItem liSelectedItem =null;

                liSelectedItem = this.ddlAssigned.Items.FindByText(this.txtAssigned.Text.Trim());
                this.ddlAssigned.SelectedIndex = this.ddlAssigned.Items.IndexOf(liSelectedItem);                    
                
                liSelectedItem = this.ddlDispStatus.Items.FindByText(this.txtDispStatus.Text.Trim());
                this.ddlDispStatus.SelectedIndex = this.ddlDispStatus.Items.IndexOf(liSelectedItem); 
                    
                liSelectedItem =this.ddlDispType.Items.FindByText(this.txtDispType.Text.Trim());
                this.ddlDispType.SelectedIndex =this.ddlDispType.Items.IndexOf(liSelectedItem);                    
                           
                liSelectedItem = this.ddlImpactArea.Items.FindByText(this.txtImpactArea.Text.Trim());
                this.ddlImpactArea.SelectedIndex =this.ddlImpactArea.Items.IndexOf(liSelectedItem);                

            } //end if                                  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }        
    }   

}
