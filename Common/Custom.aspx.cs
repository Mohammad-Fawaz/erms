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

/// <summary>
/// Custom Class
/// </summary>
public partial class Common_Custom : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;
    public String _TID;
    public String _DOCID;
    public String _COID;
        
     
    protected void Page_Load(object sender, EventArgs e)
    {       
        this.lblStatus.Text = null;

        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;

            if (Request.QueryString["TID"] != null) ///  Redirected From Task Management //
            {
                _TID = Request.QueryString["TID"];
                this.hlnkReturnLink.Text = "Return to Task";
                this.hlnkWFTaskReturnLink.Visible = false;  
                this.hlnkReturnLink.NavigateUrl = "~/TaskManagement/TaskInformation.aspx?SID=" + _SID + "&TID=" + _TID;
                this.hlnkWFTaskReturnLink.NavigateUrl = "~/WorkFlowManagement/WFTaskInformationReview.aspx?SID=" + _SID + "&TID=" + _TID;
            }
            if (Request.QueryString["DOCID"] != null)//// Redirected From Document Management //
            {
              _DOCID = Request.QueryString["DOCID"];
              this.hlnkReturnLink.Text = "Return To Document";
              this.hlnkWFTaskReturnLink.Visible = false;
              this.hlnkReturnLink.NavigateUrl = "~/DocumentManagement/DocInformation.aspx?SID=" + _SID + "&DOCID=" + _DOCID;
            }
            if (Request.QueryString["COID"] != null)/// Redirected From Change Management ///
            {
                _COID = Request.QueryString["COID"];
              this.hlnkReturnLink.Text = "Return to Order Request";
              this.hlnkWFTaskReturnLink.Visible = false;
              this.hlnkReturnLink.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + _COID;
            }

            if (!IsPostBack)
            {
                InitializeFormFields(); /// For Resetting the Form Fields              
                SetForm(FORM_ON.Edit); /// For Assigning the Text Box Style Class
                SetLabelText(); // For Assigning the Label Text
                SetCustomValues();/// For Setting the Data For Custom Fields
            }


        }        
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Clear Form Fields
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        InitializeFormFields();
        SetForm(FORM_ON.Edit);           
    }

    /// <summary>
    /// Save the Note
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnEditSave_Click(object sender, EventArgs e)
    {
        try
        {
           Int32 _rowCount = 0;
           Int32 existCount=0;
           Int32 statusCount=0;
           String insertUpdateStatus="";
           Int32 CusUDF7=0;
           Int32 CusUDF8=0;
           Int32 CusUDF9=0;
           Int32 CusUDF10=0;
           String validationMsg = "";
           String lblValue = "";
           ContentPlaceHolder customContentPlaceHolder;
           String strType = "";
           String strTypeId = "";
           bool blnValueExists=false;
           String[] arrCustomValues = new String[6];
          
           customContentPlaceHolder = (ContentPlaceHolder)Master.FindControl("PageContent");
           if (customContentPlaceHolder != null)
           {
                  foreach (Control cntl in customContentPlaceHolder.Controls)
                   {
                       if (cntl is Label)
                       {
                           if (cntl.ID != "lblStatus")
                           {
                               if (((Label)cntl).Text != null && ((Label)cntl).Text.Length >0)
                               {
                                   blnValueExists = true;
                                   break;
                               }       
                           }  
                           
                       }

                   }

                   if (blnValueExists == false)
                   {
                       lblStatus.Text = "No Data Found.";
                       return;
                   } 

               //// Field Validation Based on Label Values ////
               foreach (Control cntl in customContentPlaceHolder.Controls)
               {
                   if (cntl is TextBox)
                   {
                       if (cntl.ID == "txtCustom1" || cntl.ID == "txtCustom2" || cntl.ID == "txtCustom3")
                       {
                           if (cntl.ID == "txtCustom1")
                               lblValue = lblCustom1.Text;
                           if(cntl.ID == "txtCustom2")
                               lblValue = lblCustom2.Text;
                           if(cntl.ID == "txtCustom3")
                               lblValue = lblCustom3.Text;

                           if(lblValue.Length !=null && lblValue.Length >0)
                           validationMsg = Utils.ValidateFieldData(((TextBox)cntl).Text, lblValue, "STR", 20);                           
                       }
                       else
                       {
                           if (cntl.ID == "txtCustom4")
                               lblValue = lblCustom4.Text;
                           if (cntl.ID == "txtCustom5")
                               lblValue = lblCustom5.Text;
                           if (cntl.ID == "txtCustom6")
                               lblValue = lblCustom6.Text;

                           if (lblValue.Length != null && lblValue.Length > 0)
                           validationMsg = Utils.ValidateFieldData(((TextBox)cntl).Text, lblValue, "STR", 255);
                           
                       }

                       if (validationMsg != null && validationMsg.Length > 0)
                       {
                           lblStatus.Text = validationMsg;
                           return;
                       }

                   }

               }
           }

             if (_DOCID != null && _DOCID.Length > 0)
            {
                strType = "DOC";
                strTypeId = _DOCID;
            }

            if (_TID != null && _TID.Length > 0)
            {
                strType = "TASK";
                strTypeId = _TID;
            }
            if (_COID != null && _COID.Length > 0)
            {
                strType = "CO";
                strTypeId = _COID;
            }

            using (DataTable _tempCustomSave = DataAccess.GetRecords(DataQueries.getCustomExistCount(strTypeId, strType)))
            {
                _rowCount = _tempCustomSave.Rows.Count;
                if(_rowCount >0)
                {
                      existCount=Int32.Parse(_tempCustomSave.Rows[0]["ExistCount"].ToString());
                     if(existCount >0)
                     {
                       insertUpdateStatus="U";
                     }
                     else
                     {
                      insertUpdateStatus="I";
                     }
                }
            }

           CusUDF7=  cbCustom1.Checked ? -1 : 0;
           CusUDF8 = cbCustom2.Checked ? -1 : 0;
           CusUDF9 = cbCustom3.Checked ? -1 : 0;
           CusUDF10 = cbCustom4.Checked ? -1 : 0;


            arrCustomValues[0]=txtCustom1.Text;
            arrCustomValues[1]=txtCustom2.Text;
            arrCustomValues[2]=txtCustom3.Text;
            arrCustomValues[3]=txtCustom4.Text;
            arrCustomValues[4]=txtCustom5.Text;
            arrCustomValues[5]=txtCustom6.Text;

            //// Table Insertion ///
           statusCount = DataAccess.ModifyRecords(DataQueries.InsertCustomValues(strTypeId, strType,
                                               arrCustomValues, CusUDF7, CusUDF8, CusUDF9,
                                             CusUDF10, insertUpdateStatus));

            if(statusCount>0)
            {
                lblStatus.Text = "Record[s] Saved Successfully.";
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }       
    }    

    /// <summary>
    /// Data Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvNotes_RowDataBound(object sender, GridViewRowEventArgs e)
    {
       
    }
    
    /// <summary>
    /// Initialize Page
    /// </summary>
    private void InitializeFormFields()
    {
        ContentPlaceHolder customContentPlaceHolder;
        try
        {
            customContentPlaceHolder = (ContentPlaceHolder)Master.FindControl("PageContent");
            if (customContentPlaceHolder != null)
            {
                foreach (Control cntl in customContentPlaceHolder.Controls)
                {
                    if (cntl is TextBox)
                    ((TextBox)cntl).Text = null;                   
                    if(cntl is CheckBox)
                    ((CheckBox)cntl).Checked = false;                    
                }
            }            
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
        
        ContentPlaceHolder customContentPlaceHolder;
        
        try
        {
             //// Assigning the Style Class For Text Box and Labels
            if (EditView == FORM_ON.Edit)
            {

                customContentPlaceHolder = (ContentPlaceHolder)Master.FindControl("PageContent");
                if (customContentPlaceHolder != null)
                {
                    
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }       
    }


    private void SetLabelText()
    {

        Int32 _rowCount = 0;
        String strLabel = "";
        String strValue="";
        String strType = "";
        ContentPlaceHolder customContentPlaceHolder;
        Label label = null;
        TextBox textbox = null;
        CheckBox checkbox = null;

        try
        {
           
             customContentPlaceHolder = (ContentPlaceHolder)Master.FindControl("PageContent");


            //  Assigning the Lables Text //

            if (_DOCID != null && _DOCID.Length > 0)
            {
                strType = "DM";
            }

            if (_TID != null && _TID.Length > 0)
            {
                strType = "TM";
            }

            if (_COID != null && _COID.Length > 0)
            {
                strType = "CM";
            }


            using (DataTable _tempCustomLabels = DataAccess.GetRecords(DataQueries.GetCustomLabels(strType)))
            {
                _rowCount = _tempCustomLabels.Rows.Count;

                if (_rowCount > 0)
                {
                    for (Int32 i = 1; i <= 10; i++)
                    {
                        strLabel = "UDFLbl" + i;
                        if (_tempCustomLabels.Rows[0][strLabel] != null && _tempCustomLabels.Rows[0][strLabel].ToString().Length > 0)
                        {
                            strValue = _tempCustomLabels.Rows[0][strLabel].ToString();
                            label = (Label)customContentPlaceHolder.FindControl("lblCustom" + i);
                            label.Text = _tempCustomLabels.Rows[0][strLabel].ToString();
                        }
                        else
                        {
                            if (i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6)
                            {
                                textbox = (TextBox)customContentPlaceHolder.FindControl("txtCustom" + i);
                                textbox.Enabled = false;
                                //textbox.CssClass = "CtrlShortValueView";
                            }
                            else
                            {
                                checkbox = (CheckBox)customContentPlaceHolder.FindControl("cbCustom" + (i - 6));
                                checkbox.Enabled = false;
                            }
                        }
                    }
                }

                else
                {

                    customContentPlaceHolder = (ContentPlaceHolder)Master.FindControl("PageContent");
                    if (customContentPlaceHolder != null)
                    {
                       
                    }


                }

            }

            
        }

        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }



    private void SetCustomValues()
    {

        Int32 _rowCount = 0;
        String strValue = "";
        String strType = "";

        try
        {
             /// Assigning the Data to Text Boxes and Check Boxes.
            if (_DOCID != null && _DOCID.Length > 0)
            {
                strType = "DOC";
                strValue=_DOCID;
            }

            if (_TID != null && _TID.Length > 0)
            {
                strType = "TASK";
                strValue = _TID;
            }

            if (_COID != null && _COID.Length > 0)
            {
                strType = "CO";
                strValue = _COID;
            }



            using (DataTable _tempCustomValues = DataAccess.GetRecords(DataQueries.GetCustomValues(strValue, strType)))
            {
                _rowCount = _tempCustomValues.Rows.Count;

                if (_rowCount > 0)
                {
                    txtCustom1.Text = lblCustom1.Text != "" ? _tempCustomValues.Rows[0]["UDF1"].ToString().Replace("`","'") : null;
                    txtCustom2.Text = lblCustom2.Text != "" ? _tempCustomValues.Rows[0]["UDF2"].ToString().Replace("`", "'") : null;
                    txtCustom3.Text = lblCustom3.Text != "" ? _tempCustomValues.Rows[0]["UDF3"].ToString() : null;
                    txtCustom4.Text = lblCustom4.Text != "" ? _tempCustomValues.Rows[0]["UDF4"].ToString() : null;
                    txtCustom5.Text = lblCustom5.Text != "" ? _tempCustomValues.Rows[0]["UDF5"].ToString() : null;
                    txtCustom6.Text = lblCustom6.Text != "" ? _tempCustomValues.Rows[0]["UDF6"].ToString() : null;

                    cbCustom1.Checked=lblCustom7.Text != "" && _tempCustomValues.Rows[0]["UDF7"] != null && _tempCustomValues.Rows[0]["UDF7"].ToString().Equals("True") ? true : false ;
                    cbCustom2.Checked =lblCustom8.Text != "" && _tempCustomValues.Rows[0]["UDF8"] != null && _tempCustomValues.Rows[0]["UDF8"].ToString().Equals("True") ? true : false;
                    cbCustom3.Checked =lblCustom9.Text != "" &&  _tempCustomValues.Rows[0]["UDF9"] != null && _tempCustomValues.Rows[0]["UDF9"].ToString().Equals("True") ? true : false;
                    cbCustom4.Checked =lblCustom10.Text != "" &&  _tempCustomValues.Rows[0]["UDF10"] != null && _tempCustomValues.Rows[0]["UDF10"].ToString().Equals("True") ? true : false;
                }
            }
        }

        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }

}
