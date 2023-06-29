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

public partial class ChangeManagement_ChangeImpact : System.Web.UI.Page
{    
    public String _SID;
    public String _SessionUser;
    public Int32 _COID; 

    /// <summary>
    /// Page Load Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.lblStatus.Text = null;
       
        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID; 

            if (Request.QueryString["COID"] != null)
            {
                _COID = Convert.ToInt32(Request.QueryString["COID"]);
            }
                       
            if (!IsPostBack)
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);                       
            }

            GetChangeImpact(_COID);    
            this.hlnkReturnLink.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + _COID;
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Save the Impact
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnSave_Click(object sender, EventArgs e)
    {
        Int32 _rowCount = 0;
        Int32 _OrderID = 0;
        Int32 _LineItemID = 0;
        Int32 _StatusID = 0;

        try
        {
            using (DataTable _tempChangeImpact = DataAccess.GetRecords(DataQueries.GetViewImpactByID(_COID)))
            {
                _rowCount = _tempChangeImpact.Rows.Count;
                if (_rowCount > 0)
                {
                    if (_COID == 0)
                    {
                        throw new Exception("The Change Order ID could not be located. The record will not be saved.");
                    }

                    foreach (DataRow drImpact in _tempChangeImpact.Rows)
                    {
                        //Get Order ID
                        if (!String.IsNullOrEmpty(drImpact.ItemArray[_tempChangeImpact.Columns["Order ID"].Ordinal].ToString()))
                        {
                            _OrderID = Convert.ToInt32(drImpact.ItemArray[_tempChangeImpact.Columns["Order ID"].Ordinal].ToString());
                        }
                        else
                        {
                            throw new Exception("The Order ID could not be located. The record will not be saved.");
                        }

                        //Get LineItem ID
                        if (!String.IsNullOrEmpty(drImpact.ItemArray[_tempChangeImpact.Columns["Line Item ID"].Ordinal].ToString()))
                        {
                            _LineItemID = Convert.ToInt32(drImpact.ItemArray[_tempChangeImpact.Columns["Line Item ID"].Ordinal].ToString());
                        }
                        else
                        {
                            throw new Exception("The Line Item ID could not be located. The record will not be saved.");
                        }

                        _StatusID = DataAccess.ModifyRecords(DataQueries.InsertCOImpact(_COID, _OrderID, _LineItemID));
                        //if (_StatusID > 0)
                        //{
                        //  //Write Status of every Line Item. -- if needed.
                        //}
                    }

                    if (_StatusID > 0)
                    {
                        this.lblStatus.Text = "Impact items has been saved";
                    }
                    
                }
            }
            GetChangeImpact(_COID);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }    
    
    /// <summary>
    /// Rebuild the Impact Changes
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnRebuild_Click(object sender, EventArgs e)
    {
        try
        {
            DataAccess.ModifyRecords(DataQueries.DeleteCOImpactByID(_COID));
            GetChangeImpact(_COID);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }       
    }

    /// <summary>
    /// Pagination
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvImpacts_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            this.gvImpacts.PageIndex = e.NewPageIndex;
            this.gvImpacts.DataBind();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }       
    }
    
    /// <summary>
    /// Impact Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvImpacts_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Int32 _colOrderIDIndex = 1;
        Int32 _colLineItemIDIndex = 2;

        if (gvImpacts.Rows.Count <= 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _OrderID = Convert.ToInt32(gvImpacts.Rows[e.RowIndex].Cells[_colOrderIDIndex].Text);
            Int32 _LineItemID = Convert.ToInt32(gvImpacts.Rows[e.RowIndex].Cells[_colLineItemIDIndex].Text);

            Int32 _StatusCheck = DataAccess.ModifyRecords(DataQueries.DeleteCOImpactByID(_OrderID, _LineItemID, _COID));
            if (_StatusCheck > 0)
            {
                this.lblStatus.Text = "Success ! Impact was removed";
            }

            GetChangeImpact(_COID);
        }
    }
    
    /// <summary>
    /// Impact Row Select
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvImpacts_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {        
        Int32 _colOrderIDIndex = 1;
        Int32 _colLineItemIDIndex = 2;
        Int32 _selectedRowIndex = e.NewSelectedIndex;

        if (gvImpacts.Rows.Count <= 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _OrderID = Convert.ToInt32(gvImpacts.Rows[_selectedRowIndex].Cells[_colOrderIDIndex].Text);
            Int32 _LineItemID = Convert.ToInt32(gvImpacts.Rows[_selectedRowIndex].Cells[_colLineItemIDIndex].Text);

            if (GetRecord(_COID, _OrderID, _LineItemID) > 0)
            {
                SetForm(FORM_ON.View);
            }

            GetChangeImpact(_COID);
        }                
    }    

    /// <summary>
    /// Get Impact
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetChangeImpact(Int32 COID)
    {
        Int32 _rowCount = 0;

        try
        {                             
            this.gvImpacts.AutoGenerateDeleteButton = true;
            this.gvImpacts.AutoGenerateSelectButton = true;
            this.gvImpacts.EnableViewState = false;
            this.gvImpacts.Controls.Clear();

            using (DataTable _tempChangeImpact = DataAccess.GetRecords(DataQueries.GetViewImpactByID(COID)))
            {
                _rowCount = _tempChangeImpact.Rows.Count;
                if (_rowCount > 0)
                {                 
                    this.gvImpacts.DataSource = _tempChangeImpact;
                    this.gvImpacts.DataBind();
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
    /// Impact Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvImpacts_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colDeleteIndex = 0;
        Int32 _colSelectIndex = 0;
        Int32 _colOrderIDIndex = 1;
        Int32 _colLineItemIDIndex = 2;
      
        if (e.Row.RowType == DataControlRowType.Header)
        {
            //Hide
            e.Row.Cells[_colOrderIDIndex].Visible = false;
            e.Row.Cells[_colLineItemIDIndex].Visible = false;
        }
        
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //Hide
            e.Row.Cells[_colOrderIDIndex].Visible = false;
            e.Row.Cells[_colLineItemIDIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvChangeImpact = (DataRowView)e.Row.DataItem;              
            Int32 _colOrdTypeIndex = drvChangeImpact.DataView.Table.Columns["Order Type"].Ordinal + 1;
            Int32 _colOrdNumIndex = drvChangeImpact.DataView.Table.Columns["Order Number"].Ordinal + 1;
            Int32 _colOrdStatusIndex = drvChangeImpact.DataView.Table.Columns["Order Status"].Ordinal + 1;
            Int32 _colLineItemIndex = drvChangeImpact.DataView.Table.Columns["Line Item"].Ordinal + 1;
            Int32 _colPartNumIndex = drvChangeImpact.DataView.Table.Columns["Part Number"].Ordinal + 1;
            Int32 _colRevStatusIndex = drvChangeImpact.DataView.Table.Columns["Revision Status"].Ordinal + 1;
            Int32 _colPartRevIndex = drvChangeImpact.DataView.Table.Columns["Part Revision"].Ordinal + 1;
            Int32 _colPEffDateIndex = drvChangeImpact.DataView.Table.Columns["Part Effective Date"].Ordinal + 1;
            Int32 _colPDescIndex = drvChangeImpact.DataView.Table.Columns["Part Description"].Ordinal + 1;
            Int32 _colUnitIndex = drvChangeImpact.DataView.Table.Columns["Unit"].Ordinal + 1;
            Int32 _colQtyIndex = drvChangeImpact.DataView.Table.Columns["Qty"].Ordinal + 1;
            Int32 _colCostIndex = drvChangeImpact.DataView.Table.Columns["Cost"].Ordinal + 1;

            //Delete Button
            LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0];
            lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";

            //Format            
            e.Row.Cells[_colPEffDateIndex].Text = DateTime.Parse(e.Row.Cells[_colPEffDateIndex].Text).ToShortDateString();
            e.Row.Cells[_colCostIndex].Text = Double.Parse(e.Row.Cells[_colCostIndex].Text).ToString("c");

            //Align 
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
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
    /// Get Record
    /// </summary>
    /// <param name="COID"></param>
    /// <param name="OID"></param>
    /// <param name="LID"></param>
    /// <returns></returns>
    private Int32 GetRecord(Int32 COID, Int32 OID, Int32 LID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewRecord = DataAccess.GetRecords(DataQueries.GetViewImpactByID(COID, OID, LID)))
            {
                _rowCount = _tempViewRecord.Rows.Count;
                if (_rowCount  > 0)
                {
                    this.txtOrderID.Text = _tempViewRecord.Rows[0]["Order ID"].ToString();
                    this.txtStatus.Text = _tempViewRecord.Rows[0]["Order Status"].ToString();
                    this.txtOrderLine.Text = _tempViewRecord.Rows[0]["Line Item"].ToString();
                    this.txtOrderType.Text = _tempViewRecord.Rows[0]["Order Type"].ToString();
                    this.txtPartNumber.Text = _tempViewRecord.Rows[0]["Part Number"].ToString();
                    this.txtRevision.Text = _tempViewRecord.Rows[0]["Part Revision"].ToString();
                    this.txtRevisionStatus.Text = _tempViewRecord.Rows[0]["Revision Status"].ToString();
                    this.txtQty.Text = _tempViewRecord.Rows[0]["Qty"].ToString();
                    this.txtUnit.Text = _tempViewRecord.Rows[0]["Unit"].ToString();

                    if (!String.IsNullOrEmpty(_tempViewRecord.Rows[0]["Cost"].ToString()))
                    {
                        this.txtCost.Text = _tempViewRecord.Rows[0]["Cost"].ToString();
                    }
                    else
                    {
                        this.txtCost.Text = "0.00";
                    }
                    
                    this.txtDescription.Text = _tempViewRecord.Rows[0]["Part Description"].ToString();
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
    /// Initialize Form
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {
            //Reset           
            this.txtOrderID.Text = null;
            this.txtOrderLine.Text = null;
            this.txtOrderType.Text = null;
            this.txtPartNumber.Text = null;
            this.txtQty.Text = null;
            this.txtCost.Text = null;
            this.txtRevision.Text = null;
            this.txtRevisionStatus.Text = null;
            this.txtStatus.Text = null;
            this.txtUnit.Text = null;
            this.txtDescription.Text = null;

            this.txtDescription.TextMode = TextBoxMode.MultiLine;
            this.txtDescription.Height = 50;

            this.gvImpacts.EnableViewState = false;
            this.gvImpacts.Controls.Clear();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }    
    }

    /// <summary>
    /// Set Page 
    /// </summary>
    /// <param name="EditView"></param>
    private void SetForm(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {
                
                //Set Read Only
                this.txtOrderID.ReadOnly = true;
                this.txtOrderLine.ReadOnly = true;
                this.txtOrderType.ReadOnly = true;
                this.txtPartNumber.ReadOnly = true;
                this.txtQty.ReadOnly = true;
                this.txtCost.ReadOnly = true;
                this.txtRevision.ReadOnly = true;
                this.txtRevisionStatus.ReadOnly = true;
                this.txtStatus.ReadOnly = true;
                this.txtUnit.ReadOnly = true;
                this.txtDescription.ReadOnly = true;

            }//end if - VIEW 

            if (EditView == FORM_ON.Edit)
            {
                //None
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }        
    }

}