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
using System.Collections.Generic;
using Microsoft.VisualBasic;
using OpenQA.Selenium.Remote;

public partial class DefaultOldMaster : System.Web.UI.MasterPage
{
    /// <summary>
    /// Master Page 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Init(object sender, EventArgs e)
    {
        try
        {
            //Check State and get user information
            if (Page.User.Identity.IsAuthenticated == true)
            {

                             
                    _SID = Request.QueryString["SID"];
                    if (String.IsNullOrEmpty(SID))
                    {
                        _SID = Request.Form["SID"];
                    }
                

                Dictionary<String, String> _dictonarySession = Utils.GetSessionItems(SID);
                if (_dictonarySession.Count > 0)
                {
                    _UserName = _dictonarySession["UserName"];
                    _UserID = _dictonarySession["UserID"];
                    _EmpID = Convert.ToInt32(_dictonarySession["EmpID"]);
                    _ProfileId = Convert.ToInt32(_dictonarySession["ProfileID"]);
                    Session["_ProfileId"] = _ProfileId;
                }
            }
            else
            {
                if (!String.IsNullOrEmpty(SID) && !String.IsNullOrEmpty(UserID))
                {
                    Utils.DumpSessions(SID, UserID);
                    Session.Abandon();
                    Response.Redirect("../Login.aspx");
                }

                

            }
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Log the messsage
        }
    }




    /// <summary>
    /// Master Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    
    {


       
        try
        {
            BindMenu();
            if (!IsPostBack)
            {
                
                //User Name
                if (!String.IsNullOrEmpty(_UserName))
                {
                    if (_UserName.IndexOf(',') > 0)
                    {
                        String _LastName = _UserName.Substring(0, _UserName.IndexOf(','));
                        String _FirstName = _UserName.Substring(_UserName.IndexOf(',') + 1);
                        this.lblUserName.Text = "Welcome " + _FirstName + " " + _LastName;
                        //ADDED BY TRAVIS 
                        // this.lblUserName0.Text = "Welcome " + _FirstName + " " + _LastName;
                    }
                    else
                    {
                        this.lblUserName.Text = "Welcome " + _UserName;
                        //added by tmc 4/4/2020 

                    }
                }

                using (DataTable _tempLogin = DataAccess.GetRecords(DataQueries.getPageIdByRoleId(_ProfileId)))
                {
                    Int32 _rowCount = 0;
                    _rowCount = _tempLogin.Rows.Count;
                    //for (int i = 0; i < _tempLogin.Rows.Count; i++)
                    //{
                    //    //Session["PageName"] = Convert.ToInt32(_tempLogin.Rows[i]["PageName"]);

                    //}
                    //if (_rowCount == 1)
                    //{
                    //    _IsValidUser = true;
                    //    _userName = _tempLogin.Rows[0]["User Name"].ToString();
                    //    _empID = Convert.ToInt32(_tempLogin.Rows[0]["EmpID"].ToString());
                    //    _profileID = Convert.ToInt32(_tempLogin.Rows[0]["ProfileID"].ToString());
                    //}
                }


                //use code above to allow username to load and show _Firstname + " " _Lastname: afer login 

                // going to replace "QSearch.aspx?SID=" + SID with "Default.aspx?SID=" + SID; *4/18/2020
                //     this.hlnkHome.NavigateUrl = "Default.master.aspx?SID=" + SID;
                //this.hlnkLogo.NavigateUrl = "Default.aspx?SID=" + SID;

                // this.imgLogo.ImageUrl = "~/App_Themes/mar_logo_320.gif";
                //  this.imgLogo.AlternateText = "Micropac Industries, Inc.®";

                this.hlnkQSearch.NavigateUrl = "QSearch.aspx?SID=" + SID;
                this.hlnkAdvSearch.NavigateUrl = "AdvanceSearch.aspx?SID=" + SID;
                //TMC COMMENTING OUT BELOW AS IS DEAD LINK WITH PLANS TO REMOVE 
                //     this.hlnkFileCab.NavigateUrl =  "FileCabinet.aspx?SID=" + SID;

                //changed this from the jgoresoftware shti to google
                //this.hlnkIntranet.NavigateUrl = "http://www.google.com";
                //  this.hlnkIntranet.NavigateUrl = "http://www.jgsoftwares.com";

                this.hlnkContact.NavigateUrl = "ContactInfo.aspx?SID=" + SID;
                this.hlnkSupport.NavigateUrl = "Support.aspx?SID=" + SID;
                this.hlnkHelp.NavigateUrl = "Help.aspx?SID=" + SID;
                BindMenu();

               // BindPageName();


            }
        }

        catch (Exception ex)
        {
            Response.Write(ex);
            //log       
        }
    }

    //public void BindPageName()
    //{
    //    DataTable _tempDispType = DataAccess.GetRecords(DataQueries.getPageIdByRoleId(_ProfileId));
    //    ddl_PageName.DataSource = _tempDispType;
    //    ddl_PageName.DataBind();
    //}
    public void BindMenu()
    {
        //DataTable _tempDispType = DataAccess.GetRecords(DataQueries.GetSideBarMainMenu(_ProfileId));

        //dlcategory.DataSource = _tempDispType;
        //dlcategory.DataBind();
    }

    //protected void dlcategory_ItemDataBound(object sender, DataListItemEventArgs e)
    //{

    //    int id = Convert.ToInt32(dlcategory.DataKeys[e.Item.ItemIndex].ToString());
    //    int Profile_ID = _ProfileId;
    //    DataTable _tempLogin = DataAccess.GetRecords(DataQueries.getpageByroleIdatalist(Profile_ID,id));

    //    DataList dlsubcat = (DataList)e.Item.FindControl("dlsubcategory");
    //    dlsubcat.DataSource = _tempLogin;
    //    dlsubcat.DataBind();
    //}


    //probably can delete this going alternate route 8/10
    //   protected void DropDownList1_SelectedIndexChange(object sender, EventArgs e)
    //{
    //    string sUrl = DropDownList1.SelectedItem.Text + ".aspx";
    //    Response.Redirect(sUrl);

    //}

    //added by tmc to make notes expand onclick
    private void tvMenu_NodeMouseClick(object sender, EventArgs e)
    {
        
        
    }


    public void PrintNodesRecursive(TreeNode oParentNode)
    {


        // Start recursion on all subnodes.
        foreach (TreeNode oSubNode in oParentNode.ChildNodes)
        {
            oSubNode.SelectAction = TreeNodeSelectAction.Expand;
            PrintNodesRecursive(oSubNode);
        }
    }

    #region Master Page Properties
    /// <summary>
    /// Read Only Property : SID
    /// </summary>
    private String _SID;
    public String SID
    {
        get
        {
            return _SID;
        }
    }

    /// <summary>
    /// Read Only Property : User Name
    /// </summary>
    private String _UserName;
    public String UserName
    {
        get
        {
            return _UserName;
        }
    }

    /// <summary>
    /// Read Only Property : User ID
    /// </summary>
    private String _UserID;
    public String UserID
    {
        get
        {
            return _UserID;
        }
    }
    private Int32 _ProfileId;
    public Int32 ProfileId
    {
        get
        {
            return _ProfileId;
        }
    }

    /// <summary>
    /// Read Only Property : Employee ID
    /// </summary>
    private Int32 _EmpID;
    public Int32 EmpID
    {
        get
        {
            return _EmpID;
        }
    }

    protected void Menu1_MenuItemClick(object sender, MenuEventArgs e)
    {

    }

}

#endregion






/* this is my attempt to get the search bar on aser to work 
protected void TextBox1_TextChanged(object sender, EventArgs e)
{
    this.hlnkQSearch.NavigateUrl = "QSearch.aspx?SID=" + SID;
}
}
*/
