using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;


//Form Enumeration
public enum FORM_ON
{
    View,
    Edit
}

/// <summary>
/// Global Constants
/// </summary>
static public class Constants
{
    //Minimum Date Time Value - Bug in MS DateTime - 1/1/0001 --> 1/1/2001
    public const String DateTimeMinimum = "1/1/1900 12:00:00 AM";

    public const String ChangeReferenceType = "CO";    
    public const String DocReferenceType = "DOC";
    public const String TaskReferenceType = "TASK";
    public const String MaterialDispReferenceType = "MDISP";
    public const String NonConformanceReferenceType =  "NCR";
    public const String CorrectiveActionReferenceType = "CAR";
    public const String ProjectReferenceType = "PROJ";

    public const String SecurityFileReference = "DFILE";
    public const String ChangeFileReferenceType = "COA";
    public const String TaskFileReferenceType = "TA";
    public const String HelpDeskTickets = "HDT";


    public const String DocumentStatus = "DocStatus";
    public const String ChangeStatus = "ChStatus";
    public const String TaskStatus = "TaskStatus";
    
}
