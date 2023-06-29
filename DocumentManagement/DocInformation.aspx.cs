using System;
using System.Data;
using System.Configuration;
using System.Web.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Globalization;
using System.Xml.Linq;
using System.IdentityModel.Claims;

/// <summary>
/// Document Information Class
/// </summary>
public partial class DocumentManagement_DocInformation : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;

    private Boolean _IsEditAllow = true;
    public Boolean IsEditAllow
    {
        get { return _IsEditAllow; }
        set { _IsEditAllow = value; }
    }
    //public static (vSID, vUID, vPW);

    string bUserSet;
    public int nEmpID;
    public String sUName;
    public bool nProfileID;
    public String nMenu;
    public Double nRetCode;
    public String sSQL;
    //form prporties vaiables
    public bool txtstatus;

    //;get query for profile id x  and set properties 
    //        txtstatus = true



    //Dim nEmpID
    //Dim sUName
    //Dim nProfileID
    //Dim nMenu
    //Dim nRetCode
    //Dim sSQL

    /// <summary>
    /// Page Load Event
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    /// 
    public static Boolean IsAdmin(String SessionID)
    {
        Int32 _ProfileID = 0;
        String Query = DataQueries.GetEWebSessions(SessionID);

        Int32 _rowCount = 0;
        using (DataTable _tempAdmin = DataAccess.GetRecords(Query))
        {
            _rowCount = _tempAdmin.Rows.Count;

            if (_rowCount > 0)
            {
                if (!String.IsNullOrEmpty(_tempAdmin.Rows[0]["ProfileID"].ToString()))
                {
                    _ProfileID = Convert.ToInt32(_tempAdmin.Rows[0]["ProfileID"].ToString());
                }
            }
        }

        if (_ProfileID == 1)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {

        this.lblStatus.Text = null;
        String DocumentID = null;

        string name = btnNew.Text;


        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;


            if (Utils.IsAdmin(_SID))
            {
                txtStatus.Visible = txtstatus;
                txtStatus.EnableViewState = txtstatus;
                txtStatus.Enabled = txtstatus;


                btnFind.Visible = true;
                btnFindNew.Visible = false;
                btnFind.EnableViewState = false;
            }

            if (nProfileID)
            {
                btnDelete.Visible = false;

            }
            //Get Document ID
            if (Request.QueryString["DOCID"] != null)
            {
                DocumentID = Request.QueryString["DOCID"];
            }

            if (!IsPostBack)
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);

                if (!String.IsNullOrEmpty(DocumentID))
                {
                    if (GetRecord(DocumentID) > 0)
                    {
                        this.btnFind.AlternateText = "Find New Document";
                        this.btnEdit.Text = "Edit";
                        this.btnNew.Visible = false;
                        this.btnEdit.Visible = true;

                        this.btnCancel.Visible = false;
                        this.btnDelete.Visible = true;

                        GetGrids(DocumentID);
                        SetLinkURLs(DocumentID);
                    }
                    else // if No Records found
                    {
                        //this.txtDocID.CssClass = "CtrlShortValueEdit";
                        this.txtDocID.ReadOnly = false;
                        this.txtDocID.Focus();
                    }

                }
                else //if DocID is null
                {
                    //this.txtDocID.CssClass = "CtrlShortValueEdit";
                    this.txtDocID.ReadOnly = false;
                    this.txtDocID.Focus();
                }

                CheckDropdownVisible();
                CheckdropsdownView();
                EnabledDropsDown();
                CheckFields();
            }

        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage            
        }
    }

    /// <summary>
    /// Set all Navigation URLs
    /// </summary>
    private void SetLinkURLs(String DocumentId)
    {
        //hlnkAttachFiles.NavigateUrl = "~/DocumentManagement/AttachFiles.aspx?SID=" + _SID + "&DOCID=" + DocumentId;
        //hlnkAddParts.NavigateUrl = "~/DocumentManagement/AddParts.aspx?SID=" + _SID + "&DOCID=" + DocumentId;
        //hlnkDocHistory.NavigateUrl = "~/DocumentManagement/AssociateOrders.aspx?SID=" + _SID + "&DOCID=" + DocumentId;
        //hlnkControlLists.NavigateUrl = "~/DocumentManagement/ControlLists.aspx?SID=" + _SID + "&DOCID=" + DocumentId;
        //hlnkRestrictions.NavigateUrl = "~/DocumentManagement/Restrictions.aspx?SID=" + _SID + "&DOCID=" + DocumentId;
        //hlnkNotes.NavigateUrl = "~/DocumentManagement/AddNotes.aspx?SID=" + _SID + "&DOCID=" + DocumentId;
        //hlnkWFTasks.NavigateUrl = "~/WorkFlowManagement/WFAssignment.aspx?SID=" + _SID + "&RFTP=DOC&RFID=" + DocumentId;
        //hlnkWFCustom.NavigateUrl = "~/Common/Custom.aspx?SID=" + _SID + "&DOCID=" + DocumentId;

        //hlnkViewDocument.NavigateUrl = "../Legacy/secweb/ret_selitem.asp?SID=" + _SID + "&Listing=Doc&Item=" + DocumentId;
        //hlnkPrintableFormate.NavigateUrl = "../Legacy/secweb/ret_selitem.asp?SID=" + _SID + "&Listing=Doc&Item=" + DocumentId + "&Opt=0100";

        //hlnkPrintableDocument.NavigateUrl = "../Legacy/secweb/pnt_chgreq.asp?SID=" + _SID + "&Listing=Doc&Item=" + DocumentId;
        //hlnkPrintableWaiver.NavigateUrl = "../Legacy/secweb/pnt_dev.asp?SID=" + _SID + "&Listing=Doc&Item=" + DocumentId;
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
            //Cancel On Selecting a New Document ID 
            if (this.btnFind.AlternateText == "Find" && (this.btnNew.Text == "New Document"))
            {
                InitializeFormFields();
                InitializeGrids();

                SetForm(FORM_ON.View);
                //this.txtDocID.CssClass = "CtrlShortValueEdit";
                this.txtDocID.ReadOnly = false;
                this.txtDocID.Focus();

                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.Visible = true;
                //this.btnNewEditSave.Visible = true;
                this.btnNew.Visible = true;
                this.btnEdit.Visible = false;
                this.gvNumSchemes.Visible = true;
                
                this.ddlDocType.AutoPostBack = false;
                this.ddlDiscipline.AutoPostBack = false;
            }

            if(this.btnNew.Text == "Save" && this.btnFind.AlternateText == "Find")
            {
                InitializeFormFields();
                InitializeGrids();

                SetForm(FORM_ON.View);
                //this.txtDocID.CssClass = "CtrlShortValueEdit";
                this.txtDocID.ReadOnly = false;
                this.txtDocID.Focus();
                this.ddlNumSchemes.Visible = false;
                this.txtNumSchemes.Visible = true;
                this.txtNumSchemes.Text = "";
                this.txtNumSchemes.ReadOnly = true;

                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.Visible = true;
                this.btnEdit.Visible = false;
                this.btnNew.Visible = true;
                this.btnNew.Text = "New Document";
            }

            //Cancel on Edited Existing Document before Saving
            if ((this.btnFind.AlternateText == "Find New Document")
                && (this.btnNew.Text == "Save" || this.btnEdit.Text == "Update"))
            {
                String DocumentID = this.txtDocID.Text;

                //Check for Cancel from Edited Document OR New Document.
                if (GetRecord(DocumentID) > 0)
                {
                    GetGrids(DocumentID);
                    SetLinkURLs(DocumentID);

                    SetForm(FORM_ON.View);
                    this.btnEdit.Text = "Edit";
                    this.btnNew.Visible = false;
                    this.btnEdit.Visible = true;

                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;
                }
                else
                {
                    InitializeFormFields();
                    InitializeGrids();

                    SetForm(FORM_ON.View);
                    SetNewItemFilter(FORM_ON.Edit);

                    this.ddlDocType.AutoPostBack = true;
                    this.ddlDiscipline.AutoPostBack = true;

                    this.btnCancel.Visible = true;
                    this.btnDelete.Visible = false;
                    //this.btnNewEditSave.Visible = false;
                    this.btnNew.Visible = false;
                    this.btnEdit.Visible = false;


                    this.btnFind.Visible = false;

                    this.btnFind.AlternateText = "Find";
                    this.btnNew.Text = "New Document";
                    GetNumSchemes(null, null);
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
            String DocumentID = this.txtDocID.Text;

            //Find Document
            if (this.btnFind.AlternateText == "Find")
            {
                //Doc Record               
                if (GetRecord(DocumentID) > 0)
                {
                    SetForm(FORM_ON.View);
                    this.btnFind.AlternateText = "Find New Document";
                    this.btnEdit.Text = "Edit";
                    this.btnNew.Visible = false;
                    this.btnEdit.Visible = true;

                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;

                    GetGrids(DocumentID);
                    SetLinkURLs(DocumentID);
                    btnFindNew.Visible = true;
                    this.btnFind.Visible = false;
                }
                else
                {
                    InitializeFormFields();
                    InitializeGrids();

                    SetForm(FORM_ON.View);
                    //this.txtDocID.CssClass = "CtrlShortValueEdit";
                    this.txtDocID.ReadOnly = false;
                    this.txtDocID.Focus();

                    lblStatus.Text = "A Document " + DocumentID + " could not be located or created..";
                }
            }
            else if (this.btnFind.AlternateText == "Find New Document")
            {
                InitializeFormFields();
                InitializeGrids();

                SetForm(FORM_ON.View);
                //  this.txtDocID.CssClass = "CtrlShortValueEdit";
                this.txtDocID.ReadOnly = false;
                this.txtDocID.Focus();

                this.btnFind.AlternateText = "Find";
                this.btnNew.Text = "New Document";
                this.btnNew.Visible = true;
                this.btnEdit.Visible = false;
                this.btnCancel.Visible = true;
                this.btnDelete.Visible = false;
                btnFindNew.Visible = false;
                this.btnFind.Visible = true;
                this.btnFind.PostBackUrl = "DocInformation.aspx?SID=" + _SID + "&DOCID=";
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }
    protected void btnFindNew_Click(object sender, EventArgs e)
    {
        try
        {
            String DocumentID = this.txtDocID.Text;
            InitializeFormFields();
            InitializeGrids();

            SetForm(FORM_ON.View);
            //  this.txtDocID.CssClass = "CtrlShortValueEdit";
            this.txtDocID.ReadOnly = false;
            this.txtDocID.Focus();

            this.btnFind.AlternateText = "Find";
            this.btnNew.Text = "New Document";
            this.btnNew.Visible = true;
            this.btnEdit.Visible = false;

            this.btnCancel.Visible = false;
            this.btnDelete.Visible = false;
            this.btnFind.PostBackUrl = "DocInformation.aspx?SID=" + _SID + "&DOCID=";
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
    //protected void btnNewEditSave_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        if (this.btnNewEditSave.Text == "New Document")
    //        {
    //            InitializeFormFields();
    //            InitializeGrids();

    //            SetForm(FORM_ON.View);
    //            SetNewItemFilter(FORM_ON.Edit);

    //            this.ddlDocType.AutoPostBack = true;
    //            this.ddlDiscipline.AutoPostBack = true;

    //            this.btnCancel.Visible = true;
    //            this.btnDelete.Visible = false;
    //            this.btnNewEditSave.Visible = false;
    //            this.btnFind.Visible = false;

    //            GetNumSchemes(null, null);
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
    //            String DocumetID = this.txtDocID.Text;
    //            if (String.IsNullOrEmpty(DocumetID))
    //            {
    //                throw new Exception("The [Document Number] does not appear to be valid. The record will not be saved.");
    //            }

    //            String CurrentRevision = null;
    //            if (!String.IsNullOrEmpty(this.txtRevision.Text))
    //            {
    //                CurrentRevision = this.txtRevision.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "CurrentRev"))
    //                {
    //                    throw new Exception("A [Revision] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String DocStatus = null;
    //            if (this.ddlStatus.SelectedItem.Text != "-NONE-")
    //            {
    //                DocStatus = this.ddlStatus.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocStatus"))
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
    //                if (Utils.IsRequiredField("Documents", "DocDesc"))
    //                {
    //                    throw new Exception("A [Description] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String Discipline = null;
    //            if (this.ddlDiscipline.SelectedItem.Text != "-NONE-")
    //            {
    //                Discipline = this.ddlDiscipline.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "Discipline"))
    //                {
    //                    throw new Exception("A [Discipline] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String DocType = null;
    //            if (this.ddlDocType.SelectedItem.Text != "-NONE-")
    //            {
    //                DocType = this.ddlDocType.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocType"))
    //                {
    //                    throw new Exception("A [Document Type] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String IsTabulated;
    //            if (this.cbTabulated.Checked)
    //            {
    //                IsTabulated = "0";
    //            }
    //            else
    //            {
    //                IsTabulated = "-1";
    //            }

    //            String Project = null;
    //            if (this.ddlProject.SelectedItem.Text != "-NONE-")
    //            {
    //                Project = this.ddlProject.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "ProjNum"))
    //                {
    //                    throw new Exception("A [Project] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String DocRequestedBy = null;
    //            if (this.ddlRequestedBy.SelectedItem.Text != "-NONE-")
    //            {
    //                DocRequestedBy = this.ddlRequestedBy.SelectedItem.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocReqBy"))
    //                {
    //                    throw new Exception("The person [Requested By] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime DocRequestedDate = DateTime.Now;
    //            if (!String.IsNullOrEmpty(this.ucDateRequestedBy.SelectedDate) &&
    //                !String.IsNullOrEmpty(DocRequestedBy) && DocRequestedBy != "-NONE-")
    //            {
    //                DocRequestedDate = Convert.ToDateTime(this.ucDateRequestedBy.SelectedDate);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocReqDate"))
    //                {
    //                    throw new Exception("A [Request Date] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String DocCreatedBy = null;
    //            if (this.ddlCreatedBy.SelectedItem.Text != "-NONE-")
    //            {
    //                DocCreatedBy = this.ddlCreatedBy.SelectedItem.Text;
    //            }
    //            //else
    //            //{
    //            //    throw new Exception("The person [Created By] could not be located or created. The record will not be saved.");
    //            //}

    //            DateTime DocCreatedDate;
    //            if (!String.IsNullOrEmpty(this.ucDateCreatedBy.SelectedDate) &&
    //                !String.IsNullOrEmpty(DocCreatedBy) && DocCreatedBy != "-NONE-")
    //            {
    //                DocCreatedDate = Convert.ToDateTime(this.ucDateCreatedBy.SelectedDate);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocCreatedDate"))
    //                {
    //                    throw new Exception("A [Created Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    DocCreatedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            String DocReviewedBy = null;
    //            if (this.ddlReviewedBy.SelectedItem.Text != "-NONE-")
    //            {
    //                DocReviewedBy = this.ddlReviewedBy.SelectedItem.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocReviewBy"))
    //                {
    //                    throw new Exception("The person [Reviewed By] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime DocReviewedDate;
    //            if (!String.IsNullOrEmpty(this.ucDateReviewedBy.SelectedDate) &&
    //                !String.IsNullOrEmpty(DocReviewedBy) && DocReviewedBy != "-NONE-")
    //            {
    //                DocReviewedDate = Convert.ToDateTime(this.ucDateReviewedBy.SelectedDate);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocReviewDate"))
    //                {
    //                    throw new Exception("A [Review Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    DocReviewedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            String DocReleasedBy = null;
    //            if (this.ddlReleasedBy.SelectedItem.Text != "-NONE-")
    //            {
    //                DocReleasedBy = this.ddlReleasedBy.SelectedItem.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocRelRef"))
    //                {
    //                    throw new Exception("The person [Released By] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime DocReleasedDate;
    //            if (!String.IsNullOrEmpty(this.ucDateReleasedBy.SelectedDate) &&
    //                !String.IsNullOrEmpty(DocReleasedBy) && DocReleasedBy != "-NONE-")
    //            {
    //                DocReleasedDate = Convert.ToDateTime(this.ucDateReleasedBy.SelectedDate);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocRelDate"))
    //                {
    //                    throw new Exception("A [Release Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    DocReleasedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            String DocObsoletedBy = null;
    //            if (this.ddlObsoletedBy.SelectedItem.Text != "-NONE-")
    //            {
    //                DocObsoletedBy = this.ddlObsoletedBy.SelectedItem.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocObsRef"))
    //                {
    //                    throw new Exception("The person [Obsoleted By] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime DocObsoletedDate;
    //            if (!String.IsNullOrEmpty(this.ucDateObsoletedBy.SelectedDate) &&
    //                !String.IsNullOrEmpty(DocObsoletedBy) && DocObsoletedBy != "-NONE-")
    //            {
    //                DocObsoletedDate = Convert.ToDateTime(this.ucDateObsoletedBy.SelectedDate);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocObsDate"))
    //                {
    //                    throw new Exception("An [Obsolete Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    DocObsoletedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            DateTime ExpDate;
    //            if (!String.IsNullOrEmpty(this.ucDateExpiry.SelectedDate))
    //            {
    //                ExpDate = Convert.ToDateTime(this.ucDateExpiry.SelectedDate);
    //                //ExpDate = DateTime.ParseExact(this.ucDateExpiry.SelectedDate, "MM-dd-yyyy", CultureInfo.InvariantCulture); 
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Documents", "DocExpDate"))
    //                {
    //                    throw new Exception("An [Expiration Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    ExpDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            String LastModifiedBy = _SessionUser;
    //            DateTime LastModifiedDate = DateTime.Now;

    //            if (this.btnNewEditSave.Text == "Update")
    //            {
    //                DataAccess.ModifyRecords(DataQueries.UpdateDocumentByID(DocumetID, DocStatus, CurrentRevision, Description, Discipline,
    //                                                                         DocType, IsTabulated, Project, DocRequestedBy, DocRequestedDate,
    //                                                                         DocCreatedBy, DocCreatedDate, DocReviewedBy, DocReviewedDate,
    //                                                                         DocReleasedBy, DocReleasedDate, DocObsoletedBy, DocObsoletedDate,
    //                                                                         ExpDate, LastModifiedBy, LastModifiedDate));
    //            }

    //            if (this.btnNewEditSave.Text == "Save")
    //            {
    //                DataAccess.ModifyRecords(DataQueries.InsertDocument(DocumetID, DocStatus, CurrentRevision, Description, Discipline,
    //                                                                    DocType, IsTabulated, Project, DocRequestedBy, DocRequestedDate,
    //                                                                    DocCreatedBy, DocCreatedDate, DocReviewedBy, DocReviewedDate,
    //                                                                    DocReleasedBy, DocReleasedDate, DocObsoletedBy, DocObsoletedDate,
    //                                                                    ExpDate, LastModifiedBy, LastModifiedDate));
    //            }

    //            GetRecord(DocumetID);
    //            GetGrids(DocumetID);
    //            SetLinkURLs(DocumetID);

    //            SetForm(FORM_ON.View);
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

    /// <summary>
    /// Delete Documents and Associated Records
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        Boolean _DeleteRecordsPref = false;
        String _DeletePreference = this.Request.Form["hdnDeleteUserPref"];
        if (!String.IsNullOrEmpty(_DeletePreference))
        {
            _DeleteRecordsPref = Convert.ToBoolean(_DeletePreference);
        }

        String DocumentID = this.txtDocID.Text;

        if (_DeleteRecordsPref)
        {
            DataAccess.ModifyRecords(DataQueries.DeleteDocFiles(DocumentID));
            DataAccess.ModifyRecords(DataQueries.DeletePartsXRefByID(DocumentID));
            DataAccess.ModifyRecords(DataQueries.DeleteControlListRefs(Constants.DocReferenceType, DocumentID));
            DataAccess.ModifyRecords(DataQueries.DeleteResNoticeRefs(Constants.DocReferenceType, DocumentID));
            DataAccess.ModifyRecords(DataQueries.DeleteNotesByRefIDType(DocumentID, Constants.DocReferenceType));
            DataAccess.ModifyRecords(DataQueries.DeleteDocumentsByID(DocumentID));

            InitializeFormFields();
            InitializeGrids();

            SetForm(FORM_ON.View);
            //this.txtDocID.CssClass = "CtrlShortValueEdit";
            this.txtDocID.ReadOnly = false;
            this.txtDocID.Focus();

            this.btnFind.AlternateText = "Find";
            this.btnNew.Text = "New Document";
            this.btnNew.Visible = true;
            this.btnEdit.Visible = false;
            this.btnCancel.Visible = false;
            this.btnDelete.Visible = false;
            this.btnFind.PostBackUrl = "DocInformation.aspx?SID=" + _SID + "&DOCID=";

            this.lblStatus.Text = "Success ! Document " + DocumentID + " and its associated records are deleted ";
        }
    }

    /// <summary>
    /// AutoPostBack for New Items Filter
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlDocType_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            gvNumSchemes_Filter();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage 
        }
    }

    /// <summary>
    /// AutoPostBack for New Items Filter
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlDiscipline_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            gvNumSchemes_Filter();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage 
        }
    }

    #region Number Scheme

    /// <summary>
    /// Filter Items in Num Schemes Gridview
    /// </summary>
    private void gvNumSchemes_Filter()
    {
        try
        {
            String _SelectedDocType = null;
            if (this.ddlDocType.SelectedItem.Text != "-NONE-")
            {
                _SelectedDocType = this.ddlDocType.SelectedItem.Value;
            }

            String _SelectedDiscipline = null;
            if (this.ddlDiscipline.SelectedItem.Text != "-NONE-")
            {
                _SelectedDiscipline = this.ddlDiscipline.SelectedItem.Value;
            }

            this.txtDocType.Text = this.ddlDocType.SelectedItem.Text;
            this.txtDiscipline.Text = this.ddlDiscipline.SelectedItem.Text;

            SetNewItemFilter(FORM_ON.Edit);
            GetNumSchemes(_SelectedDiscipline, _SelectedDocType);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage     
        }
    }

    /// <summary>
    /// Get New Items Filter
    /// </summary>
    /// <param name="Discipline"></param>
    /// <param name="DocType"></param>
    /// <returns></returns>
    private Int32 GetNumSchemes(String Discipline, String DocType)
    {
        Int32 _rowCount = 0;
        String SchemeDescType = WebConfigurationManager.AppSettings["Documents"];

        try
        {
            //this.gvNumSchemes.CssClass = "GridViewStyleView";
            //this.gvNumSchemes.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvNumSchemes.RowStyle.CssClass = "GridViewStyleView";
            //this.gvNumSchemes.FooterStyle.CssClass = "GridViewStyleView";   
            this.gvNumSchemes.AutoGenerateSelectButton = true;
            this.gvNumSchemes.EnableViewState = false;
            this.gvNumSchemes.Controls.Clear();

            using (DataTable _tempNumSchemes = DataAccess.GetRecords(DataQueries.GetQNumSchemes(Discipline, DocType, SchemeDescType)))
            {
                _rowCount = _tempNumSchemes.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvNumSchemes.DataSource = _tempNumSchemes;
                    this.gvNumSchemes.DataBind();

                    this.ddlNumSchemes.DataSource = _tempNumSchemes;
                    this.ddlNumSchemes.DataTextField = "Description_Format";
                    this.ddlNumSchemes.DataValueField = "ID_DocType_Discipline";
                    this.ddlNumSchemes.DataBind();

                    this.ddlNumSchemesPop.DataSource = _tempNumSchemes;
                    this.ddlNumSchemesPop.DataTextField = "Description_Format";
                    this.ddlNumSchemesPop.DataValueField = "ID_DocType_Discipline";
                    this.ddlNumSchemesPop.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = "GetNumSchemes :" + ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// NumSchemes Pagination
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvNumSchemes_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            this.gvNumSchemes_Filter();
            this.gvNumSchemes.PageIndex = e.NewPageIndex;
            this.gvNumSchemes.DataBind();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Number Schemes - Selection Index Changed
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvNumSchemes_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {
            Int32 _selectedRowIndex = e.NewSelectedIndex;
            this.gvNumSchemes_Filter();

            if (gvNumSchemes.Rows.Count < 1)
            {
                e.Cancel = true;
            }
            else
            {
                Int32 _SchemeID = Convert.ToInt32(gvNumSchemes.Rows[_selectedRowIndex].Cells[1].Text);
                String _DocTypeID = gvNumSchemes.Rows[_selectedRowIndex].Cells[4].Text;
                String _Discipline = gvNumSchemes.Rows[_selectedRowIndex].Cells[5].Text;

                this.txtDocID.Text = Utils.GetNewID(_SchemeID, "Documents", null);

                SetForm(FORM_ON.Edit);
                gvNumSchemes.Visible = false;
                this.btnFind.Visible = true;
                this.ddlDocType.AutoPostBack = false;
                this.ddlDiscipline.AutoPostBack = false;
                this.btnNew.Text = "Save";
                this.btnNew.Visible = true;
                this.btnEdit.Visible = false;

                this.btnFind.AlternateText = "Find New Document";

                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlStatus.Items.FindByValue("REQ");
                this.ddlStatus.SelectedIndex = this.ddlStatus.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlDocType.Items.FindByValue(_DocTypeID);
                this.ddlDocType.SelectedIndex = this.ddlDocType.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlDiscipline.Items.FindByValue(_Discipline);
                this.ddlDiscipline.SelectedIndex = this.ddlDiscipline.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlRequestedBy.Items.FindByText(_SessionUser);
                this.ddlRequestedBy.SelectedIndex = this.ddlRequestedBy.Items.IndexOf(liSelectedItem);
                this.txtLastModifiedBy.Text = this.ddlRequestedBy.SelectedItem.ToString();
                this.ucDateRequestedBy.SelectedDate = DateTime.Now.ToShortDateString();
                this.txtDateLastModifiedBy.Text = DateTime.Now.ToShortDateString();
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Num Schemes Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvNumSchemes_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colSelectIndex = 0;
        Int32 _colDocTypeIndex = 4;
        Int32 _colDisciplineIndex = 5;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colDocTypeIndex].Visible = false;
            e.Row.Cells[_colDisciplineIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //Get Column Indexes
            DataRowView drvNSchemes = (DataRowView)e.Row.DataItem;
            Int32 _colIDIndex = drvNSchemes.DataView.Table.Columns["ID"].Ordinal + 1;
            Int32 _colDescriptionIndex = drvNSchemes.DataView.Table.Columns["Description"].Ordinal + 1;
            Int32 _colFormatIndex = drvNSchemes.DataView.Table.Columns["Format"].Ordinal + 1;

            //Align
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colDescriptionIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFormatIndex].HorizontalAlign = HorizontalAlign.Left;

            //Hide
            e.Row.Cells[_colDocTypeIndex].Visible = false;
            e.Row.Cells[_colDisciplineIndex].Visible = false;
        }
    }

    #endregion

    /// <summary>
    /// On Change - Selected By
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlCreatedBy_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtDateCreatedBy.Text = DateTime.Now.ToString();
    }

    /// <summary>
    /// On Change - Reviewed By
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlReviewedBy_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtDateReviewedBy.Text = DateTime.Now.ToString();
    }

    /// <summary>
    /// On Change - Obsoleted By
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlObsoletedBy_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtDateObsoletedBy.Text = DateTime.Now.ToString();
    }

    /// <summary>
    /// On Change - Released By
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
    /// <param name="DOCID"></param>
    /// <returns></returns>
    private Int32 GetRecord(String DocID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewDocs = DataAccess.GetRecords(DataQueries.GetViewDocsByID(DocID)))
            {
                _rowCount = _tempViewDocs.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtDocID.Text = _tempViewDocs.Rows[0]["Document ID"].ToString();
                    this.txtStatus.Text = _tempViewDocs.Rows[0]["Status"].ToString();
                    this.txtDocType.Text = _tempViewDocs.Rows[0]["Document Type"].ToString();

                    String _ExpiryDate = _tempViewDocs.Rows[0]["Doc Expiry Date"].ToString();
                    if (!String.IsNullOrEmpty(_ExpiryDate) && Constants.DateTimeMinimum != _ExpiryDate)
                    {
                        this.txtExpiryDate.Text = Convert.ToDateTime(_ExpiryDate).ToShortDateString();
                    }

                    this.txtRevision.Text = _tempViewDocs.Rows[0]["Current Revision"].ToString();
                    this.txtDiscipline.Text = _tempViewDocs.Rows[0]["Discipline Description"].ToString();
                    this.txtProject.Text = _tempViewDocs.Rows[0]["Project Description"].ToString();
                    this.txtDescription.Text = _tempViewDocs.Rows[0]["Document Description"].ToString();

                    this.txtRequestedBy.Text = _tempViewDocs.Rows[0]["Requested By"].ToString();
                    this.txtCreatedBy.Text = _tempViewDocs.Rows[0]["Created By"].ToString();
                    this.txtReviewedBy.Text = _tempViewDocs.Rows[0]["Reviewed By"].ToString();
                    this.txtObsoletedBy.Text = _tempViewDocs.Rows[0]["Obsoleted By"].ToString();
                    this.txtReleasedBy.Text = _tempViewDocs.Rows[0]["Released By"].ToString();
                    this.txtLastModifiedBy.Text = _tempViewDocs.Rows[0]["Last Modified By"].ToString();

                    String _DateRequestedBy = _tempViewDocs.Rows[0]["Doc Requested Date"].ToString();
                    if (!String.IsNullOrEmpty(_DateRequestedBy) && Constants.DateTimeMinimum != _DateRequestedBy)
                    {
                        this.txtDateRequestedBy.Text = Convert.ToDateTime(_DateRequestedBy).ToShortDateString();
                    }

                    String _DateCreatedBy = _tempViewDocs.Rows[0]["Doc Created Date"].ToString();
                    if (!String.IsNullOrEmpty(_DateCreatedBy) && Constants.DateTimeMinimum != _DateCreatedBy)
                    {
                        this.txtDateCreatedBy.Text = Convert.ToDateTime(_DateCreatedBy).ToShortDateString();
                    }

                    String _DateReviewedBy = _tempViewDocs.Rows[0]["Doc Reviewed Date"].ToString();
                    if (!String.IsNullOrEmpty(_DateReviewedBy) && Constants.DateTimeMinimum != _DateReviewedBy)
                    {
                        this.txtDateReviewedBy.Text = Convert.ToDateTime(_DateReviewedBy).ToShortDateString();
                    }

                    String _DateObsoletedBy = _tempViewDocs.Rows[0]["Doc Obsoleted Date"].ToString();
                    if (!String.IsNullOrEmpty(_DateObsoletedBy) && Constants.DateTimeMinimum != _DateObsoletedBy)
                    {
                        this.txtDateObsoletedBy.Text = Convert.ToDateTime(_DateObsoletedBy).ToShortDateString();
                    }

                    String _DateReleasedBy = _tempViewDocs.Rows[0]["Doc Released Date"].ToString();
                    if (!String.IsNullOrEmpty(_DateReleasedBy) && Constants.DateTimeMinimum != _DateReleasedBy)
                    {
                        this.txtDateReleasedBy.Text = Convert.ToDateTime(_DateReleasedBy).ToShortDateString();
                    }

                    this.txtDateLastModifiedBy.Text = _tempViewDocs.Rows[0]["Last Modified Date"].ToString();
                }
            }
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }

        return _rowCount;
    }

    #region Attach Files

    /// <summary>
    /// Get Attached Files
    /// </summary>
    /// <param name="DOCID"></param>
    /// <returns></returns>
    private Int32 GetAttachedFiles(String DOCID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvAttachedFiles.CssClass = "GridViewStyleView";
            //this.gvAttachedFiles.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvAttachedFiles.RowStyle.CssClass = "GridViewStyleView";

            //this.gvAttachedFiles.AutoGenerateDeleteButton = true; 
            this.gvAttachedFiles.AutoGenerateSelectButton = true;
            this.gvAttachedFiles.EnableViewState = false;
            this.gvAttachedFiles.Controls.Clear();

            using (DataTable _tempAttachFiles = DataAccess.GetRecords(DataQueries.GetViewDocFilesByID(DOCID)))
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
            //lblStatus.Text = "GetAttachedFiles :" + ex.Message; //Log the messsage    
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
        String DocumentID = this.txtDocID.Text;
        GetAttachedFiles(DocumentID);

        if (gvAttachedFiles.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _FileID = Convert.ToInt32(gvAttachedFiles.Rows[e.RowIndex].Cells[1].Text);
            Int32 _StatusCheck = DataAccess.ModifyRecords(DataQueries.DeleteDocFilesByID(_FileID));
            if (_StatusCheck > 0)
            {
                this.lblStatus.Text = "Success ! File was detached";
            }
        }

        GetGrids(DocumentID);
    }

    /// <summary>
    /// Files Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAttachedFiles_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //Hide ID Column
        Int32 _colSelectIndex = 0;
        Int32 _colIDIndex = 1;

        //QuickFix
        Int32 _colFLinkIndex = 8;
        Int32 _colFLocationIndex = 7;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colIDIndex].Visible = false;

            //QuickFix 
            e.Row.Cells[_colFLinkIndex].Visible = false;
            e.Row.Cells[_colFLocationIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colIDIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvAttachedFiles = (DataRowView)e.Row.DataItem;
            Int32 _colFIDIndex = drvAttachedFiles.DataView.Table.Columns["File ID"].Ordinal + 1;
            Int32 _colFNameIndex = drvAttachedFiles.DataView.Table.Columns["File Name"].Ordinal + 1;
            Int32 _colStatusIndex = drvAttachedFiles.DataView.Table.Columns["Status"].Ordinal + 1;
            Int32 _colFDescIndex = drvAttachedFiles.DataView.Table.Columns["Description"].Ordinal + 1;
            Int32 _colFTypeIndex = drvAttachedFiles.DataView.Table.Columns["Type"].Ordinal + 1;
            //Int32 _colFLocationIndex = drvAttachedFiles.DataView.Table.Columns["Location"].Ordinal + 1;

            //e.Row.Cells[_colFLocationIndex].Visible = false;
            //QuickFix 
            //Int32 _colFLinkIndex = drvAttachedFiles.DataView.Table.Columns["Link"].Ordinal + 1;

            Int32 _colFCreatedByIndex = drvAttachedFiles.DataView.Table.Columns["Created By"].Ordinal + 1;
            Int32 _colFDateIndex = drvAttachedFiles.DataView.Table.Columns["Date Created"].Ordinal + 1;

            String FID = e.Row.Cells[_colFIDIndex].Text;

            using (LinkButton lbSelect = (LinkButton)e.Row.Cells[_colSelectIndex].Controls[0])
            {
                lbSelect.Text = "<img height=15 width=15 border=0 src=../App_Themes/eye.png />";
                lbSelect.Attributes.Add("OnClick", "Javascript:location.href = '/DocumentManagement/AttachFiles.aspx?SID=&DOCID=" + this.txtDocID.Text + "&FID=" + FID + "'");
                lbSelect.Attributes.Add("href", "#");
            }

            //Format     
            String _FDate = e.Row.Cells[_colFDateIndex].Text;
            if (!String.IsNullOrEmpty(_FDate) && _FDate != "&nbsp;")
            {
                e.Row.Cells[_colFDateIndex].Text = Convert.ToDateTime(_FDate).ToShortDateString();
            }

            //Set Link  
            String _fileLink = e.Row.Cells[_colFLinkIndex].Text;
            String param = "DocumentPreview.aspx?file=" + _fileLink;

            String _strMessage = Utils.GetDocumentRestrictionText(this.txtDocID.Text, Constants.DocReferenceType);
            //if (!String.IsNullOrEmpty(_strMessage))
            //{
            //    e.Row.Cells[_colFTypeIndex].Attributes.Add("OnClick", "Javascript:alert('" + _strMessage + "')");
            //}
            //e.Row.Cells[_colFTypeIndex].Text = "<a href='" +
            //                                     _fileLink +
            //                                    "' target='_blank'>" +
            //                                    e.Row.Cells[_colFTypeIndex].Text +
            //                                    "</a>";
            e.Row.Cells[_colFTypeIndex].Text = "<a href='" +
                                     param +
                                    "' target='_blank'>" +
                                     _fileLink +
                                    "</a>";

            //Align    
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colFIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colFNameIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFDescIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFLocationIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFLinkIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFCreatedByIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFDateIndex].HorizontalAlign = HorizontalAlign.Center;

            //Quick Fix
            e.Row.Cells[_colFLocationIndex].Text = e.Row.Cells[_colFLocationIndex].Text.Replace(@"\", @" \");
            //e.Row.Cells[_colFLinkIndex].Text = e.Row.Cells[_colFLinkIndex].Text.Replace("/", @" \");
            e.Row.Cells[_colFLinkIndex].Visible = false;
            e.Row.Cells[_colFLocationIndex].Visible = false;
        }
    }

    #endregion

    #region Add Parts
    /// <summary>
    /// Get Added Parts
    /// </summary>
    /// <param name="DOCID"></param>
    /// <returns></returns>
    private Int32 GetAddParts(String DOCID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvAddParts.CssClass = "GridViewStyleView";
            //this.gvAddParts.HeaderStyle.CssClass = "GridViewStyleView";            
            //this.gvAddParts.RowStyle.CssClass = "GridViewStyleView";
            this.gvAddParts.AutoGenerateSelectButton = true;
            this.gvAddParts.AutoGenerateDeleteButton = true;
            this.gvAddParts.EnableViewState = false;
            this.gvAddParts.Controls.Clear();

            using (DataTable _tempAddParts = DataAccess.GetRecords(DataQueries.GetViewParts(DOCID)))
            {
                _rowCount = _tempAddParts.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvAddParts.DataSource = _tempAddParts;
                    this.gvAddParts.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            //lblStatus.Text = "GetAddParts :" + ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Parts Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAddParts_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        String DocumentID = this.txtDocID.Text;
        GetAddParts(DocumentID);

        if (gvAddParts.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _PartID = Convert.ToInt32(gvAddParts.Rows[e.RowIndex].Cells[1].Text);
            Int32 _StatusCheck = DataAccess.ModifyRecords(DataQueries.DeletePartsXRefByID(_PartID));
            if (_StatusCheck > 0)
            {
                this.lblStatus.Text = "Success ! Part was Removed";
            }
        }

        GetGrids(DocumentID);
    }

    /// <summary>
    /// Parts Row Select
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAddParts_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        String DocumentID = this.txtDocID.Text;
        GetAddParts(DocumentID);
        String _PartID = gvAddParts.Rows[e.NewSelectedIndex].Cells[1].Text;
        String _PartNumber = gvAddParts.Rows[e.NewSelectedIndex].Cells[2].Text;
        Server.Transfer("~/DocumentManagement/AddParts.aspx?SID=" + _SID + "&DOCID=" + DocumentID
                                                        + "&PID=" + _PartID + "&PNR=" + _PartNumber);
    }

    /// <summary>
    /// Parts Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAddParts_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colDeleteIndex = 0;
        Int32 _ctrlDeleteIndex = 0;
        Int32 _colSelectIndex = 0;
        Int32 _ctrlSelectIndex = 2;

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //Get Column Indexes
            DataRowView drvAParts = (DataRowView)e.Row.DataItem;
            Int32 _colPartIDIndex = drvAParts.DataView.Table.Columns["Part ID"].Ordinal + 1;
            Int32 _colPNumberIndex = drvAParts.DataView.Table.Columns["Part Number"].Ordinal + 1;
            Int32 _colCRevIndex = drvAParts.DataView.Table.Columns["Current Revision"].Ordinal + 1;
            Int32 _colDescriptionIndex = drvAParts.DataView.Table.Columns["Description"].Ordinal + 1;
            Int32 _colStatusIndex = drvAParts.DataView.Table.Columns["Status"].Ordinal + 1;
            Int32 _colRTypeIndex = drvAParts.DataView.Table.Columns["Revision Type"].Ordinal + 1;
            Int32 _colEffDateIndex = drvAParts.DataView.Table.Columns["Effective Date"].Ordinal + 1;
            Int32 _colFAIIndex = drvAParts.DataView.Table.Columns["FAI"].Ordinal + 1;
            Int32 _colFAIDateIndex = drvAParts.DataView.Table.Columns["FAI Date"].Ordinal + 1;

            //Delete Button
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[_ctrlDeleteIndex])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Select Button
            using (LinkButton lbSelect = (LinkButton)e.Row.Cells[_colSelectIndex].Controls[_ctrlSelectIndex])
            {
                lbSelect.Text = "<img height=15 width=15 border=0 src=../App_Themes/find.gif />";
            }

            //Format     
            String _EffDate = e.Row.Cells[_colEffDateIndex].Text;
            if (!String.IsNullOrEmpty(_EffDate))
            {
                e.Row.Cells[_colEffDateIndex].Text = Convert.ToDateTime(_EffDate).ToShortDateString();
            }

            String _FAIDate = e.Row.Cells[_colFAIDateIndex].Text;
            if (!String.IsNullOrEmpty(_FAIDate))
            {
                e.Row.Cells[_colFAIDateIndex].Text = Convert.ToDateTime(_FAIDate).ToShortDateString();
            }

            //Align
            e.Row.Cells[_colPartIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colPNumberIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colCRevIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colDescriptionIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colRTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colEffDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colFAIIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colFAIDateIndex].HorizontalAlign = HorizontalAlign.Center;
        }
    }

    #endregion

    #region Notes

    /// <summary>
    /// Get Notes
    /// </summary>
    /// <param name="DOCID"></param>
    /// <returns></returns>
    private Int32 GetAddedNotes(String DOCID)
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

            using (DataTable _tempAddedNotes = DataAccess.GetRecords(DataQueries.GetViewNotesByTypeAndID(Constants.DocReferenceType, DOCID)))
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
            lblStatus.Text = "GetAddedNotes :" + ex.Message; //Log the messsage    
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
        String DocumentID = this.txtDocID.Text;
        GetAddedNotes(DocumentID);

        if (gvNotes.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _NoteID = Convert.ToInt32(gvNotes.Rows[e.RowIndex].Cells[1].Text);
            Int32 _StatusCheck = DataAccess.ModifyRecords(DataQueries.DeleteNotesByIDType(_NoteID, Constants.DocReferenceType));
            if (_StatusCheck > 0)
            {
                this.lblStatus.Text = "Success ! Note was removed";
            }
        }

        GetGrids(DocumentID);
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
            String _DateNote = e.Row.Cells[_colDateIndex].Text;
            if (!String.IsNullOrEmpty(_DateNote))
            {
                e.Row.Cells[_colDateIndex].Text = Convert.ToDateTime(_DateNote).ToShortDateString();
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

    #endregion

    #region Doc History

    /// <summary>
    /// Get History
    /// </summary>
    /// <param name="DOCID"></param>
    /// <returns></returns>
    private Int32 GetDocHistory(String DOCID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvDocHistory.CssClass = "GridViewStyleView"; 
            //this.gvDocHistory.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvDocHistory.RowStyle.CssClass = "GridViewStyleView";           
            this.gvDocHistory.EnableViewState = false;
            this.gvDocHistory.Controls.Clear();

            using (DataTable _tempDocHistory = DataAccess.GetRecords(DataQueries.GetViewDocHistoryByID(DOCID)))
            {
                _rowCount = _tempDocHistory.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvDocHistory.DataSource = _tempDocHistory;
                    this.gvDocHistory.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = "GetDocHistory :" + ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// History Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvDocHistory_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        //if (gvDocHistory.Rows.Count < 1)
        //{
        //    e.Cancel = true;
        //}
        //else
        //{
        //    //Delete the record.
        //    lblStatus.Text = gvDocHistory.Rows[e.RowIndex].Cells[1].Text;
        //}        
    }

    /// <summary>
    /// History Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvDocHistory_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //Get Column Indexes
            DataRowView drvDocHistory = (DataRowView)e.Row.DataItem;
            Int32 _colCOIndex = drvDocHistory.DataView.Table.Columns["Change Order"].Ordinal;
            Int32 _colOldRevisionIndex = drvDocHistory.DataView.Table.Columns["Old Revision"].Ordinal;
            Int32 _colNewRevisionIndex = drvDocHistory.DataView.Table.Columns["New Revision"].Ordinal;
            Int32 _colStatusIndex = drvDocHistory.DataView.Table.Columns["Change Status"].Ordinal;
            Int32 _colCTypeIndex = drvDocHistory.DataView.Table.Columns["Change Type"].Ordinal;
            Int32 _colEffDateIndex = drvDocHistory.DataView.Table.Columns["Effective Date"].Ordinal;
            Int32 _colModByIndex = drvDocHistory.DataView.Table.Columns["Last Modified By"].Ordinal;
            Int32 _colModDateIndex = drvDocHistory.DataView.Table.Columns["Last Modified Date"].Ordinal;

            //Format      
            String _EffDate = e.Row.Cells[_colEffDateIndex].Text;
            if (!String.IsNullOrEmpty(_EffDate) && _EffDate != "&nbsp;")
            {
                e.Row.Cells[_colEffDateIndex].Text = Convert.ToDateTime(_EffDate).ToShortDateString();
            }

            String _ModDate = e.Row.Cells[_colModDateIndex].Text;
            if (!String.IsNullOrEmpty(_ModDate) && _ModDate != "&nbsp;")
            {
                e.Row.Cells[_colModDateIndex].Text = Convert.ToDateTime(_ModDate).ToShortDateString();
            }

            //Align 
            e.Row.Cells[_colCOIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colOldRevisionIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colNewRevisionIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colCTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colEffDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colModByIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colModDateIndex].HorizontalAlign = HorizontalAlign.Center;
        }
    }

    #endregion

    #region Control Lists

    /// <summary>
    /// Get Control List
    /// </summary>
    /// <param name="DOCID"></param>
    /// <returns></returns>
    private Int32 GetControlLists(String DOCID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvControlLists.CssClass = "GridViewStyleView";
            //this.gvControlLists.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvControlLists.RowStyle.CssClass = "GridViewStyleView";        
            this.gvControlLists.AutoGenerateDeleteButton = true;
            this.gvControlLists.EnableViewState = false;
            this.gvControlLists.Controls.Clear();

            using (DataTable _tempCLInfo = DataAccess.GetRecords(DataQueries.GetViewControlListByID(Constants.DocReferenceType, DOCID)))
            {
                _rowCount = _tempCLInfo.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvControlLists.DataSource = _tempCLInfo;
                    this.gvControlLists.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = "GetControlLists :" + ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Control List Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvControlLists_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        String DocumentID = this.txtDocID.Text;
        GetControlLists(DocumentID);

        if (gvControlLists.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            String _CList = gvControlLists.Rows[e.RowIndex].Cells[1].Text;

            DataAccess.ModifyRecords(DataQueries.DeleteControlListRefs(Constants.DocReferenceType, DocumentID, Convert.ToInt32(_CList)));
            this.lblStatus.Text = "Success ! Control List was removed";
        }

        GetGrids(DocumentID);
    }

    /// <summary>
    /// Control List Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvControlLists_RowDataBound(object sender, GridViewRowEventArgs e)
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
            DataRowView drvCLst = (DataRowView)e.Row.DataItem;
            Int32 _colCLIndex = drvCLst.DataView.Table.Columns["Control List"].Ordinal + 1;
            Int32 _colDescIndex = drvCLst.DataView.Table.Columns["Description"].Ordinal + 1;

            //Set Delete Image
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Align      
            e.Row.Cells[_colCLIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colDescIndex].HorizontalAlign = HorizontalAlign.Left;
        }
    }

    #endregion

    #region Restrictions

    /// <summary>
    /// Get Restrictions
    /// </summary>
    /// <param name="DOCID"></param>
    /// <returns></returns>
    private Int32 GetRestrictions(String DOCID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvRestrictions.CssClass = "GridViewStyleView";
            //this.gvRestrictions.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvRestrictions.RowStyle.CssClass = "GridViewStyleView";
            this.gvRestrictions.AutoGenerateDeleteButton = true;
            this.gvRestrictions.EnableViewState = false;
            this.gvRestrictions.Controls.Clear();

            using (DataTable _tempRSTInfo = DataAccess.GetRecords(DataQueries.GetViewResNotice(Constants.DocReferenceType, DOCID)))
            {
                _rowCount = _tempRSTInfo.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvRestrictions.DataSource = _tempRSTInfo;
                    this.gvRestrictions.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = "GetRestrictions :" + ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Restrictions Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvRestrictions_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        String DocumentID = this.txtDocID.Text;
        GetRestrictions(DocumentID);

        if (gvRestrictions.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _RestrictionID = Convert.ToInt32(gvRestrictions.Rows[e.RowIndex].Cells[1].Text);

            Int32 _StatusCheck = DataAccess.ModifyRecords(DataQueries.DeleteResNoticeRefs(Constants.DocReferenceType, DocumentID, _RestrictionID));
            if (_StatusCheck > 0)
            {
                this.lblStatus.Text = "Success ! Restriction was removed";
            }
        }

        GetGrids(DocumentID);
    }

    /// <summary>
    /// Restrictions Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvRestrictions_RowDataBound(object sender, GridViewRowEventArgs e)
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
            DataRowView drvRst = (DataRowView)e.Row.DataItem;
            Int32 _colDescIndex = drvRst.DataView.Table.Columns["Description"].Ordinal + 1;

            //Set Delete Image
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Align               
            e.Row.Cells[_colDescIndex].HorizontalAlign = HorizontalAlign.Left;
        }
    }

    #endregion

    #region WF Tasks

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
        String _RefID = this.txtDocID.Text;
        String _RefTypeCode = Constants.DocReferenceType;

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
        String _RefID = this.txtDocID.Text;
        String _RefTypeCode = Constants.DocReferenceType;

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

    #endregion

    /// <summary>
    /// Get Document Related Grids
    /// </summary>
    /// <param name="DOCID"></param>
    private void GetGrids(String DOCID)
    {
        GetRestrictions(DOCID);
        GetControlLists(DOCID);
        GetDocHistory(DOCID);
        GetAddedNotes(DOCID);
        GetAttachedFiles(DOCID);
        GetAddParts(DOCID);
        GetWFTasks(Constants.DocReferenceType, DOCID);
        GetCustomFieldsInfo(DOCID);
    }
    public void CheckFields()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.ShowFieldsData(31, RoleId)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["Controlid"].ToString();
                if (txtDocIDs == "divtxtDocID") { divtxtDocID.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divtxtStatus") { divStatus.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "divtxtRevision") { divRevision.Visible = true; } //else { divRevision.Visible = false; }
                if (txtDocIDs == "divtxtExpiryDate") { divExpires.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "divtxtDocType") { divtxtDocType.Visible = true; }
                if (txtDocIDs == "divcbTabulated") { divcbTabulated.Visible = true; }
                if (txtDocIDs == "divtxtDiscipline") { divtxtDiscipline.Visible = true; }
                if (txtDocIDs == "divtxtProject") { divtxtProject.Visible = true; }
                if (txtDocIDs == "divtxtDescription") { divtxtDescription.Visible = true; }
                if (txtDocIDs == "divtxtRequestedBy") { divtxtRequestedBy.Visible = true; }
                if (txtDocIDs == "divtxtDateRequestedBy") { divtxtDateRequestedBy.Visible = true; }
                if (txtDocIDs == "divtxtDateCreatedBy") { divtxtDateCreatedBy.Visible = true; }
                if (txtDocIDs == "divtxtCreatedBy") { divtxtCreatedBy.Visible = true; }
                if (txtDocIDs == "divtxtReviewedBy") { divtxtReviewedBy.Visible = true; }
                //
                if (txtDocIDs == "divtxtDateReviewedBy") { divtxtDateReviewedBy.Visible = true; }
                if (txtDocIDs == "divtxtReleasedBy") { divtxtReleasedBy.Visible = true; }
                if (txtDocIDs == "divtxtDateReleasedBy") { divtxtDateReleasedBy.Visible = true; }
                if (txtDocIDs == "divtxtObsoletedBy") { divtxtObsoletedBy.Visible = true; }
                //
                if (txtDocIDs == "divtxtDateObsoletedBy") { divtxtDateObsoletedBy.Visible = true; }
                if (txtDocIDs == "divtxtLastModifiedBy") { divtxtLastModifiedBy.Visible = true; }
                if (txtDocIDs == "divtxtDateLastModifiedBy") { divtxtDateLastModifiedBy.Visible = true; }
                if (txtDocIDs == "divddlNumSchemes") { divddlNumSchemes.Visible = true; }
                //For Buttons
                if (txtDocIDs == "btnFind") { btnFind.Visible = true; }
                //else { btnFind.Visible = false; }
                // if (txtDocIDs == "btnNewEditSave") { btnNewEditSave.Visible = true; }
                if (txtDocIDs == "btnNew") { btnNew.Visible = true; }
                if (txtDocIDs == "btnEdit") { IsEditAllow = true; }
                //else { btnNewEditSave.Visible = false; }
                if (txtDocIDs == "btnCancel") { btnCancel.Visible = true; }
                // else { btnCancel.Visible = false; }
                if (txtDocIDs == "btnDelete") { btnDelete.Visible = true; }
                else { btnDelete.Visible = false; }




            }
            //foreach (DataRow row in dt.Rows)
            //{
            //    if (row.) // bool property 
            //    {
            //        //Stuff to do if that condition is true
            //        doSomethingElse();
            //        //Calling the break keyword will stop the loop and jump immediately outside of it
            //        break;
            //    }
            //    //Other code to run for each iteration of the loop
            //}
            //DataRow foundRow = dt.Rows.Find("txtRevision");
            //foreach (DataRow row in dt.Rows)
            //{
            //    if (row.) // bool property 
            //    {
            //        //Stuff to do if that condition is true
            //        doSomethingElse();
            //        //Calling the break keyword will stop the loop and jump immediately outside of it
            //        break;
            //    }
            //    //Other code to run for each iteration of the loop
            //}
        }

    }
    public void CheckDropdownVisible()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.ShowDropdowns(RoleId, 31)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["MasterID"].ToString();
                if (txtDocIDs == "divCurrentControlList") { divCurrentControlList.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divListofAppliedRestrictions") { divListofAppliedRestrictions.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "divListofAddedNotes") { divListofAddedNotes.Visible = true; } //else { divRevision.Visible = false; }

                if (txtDocIDs == "divListofAttachedFiles") { divListofAttachedFiles.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "divListofAddedParts") { divListofAddedParts.Visible = true; }
                if (txtDocIDs == "divChangeOrderHistory") { divChangeOrderHistory.Visible = true; }
                if (txtDocIDs == "divCurrentControlList") { divCurrentControlList.Visible = true; }
                if (txtDocIDs == "divListofAppliedRestrictions") { divListofAppliedRestrictions.Visible = true; }
                if (txtDocIDs == "divListofAddedNotes") { divListofAddedNotes.Visible = true; }
                if (txtDocIDs == "divWorkflowTasks") { divWorkflowTasks.Visible = true; }
                if (txtDocIDs == "divCustomFields") { divCustomFields.Visible = true; }
                //if (txtDocIDs == "divtxtDateCreatedBy") { divtxtDateCreatedBy.Visible = true; }
                //if (txtDocIDs == "divtxtCreatedBy") { divtxtCreatedBy.Visible = true; }
                //if (txtDocIDs == "divtxtReviewedBy") { divtxtReviewedBy.Visible = true; }
                ////
                //if (txtDocIDs == "divtxtDateReviewedBy") { divtxtDateReviewedBy.Visible = true; }
                //if (txtDocIDs == "divtxtReleasedBy") { divtxtReleasedBy.Visible = true; }
                //if (txtDocIDs == "divtxtDateReleasedBy") { divtxtDateReleasedBy.Visible = true; }
                //if (txtDocIDs == "divtxtObsoletedBy") { divtxtObsoletedBy.Visible = true; }
                ////
                //if (txtDocIDs == "divtxtDateObsoletedBy") { divtxtDateObsoletedBy.Visible = true; }
                //if (txtDocIDs == "divtxtLastModifiedBy") { divtxtLastModifiedBy.Visible = true; }
                //if (txtDocIDs == "divtxtDateLastModifiedBy") { divtxtDateLastModifiedBy.Visible = true; }




            }

        }

    }
    public void CheckdropsdownView()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.visibleDropDown(RoleId, 31)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ChildID"].ToString();
                if (txtDocIDs == "hlnkAttachFiles") { hlnkAttachFiles.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "hlnkAddParts") { hlnkAddParts.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "hlnkDocHistory") { hlnkDocHistory.Visible = true; } //else { divRevision.Visible = false; }

                if (txtDocIDs == "hlnkControlLists") { hlnkControlLists.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "hlnkRestrictions") { hlnkRestrictions.Visible = true; }
                if (txtDocIDs == "hlnkNotes") { hlnkNotes.Visible = true; }
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Visible = true; }
                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Visible = true; }
            }

        }

    }
    public void EnabledDropsDown()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.EnabledDropDown(RoleId, 31)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ChildID"].ToString();
                if (txtDocIDs == "hlnkAttachFiles") { hlnkAttachFiles.Enabled = true; hfd_gvAttachedFiles.Value = "1"; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "hlnkAddParts") { hlnkAddParts.Enabled = true; hfd_gvAddParts.Value = "1"; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "hlnkDocHistory") { hlnkDocHistory.Enabled = true; hfd_gvDocHistory.Value = "1"; } //else { divRevision.Visible = false; }

                if (txtDocIDs == "hlnkControlLists") { hlnkControlLists.Enabled = true; hfd_gvControlLists.Value = "1"; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "hlnkRestrictions") { hlnkRestrictions.Enabled = true; hfd_gvRestrictions.Value = "1"; }
                if (txtDocIDs == "hlnkNotes") { hlnkNotes.Enabled = true; hfd_gvNotes.Value = "1"; }
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Enabled = true; hfd_gvWFTasks.Value = "1"; }
                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Enabled = true; }

            }

        }

    }
    /// <summary>
    /// Initialize Form 
    /// </summary>
    /// 
    private void InitializeFormFields()
    {
        try
        {
            this.lblStatus.Text = null;
            this.txtDocID.Text = null;
            this.txtStatus.Text = null;
            this.txtExpiryDate.Text = null;
            this.txtRevision.Text = null;
            this.ucDateExpiry.SelectedDate = null;

            this.txtDescription.Text = null;
            this.txtDescription.TextMode = TextBoxMode.MultiLine;
            this.txtDescription.Height = 50;

            this.txtDocType.Text = null;
            this.txtDiscipline.Text = null;
            this.txtProject.Text = null;

            this.txtRequestedBy.Text = null;
            this.txtCreatedBy.Text = null;
            this.txtReviewedBy.Text = null;
            this.txtObsoletedBy.Text = null;
            this.txtReleasedBy.Text = null;
            this.txtLastModifiedBy.Text = null;

            this.txtDateRequestedBy.Text = null;
            this.txtDateCreatedBy.Text = null;
            this.txtDateReviewedBy.Text = null;
            this.txtDateObsoletedBy.Text = null;
            this.txtDateReleasedBy.Text = null;
            this.txtDateLastModifiedBy.Text = null;

            this.ucDateRequestedBy.SelectedDate = null;
            this.ucDateCreatedBy.SelectedDate = null;
            this.ucDateReviewedBy.SelectedDate = null;
            this.ucDateObsoletedBy.SelectedDate = null;
            this.ucDateReleasedBy.SelectedDate = null;

            using (DataTable _tempStatus = new DataTable())
            {
                _tempStatus.Columns.Add("Code", Type.GetType("System.String"));
                _tempStatus.Columns.Add("Description", Type.GetType("System.String"));
                _tempStatus.Rows.Add("-NONE-", "-NONE-");
                _tempStatus.Merge(DataAccess.GetRecords(DataQueries.GetQDocStatus()), true);
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
                _tempProject.Merge(DataAccess.GetRecords(DataQueries.GetQProject()), true);
                this.ddlProject.DataSource = _tempProject;
                this.ddlProject.DataTextField = "Description";
                this.ddlProject.DataValueField = "ID";
                this.ddlProject.DataBind();
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

                this.ddlCreatedBy.DataSource = _tempUserInfo;
                this.ddlCreatedBy.DataTextField = "User Name";
                this.ddlCreatedBy.DataValueField = "User ID";
                this.ddlCreatedBy.DataBind();

                this.ddlReviewedBy.DataSource = _tempUserInfo;
                this.ddlReviewedBy.DataTextField = "User Name";
                this.ddlReviewedBy.DataValueField = "User ID";
                this.ddlReviewedBy.DataBind();

                this.ddlObsoletedBy.DataSource = _tempUserInfo;
                this.ddlObsoletedBy.DataTextField = "User Name";
                this.ddlObsoletedBy.DataValueField = "User ID";
                this.ddlObsoletedBy.DataBind();

                this.ddlReleasedBy.DataSource = _tempUserInfo;
                this.ddlReleasedBy.DataTextField = "User Name";
                this.ddlReleasedBy.DataValueField = "User ID";
                this.ddlReleasedBy.DataBind();
            }

            using (DataTable _tempDocType = new DataTable())
            {
                _tempDocType.Columns.Add("Code", Type.GetType("System.String"));
                _tempDocType.Columns.Add("Description", Type.GetType("System.String"));
                _tempDocType.Rows.Add("-NONE-", "-NONE-");
                _tempDocType.Merge(DataAccess.GetRecords(DataQueries.GetQDocType()), true);
                this.ddlDocType.DataSource = _tempDocType;
                this.ddlDocType.DataTextField = "Description";
                this.ddlDocType.DataValueField = "Code";
                this.ddlDocType.DataBind();

                //Popup
                this.ddlDocTypePop.DataSource = _tempDocType;
                this.ddlDocTypePop.DataTextField = "Description";
                this.ddlDocTypePop.DataValueField = "Code";
                this.ddlDocTypePop.DataBind();
            }

            using (DataTable _tempDiscipline = new DataTable())
            {
                _tempDiscipline.Columns.Add("Code", Type.GetType("System.String"));
                _tempDiscipline.Columns.Add("Description", Type.GetType("System.String"));
                _tempDiscipline.Rows.Add("-NONE-", "-NONE-");
                _tempDiscipline.Merge(DataAccess.GetRecords(DataQueries.GetQDiscipline()), true);
                this.ddlDiscipline.DataSource = _tempDiscipline;
                this.ddlDiscipline.DataTextField = "Description";
                this.ddlDiscipline.DataValueField = "Code";
                this.ddlDiscipline.DataBind();

                //Popup
                this.ddlDisciplinePop.DataSource = _tempDiscipline;
                this.ddlDisciplinePop.DataTextField = "Description";
                this.ddlDisciplinePop.DataValueField = "Code";
                this.ddlDisciplinePop.DataBind();
            }

            //Register Script for Delete Button
            this.btnDelete.OnClientClick = "GetDocDeleteUserConf()";
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }

    /// <summary>
    /// Initialize Grid Views
    /// </summary>
    private void InitializeGrids()
    {
        try
        {
            this.gvAddParts.EnableViewState = false;
            this.gvAddParts.Controls.Clear();

            this.gvAttachedFiles.EnableViewState = false;
            this.gvAttachedFiles.Controls.Clear();

            this.gvNotes.EnableViewState = false;
            this.gvNotes.Controls.Clear();

            this.gvDocHistory.EnableViewState = false;
            this.gvDocHistory.Controls.Clear();

            this.gvControlLists.EnableViewState = false;
            this.gvControlLists.Controls.Clear();

            this.gvRestrictions.EnableViewState = false;
            this.gvRestrictions.Controls.Clear();

            this.gvNumSchemes.EnableViewState = false;
            this.gvNumSchemes.Controls.Clear();
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }

    /// <summary>
    /// Set Page to Edit / View
    /// </summary>
    /// <param name="EditView"></param>
    private void SetForm(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {
                //Apply View Style                
                //this.txtDocID.CssClass = "CtrlShortValueView";
                //this.txtStatus.CssClass = "CtrlMediumValueView";                
                //this.txtExpiryDate.CssClass = "CtrlShortValueView";
                //this.txtRevision.CssClass = "CtrlShortValueView";               
                //this.txtProject.CssClass = "CtrlWideValueView";
                //this.txtDescription.CssClass = "CtrlWideValueView";   

                //this.txtRequestedBy.CssClass = "CtrlMediumValueView";
                //this.txtCreatedBy.CssClass = "CtrlMediumValueView";
                //this.txtReviewedBy.CssClass = "CtrlMediumValueView";
                //this.txtObsoletedBy.CssClass = "CtrlMediumValueView";
                //this.txtReleasedBy.CssClass = "CtrlMediumValueView";
                //this.txtLastModifiedBy.CssClass = "CtrlMediumValueView";

                //this.txtDateRequestedBy.CssClass = "CtrlShortValueView";
                //this.txtDateCreatedBy.CssClass = "CtrlShortValueView";
                //this.txtDateReviewedBy.CssClass = "CtrlShortValueView";
                //this.txtDateObsoletedBy.CssClass = "CtrlShortValueView";
                //this.txtDateReleasedBy.CssClass = "CtrlShortValueView";
                //this.txtDateLastModifiedBy.CssClass = "CtrlShortValueView";

                //Set Read Only      
                this.txtDocID.ReadOnly = true;
                this.txtStatus.ReadOnly = true;
                this.txtExpiryDate.ReadOnly = true;
                this.txtRevision.ReadOnly = true;
                this.txtProject.ReadOnly = true;
                this.txtDescription.ReadOnly = true;

                this.txtRequestedBy.ReadOnly = true;
                this.txtCreatedBy.ReadOnly = true;
                this.txtReviewedBy.ReadOnly = true;
                this.txtObsoletedBy.ReadOnly = true;
                this.txtReleasedBy.ReadOnly = true;
                this.txtLastModifiedBy.ReadOnly = true;

                this.txtDateRequestedBy.ReadOnly = true;
                this.txtDateCreatedBy.ReadOnly = true;
                this.txtDateReviewedBy.ReadOnly = true;
                this.txtDateObsoletedBy.ReadOnly = true;
                this.txtDateReleasedBy.ReadOnly = true;
                this.txtDateLastModifiedBy.ReadOnly = true;

                //Hide Edit Controls    
                this.ddlStatus.Visible = false;
                this.ucDateExpiry.Visible = false;
                this.ddlProject.Visible = false;

                this.ddlRequestedBy.Visible = false;
                this.ddlCreatedBy.Visible = false;
                this.ddlReviewedBy.Visible = false;
                this.ddlObsoletedBy.Visible = false;
                this.ddlReleasedBy.Visible = false;

                this.ucDateRequestedBy.Visible = false;
                this.ucDateCreatedBy.Visible = false;
                this.ucDateReviewedBy.Visible = false;
                this.ucDateObsoletedBy.Visible = false;
                this.ucDateReleasedBy.Visible = false;

                //Show View Controls
                this.txtStatus.Visible = true;
                this.txtExpiryDate.Visible = true;
                this.txtProject.Visible = true;

                this.txtRequestedBy.Visible = true;
                this.txtCreatedBy.Visible = true;
                this.txtReviewedBy.Visible = true;
                this.txtObsoletedBy.Visible = true;
                this.txtReleasedBy.Visible = true;

                this.txtDateRequestedBy.Visible = true;
                this.txtDateCreatedBy.Visible = true;
                this.txtDateReviewedBy.Visible = true;
                this.txtDateObsoletedBy.Visible = true;
                this.txtDateReleasedBy.Visible = true;

                SetNewItemFilter(FORM_ON.View);

            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
                //Apply Edit Style       
                //this.txtRevision.CssClass = "CtrlShortValueEdit";
                //this.txtDescription.CssClass = "CtrlWideValueEdit";                
                //this.ucDateExpiry.CssClass = "CtrlShortValueEdit";

                //this.ddlStatus.CssClass = "CtrlMediumValueEdit";
                //this.ddlProject.CssClass = "CtrlWideValueEdit";

                //this.ddlRequestedBy.CssClass = "CtrlMediumValueEdit";                             
                //this.ddlCreatedBy.CssClass = "CtrlMediumValueEdit";
                //this.ddlReviewedBy.CssClass = "CtrlMediumValueEdit";                
                //this.ddlObsoletedBy.CssClass = "CtrlMediumValueEdit";
                //this.ddlReleasedBy.CssClass = "CtrlMediumValueEdit";            

                //this.ucDateRequestedBy.CssClass = "CtrlShortValueEdit";
                //this.ucDateCreatedBy.CssClass = "CtrlShortValueEdit";
                //this.ucDateReviewedBy.CssClass = "CtrlShortValueEdit";
                //this.ucDateObsoletedBy.CssClass = "CtrlShortValueEdit";
                //this.ucDateReleasedBy.CssClass = "CtrlShortValueEdit";

                //Reset the Read Only                
                this.txtDescription.ReadOnly = false;
                this.txtRevision.ReadOnly = false;

                //Hide View Controls
                this.txtStatus.Visible = false;
                this.txtExpiryDate.Visible = false;
                this.txtProject.Visible = false;

                this.txtRequestedBy.Visible = false;
                this.txtCreatedBy.Visible = false;
                this.txtReviewedBy.Visible = false;
                this.txtObsoletedBy.Visible = false;
                this.txtReleasedBy.Visible = false;

                this.txtDateRequestedBy.Visible = false;
                this.txtDateCreatedBy.Visible = false;
                this.txtDateReviewedBy.Visible = false;
                this.txtDateObsoletedBy.Visible = false;
                this.txtDateReleasedBy.Visible = false;

                //Show Edit Controls
                this.ddlStatus.Visible = true;
                this.ucDateExpiry.Visible = true;
                this.ddlProject.Visible = true;

                this.ddlRequestedBy.Visible = true;
                this.ddlCreatedBy.Visible = true;
                this.ddlReviewedBy.Visible = true;
                this.ddlObsoletedBy.Visible = true;
                this.ddlReleasedBy.Visible = true;

                this.ucDateRequestedBy.Visible = true;
                this.ucDateCreatedBy.Visible = true;
                this.ucDateReviewedBy.Visible = true;
                this.ucDateObsoletedBy.Visible = true;
                this.ucDateReleasedBy.Visible = true;

                //Initialize from View Controls                
                this.ucDateExpiry.SelectedDate = this.txtExpiryDate.Text;
                this.ucDateRequestedBy.SelectedDate = this.txtDateRequestedBy.Text;
                this.ucDateCreatedBy.SelectedDate = this.txtDateCreatedBy.Text;
                this.ucDateReviewedBy.SelectedDate = this.txtDateReviewedBy.Text;
                this.ucDateObsoletedBy.SelectedDate = this.txtDateObsoletedBy.Text;
                this.ucDateReleasedBy.SelectedDate = this.txtDateReleasedBy.Text;

                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlStatus.Items.FindByText(this.txtStatus.Text.Trim());
                this.ddlStatus.SelectedIndex = this.ddlStatus.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlProject.Items.FindByText(this.txtProject.Text.Trim());
                this.ddlProject.SelectedIndex = this.ddlProject.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlRequestedBy.Items.FindByText(this.txtRequestedBy.Text.Trim());
                this.ddlRequestedBy.SelectedIndex = this.ddlRequestedBy.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlCreatedBy.Items.FindByText(this.txtCreatedBy.Text.Trim());
                this.ddlCreatedBy.SelectedIndex = this.ddlCreatedBy.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlReviewedBy.Items.FindByText(this.txtReviewedBy.Text.Trim());
                this.ddlReviewedBy.SelectedIndex = this.ddlReviewedBy.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlObsoletedBy.Items.FindByText(this.txtObsoletedBy.Text.Trim());
                this.ddlObsoletedBy.SelectedIndex = this.ddlObsoletedBy.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlReleasedBy.Items.FindByText(this.txtReleasedBy.Text.Trim());
                this.ddlReleasedBy.SelectedIndex = this.ddlReleasedBy.Items.IndexOf(liSelectedItem);

                SetNewItemFilter(FORM_ON.Edit);

            } //end if - EDIT

            this.txtDocID.Focus();
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }

    /// <summary>
    /// Set New Items Filter
    /// </summary>
    /// <param name="EditView"></param>
    private void SetNewItemFilter(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {
                //Apply View Style 
                //this.txtDiscipline.CssClass = "CtrlMediumValueView";
                //this.txtDocType.CssClass = "CtrlWideValueView";

                //Set Read Only           
                this.txtDocType.ReadOnly = true;
                this.txtDiscipline.ReadOnly = true;

                //Hide Edit Controls
                this.ddlDiscipline.Visible = false;
                this.ddlDocType.Visible = false;

                //Show View Controls
                this.txtDocType.Visible = true;
                this.txtDiscipline.Visible = true;
            }

            if (EditView == FORM_ON.Edit)
            {
                //Apply Edit Style
                //this.ddlDocType.CssClass = "CtrlWideValueEdit";
                //this.ddlDiscipline.CssClass = "CtrlMediumValueEdit";

                //Hide View Controls
                this.txtDiscipline.Visible = false;
                this.txtDocType.Visible = false;

                //Show Edit Controls
                this.ddlDocType.Visible = true;
                this.ddlDiscipline.Visible = true;

                //Initialize from View Controls    
                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlDocType.Items.FindByText(this.txtDocType.Text.Trim());
                this.ddlDocType.SelectedIndex = this.ddlDocType.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlDiscipline.Items.FindByText(this.txtDiscipline.Text.Trim());
                this.ddlDiscipline.SelectedIndex = this.ddlDiscipline.Items.IndexOf(liSelectedItem);
            }
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }

    /// <summary>
    /// Get Custom Fields
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetCustomFieldsInfo(String DOCID)
    {
        Int32 _rowCount = 0;
        String strHtml = "";
        String[] arrCustomLabels = new String[10];
        String strLabel = "";
        Int32 rowOrderCnt = 0;
        String strValue = "";

        try
        {
            using (DataTable _tempCustomLabels = DataAccess.GetRecords(DataQueries.GetCustomLabels("DM")))
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

            using (DataTable _tempCustomInfo = DataAccess.GetRecords(DataQueries.GetCustomValues(DOCID, "DOC")))
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


    protected void ddlNumSchemes_SelectedIndexChanged(object sender, EventArgs e)
    {
        string selectedValue = ddlNumSchemes.SelectedValue;
        if (!string.IsNullOrEmpty(selectedValue))
        {
            Int32 _SchemeID = Convert.ToInt32(selectedValue.Split('|')[0]);
            String _DocTypeID = selectedValue.Split('|')[1];
            String _Discipline = selectedValue.Split('|')[2];

            this.txtDocID.Text = Utils.GetNewID(_SchemeID, "Documents", null);

            SetForm(FORM_ON.Edit);
            gvNumSchemes.Visible = false;
            this.btnFind.Visible = true;
            this.ddlDocType.AutoPostBack = false;
            this.ddlDiscipline.AutoPostBack = false;
            this.btnNew.Text = "Save";
            this.btnNew.Visible = true;
            this.btnEdit.Visible = false;

            this.btnFind.AlternateText = "Find New Document";

            ListItem liSelectedItem = null;

            liSelectedItem = this.ddlStatus.Items.FindByValue("REQ");
            this.ddlStatus.SelectedIndex = this.ddlStatus.Items.IndexOf(liSelectedItem);

            liSelectedItem = this.ddlDocType.Items.FindByValue(_DocTypeID);
            this.ddlDocType.SelectedIndex = this.ddlDocType.Items.IndexOf(liSelectedItem);

            liSelectedItem = this.ddlDiscipline.Items.FindByValue(_Discipline);
            this.ddlDiscipline.SelectedIndex = this.ddlDiscipline.Items.IndexOf(liSelectedItem);

            liSelectedItem = this.ddlRequestedBy.Items.FindByText(_SessionUser);
            this.ddlRequestedBy.SelectedIndex = this.ddlRequestedBy.Items.IndexOf(liSelectedItem);
            this.txtLastModifiedBy.Text = this.ddlRequestedBy.SelectedItem.ToString();
            this.ucDateRequestedBy.SelectedDate = DateTime.Now.ToShortDateString();
            this.txtDateLastModifiedBy.Text = DateTime.Now.ToShortDateString();
        }
    }

    protected void btnNew_Click(object sender, EventArgs e)
    {
        if (this.btnNew.Text == "New Document")
        {

            InitializeFormFields();
            InitializeGrids();

            SetForm(FORM_ON.View);
            SetNewItemFilter(FORM_ON.Edit);

            this.ddlDocType.AutoPostBack = true;
            this.ddlDiscipline.AutoPostBack = true;

            this.btnCancel.Visible = true;
            this.btnDelete.Visible = false;
            //this.btnNewEditSave.Visible = false;
            this.btnNew.Visible = false;
            this.btnFind.Visible = false;

            GetNumSchemes(null, null);
            mp1.Show();

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
            this.btnCancel.Visible = true;
            this.btnDelete.Visible = false;
            this.btnEdit.Text = "Update";
            this.btnNew.Visible = false;
            this.btnEdit.Visible = IsEditAllow;//true;
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
            String DocumetID = this.txtDocID.Text;
            if (String.IsNullOrEmpty(DocumetID))
            {
                throw new Exception("The [Document Number] does not appear to be valid. The record will not be saved.");
            }

            String CurrentRevision = null;
            if (!String.IsNullOrEmpty(this.txtRevision.Text))
            {
                CurrentRevision = this.txtRevision.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "CurrentRev"))
                {
                    throw new Exception("A [Revision] could not be located or created. The record will not be saved.");
                }
            }

            String DocStatus = null;
            if (this.ddlStatus.SelectedItem.Text != "-NONE-")
            {
                DocStatus = this.ddlStatus.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocStatus"))
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
                if (Utils.IsRequiredField("Documents", "DocDesc"))
                {
                    throw new Exception("A [Description] could not be located or created. The record will not be saved.");
                }
            }

            String Discipline = null;
            if (this.ddlDiscipline.SelectedItem.Text != "-NONE-")
            {
                Discipline = this.ddlDiscipline.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "Discipline"))
                {
                    throw new Exception("A [Discipline] could not be located or created. The record will not be saved.");
                }
            }

            String DocType = null;
            if (this.ddlDocType.SelectedItem.Text != "-NONE-")
            {
                DocType = this.ddlDocType.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocType"))
                {
                    throw new Exception("A [Document Type] could not be located or created. The record will not be saved.");
                }
            }

            String IsTabulated;
            if (this.cbTabulated.Checked)
            {
                IsTabulated = "0";
            }
            else
            {
                IsTabulated = "-1";
            }

            String Project = null;
            if (this.ddlProject.SelectedItem.Text != "-NONE-")
            {
                Project = this.ddlProject.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "ProjNum"))
                {
                    throw new Exception("A [Project] could not be located or created. The record will not be saved.");
                }
            }

            String DocRequestedBy = null;
            if (this.ddlRequestedBy.SelectedItem.Text != "-NONE-")
            {
                DocRequestedBy = this.ddlRequestedBy.SelectedItem.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocReqBy"))
                {
                    throw new Exception("The person [Requested By] could not be located or created. The record will not be saved.");
                }
            }

            DateTime DocRequestedDate = DateTime.Now;
            if (!String.IsNullOrEmpty(this.ucDateRequestedBy.SelectedDate) &&
                !String.IsNullOrEmpty(DocRequestedBy) && DocRequestedBy != "-NONE-")
            {
                DocRequestedDate = Convert.ToDateTime(this.ucDateRequestedBy.SelectedDate);
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocReqDate"))
                {
                    throw new Exception("A [Request Date] could not be located or created. The record will not be saved.");
                }
            }

            String DocCreatedBy = null;
            if (this.ddlCreatedBy.SelectedItem.Text != "-NONE-")
            {
                DocCreatedBy = this.ddlCreatedBy.SelectedItem.Text;
            }
            //else
            //{
            //    throw new Exception("The person [Created By] could not be located or created. The record will not be saved.");
            //}

            DateTime DocCreatedDate;
            if (!String.IsNullOrEmpty(this.ucDateCreatedBy.SelectedDate) &&
                !String.IsNullOrEmpty(DocCreatedBy) && DocCreatedBy != "-NONE-")
            {
                DocCreatedDate = Convert.ToDateTime(this.ucDateCreatedBy.SelectedDate);
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocCreatedDate"))
                {
                    throw new Exception("A [Created Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    DocCreatedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            String DocReviewedBy = null;
            if (this.ddlReviewedBy.SelectedItem.Text != "-NONE-")
            {
                DocReviewedBy = this.ddlReviewedBy.SelectedItem.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocReviewBy"))
                {
                    throw new Exception("The person [Reviewed By] could not be located or created. The record will not be saved.");
                }
            }

            DateTime DocReviewedDate;
            if (!String.IsNullOrEmpty(this.ucDateReviewedBy.SelectedDate) &&
                !String.IsNullOrEmpty(DocReviewedBy) && DocReviewedBy != "-NONE-")
            {
                DocReviewedDate = Convert.ToDateTime(this.ucDateReviewedBy.SelectedDate);
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocReviewDate"))
                {
                    throw new Exception("A [Review Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    DocReviewedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            String DocReleasedBy = null;
            if (this.ddlReleasedBy.SelectedItem.Text != "-NONE-")
            {
                DocReleasedBy = this.ddlReleasedBy.SelectedItem.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocRelRef"))
                {
                    throw new Exception("The person [Released By] could not be located or created. The record will not be saved.");
                }
            }

            DateTime DocReleasedDate;
            if (!String.IsNullOrEmpty(this.ucDateReleasedBy.SelectedDate) &&
                !String.IsNullOrEmpty(DocReleasedBy) && DocReleasedBy != "-NONE-")
            {
                DocReleasedDate = Convert.ToDateTime(this.ucDateReleasedBy.SelectedDate);
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocRelDate"))
                {
                    throw new Exception("A [Release Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    DocReleasedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            String DocObsoletedBy = null;
            if (this.ddlObsoletedBy.SelectedItem.Text != "-NONE-")
            {
                DocObsoletedBy = this.ddlObsoletedBy.SelectedItem.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocObsRef"))
                {
                    throw new Exception("The person [Obsoleted By] could not be located or created. The record will not be saved.");
                }
            }

            DateTime DocObsoletedDate;
            if (!String.IsNullOrEmpty(this.ucDateObsoletedBy.SelectedDate) &&
                !String.IsNullOrEmpty(DocObsoletedBy) && DocObsoletedBy != "-NONE-")
            {
                DocObsoletedDate = Convert.ToDateTime(this.ucDateObsoletedBy.SelectedDate);
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocObsDate"))
                {
                    throw new Exception("An [Obsolete Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    DocObsoletedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            DateTime ExpDate;
            if (!String.IsNullOrEmpty(this.ucDateExpiry.SelectedDate))
            {
                ExpDate = Convert.ToDateTime(this.ucDateExpiry.SelectedDate);
                //ExpDate = DateTime.ParseExact(this.ucDateExpiry.SelectedDate, "MM-dd-yyyy", CultureInfo.InvariantCulture); 
            }
            else
            {
                if (Utils.IsRequiredField("Documents", "DocExpDate"))
                {
                    throw new Exception("An [Expiration Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    ExpDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            String LastModifiedBy = _SessionUser;
            DateTime LastModifiedDate = DateTime.Now;

            if (action == "Update")
            {
                DataAccess.ModifyRecords(DataQueries.UpdateDocumentByID(DocumetID, DocStatus, CurrentRevision, Description, Discipline,
                                                                         DocType, IsTabulated, Project, DocRequestedBy, DocRequestedDate,
                                                                         DocCreatedBy, DocCreatedDate, DocReviewedBy, DocReviewedDate,
                                                                         DocReleasedBy, DocReleasedDate, DocObsoletedBy, DocObsoletedDate,
                                                                         ExpDate, LastModifiedBy, LastModifiedDate));
            }

            if (action == "Save")
            {
                DataAccess.ModifyRecords(DataQueries.InsertDocument(DocumetID, DocStatus, CurrentRevision, Description, Discipline,
                                                                    DocType, IsTabulated, Project, DocRequestedBy, DocRequestedDate,
                                                                    DocCreatedBy, DocCreatedDate, DocReviewedBy, DocReviewedDate,
                                                                    DocReleasedBy, DocReleasedDate, DocObsoletedBy, DocObsoletedDate,
                                                                    ExpDate, LastModifiedBy, LastModifiedDate));
            }

            GetRecord(DocumetID);
            GetGrids(DocumetID);
            SetLinkURLs(DocumetID);

            SetForm(FORM_ON.View);
            this.btnEdit.Text = "Edit";
            this.btnNew.Visible = false;
            this.btnEdit.Visible = true;
            this.btnCancel.Visible = false;
            this.btnDelete.Visible = true;
            this.btnFind.Visible = true;
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    protected void ddlDisciplinePop_SelectedIndexChanged(object sender, EventArgs e)
    {
        gvNumSchemes_Filter_Popup();
        mp1.Show();
    }

    protected void ddlDocTypePop_SelectedIndexChanged(object sender, EventArgs e)
    {
        gvNumSchemes_Filter_Popup();
        mp1.Show();
    }

    protected void ddlNumSchemesPop_SelectedIndexChanged(object sender, EventArgs e)
    {
        string selectedValue = ddlNumSchemesPop.SelectedValue;
        if (!string.IsNullOrEmpty(selectedValue))
        {
            Int32 _SchemeID = Convert.ToInt32(selectedValue.Split('|')[0]);
            String _DocTypeID = selectedValue.Split('|')[1];
            String _Discipline = selectedValue.Split('|')[2];

            this.txtDocID.Text = Utils.GetNewID(_SchemeID, "Documents", null);

            SetForm(FORM_ON.Edit);
            gvNumSchemes.Visible = false;
            this.btnFind.Visible = true;
            this.ddlDocType.AutoPostBack = false;
            this.ddlDiscipline.AutoPostBack = false;
            this.btnNew.Text = "Save";
            this.btnNew.Visible = true;
            this.btnEdit.Visible = false;

            this.btnFind.AlternateText = "Find New Document";

            ListItem liSelectedItem = null;

            liSelectedItem = this.ddlStatus.Items.FindByValue("REQ");

            if (liSelectedItem != null)
                this.ddlStatus.SelectedIndex = this.ddlStatus.Items.IndexOf(liSelectedItem);

            liSelectedItem = this.ddlDocTypePop.Items.FindByValue(_DocTypeID);
            if (liSelectedItem != null)
                this.ddlDocTypePop.SelectedIndex = this.ddlDocTypePop.Items.IndexOf(liSelectedItem);

            liSelectedItem = this.ddlDisciplinePop.Items.FindByValue(_Discipline);
            if (liSelectedItem != null)
                this.ddlDisciplinePop.SelectedIndex = this.ddlDisciplinePop.Items.IndexOf(liSelectedItem);

            liSelectedItem = this.ddlRequestedBy.Items.FindByText(_SessionUser);
            if (liSelectedItem != null)
                this.ddlRequestedBy.SelectedIndex = this.ddlRequestedBy.Items.IndexOf(liSelectedItem);

            this.txtLastModifiedBy.Text = this.ddlRequestedBy.SelectedItem.ToString();
            this.ucDateRequestedBy.SelectedDate = DateTime.Now.ToShortDateString();
            this.txtDateLastModifiedBy.Text = DateTime.Now.ToShortDateString();

            ddlNumSchemes.SelectedValue = selectedValue;
        }
        mp1.Show();
    }
    private void gvNumSchemes_Filter_Popup()
    {
        try
        {
            String _SelectedDocType = null;
            if (this.ddlDocTypePop.SelectedItem.Text != "-NONE-")
            {
                _SelectedDocType = this.ddlDocTypePop.SelectedItem.Value;
            }

            String _SelectedDiscipline = null;
            if (this.ddlDisciplinePop.SelectedItem.Text != "-NONE-")
            {
                _SelectedDiscipline = this.ddlDisciplinePop.SelectedItem.Value;
            }

            this.txtDocType.Text = this.ddlDocTypePop.SelectedItem.Text;
            this.txtDiscipline.Text = this.ddlDisciplinePop.SelectedItem.Text;

            SetNewItemFilter(FORM_ON.Edit);
            GetNumSchemes(_SelectedDiscipline, _SelectedDocType);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage     
        }
    }
}
