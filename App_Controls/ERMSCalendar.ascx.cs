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

public partial class ERMSCalendar : System.Web.UI.UserControl
{
    /// <summary>
    /// On Control Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //Script to Register
            string dispScript = "<script> "
                                + " function On" + this.ID + "Click() " +
                                  " {  if (ctl00_PageContent_" + this.ID + "_ucpnlDate.style.display == \"none\") "
                                             + "ctl00_PageContent_" + this.ID + "_ucpnlDate.style.display = \"\"; else "
                                             + "ctl00_PageContent_" + this.ID + "_ucpnlDate.style.display = \"none\"; } </script>";

            //Initialize Calendar
            if (!Page.IsPostBack)
            {
                this.ucpnlDate.Attributes.Add("style", "DISPLAY: none; POSITION: absolute");
            }

            //Register the script block
            ClientScriptManager _csmScript = Page.ClientScript;
            _csmScript.RegisterClientScriptBlock(this.GetType(), "Script_Panel" + this.ID, dispScript);

            //Onclick Attribute
            this.ucbtnDate.Attributes.Add("OnClick", "On" + this.ID + "Click()");
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// On Date Selection
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void uccldrDate_SelectionChanged(object sender, EventArgs e)
    {
        try
        {
            this.uctxtDate.Text = this.uccldrDate.SelectedDate.ToShortDateString();                                 
            this.ucpnlDate.Attributes.Add("style", "DISPLAY: none; POSITION: absolute");
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// On Month Selection
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void uccldrDate_VisibleMonthChanged(object sender, MonthChangedEventArgs e)
    {
        try
        {
            this.ucpnlDate.Attributes.Add("style", "POSITION: absolute");
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }
      
    /// <summary>
    /// Property
    /// </summary>
    public String SelectedDate
    {
        get 
        {             
            return this.uctxtDate.Text; 
        }

        set 
        { 
            this.uctxtDate.Text = value;
        }    
    }
    
    /// <summary>
    /// Property
    /// </summary>
    public String CssClass
    {
        get
        {
            return this.uctxtDate.CssClass;
        }

        set
        {
            this.uctxtDate.CssClass = value;
        }
    }    
}    

