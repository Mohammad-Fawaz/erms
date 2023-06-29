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
using System.Drawing;
using System.Diagnostics;
 
public partial class Login : System.Web.UI.Page
{
    /// <summary>
    /// Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {        
        try
        {
            if (!Page.IsPostBack)
            {
              //  HideAccessRequiredCtrls();
                InitializeLoginControl();
            }  
        }
        catch (Exception ex)
        {
            //lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// Initialize Login Control
    /// </summary>
    private void InitializeLoginControl()
    {
        try
        {
            //this.ctrlLogin.TitleText = "<b><font face=verdana size=3>System Login</font></b><br><br>" +
            //                                  "<font face=verdana size=2 color=#778899>The<b>ERMS</b><em>Web</em>" +
            //                                  " requires a valid login<br>for access to system components.<hr>";
            this.ctrlLogin.BorderColor = Color.Black;
            this.ctrlLogin.BorderWidth = 1;
        }
        catch (Exception ex)
        {
            //lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// Hide Access Required Controls
    /// </summary>
    private void HideAccessRequiredCtrls()
    {
        try
        {
            //this.Master.FindControl("hlnkQSearch").Visible = false;
            //this.Master.FindControl("hlnkAdvSearch").Visible = false;
    //        this.Master.FindControl("hlnkFileCab").Visible = false;
       //     this.Master.FindControl("hlnkHome").Visible = false;
            //this.Master.FindControl("tvMenu").Visible = false;

            //this.Master.FindControl("hlnkContact").Visible = false;
            //this.Master.FindControl("hlnkSupport").Visible = false;
            //this.Master.FindControl("hlnkHelp").Visible = false;
        }
        catch (Exception ex)
        {
            //lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// Authenticate User
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ctrlLogin_Authenticate(object sender, AuthenticateEventArgs e)
    {
        Int32 _rowCount = 0;
        
        try
        {
            String _userID = this.ctrlLogin.UserName;
            String _pwd = this.ctrlLogin.Password;
            String _SID = Session.SessionID;             
            Boolean _IsValidUser = false;

            String _userName = null;
            Int32 _empID = 0;
            Int32 _profileID = 0;
            
            //Get as NT User  ??
            //sNTUser = Request.ServerVariables("LOGON_USER")		
            //If (InStr(1, sNTUser ,"/", 1) > 0) Then sNTUser = Mid(sNTUser, InStr(1, sNTUser, "/", 1) + 1)
            //If (InStr(1, sNTUser ,"\", 1) > 0) Then sNTUser = Mid(sNTUser, InStr(1, sNTUser, "\", 1) + 1)
            ////vUser = SetUser(SessID, sNTUser, "NT_LOGIN", "NTA")
                      
            //Authenticate
            using (DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetQUserInfo(_userID, _pwd)))
            {
                _rowCount = _tempLogin.Rows.Count;
                if (_rowCount == 1)
                {
                    _IsValidUser = true;
                    _userName = _tempLogin.Rows[0]["User Name"].ToString();
                    _empID = Convert.ToInt32(_tempLogin.Rows[0]["EmpID"].ToString());
                    _profileID = Convert.ToInt32(_tempLogin.Rows[0]["ProfileID"].ToString());
                }
            }

            //Set Session Record
            if (_IsValidUser)
            {               
                Utils.DumpSessions(_SID, _userID);   
                  
                _rowCount = DataAccess.ModifyRecords(
                                DataQueries.InsertEWebSessions(_SID, _userID, _userName,
                                                               _empID, _profileID, DateTime.Now));
               
                if (_rowCount == 1)
                {
                    e.Authenticated = true;
                    Session["SID"] = _SID;
                    this.ctrlLogin.DestinationPageUrl = FormsAuthentication.DefaultUrl + "?SID=" + _SID;
                }
            }            
        }
        catch (Exception ex)
        {
            Response.Write(ex);
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }   
}
