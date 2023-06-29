using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Activities.Statements;
using OpenQA.Selenium.Remote;

/// <summary>
/// Data Queries
/// </summary>
public static class DataQueries
{

    #region Table_AssigneeWkgrp

    public static String GetAssigneeWkgrpByID(Int32 ResourceID)
    {
        return "SELECT MAX(ContribPct), WorkgroupID AS [WorkGroup ID] FROM AssigneeWkgrp " +
               "WHERE (ResourceID = " + ResourceID + ") GROUP BY WorkgroupID";
    }

    #endregion

    #region Table_AttDefs

    public static String GetAttDefs(String AttachType, String AttachReference)
    {
        if (String.IsNullOrEmpty(AttachReference))
        {
            return "SELECT AttDir AS [Path] FROM AttDefs WHERE (AttType = '" + AttachType + "') AND (AttRef IS NULL)";
        }
        else
        {
            return "SELECT AttDir AS [Path] FROM AttDefs WHERE (AttType = '" + AttachType + "') AND (AttRef = '" + AttachReference + "')";
        }
    }

    #endregion

    #region Table_AttRefs  

    public static String InsertAttRefsFile(String RefType, String RefID, String FileName, String FileType,
                                           String FileLocation, String FileLink, String FileDesc,
                                           String PrintSize, String PrintLocation, Boolean WebView,
                                           DateTime UploadedOn, String UploadedBy)
    {
        return "INSERT INTO AttRefs " +
                "(RefType, RefID, " +
                " AttFName, AttFType, AttFLoc, AttFLink, " +
                " AttFDesc, PSize, PLoc, WebView," +
                " AttLUpd, AttLUpdBy)" +
              "VALUES" +
                "('" + RefType + "','" + RefID + "','" +
                  FileName + "','" + FileType + "'," +
                  (string.IsNullOrEmpty(FileLocation) ? "null" : "'" + FileLocation + "'") + "," +
                  (string.IsNullOrEmpty(FileLink) ? "null" : "'" + FileLink + "'") + "," +
                  (string.IsNullOrEmpty(FileDesc) ? "null" : "'" + FileDesc + "'") + "," +
                  (string.IsNullOrEmpty(PrintSize) ? "null" : "'" + PrintSize + "'") + "," +
                  (string.IsNullOrEmpty(PrintLocation) ? "null" : "'" + PrintLocation + "'") + "," +
                  WebView + ",'" +
                  UploadedOn + "','" +
                  UploadedBy + "')";
    }

    public static String UpdateAttRefsFile(String RefType, String RefID, String FileName, String FileType,
                                           String FileLocation, String FileLink, String FileDesc,
                                           String PrintSize, String PrintLocation, Boolean WebView,
                                           DateTime UploadedOn, String UploadedBy, Int32 AttachedID)
    {
        return "UPDATE AttRefs " +
                 "SET  RefType = '" + RefType + "'" +
                 ", RefID = '" + RefID + "'" +
                 ", AttFName = '" + FileName + "'" +
                 ", AttFType = '" + FileType + "'" +
                 ", AttFLoc = '" + FileLocation + "'" +
                 ", AttFLink = '" + FileLink + "'" +
                 ", AttFDesc = '" + FileDesc + "'" +
                 ", PSize = '" + PrintSize + "'" +
                 ", PLoc = '" + PrintLocation + "'" +
                 ", WebView = " + WebView +
                 ", AttLUpd = '" + UploadedOn + "'" +
                 ", AttLUpdBy = '" + UploadedBy + "'" +
             "WHERE AttID = " + AttachedID;
    }

    public static String DeleteAttRefsByID(Int32 AttachedID)
    {
        return "DELETE * FROM AttRefs WHERE (AttID = " + AttachedID + ")";
    }

    public static String DeleteAttRefsByID(String ReferenceType, String ReferenceID)
    {
        return "DELETE * FROM AttRefs WHERE (RefType = '" + ReferenceType + "') AND (RefID = '" + ReferenceID + "')";
    }

    #endregion

    #region Table_BOM

    public static String GetBOMByPartID(String PartID, String ItemRevision)
    {
        return "SELECT " +
               "A.BItemID AS [BOM Header ID], B.CItemID AS [BOM Item ID], B.SeqNum AS [Seq No], " +
               "B.CItemNum AS [Item No], B.CItemQty AS [Qty], B.CItemUOM AS [UOM], B.CItemDesc AS [Description], " +
               "B.CItemRev AS [Rev], B.BOMLStat AS [Status], B.RefDes AS [Ref Designator] " +
               "FROM BOMHdr A INNER JOIN BOMItems B ON A.BItemID = B.BItemID " +
               "WHERE (A.ItemNum = '" + PartID + "' AND B.CItemRev = '" + ItemRevision +
               "' ) ORDER BY B.SeqNum DESC";
    }

    #endregion

    #region Table_CfgRF

    public static String GetCfgRF(String TableName, String FieldName)
    {
        string qry = "SELECT RFReq AS RetVal FROM CfgRF WHERE (RFTable = '" + TableName + "') AND (RFField = '" + FieldName + "')";
        return qry;
    }

    #endregion

    #region Table_Changes

    public static String InsertChangesRequest(Int32 ChangeID, String RefType, String ChangeStatus, DateTime EndDate, DateTime StartDate,
                                             String ChangeClass, String ChangeType, String Description, String ProjectID, String Priority,
                                             String Justification, String ChangeRequestedBy, String ChangeApprovedBy, String ChangeAssignedTo,
                                             String ChangeCompletedBy, String ChangeReleasedBy, String LastModifiedBy, DateTime DateRequestedBy,
                                             DateTime DateApprovedBy, DateTime DateAssignedTo, DateTime DateCompletedBy, DateTime DateReleasedBy,
                                             DateTime DateModifiedBy, Int32 ChargeNo)
    {
        string ChangeClassValue = "null";
        if (ChangeClass != null) { ChangeClassValue = "'" + ChangeClass + "'"; }
        return "INSERT INTO Changes " +
                    "(CO, RefType, ChStatus, ChDue, ChEffDate, ChangeClass, ChangeType, ChangeDesc, ProjNum, ChPriority, ChJustification, " +
                    " ChReqBy, ChReqDate, ChApprBy, ChApprDate, ChAssignTo, ChAssignDate, ChCompletedBy, ChCompletedDate, ChReleasedBy, " +
                    " ChReleasedDate, LastModBy, LastModDate,ChargeNo)" +
                "VALUES ( " + ChangeID + ",'" + RefType + "','" + ChangeStatus + "','" + EndDate + "','" + StartDate + "',"
                            + ChangeClassValue + ",'" + ChangeType + "','" + Description + "','" + ProjectID + "','" + Priority + "','"
                            + Justification + "','" + ChangeRequestedBy + "','" + DateRequestedBy + "','" + ChangeApprovedBy + "','"
                            + DateApprovedBy + "','" + ChangeAssignedTo + "','" + DateAssignedTo + "','" + ChangeCompletedBy + "','"
                            + DateCompletedBy + "','" + ChangeReleasedBy + "','" + DateReleasedBy + "','" + LastModifiedBy + "','"
                            + DateModifiedBy + "','" + ChargeNo + "')";
    }

    internal static string GetTasksMaxID()
    {
        return "SELECT MAX(TaskID) AS [ID] FROM Tasks";
    }

    public static String UpdateChangesRequest(Int32 ChangeID, String RefType, String ChangeStatus,
                                              String LastModifiedBy, DateTime DateModifiedBy)
    {

        return "UPDATE Changes " +
               "SET  ChStatus = '" + ChangeStatus + "'" +
               ", LastModBy = '" + LastModifiedBy + "'" +
               ", LastModDate = '" + DateModifiedBy + "' " +
               "WHERE CO = " + ChangeID +
               " AND RefType = '" + RefType + "'";
    }

    public static String UpdateChangesRequest(Int32 ChangeID, String RefType, String ChangeStatus, DateTime EndDate, DateTime StartDate,
                                             String ChangeClass, String ChangeType, String Description, String ProjectID, String Priority,
                                             String Justification, String ChangeRequestedBy, String ChangeApprovedBy, String ChangeAssignedTo,
                                             String ChangeCompletedBy, String ChangeReleasedBy, String LastModifiedBy, DateTime DateRequestedBy,
                                             DateTime DateApprovedBy, DateTime DateAssignedTo, DateTime DateCompletedBy, DateTime DateReleasedBy,
                                             DateTime DateModifiedBy, Int32 ChargeNo)
    {
        string ChangeClassValue = "null";
        if (ChangeClass != null) { ChangeClassValue = "'" + ChangeClass + "'"; }
        return "UPDATE Changes " +
               "SET  ChStatus = '" + ChangeStatus + "'" +
               ", ChDue = '" + EndDate + "'" +
               ", ChEffDate = '" + StartDate + "'" +
               ", ChangeClass = " + ChangeClassValue +
               ", ChangeType = '" + ChangeType + "'" +
               ", ChangeDesc = '" + Description + "'" +
               ", ProjNum = '" + ProjectID + "'" +
               ", ChPriority = '" + Priority + "'" +
               ", ChJustification = '" + Justification + "'" +
               ", ChReqBy = '" + ChangeRequestedBy + "'" +
               ", ChReqDate = '" + DateRequestedBy + "'" +
               ", ChApprBy = '" + ChangeApprovedBy + "'" +
               ", ChApprDate = '" + DateApprovedBy + "'" +
               ", ChAssignTo = '" + ChangeAssignedTo + "'" +
               ", ChAssignDate = '" + DateAssignedTo + "'" +
               ", ChCompletedBy = '" + ChangeCompletedBy + "'" +
               ", ChCompletedDate = '" + DateCompletedBy + "'" +
               ", ChReleasedBy = '" + ChangeReleasedBy + "'" +
               ", ChReleasedDate = '" + DateReleasedBy + "'" +
               ", LastModBy = '" + LastModifiedBy + "'" +
               ", LastModDate = '" + DateModifiedBy + "'" +
                ", ChargeNo = '" + ChargeNo + "'" +
               "WHERE CO = " + ChangeID +
               " AND RefType = '" + RefType + "'";
    }

    public static String DeleteChangesByID(String ReferenceType, Int32 ChangeID)
    {
        return "DELETE * FROM Changes WHERE (RefType = '" + ReferenceType + "') AND (CO = " + ChangeID + ")";
    }

    #endregion

    #region Table_COImpact

    public static String InsertCOImpact(Int32 OrderID, Int32 LineItemID, Int32 COID)
    {
        return "INSERT INTO COImpact (OrderID, LineItemID, CO) " +
                "VALUES (" + OrderID + ", " + LineItemID + ", " + COID + ")";
    }

    public static String DeleteCOImpactByID(Int32 OrderID, Int32 LineItemID, Int32 COID)
    {
        return "DELETE * FROM COImpact WHERE (CO = " + COID + ") AND (OrderID = " + OrderID + ") AND  (LineItemID = " + LineItemID;
    }

    public static String DeleteCOImpactByID(Int32 COID)
    {
        return "DELETE * FROM COImpact WHERE (CO = " + COID + ")";
    }

    #endregion

    #region Table_Custom
    public static String GetCustomLabels(String strType)
    {
        return "SELECT * FROM UDFLabels WHERE (UDFLblRef = '" + strType + "')";
    }

    public static String GetCustomValues(String RefId, String strType)
    {
        return "SELECT UDF1, UDF2, UDF3, UDF4, UDF5, UDF6, UDF7, UDF8, UDF9, UDF10 " +
                     "FROM CustomUDF WHERE (RefType =" + "'" + strType + "'" + ") AND (RefID = '" + RefId + "')";
    }

    public static String getCustomExistCount(String RefId, String RefType)
    {
        return "Select count(UDFRefID) as ExistCount from CustomUDF  where RefID='" + RefId +
            "' and RefType='" + RefType + "'";
    }

    public static String InsertCustomValues(String RefId, String RefType, String[] customValues,
                                            Int32 CusUDF7, Int32 CusUDF8, Int32 CusUDF9,
                                            Int32 CusUDF10, String InsertUpdateInd)
    {
        String strsql = "";
        Int32 datalen = customValues.Length;
        String strvalues = "";

        if (InsertUpdateInd == "I")
        {
            strsql = "INSERT INTO CustomUDF(RefType,RefID,";
            strvalues = " VALUES('" + RefType + "','" + RefId + "',";

            for (Int32 i = 0; i < datalen; i++)
            {
                if (customValues[i] != null && customValues[i].Length > 0)
                {
                    strsql = strsql + "UDF" + (i + 1) + ",";
                    strvalues = strvalues + "'" + customValues[i].Replace("'", "`") + "',";
                }

            }

            strsql = strsql + "UDF7, UDF8, UDF9, UDF10 )";
            strvalues = strvalues + " " + CusUDF7 + "," +
                  CusUDF8 + "," + CusUDF9 + "," + CusUDF10 + ")";

            strsql = strsql + strvalues;
        }
        else
        {
            strsql = "Update CustomUDF set ";

            for (Int32 i = 0; i < datalen; i++)
            {
                if (customValues[i] != null && customValues[i].Length > 0)
                {
                    strsql = strsql + "UDF" + (i + 1) + "='" + customValues[i].Replace("'", "`") + "',";
                }
            }

            strsql = strsql + "UDF7=" + CusUDF7 + ",UDF8=" + CusUDF8 + ",UDF9=" + CusUDF9 + ",UDF10=" + CusUDF10 +
            " Where RefID='" + RefId + "' and RefType='" + RefType + "'";
        }

        return strsql;

    }
    #endregion

    #region Table_ControlListRefs

    public static String DeleteControlListRefs(String RefType, String RefID, int CList)
    {
        return "DELETE * FROM ControlListRefs WHERE CLRefID = " + CList + "";
    }

    public static String DeleteControlListRefs(String RefType, String RefID)
    {
        return "DELETE * FROM ControlListRefs WHERE (RefType = '" + RefType + "') AND (RefID = '" + RefID + "')";
    }

    public static String InsertControlListRefs(String RefType, String RefID, String ControlList)
    {
        return "INSERT INTO ControlListRefs " +
               "(RefType, RefID, ControlList) " +
               "VALUES " +
                "('" + RefType + "','" + RefID + "','" + ControlList + "')";
    }

    #endregion

    #region Table_DocFiles

    public static String DeleteDocFiles(String DOCID)
    {
        return "DELETE * FROM DocFiles WHERE (DocID = '" + DOCID + "')";
    }

    public static String DeleteDocFilesByID(Int32 FileID)
    {
        return "DELETE * FROM DocFiles WHERE (FileID = " + FileID + "')";
    }

    public static String InsertDocFiles(String DocumentID, Int32 FileID, String FileName, String Status,
                                        String FileDesc, String FileType, String FileLocation, String FileLink,
                                        String FileCreatedBy, DateTime FileCreatedDate, String PrintSize,
                                        String PrintLocation, Boolean WebView)
    {
        return "INSERT INTO DocFiles " +
                "(DocID, " +
                " FileName, FileStatus, FileDesc, FileType, " +
                " FileLocation, FileLink, FileCreatedBy, FileCreated," +
                " PSize, PLoc, WebView)" +
              "VALUES" +
                "('" + DocumentID + "','" +
                  FileName + "','" + Status + "','" + FileDesc + "','" + FileType + "','" +
                  FileLocation + "','" + FileLink + "','" + FileCreatedBy + "','" + FileCreatedDate + "','" +
                  PrintSize + "','" + PrintLocation + "'," + WebView + ")";
    }

    //public static string UpdateTasks(DateTime overrunEndDate, float overrunHours, decimal overrunCost, DateTime actualStartDate, DateTime actualEndDate, float actualHours, decimal actualCost, float percentComplete, int taskID)
    //{
    //    throw new NotImplementedException();
    //}
    public static String UpdateTasks(DateTime EstOverrunFinish, Single OverrunHours, Decimal OverrunCost,
                                     DateTime ActualStart, DateTime ActualFinish, Single ActualHours,
                                     Decimal ActualCost, Single PercentComplete, Int32 TaskID)
    {

        return "UPDATE Tasks " +
               "SET OverrunEstFinish = '" + EstOverrunFinish + "', " +
                    "OverrunHrs = " + OverrunHours + ", " +
                    "OvrCost = " + OverrunCost + ", " +
                    "ActualStart = '" + ActualStart + "', " +
                    "ActualFinish = '" + ActualFinish + "', " +
                    "ActualHours = " + ActualHours + ", " +
                    "ActualCost = " + ActualCost + ", " +
                    "PcntComplete = " + PercentComplete + " " +
              "WHERE ( TaskID = " + TaskID + ")";
    }

    public static String UpdateDocFiles(String DocumentID, Int32 FileID, String FileName, String Status,
                                        String FileDesc, String FileType, String FileLocation, String FileLink,
                                        String FileCreatedBy, DateTime FileCreatedDate, String PrintSize,
                                        String PrintLocation, Boolean WebView)
    {
        return "UPDATE DocFiles " +
                   "SET  FileName = '" + FileName + "'" +
                   ", FileStatus = '" + Status + "'" +
                   ", FileDesc = '" + FileDesc + "'" +
                   ", FileType = '" + FileType + "'" +
                   ", FileLocation = '" + FileLocation + "'" +
                   ", FileLink = '" + FileLink + "'" +
                   ", FileCreatedBy = '" + FileCreatedBy + "'" +
                   ", FileCreated = '" + FileCreatedDate + "'" +
                   ", PSize = '" + PrintSize + "'" +
                   ", PLoc = '" + PrintLocation + "'" +
                   ", WebView = " + WebView +
               " WHERE (DocID = '" + DocumentID + "') AND (FileID = " + FileID + ")";
    }

    //public static string UpdateTasksStatus(int taskID, string taskStatusCode)
    //{
    //    throw new NotImplementedException();
    //}
    public static String UpdateTasksStatus(Int32 TaskID, String TaskStatus)
    {

        return "UPDATE Tasks " +
               "SET TaskStatus = '" + TaskStatus + "' " +
               "WHERE ( TaskID = " + TaskID + ")";
    }
    #endregion

    #region Table_Documents

    public static String GetDocumentsMaxID(String SearchSegment, Int32 RangeStart, Int32 RangeStop)
    {
        //return "SELECT MAX(DocID) AS [MaxID] FROM Documents " +
        //       "WHERE (DocID LIKE '" + SearchSegment + "*') " +
        //              "AND (Mid(DocID," + (SearchSegment.Length + 1) + ", LEN(DocID)-" + SearchSegment.Length +
        //              ") BETWEEN " + RangeStart + " AND " + RangeStop + ")";


        return "SELECT MAX(DocID) AS [MaxID] FROM Documents " +
               "WHERE (DocID LIKE '" + SearchSegment + "[0-9]*') " +
                     "AND (Mid(IIF(InStr(DocID, '-') > 0, Left(DocID, InStr(DocID, '-') - 1), DocID)," + (SearchSegment.Length + 1) + ", LEN(IIF(InStr(DocID, '-') > 0, Left(DocID, InStr(DocID, '-') - 1), DocID))-" + SearchSegment.Length +
                     ") BETWEEN " + RangeStart + " AND " + RangeStop + ")";
    }

    public static String GetDocumentsByID(String DOCID)
    {
        return "SELECT " +
               "DocID AS [Document ID], DocStatus AS [Document Status], CurrentRev AS [Current Revision], " +
               "DocDesc AS [Document Description], DocReqBy AS [Requested By] " +
               "FROM Documents " +
               "WHERE (DocID = '" + DOCID + "') ORDER BY DocID";
    }

    public static string GetTasksStatus(int parallelTaskID)
    {
        throw new NotImplementedException();
    }

    public static String InsertDocument(String DOCID, String DocStatus, String CurrentRevision,
                                        String Description, String Discipline, String DocType, String IsTabulated,
                                        String ProjectID, String RequestedBy, DateTime RequestedDate, String CreatedBy,
                                        DateTime CreatedDate, String ReviewedBy, DateTime ReviewedDate, String ReleasedBy,
                                        DateTime ReleasedDate, String ObsoletedBy, DateTime ObsoletedDate, DateTime ExpDate,
                                        String LastModifiedBy, DateTime LastModifiedDate)
    {
        return "INSERT INTO Documents " +
               "(DocID, DocStatus, CurrentRev, DocDesc, " +
               " Discipline, DocType, Tabulated, ProjNum, " +
               " DocReqBy, DocReqDate, DocCreatedBy, DocCreatedDate, " +
               " DocReviewBy, DocReviewDate, DocRelRef, DocRelDate, " +
               " DocObsRef , DocObsDate, DocExpDate, LastModBy, " +
               " LastModDate) " +
               "VALUES " +
               "( '" + DOCID + "', '" + DocStatus + "', '" + CurrentRevision + "', '" + Description + "', '" +
                  Discipline + "', '" + DocType + "', '" + IsTabulated + "', '" + ProjectID + "', '" +
                  RequestedBy + "', '" + RequestedDate + "', '" + CreatedBy + "', '" + CreatedDate + "', '" +
                  ReviewedBy + "', '" + ReviewedDate + "', '" + ReleasedBy + "', '" + ReleasedDate + "', '" +
                  ObsoletedBy + "', '" + ObsoletedDate + "', '" + ExpDate + "', '" + LastModifiedBy + "', '" +
                  LastModifiedDate + "')";
    }

    //public static string InsertTasks(string chargeAccountCode, string taskStatus, string wFActionName, string taskProjectCode, string wFStandardTaskCode, string taskCostType, string refTypeCode, string refID, int v1, string taskPriority, int assignByID, int assignToID, DateTime currentDate, string assignToWorkGroup, string wFStepDescription, DateTime stepStartDate, DateTime stepCompleteDate, float hours, float duration, decimal cost, DateTime minDate1, float v2, int v3, DateTime minDate2, DateTime minDate3, float v4, int v5, float v6, string v7)
    //{
    //    throw new NotImplementedException();
    //}

    public static String UpdateDocumentByID(String DOCID, String DocStatus, String CurrentRevision,
                                             String LastModifiedBy, DateTime LastModifiedDate)
    {

        return "UPDATE Documents " +
               "SET DocStatus = '" + DocStatus + "', " +
                    "CurrentRev = '" + CurrentRevision + "', " +
                    "LastModBy = '" + LastModifiedBy + "', " +
                    "LastModDate = '" + LastModifiedDate + "' " +
               "WHERE ( DocID = '" + DOCID + "')";
    }

    public static String UpdateDocumentByID(String DOCID, String DocStatus, String LastModifiedBy,
                                            DateTime LastModifiedDate)
    {
        return "UPDATE Documents " +
               "SET DocStatus = '" + DocStatus + "', " +
                   "LastModBy = '" + LastModifiedBy + "', " +
                   "LastModDate = '" + LastModifiedDate + "' " +
               "WHERE ( DocID = '" + DOCID + "')";
    }

    public static String UpdateDocumentByID(String DOCID, String DocStatus, String CurrentRevision,
                                            String Description, String Discipline, String DocType, String IsTabulated,
                                            String ProjectID, String RequestedBy, DateTime RequestedDate, String CreatedBy,
                                            DateTime CreatedDate, String ReviewedBy, DateTime ReviewedDate, String ReleasedBy,
                                            DateTime ReleasedDate, String ObsoletedBy, DateTime ObsoletedDate, DateTime ExpDate,
                                            String LastModifiedBy, DateTime LastModifiedDate)
    {

        return "UPDATE Documents " +
               "SET DocStatus = '" + DocStatus + "', " +
                     "CurrentRev = '" + CurrentRevision + "', " +
                     "DocDesc = '" + Description + "', " +
                     "Discipline = '" + Discipline + "', " +
                     "DocType = '" + DocType + "', " +
                     "Tabulated = '" + IsTabulated + "', " +
                     "ProjNum = '" + ProjectID + "', " +
                     "DocReqBy = '" + RequestedBy + "', " +
                     "DocReqDate = '" + RequestedDate + "', " +
                     "DocCreatedBy = '" + CreatedBy + "', " +
                     "DocCreatedDate = '" + CreatedDate + "', " +
                     "DocReviewBy = '" + ReviewedBy + "', " +
                     "DocReviewDate = '" + ReviewedDate + "', " +
                     "DocRelRef = '" + ReleasedBy + "', " +
                     "DocRelDate = '" + ReleasedDate + "', " +
                     "DocObsRef = '" + ObsoletedBy + "', " +
                     "DocObsDate = '" + ObsoletedDate + "', " +
                     "DocExpDate = '" + ExpDate + "', " +
                     "LastModBy = '" + LastModifiedBy + "', " +
                     "LastModDate = '" + LastModifiedDate + "' " +
                "WHERE ( DocID = '" + DOCID + "')";
    }

    //public static string UpdateTasks(string chargeCode, string taskStatusCode, string taskDescription, string project, string stdTaskCode, string headerControlRefCode, string headerControlRefID, string priority, int assignByID, int assignToID, DateTime currentDate, string stepDescription, DateTime plannedStartDate, DateTime plannedEndDate, float plannedHours, decimal plannedCost, DateTime overrunEndDate, float overrunHours, decimal overrunCost, DateTime actualStartDate, DateTime actualEndDate, float actualHours, decimal actualCost, float percentComplete, int taskID)
    //{
    //    throw new NotImplementedException();
    //}
    public static String UpdateTasks(String ChargeAccount, String TaskStatus, String TaskDescription,
                                     String ProjectID, String TaskType, String CostType, String ReferenceType,
                                     String ReferenceID, Int32 ParentTask, String TaskPriority, Int32 AssignBy,
                                     Int32 AssignTo, DateTime DateAssignedTo, String AssignWG, String TaskDetail,
                                     DateTime PlannedStart, DateTime PlannedFinish, Single EstHours, Decimal EstCost,
                                     DateTime EstOverrunFinish, Single OverrunHours, Decimal OverrunCost, DateTime ActualStart,
                                     DateTime ActualFinish, Single ActualHours, Decimal ActualCost, Single PercentComplete,
                                     String IsScheduleVisible, Int32 TaskID)
    {

        return "UPDATE Tasks " +
               "SET ChargeAcct = '" + ChargeAccount + "'," +
                    "TaskStatus = '" + TaskStatus + "'," +
                    "TaskDesc = '" + TaskDescription + "'," +
                    "ProjNum = '" + ProjectID + "'," +
                    "StdTaskID = '" + TaskType + "'," +
                    "TaskCostType = '" + CostType + "'," +
                    "RefType = '" + ReferenceType + "'," +
                    "RefNum = '" + ReferenceID + "'," +
                    "ParentTask = '" + ParentTask + "'," +
                    "TaskPriority = '" + TaskPriority + "'," +
                    "AssignBy = " + AssignBy + "," +
                    "AssignTo = " + AssignTo + "," +
                    "DateAssigned = '" + DateAssignedTo + "'," +
                    "AssignWkgrp = '" + AssignWG + "'," +
                    "TaskDetail = '" + TaskDetail + "'," +
                    "PlannedStart = '" + PlannedStart + "'," +
                    "PlannedFinish = '" + PlannedFinish + "'," +
                    "EstHours = " + EstHours + "," +
                    "EstCost = " + EstCost + "," +
                    "OverrunEstFinish = '" + EstOverrunFinish + "'," +
                    "OverrunHrs = " + OverrunHours + "," +
                    "OvrCost = " + OverrunCost + "," +
                    "ActualStart = '" + ActualStart + "'," +
                    "ActualFinish = '" + ActualFinish + "'," +
                    "ActualHours = " + ActualHours + "," +
                    "ActualCost = " + ActualCost + "," +
                    "PcntComplete = " + PercentComplete + "," +
                    "SchedVisible = '" + IsScheduleVisible + "' " +
              "WHERE ( TaskID = " + TaskID + ")";
    }

    public static String UpdateTasks(String ChargeAccount, String TaskStatus, String TaskDescription,
                                     String ProjectID, String TaskType, String ReferenceType,
                                     String ReferenceID, String TaskPriority, Int32 AssignBy,
                                     Int32 AssignTo, DateTime DateAssignedTo, String TaskDetail,
                                     DateTime PlannedStart, DateTime PlannedFinish, Single EstHours, Decimal EstCost,
                                     DateTime EstOverrunFinish, Single OverrunHours, Decimal OverrunCost, DateTime ActualStart,
                                     DateTime ActualFinish, Single ActualHours, Decimal ActualCost, Single PercentComplete,
                                     Int32 TaskID)
    {

        return "UPDATE Tasks " +
               "SET ChargeAcct = '" + ChargeAccount + "', " +
                    "TaskStatus = '" + TaskStatus + "', " +
                    "TaskDesc = '" + TaskDescription + "', " +
                    "ProjNum = '" + ProjectID + "', " +
                    "StdTaskID = '" + TaskType + "', " +
                    //"TaskCostType = '" + CostType + "', " +
                    "RefType = '" + ReferenceType + "', " +
                    "RefNum = '" + ReferenceID + "', " +
                    //"ParentTask = '" + ParentTask + "', " +
                    "TaskPriority = '" + TaskPriority + "', " +
                    "AssignBy = " + AssignBy + ", " +
                    "AssignTo = " + AssignTo + ", " +
                    "DateAssigned = '" + DateAssignedTo + "', " +
                    //"AssignWkgrp = '" + AssignWG + "', " +
                    "TaskDetail = '" + TaskDetail + "', " +
                    "PlannedStart = '" + PlannedStart + "', " +
                    "PlannedFinish = '" + PlannedFinish + "', " +
                    "EstHours = " + EstHours + ", " +
                    "EstCost = " + EstCost + ", " +
                    "OverrunEstFinish = '" + EstOverrunFinish + "', " +
                    "OverrunHrs = " + OverrunHours + ", " +
                    "OvrCost = " + OverrunCost + ", " +
                    "ActualStart = '" + ActualStart + "', " +
                    "ActualFinish = '" + ActualFinish + "', " +
                    "ActualHours = " + ActualHours + ", " +
                    "ActualCost = " + ActualCost + ", " +
                    "PcntComplete = " + PercentComplete + " " +
              //"SchedVisible = '" + IsScheduleVisible + "' " +
              "WHERE ( TaskID = " + TaskID + ")";
    }

    public static String DeleteDocumentsByID(String DocID)
    {
        return "DELETE * FROM Documents WHERE (DocID = '" + DocID + "')";
    }

    #endregion

    #region Table_EWebSessions

    public static String GetEWebSessions(String SessionID)
    {
        return "SELECT UID As [User ID], EmpID As [Emp ID], ULNF As [User Name], ProfileID As [ProfileID], " +
               "SessionStart As [Session Start] FROM EWebSessions WHERE (SessionID = '" + SessionID + "') ORDER BY ULNF";
    }

    public static String InsertEWebSessions(String SessionID, String UserID, String UserName,
                                            Int32 EmpID, Int32 ProfileID, DateTime SessionDate)
    {
        return "INSERT INTO EWebSessions (SessionID, UID, EmpID, ULNF, ProfileID, SessionStart) " +
               "VALUES ( '" + SessionID + "', '" + UserID + "', " + EmpID + ", '" + UserName + "', " +
                             ProfileID + ", '" + SessionDate + "')";
    }

    public static String DeleteEWebSessionsByUserID(String UserID)
    {
        return "DELETE * FROM EWebSessions WHERE (UID = '" + UserID + "')";
    }

    public static String DeleteEWebSessionsBySessionID(String SessionID)
    {
        return "DELETE * FROM EWebSessions WHERE (SessionID = '" + SessionID + "')";
    }

    public static String DeleteEWebSessions(DateTime SessionStart)
    {
        return "DELETE * FROM EWebSessions WHERE (SessionStart < #" + SessionStart + "#)";
    }

    #endregion

    #region Table_MachineSettings

    public static String GetMachineSettingsBySectParamID(String Section, String Item, String MachineID)
    {
        return "SELECT MPValue AS [Return Value] FROM MachineSettings WHERE (MPSection = '" + Section + "') AND (MParam = '" + Item +
               "') AND (MID = '" + MachineID + "') ORDER BY MPValue";
    }

    #endregion

    #region Table_MatDisp

    public static String GetMaxMatDispID()
    {
        return "SELECT MAX(MatDispID) AS [ID] FROM MatDisp";
    }

    public static String InsertTasks(String ChargeAccount, String TaskStatus, String TaskDescription,
                                     String ProjectID, String TaskType, String CostType, String ReferenceType,
                                     String ReferenceID, Int32 ParentTask, String TaskPriority, Int32 AssignBy,
                                     Int32 AssignTo, DateTime DateAssignedTo, String AssignWG, String TaskDetail,
                                     DateTime PlannedStart, DateTime PlannedFinish, Single EstHours, Single Duration,
                                     Decimal EstCost, DateTime EstOverrunFinish, Single OverrunHours, Decimal OverrunCost,
                                     DateTime ActualStart, DateTime ActualFinish, Single ActualHours, Decimal ActualCost,
                                     Single PercentComplete, String IsScheduleVisible)
    {
        return "INSERT INTO Tasks " +
                     "(ChargeAcct, TaskStatus, TaskDesc, ProjNum, StdTaskID, " +
                     "TaskCostType, RefType, RefNum, ParentTask, " +
                     "TaskPriority,AssignBy,AssignTo, DateAssigned, " +
                     "AssignWkgrp,TaskDetail,PlannedStart,PlannedFinish, " +
                     "EstHours, EstDur, EstCost,OverrunEstFinish,OverrunHrs, OvrCost, " +
                     "ActualStart,ActualFinish,ActualHours,ActualCost, " +
                     "PcntComplete,SchedVisible) " +
             "VALUES ('" +
                    ChargeAccount + "','" + TaskStatus + "','" + TaskDescription + "','" + ProjectID + "','" + TaskType + "','" +
                    CostType + "','" + ReferenceType + "','" + ReferenceID + "'," + ParentTask + ",'" + TaskPriority + "'," + AssignBy + "," +
                    AssignTo + ",'" + DateAssignedTo + "','" + AssignWG + "','" + TaskDetail + "','" + PlannedStart + "','" +
                    PlannedFinish + "'," + EstHours + "," + Duration + "," + EstCost + ",'" + EstOverrunFinish + "'," + OverrunHours + "," +
                    OverrunCost + ",'" + ActualStart + "','" + ActualFinish + "'," + ActualHours + "," + ActualCost + "," +
                    PercentComplete + ",'" + IsScheduleVisible + "')";
    }
    public static String InsertIntoTasks(Int32 parentId, String taskStatusCode, String taskPriority, String taskcost, DateTime DateAssigned, Single PcntComplete, String ChargeAcct, String RefType,
    String RefNum, String ProjNum, String StdTaskID, String TaskDesc, String TaskDetail, DateTime PlannedStart, DateTime PlannedFinish, Single EstHours, Decimal EstDur,
    Decimal EstCost, Single OverrunHrs, DateTime OverrunEstFinish, Decimal OvrCost,
    DateTime ActualStart, DateTime ActualFinish, Single ActualHours, Decimal ActualCost, Int32 AssignBy, Int32 AssignTo, String AssignWkgrp, String SchedVisible)
    {
        return "INSERT INTO Tasks(ParentTask, TaskStatus, TaskPriority, TaskCostType, DateAssigned, " +
                           "PcntComplete, ChargeAcct, RefType, RefNum,ProjNum,StdTaskID,TaskDesc,TaskDetail,PlannedStart,PlannedFinish,EstHours,EstDur,EstCost,OverrunHrs,OverrunEstFinish,OvrCost,ActualStart,ActualFinish,ActualHours,ActualCost,AssignBy,AssignTo,AssignWkgrp,SchedVisible) " +
                   "VALUES(" + parentId + ",'" + taskStatusCode + "','" + taskPriority + "','" + taskcost + "','" + DateAssigned + "'," +
                           PcntComplete + ",'" + ChargeAcct + "','" + RefType + "','" + RefNum + "','" +
                           ProjNum + "','" + StdTaskID + "','" + TaskDesc + "','" + TaskDetail + "','" +
                           PlannedStart + "','" + PlannedFinish + "'," + EstHours + "," + EstDur + ",'" +
                           EstCost + "','" + OverrunHrs + "','" + OverrunEstFinish + "','" + OvrCost + "','" +
                           ActualStart + "','" + ActualFinish + "','" + ActualHours + "','" + ActualCost + "'," +
                           AssignBy + "," + AssignTo + ",'" + AssignWkgrp + "','" + SchedVisible + "')";

    }
    public static String UpdateIntoTasks(Int32 parentId, String taskStatusCode, String taskPriority, String taskcost, DateTime DateAssigned, Single PcntComplete, String ChargeAcct, String RefType,
    String RefNum, String ProjNum, String StdTaskID, String TaskDesc, String TaskDetail, DateTime PlannedStart, DateTime PlannedFinish, Single EstHours, Decimal EstDur,
    Decimal EstCost, Single OverrunHrs, DateTime OverrunEstFinish, Decimal OvrCost,
    DateTime ActualStart, DateTime ActualFinish, Single ActualHours, Decimal ActualCost, Int32 AssignBy, Int32 AssignTo, String AssignWkgrp, String SchedVisible, Int32 TaskID)
    {
        string updateQry = "UPDATE Tasks " +
                        " SET ParentTask = " + parentId + "," +
                        "  TaskStatus = '" + taskStatusCode + "'," +
                        "  TaskPriority = '" + taskPriority + "'," +
                        "  TaskCostType = '" + taskcost + "'," +
                        "  DateAssigned = '" + DateAssigned + "'," +
                        "  ChargeAcct = '" + ChargeAcct + "'," +
                        "  RefType = '" + RefType + "'," +
                        "  RefNum = '" + RefNum + "'," +
                        "  ProjNum = '" + ProjNum + "'," +
                        "  StdTaskID = '" + StdTaskID + "'," +
                        "  TaskDesc = '" + TaskDesc + "'," +
                        "  TaskDetail = '" + TaskDetail + "'," +
                        "  PlannedStart = '" + PlannedStart + "'," +
                        "  PlannedFinish = '" + PlannedFinish + "'," +
                        "  EstHours = " + EstHours + "," +
                        "  EstDur = " + EstDur + "," +
                        "  EstCost = '" + EstCost + "'," +
                        "  OverrunHrs = '" + OverrunHrs + "'," +
                        "  OverrunEstFinish = '" + OverrunEstFinish + "'," +
                        "  OvrCost = '" + OvrCost + "'," +
                        "  ActualStart = '" + ActualStart + "'," +
                        "  ActualFinish = '" + ActualFinish + "'," +
                        "  ActualHours = '" + ActualHours + "'," +
                        "  ActualCost = '" + ActualCost + "'," +
                        "  AssignBy = " + AssignBy + "," +
                        "  AssignTo = " + AssignTo + "," +
                        "  AssignWkgrp = '" + AssignWkgrp + "'," +
                        "  SchedVisible = '" + SchedVisible + "'" +
                " WHERE TaskID = " + TaskID;
        return updateQry;
    }


    public static String InsertMatDisp(Int32 COID, String OrderBatchDate, String DispStatus, DateTime StartDate, DateTime EndDate,
                                       String ImpactArea, String DispositionType, Int32 DispAssignedTo, Decimal DispCost)
    {

        return "INSERT INTO MatDisp(CO, OrderDateBatch, DispStatus, DispEffDate, DateDue, " +
                           "ImpactArea, DispositionType, DispAssignTo, DispCost) " +
                   "VALUES(" + COID + ",'" + OrderBatchDate + "','" + DispStatus + "','" + StartDate + "','" + EndDate + "','" +
                           ImpactArea + "','" + DispositionType + "'," + DispAssignedTo + "," + DispCost + ")";
    }

    public static String UpdateMatDisp(Int32 COID, String OrderBatchDate, String DispStatus, DateTime StartDate, DateTime EndDate,
                                       String ImpactArea, String DispositionType, Int32 DispAssignedTo, Decimal DispCost,
                                       Int32 MatDispID)
    {
        return "UPDATE MatDisp " +
                        " SET CO = " + COID + "," +
                        "  OrderDateBatch = '" + OrderBatchDate + "'," +
                        "  DispStatus = '" + DispStatus + "'," +
                        "  DispEffDate = '" + StartDate + "'," +
                        "  DateDue = '" + EndDate + "'," +
                        "  ImpactArea = '" + ImpactArea + "'," +
                        "  DispositionType = '" + DispositionType + "'," +
                        "  DispAssignTo = " + DispAssignedTo + "," +
                        "  DispCost = '" + DispCost + "'" +
                " WHERE MatDispID = " + MatDispID;
    }

    public static String DeleteMatDispByID(Int32 MatDispID)
    {
        return "DELETE * FROM MatDisp WHERE (MatDispID = " + MatDispID + ")";
    }

    #endregion

    #region Table_MyReports
    public static String GetMyReports(Int32 ReportID, Int32 EmpId, bool IsAdmin)
    {
        String SQLText = "";
        SQLText = " SELECT ReportId AS [Report ID], Name AS [Report Name], " +
            " ReportDesc AS [Report Desc], UserName As [User Name], Role " +
            " FROM QReports";

        if (ReportID > 0 || EmpId > 0)
        {
            SQLText = SQLText + " WHERE (1 = 1 ";

            if (!IsAdmin && EmpId > 0)
            {
                SQLText = SQLText + " And EmpId = " + EmpId;
            }
            if (ReportID > 0)
            {
                SQLText = SQLText + " And ReportId = " + ReportID;
            }
            //SQLText = SQLText + " WHERE (ReportId = " + ReportID + ") ORDER BY ReportId";

            SQLText = SQLText + " ) ORDER BY ReportId ";
            return SQLText;
        }
        else
        {
            return SQLText;
        }
    }

    public static String DeleteMyReportsByID(Int32 ReportID)
    {
        return "DELETE * FROM MyReports WHERE (ReportId = " + ReportID + ")";
    }
    #endregion

    #region Table_Notes

    public static String InsertNotes(String ReferenceType, String ReferenceID, DateTime NoteDateTime, String UserID,
                                     String NoteType, String NoteSubject, String NoteText)
    {
        return "INSERT INTO Notes(RefType, RefID, NoteDT, UID, NoteType, NoteSubj, NoteTxt) " +
               "VALUES( '" + ReferenceType + "','" + ReferenceID + "','" + NoteDateTime + "','" + UserID + "','" +
                        NoteType + "','" + NoteSubject + "','" + NoteText + "')";
    }

    public static String DeleteNotesByIDType(Int32 NoteID, String ReferenceType)
    {
        return "DELETE * FROM Notes WHERE (RefType = '" + ReferenceType + "') AND (NoteID = " + NoteID + ")";
    }

    public static String DeleteNotesByRefIDType(String ReferenceID, String ReferenceType)
    {
        return "DELETE * FROM Notes WHERE (RefType = '" + ReferenceType + "') AND (RefID = '" + ReferenceID + "')";
    }

    #endregion 

    #region Table_PartsXRef

    public static String GetPartsXRefMaxID(String SearchSegment, Int32 RangeStart, Int32 RangeStop)
    {
        return "SELECT MAX(PartNo) AS [MaxID] FROM PartsXRef " +
               "WHERE (PartNo LIKE '" + SearchSegment + "%') " +
                      "AND (Mid(PartNo," + (SearchSegment.Length + 1) + ", LEN(PartNo)-" + SearchSegment.Length +
                      ") BETWEEN " + RangeStart + " AND " + RangeStop + ")";
    }

    public static String GetPartsXRefByID(String PartNumber)
    {
        return "SELECT " +
               "PartID AS [Part ID],PartNo AS [Part Number], DocID AS [Document ID] " +
               "FROM PartsXRef " +
               "WHERE (PartNo = '" + PartNumber + "') ORDER BY PartNo";
    }

    public static String DeletePartsXRefByID(Int32 PartID)
    {
        return "DELETE * FROM PartsXRef WHERE (PartID = " + PartID + ")";
    }

    public static String DeletePartsXRefByID(String DocID)
    {
        return "DELETE * FROM PartsXRef WHERE (DocID = '" + DocID + "')";
    }

    public static String InsertPartsXRef(String PartNumber, String DocID, Int32 FileID, String Description,
                                         String RevisionType, String CurrentRevision, String RevisionStatus,
                                         DateTime StartDate, DateTime ExpDate, Boolean FAIRequired,
                                         DateTime FAIDate, Decimal Cost, String LifecycleStatus)
    {
        return "INSERT INTO PartsXRef " +
                "(PartNo, DocID, " +
                " FileID, PartDesc, RevType, CurRev, " +
                " RevStatus, EffDate, ExpDate, FAI," +
                " FAIDate, Cost, LifeCycleStatus)" +
              "VALUES" +
                "('" + PartNumber + "','" + DocID + "'," +
                  FileID + ",'" + Description + "','" + RevisionType + "','" + CurrentRevision + "','" +
                  RevisionStatus + "','" + StartDate + "','" + ExpDate + "'," + FAIRequired + ",'" +
                  FAIDate + "'," + Cost + ",'" + LifecycleStatus + "')";
    }

    public static String UpdatePartsXRef(String PartNumber, String DocID, Int32 FileID, String Description,
                                         String RevisionType, String CurrentRevision, String RevisionStatus,
                                         DateTime StartDate, DateTime ExpDate, Boolean FAIRequired,
                                         DateTime FAIDate, Int32 PartID, Decimal Cost, String LifecycleStatus)
    {
        return "UPDATE PartsXRef " +
                 "SET  PartNo = '" + PartNumber + "'" +
                 ", FileID = " + FileID +
                 ", PartDesc = '" + Description + "'" +
                 ", RevType = '" + RevisionType + "'" +
                 ", CurRev = '" + CurrentRevision + "'" +
                 ", RevStatus = '" + RevisionStatus + "'" +
                 ", EffDate = '" + StartDate + "'" +
                 ", ExpDate = '" + ExpDate + "'" +
                 ", FAI = " + FAIRequired +
                 ", Cost = " + Cost +
                 ", LifecycleStatus = '" + LifecycleStatus + "'" +
                 ", FAIDate = '" + FAIDate + "'" +
             " WHERE (PartID = " + PartID + ") AND (DocID = '" + DocID + "')";
    }

    #endregion

    #region Table_ProjXRef

    public static String GetProjXRefList()
    {
        return "SELECT ProjNum AS [ID], ProjName AS [Description] FROM ProjXRef ";
    }

    public static String DeleteProjXRefByID(String ProjectNumber)
    {
        return "DELETE * FROM ProjXRef WHERE (ProjNum = '" + ProjectNumber + "')";
    }

    public static String InsertProjXRef(String ProjectNumber, String ProjectName, String ProjectStatus,
                                        DateTime PlanStartDate, DateTime PlanEndDate, Single PlanHours,
                                        Decimal PlanCost, DateTime ActualStartDate, DateTime ActualEndDate,
                                        Single ActualHours, Decimal ActualCost, String VendorCode,
                                        Int32 VendorContactID, String ProjectFilePath, int AssignTo)
    {
        return "INSERT INTO ProjXRef " +
                    "(ProjNum, ProjName, ProjStatus, PlannedStart, PlannedFinish," +
                    " BudgetLabor, BudgetMaterial, ActualStart, ActualFinish," +
                    " ActualLabor, ActualMaterial, VendCustID, VCContID, MSProjFile,AssignTo)" +
              "VALUES" +
                "('" + ProjectNumber + "','" + ProjectName + "','" + ProjectStatus + "','" +
                       PlanStartDate + "','" + PlanEndDate + "'," + PlanHours + "," + PlanCost + ",'" +
                       ActualStartDate + "','" + ActualEndDate + "'," + ActualHours + "," + ActualCost + ",'" +
                       VendorCode + "'," + VendorContactID + ",'" + ProjectFilePath + "'," + AssignTo + ")";

    }

    public static String UpdateProjXRef(String ProjectNumber, String ProjectName, String ProjectStatus,
                                        DateTime PlanStartDate, DateTime PlanEndDate, Single PlanHours,
                                        Decimal PlanCost, DateTime ActualStartDate, DateTime ActualEndDate,
                                        Single ActualHours, Decimal ActualCost, String VendorCode,
                                        Int32 VendorContactID, String ProjectFilePath, int AssignTo)
    {
        return "UPDATE ProjXRef " +
                "SET  ProjName = '" + ProjectName + "'," +
                " ProjStatus = '" + ProjectStatus + "'," +
                " PlannedStart = '" + PlanStartDate + "'," +
                " PlannedFinish = '" + PlanEndDate + "'," +
                " BudgetLabor = " + PlanHours + "," +
                " BudgetMaterial = " + PlanCost + "," +
                " ActualStart = '" + ActualStartDate + "'," +
                " ActualFinish = '" + ActualEndDate + "'," +
                " ActualLabor = " + ActualHours + "," +
                " ActualMaterial = " + ActualCost + "," +
                " VendCustID = '" + VendorCode + "'," +
                " VCContID = " + VendorContactID + "," +
                " MSProjFile = '" + ProjectFilePath + "'," +
                " AssignTo = " + AssignTo +
                " WHERE (ProjNum= '" + ProjectNumber + "')";
    }

    public static String UpdateProjXRef(String ProjectNumber, String ProjectStatus)
    {
        return "UPDATE ProjXRef " +
                "SET ProjStatus = '" + ProjectStatus + "' " +
                "WHERE (ProjNum= '" + ProjectNumber + "')";
    }

    #endregion

    #region Table_QChStatus

    public static String GetQChStatus()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QChStatus ORDER BY OptDesc";
    }

    #endregion            

    #region Table_QControlList

    public static String GetQControlList()
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM QControlList ORDER BY OptDesc";
    }

    #endregion

    #region Table_QDispStatus

    public static String GetQDispStatus()
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM QDispStatus ORDER BY OptDesc";
    }

    public static String GetQDispStatus(String OptCode)
    {
        return "SELECT OptDesc AS [Description] FROM QDispStatus WHERE (OptCode = '" + OptCode + "')";
    }
    #endregion

    #region Table_QDiscipline

    public static String GetQDiscipline()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QDiscipline ORDER BY OptDesc";
    }
    #endregion

    #region Table_QDispType

    public static String GetQDispType()
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM QDispType ORDER BY OptDesc";
    }

    #endregion

    #region Table_QDocStatus

    public static String GetQDocStatus()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QDocStatus ORDER BY OptDesc";
    }

    #endregion

    #region Table_QDocType

    public static String GetQDocType()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QDocType ORDER BY OptDesc";
    }

    #endregion     

    #region Table_QFileType

    public static String GetQFileType()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QFileType ORDER BY OptDesc";
    }

    #endregion

    #region Table_QImpactArea

    public static String GetQImpactArea()
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM QImpactArea ORDER BY OptDesc";
    }

    #endregion

    #region Table_QNoteTypes

    public static String GetQNoteTypes()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QNoteTypes " +
               "ORDER BY OptDesc";
    }

    #endregion

    #region Table_QNumSchemes

    public static String GetQNumSchemesChars(Int32 SchemeID)
    {
        return "SELECT LeadChar AS [Lead Character], EndChar AS [End Character] " +
               "FROM QNumSchemes " +
               "WHERE (SchemeID = " + SchemeID + ") ORDER BY NumPos";
    }

    public static String GetQNumSchemesMaxIncrementSet(Int32 SchemeID)
    {
        return "SELECT MAX(IncrementSet) AS [MaxIncID]" +
               "FROM QNumSchemes " +
               "WHERE (SchemeID = " + SchemeID + ")";
    }

    public static String GetQNumSchemesMaxNumPos(Int32 SchemeID)
    {
        return "SELECT MAX(NumPos) AS [Max Number Position]" +
               "FROM QNumSchemes " +
               "WHERE (SchemeID = " + SchemeID + ")";
    }

    public static String GetQNumSchemesByID(Int32 SchemeID, Int32 NumberPosition)
    {
        return "SELECT DISTINCT SchemeID AS [ID], NumDetailID AS [Number Detail ID], " +
               "NumPos AS [Number Position], IncrementSet AS [Increment Set], RangeStart AS [Range Start], " +
               "RangeStop AS [Range Stop], SegLen AS [Segment Length], LeadChar AS [Lead Character], EndChar AS [End Character]," +
               "SegFormat AS [Segment Format], SchemeFmt AS [Scheme Format] FROM QNumSchemes " +
               "WHERE (SchemeID = " + SchemeID + ") AND (NumPos = " + NumberPosition + ") ORDER BY NumPos";
    }

    public static String GetQNumSchemesByID(Int32 SchemeID)
    {
        return "SELECT DISTINCT SchemeID AS [ID], SchemeDesc AS [Description], ReqDiscipline AS [Discipline], " +
               "ReqDocType AS [Doc Type], SchemeFmt AS [Scheme Format] FROM QNumSchemes " +
               "WHERE (SchemeID = " + SchemeID + ") ORDER BY SchemeID";
    }

    public static String GetQNumSchemes(String Discipline, String DocType, String SchemeType)
    {
        if (!String.IsNullOrEmpty(Discipline) && !String.IsNullOrEmpty(DocType))
        {
            return "SELECT " +
                   "DISTINCT SchemeID AS [ID], SchemeDesc AS [Description], SchemeFmt AS [Format], " +
                   "ReqDocType AS [Document Type], ReqDiscipline AS [Discipline] " +
                   "FROM QNumSchemes WHERE (ReqDiscipline = '" + Discipline + "') AND (ReqDocType = '" + DocType
                    + "') AND (SchemeDesc LIKE '%" + SchemeType + "%') ORDER BY SchemeDesc";
        }
        else if (!String.IsNullOrEmpty(Discipline) && String.IsNullOrEmpty(DocType))
        {
            return "SELECT " +
                   "DISTINCT SchemeID AS [ID], SchemeDesc AS [Description], SchemeFmt AS [Format], " +
                   "ReqDocType AS [Document Type], ReqDiscipline AS [Discipline] " +
                   "FROM QNumSchemes WHERE (ReqDiscipline = '" + Discipline
                   + "') AND (SchemeDesc LIKE '%" + SchemeType + "%') ORDER BY SchemeDesc";
        }
        else if (String.IsNullOrEmpty(Discipline) && !String.IsNullOrEmpty(DocType))
        {
            return "SELECT " +
                   "DISTINCT SchemeID AS [ID], SchemeDesc AS [Description], SchemeFmt AS [Format], " +
                   "ReqDocType AS [Document Type], ReqDiscipline AS [Discipline] " +
                   "FROM QNumSchemes WHERE (ReqDocType = '" + DocType
                   + "') AND (SchemeDesc LIKE '%" + SchemeType + "%') ORDER BY SchemeDesc";
        }
        else
        {
            return "SELECT " +
                   "DISTINCT SchemeID AS [ID], SchemeDesc AS [Description], SchemeFmt AS [Format], " +
                   "ReqDocType AS [Document Type], ReqDiscipline AS [Discipline], (CStr(SchemeID)+'|'+ReqDocType+'|'+ReqDiscipline) AS ID_DocType_Discipline, (SchemeDesc +'-'+ SchemeFmt) AS Description_Format " +
                   "FROM QNumSchemes WHERE (SchemeDesc LIKE '%" + SchemeType + "%') ORDER BY SchemeDesc";
        }
    }



    public static String GetQNumSchemes(String Discipline, String DocType)
    {
        if (!String.IsNullOrEmpty(Discipline) && !String.IsNullOrEmpty(DocType))
        {
            return "SELECT " +
                   "DISTINCT SchemeID AS [ID], SchemeDesc AS [Description], SchemeFmt AS [Format], " +
                   "ReqDocType AS [Document Type], ReqDiscipline AS [Discipline] " +
                   "FROM QNumSchemes WHERE ReqDiscipline = '" + Discipline + "' AND ReqDocType = '" +
                    DocType + "' ORDER BY SchemeDesc";

        }
        else if (!String.IsNullOrEmpty(Discipline) && String.IsNullOrEmpty(DocType))
        {
            return "SELECT " +
                   "DISTINCT SchemeID AS [ID], SchemeDesc AS [Description], SchemeFmt AS [Format], " +
                   "ReqDocType AS [Document Type], ReqDiscipline AS [Discipline] " +
                   "FROM QNumSchemes WHERE ReqDiscipline = '" + Discipline + "' ORDER BY SchemeDesc";
        }
        else if (String.IsNullOrEmpty(Discipline) && !String.IsNullOrEmpty(DocType))
        {
            return "SELECT " +
                   "DISTINCT SchemeID AS [ID], SchemeDesc AS [Description], SchemeFmt AS [Format], " +
                   "ReqDocType AS [Document Type], ReqDiscipline AS [Discipline] " +
                   "FROM QNumSchemes WHERE ReqDocType = '" + DocType + "' ORDER BY SchemeDesc";
        }
        else
        {
            return "SELECT " +
                   "DISTINCT SchemeID AS [ID], SchemeDesc AS [Description], SchemeFmt AS [Format], " +
                   "ReqDocType AS [Document Type], ReqDiscipline AS [Discipline] " +
                   "FROM QNumSchemes ORDER BY SchemeDesc";
        }
    }

    #endregion

    #region Table_QPrintLoc

    public static String GetQPrintLoc()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QPrintLoc ORDER BY OptDesc";
    }

    #endregion

    #region Table_QPrintSize

    public static String GetQPrintSize()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QPrintSize ORDER BY OptDesc";
    }

    #endregion

    #region Table_QProject

    public static String GetQProject()
    {
        return "SELECT ProjNum AS [ID], Project AS [Description] FROM QProject ORDER BY ProjNum";
    }


    public static String GetQProjectByStatus(params String[] Status)
    {
        String _Status = null;

        try
        {
            for (int i = 0; i < Status.Length; i++)
            {
                _Status = _Status + "'" + Status[i] + "',";
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {

        }

        return "SELECT ProjNum AS [ID], Project AS [Description] FROM QProject WHERE ProjStatus IN (" + _Status + ") ORDER BY ProjNum";
    }

    #endregion

    #region Table_QProjStatus

    public static String GetQProjStatus(String OptCode)
    {
        return "SELECT OptDesc AS [Description] FROM QProjStatus WHERE (OptCode ='" + OptCode + "')";
    }

    public static String GetQProjStatus()
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM QProjStatus";
    }

    #endregion

    #region Table_QRefType

    public static String GetQRefType()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QRefType ORDER BY OptDesc";
    }

    #endregion  

    #region Table_QRevStatus

    public static String GetQRevStatus()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QRevStatus ORDER BY OptDesc";
    }

    #endregion

    #region Table_QRevType

    public static String GetQRevType()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QRevType ORDER BY OptDesc";
    }

    #endregion  

    #region Table_QSecClass

    public static string GetQSecClass()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QSecClass ORDER BY OptDesc";
    }

    #endregion

    #region Table_QTaskCostType

    public static string GetQTaskCostType()
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM QTaskCostType ORDER BY OptDesc";
    }

    #endregion

    #region Table_QTaskPriority

    public static string GetQTaskPriority()
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM QTaskPriority ORDER BY OptDesc";
    }

    #endregion

    #region Table_QTaskRefType

    public static string GetQTaskRefType()
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM QTaskRefType ORDER BY OptDesc";
    }

    #endregion

    #region Table_QTaskStatus

    public static string GetQTaskStatus()
    {
        return "SELECT OptCode AS [Code], OptDesc As [Description] FROM QTaskStatus ORDER BY OptDesc";
    }

    #endregion

    #region Table_QUserInfo

    public static String GetQUserInfo()
    {
        return "SELECT UID AS [User ID], ULNF AS [User Name] FROM QUserInfo ORDER BY ULNF";
    }

    public static String GetQUserInfoEmpID()
    {
        return "SELECT EmpID AS [Employee ID], ULNF AS [User Name] FROM QUserInfo ORDER BY ULNF";
    }

    public static String GetQUserInfo(String UserID, String PWD)
    {
        return "SELECT EmpID AS [EmpID], ULNF AS [User Name], ProfileID As [ProfileID] FROM QUserInfo WHERE " +
                " (UID = '" + UserID + "') AND (UPass = '" + PWD + "') ORDER BY ULNF";
    }

    #endregion

    #region Table_QWorkGroups

    public static string GetQWorkGroups()
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM QWorkGroups ORDER BY OptDesc";
    }

    #endregion

    #region Table_ResNotice

    public static String GetResNotice()
    {
        return "SELECT RNotID AS [ID], RNDesc As [Description], RNText1, RNText2 " +
               "FROM ResNotice ORDER BY RNDesc";
    }

    #endregion

    #region Table_ResNoticeRefs

    public static String DeleteResNoticeRefs(String RefType, String RefID, Int32 RestrictionID)
    {
        return "DELETE * FROM ResNoticeRefs WHERE (RefType = '" + RefType + "') AND (RefID = '" + RefID +
               "') AND (RNotID = " + RestrictionID + ")";
    }

    public static String DeleteResNoticeRefs(String RefType, String RefID)
    {
        return "DELETE * FROM ResNoticeRefs WHERE (RefType = '" + RefType + "') AND (RefID = '" + RefID + "')";
    }

    public static String InsertResNoticeRefs(String RefType, String RefID, Int32 RestrictionID)
    {
        return "INSERT INTO ResNoticeRefs" +
               "(RefType, RefID, RNotID)" +
              "VALUES" +
                "('" + RefType + "','" + RefID + "'," + RestrictionID + ")";
    }

    #endregion

    #region Table_Revisions

    public static String InsertRevisionsDoc(String DocID, Int32 ChangeOrderID, String CurrentRevision, String NewRevision)
    {

        return " INSERT INTO Revisions" +
                    "(DocID, CO, RevFrom, RevTo)" +
                " VALUES" +
                    "( '" + DocID + "','" + ChangeOrderID + "','" + CurrentRevision + "','" + NewRevision + "')";
    }

    public static String GetRevisionsByID(int COID, String DOCID)
    {
        return "SELECT RevFrom AS [Old Revision], RevTo AS [Current Revision] " +
               "FROM Revisions " +
               "WHERE (DocID = '" + DOCID + "') AND (CO = " + COID + ") ORDER BY CO";
    }

    //public static String GetRevisionsByID(String DOCID)
    //{
    //    return "SELECT RevFrom AS [Old Revision], CurrentRev AS [Current Revision] " +
    //           "FROM Revisions " +
    //           "WHERE (DocID = '" + DOCID + "')";           
    //}

    public static String RemoveRevisionsByID(int COID, String DOCID)
    {
        return "DELETE FROM Revisions WHERE (DocID = '" + DOCID + "') AND (CO = " + COID + ")";
    }

    #endregion

    #region Table_SecClassRefs

    public static String InsertSecClassRefs(String RefID, String RefType, String SecClass)
    {
        return " INSERT INTO SecClassRefs" +
                    "(RefType, RefID, SecClass)" +
                " VALUES" +
                    "( '" + RefType + "','" + RefID + "','" + SecClass + "')";
    }

    public static String RemoveSecClassRefsByID(Int32 SecurityRefID)
    {
        return " DELETE * FROM SecClassRefs WHERE (SecRefID = " + SecurityRefID + ")";
    }

    #endregion

    #region Table_StdOptions

    public static String GetStdOptionsByType(String OptType)
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM StdOptions " +
               "WHERE (OptType = '" + OptType + "') " +
               "ORDER BY OptDesc";
    }

    public static String GetStdOptionsByTypeForSubRequest(String OptType)
    {
        return "SELECT  OptType + '|' + OptCode AS [Code], OptDesc AS [Description] FROM StdOptions WHERE (OptType = '" + OptType + "') and OptCode not in (select subRequestCode from htmltemplates)";
    }

    public static String DepartmentList()
    {
        return "SELECT DeptId AS [Code], Department AS [Description] FROM DeptXRef";
    }
    public static String GetStdOptionsByType(String OptType, String OptCode)
    {
        return "SELECT OptDesc AS [Description] FROM StdOptions " +
               "WHERE (OptType = '" + OptType + "') AND (OptCode = '" + OptCode + "')";
    }

    public static String GetStdOptionsGroupType(String OptType, String OptCode)
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM StdOptions " +
               "WHERE (OptType = '" + OptType + "') AND (OptCode NOT IN ('" + OptCode + "'))";
    }

    #endregion   

    #region Table_StdTasks

    public static string GetStdTasks()
    {
        return "SELECT StdTaskID AS [Code], TaskDesc AS [Description] FROM StdTasks ORDER BY TaskDesc";
    }

    public static string GetStdTasksByID(String TaskCode)
    {
        return "SELECT TaskDesc AS [Description], TaskStdDur AS [Duration], TaskStdHrs AS [Hours] " +
               "FROM StdTasks WHERE (StdTaskID = '" + TaskCode + "')";
    }

    #endregion

    #region Table_SystemSettings

    public static String GetSysSettingsBySectParam(String Section, String Item)
    {
        return "SELECT SPValue AS [Return Value] FROM SysSettings " +
               "WHERE (SPSection = '" + Section + "') AND (SParam = '" + Item + "') ORDER BY SPValue";
    }

    #endregion


    #region Table_UserXRef

    public static String GetUserXRef()
    {
        return "SELECT EmpID AS [ID], ULNF AS [Description] FROM UserXRef ORDER BY ULNF";
    }

    public static String GetUserXRef(Int32 EmployeeID)
    {
        return "SELECT EmpID AS [ID], ULNF AS [Description] FROM UserXRef WHERE (EmpID =" + EmployeeID + ")";
    }

    public static String GetUserXRefEmail(Int32 EmployeeID)
    {
        return "SELECT EmpEMail AS [eMail] FROM UserXRef WHERE (EmpID =" + EmployeeID + ")";
    }

    #endregion

    #region Table_UserSettings

    public static String GetUserSettingsBySectParamID(String Section, String Item, Int32 UserID)
    {
        return "SELECT UPValue AS [Return Value] FROM UserSettings WHERE (UPSection = '" + Section + "') AND (UParam = '" + Item +
               "') AND (EmpID = " + UserID + ") ORDER BY UPValue";
    }

    #endregion

    #region Table_VCContacts

    public static String GetVCContactsByVendorID(String VendorID)
    {
        return "SELECT VCContID AS [ID], VCContact AS [Description], VCContEmail AS [Email], VCContPhone AS [Phone] " +
               "FROM VCContacts WHERE (VendCustID = '" + VendorID + "') ";
    }

    #endregion

    #region Table_VendCustXRef

    public static String GetVendCustXRef()
    {
        return "SELECT VendCustID AS [Code], VCName AS [Description] " +
               "FROM VendCustXRef ORDER BY VCName";
    }

    public static String GetVendCustXRefByRefType(String RefType)
    {
        return "SELECT VendCustID AS [Code], VCName AS [Description] " +
               "FROM VendCustXRef WHERE RefType = '" + RefType +
               "' ORDER BY VCName";
    }

    public static String UpdateVendCustXRef(String VendCustID, String VCName, String RefType, String VCLocation, Int32 PartID)
    {
        return "UPDATE VendCustXRef " +
                 "SET VCName = '" + VCName + "'" +
                 ", RefType = '" + RefType + "'" +
                 ", VCLocation = '" + VCLocation + "'" +
             " WHERE (VendCustID = '" + VendCustID + "')";
    }

    #endregion

    #region Table_VendorPartXRef

    public static String GetVendorPartXRefByPartNumber(String PartNumber)
    {
        return "SELECT ID, VendorPartNumber AS [Description] " +
               "FROM VendorPartXRef WHERE PartNumber = '" + PartNumber + "' ORDER BY VendorPartNumber DESC";
    }

    public static String GetVendorPartXRefByID(Int32 ID)
    {
        return "SELECT " +
               "A.PartNumber, A.VendorID, A.VendorPartNumber, A.Description, A.DataSheetLink, " +
               "B.VCContact AS [Vendor Contact Name], B.VCContEmail AS [Email], B.VCContPhone AS [Phone], " +
               "C.VCName AS [Vendor Name] " +
               "FROM " +
               "(VendorPartXRef A LEFT JOIN VCContacts B  ON A.VendorID = B.VendCustID) " +
               "LEFT JOIN VendCustXRef C ON A.VendorID = C.VendCustID " +
               "WHERE A.ID = " + ID;
    }

    public static String InsertVendorPartXRef(String PartNumber, String VendorPartNumber, String VendorID,
                                              String Description, String DataSheetLink)
    {
        return "INSERT INTO VendorPartXRef " +
                    "(PartNumber, VendorID, VendorPartNumber, Description, DataSheetLink) " +
               "VALUES ('" +
                      PartNumber + "','" + VendorID + "','" + VendorPartNumber + "','" + Description + "','" + DataSheetLink + "')";
    }

    public static String UpdateVendorPartXRef(String PartNumber, String VendorPartNumber, String VendorID,
                                              String Description, String DataSheetLink, Int32 ID)
    {

        return "UPDATE VendorPartXRef " +
                "SET PartNumber = '" + PartNumber + "'" +
                ", VendorID = '" + VendorID + "'" +
                ", VendorPartNumber = '" + VendorPartNumber + "'" +
                ", Description = '" + Description + "'" +
                ", DataSheetLink = '" + DataSheetLink + "'" +
            " WHERE (ID = " + ID + ")";
    }


    #endregion

    #region Table_ViewAssocDocs

    public static String GetViewAssocDocsByID(int COID)
    {
        return " SELECT DocID AS [Document ID], RevTo AS [Current Revision], CurrentRev AS [New Revision], " +
                " RevFrom AS [Old Revision], Status AS [Status], DocDesc AS [Description], DType AS [Document Type], " +
                " LastModBy AS [Last Modified By], LastModDate AS [Date Modified]" +
                " FROM ViewAssocDocs WHERE (CO = " + COID + ") ORDER BY DocID";
    }

    #endregion

    #region Table_ViewAttach

    public static String GetViewAttachByTypeAndID(String ReferenceType, Int32 ReferenceID)
    {

        return "SELECT AttID AS [ID], AttFName AS [File Name], AttFDesc AS [File Description], AttFType AS [File Type]," +
               " AttFLoc AS [Location], AttFLink AS [HyperLink], PrintSize AS [Print Size], " +
               " PrintLoc AS [Print Location], WebView AS [View]" +
               " FROM ViewAttach WHERE (RefType = '" + ReferenceType + "') AND (RefID = '" + ReferenceID + "') ORDER BY AttLUpd";
    }

    public static String GetViewAttachByID(Int32 AttachID)
    {
        return "SELECT AttID AS [ID], AttFName AS [File Name], AttFDesc AS [File Description], AttFType AS [File Type]," +
               " AttFLoc AS [Location], AttFLink AS [HyperLink], PrintSize AS [Print Size], " +
               " PrintLoc AS [Print Location], WebView AS [View]" +
               " FROM ViewAttach WHERE (AttID = " + AttachID + " ) ORDER BY AttID";
    }

    #endregion

    #region Table_ViewChanges

    public static String GetViewChangesByID(Int32 COID)
    {
        return "SELECT CO AS [Change ID], Status AS [Change Status], ChClass AS [Change Class], ChType AS [Change Type], " +
               "ChEffDate AS [Start Date], ChDue AS [End Date], Priority AS [Priority], Justification AS [Justification], " +
               "Project AS [Project], ChangeDesc AS [Change Description], ChReqBy AS [Change Requested By], ChReqDate AS [Change Requested Date], " +
               "ChApprBy AS [Change Approved By], ChApprDate AS [Change Approved Date], ChAssignTo AS [Change Assigned To], " +
               "ChAssignDate AS [Change Assigned Date], ChCompletedBy AS [Change Completed By], ChCompletedDate AS [Change Completed Date], " +
               "ChReleasedBy AS [Change Released By], ChReleasedDate AS [Change Released Date], LastModBy AS [Last Modified By], " +
               "LastModDate As [Last Modified Date] " +
               "FROM ViewChanges WHERE (CO = " + COID + ") ORDER BY CO";
    }
    public static String getchargeno(Int32 COID)
    {
        return "SELECT ChargeNo FROM Changes WHERE (CO = " + COID + ") ORDER BY CO";
    }

    public static String GetViewChangesByIDStatus(Int32 COID, String[] InvalidChStatus)
    {
        String _statusFilter = null;
        foreach (String Status in InvalidChStatus)
        {
            _statusFilter = _statusFilter + "(ChStatus <> '" + Status + "') AND ";
        }
        _statusFilter = _statusFilter.Remove(_statusFilter.LastIndexOf("AND"));

        if (COID > 0)
        {
            return "SELECT CO AS [Order ID], ProjNum AS [Project Number], Status AS [Status], " +
                   "ChEffDate AS [Effective Date], ChReqBy AS [Requested By], ChReqDate AS [Requested Date], " +
                   "ChType AS [Change Type], ChangeDesc AS [Description] FROM ViewChanges WHERE CO = " + COID +
                   " AND ( " + _statusFilter + " ) ORDER BY CO";
        }
        else
        {
            return "SELECT CO AS [Order ID], ProjNum AS [Project Number], Status AS [Status], " +
                   "ChEffDate AS [Effective Date], ChReqBy AS [Requested By], ChReqDate AS [Requested Date], " +
                   "ChType AS [Change Type], ChangeDesc AS [Description] FROM ViewChanges WHERE " +
                   _statusFilter + " ORDER BY CO";
        }
    }

    public static String GetViewChangesMaxID()
    {
        return "SELECT MAX(CO) AS ID FROM ViewChanges";
    }

    public static String GetViewChangesList()
    {
        return "SELECT CO AS [ID], ChangeDesc AS [Description], ChType AS [Type], Status AS [Status], " +
               "'Project:' & ProjNum AS [Info] " +
               "FROM ViewChanges";
    }

    #endregion

    #region Table_ViewControlList

    public static String GetViewControlListByID(String RefType, String RefID)
    {
        return "SELECT CLRefID AS [ID], ControlList AS [Control List], CLDesc AS [Description] " +
               "FROM ViewControlList WHERE (RefType = '" + RefType + "') AND (RefID = '" + RefID + "') ORDER BY CLRefID";
    }

    #endregion

    #region Table_ViewDocFiles

    public static String GetViewDocFilesByID(String DocID)
    {
        return "SELECT DocID AS [Document ID], FileID AS [File ID], FileName AS [File Name], Status AS [Status], " +
               "FileDesc AS [Description], FType AS [Type], FileLocation AS [Location], FileLink AS [Link], " +
               "FileCreatedBy AS [Created By],  FileCreated AS [Date Created] " +
               "FROM ViewDocFiles WHERE DocID = '" + DocID + "' ORDER BY FileName";
    }

    public static String GetViewDocFilesByID(Int32 FileID)
    {
        return "SELECT DocID AS [Document ID], FileID AS [File ID], FileName AS [File Name], Status AS [Status], " +
               "FileDesc AS [Description], FType AS [Type], FileLocation AS [Location], FileLink AS [Link], " +
               "FileCreatedBy AS [Created By],  FileCreated AS [Date Created], PrintSize AS [Print Size], " +
               "PrintLoc AS [Print Location], WebView AS [View] " +
               "FROM ViewDocFiles WHERE FileID = " + FileID + " ORDER BY FileName";
    }

    #endregion

    #region Table_ViewDocHistory

    public static String GetViewDocHistoryByID(String DocID)
    {
        return "SELECT CO AS [Change Order], RevFrom AS [Old Revision], RevTo AS [New Revision], " +
               "Status AS [Change Status], ChType AS [Change Type], ChEffDate AS [Effective Date], " +
               "LastModBy AS [Last Modified By], LastModDate AS [Last Modified Date] " +
               "FROM ViewDocHistory WHERE (DocID = '" + DocID + "') ORDER BY CO DESC";
    }

    public static String GetViewDocHistoryCount(String DocID, String[] CheckStatus)
    {
        String _statusFilter = null;
        foreach (String Status in CheckStatus)
        {
            _statusFilter = _statusFilter + "(ChStatus ='" + Status + "') OR ";
        }
        _statusFilter = _statusFilter.Remove(_statusFilter.LastIndexOf("OR"));

        return "SELECT COUNT(CO) AS RecordCount FROM ViewDocHistory " +
               "WHERE (DocID = '" + DocID + "') " +
               "AND " + _statusFilter;
    }

    #endregion

    #region Table_ViewDocs

    public static String GetViewDocsByID(String DOCID)
    {
        return "SELECT " +
               "DocID AS [Document ID], DocStatus AS [Document Status], Status AS [Status], CurrentRev AS [Current Revision], " +
               "Discipline AS [Discipline Code],Disc AS [Discipline Description], Tabulated AS [Tabulated], ProjNum AS [Project ID], " +
               "ProjName AS [Project Name], Project AS [Project Description], DocType AS [Document Type ID], DType AS [Document Type], " +
               "DocDesc AS [Document Description], DocReqBy AS [Requested By], DocReqDate AS [Doc Requested Date], DocCreatedBy AS [Created By], " +
               "DocCreatedDate AS [Doc Created Date], DocReviewBy AS [Reviewed By], DocReviewDate AS [Doc Reviewed Date], " +
               "DocRelRef AS [Released By], DocRelDate AS [Doc Released Date], DocObsRef AS [Obsoleted By], DocObsDate AS [Doc Obsoleted Date], " +
               "LastModBy AS [Last Modified By], LastModDate AS [Last Modified Date], DocExpDate AS [Doc Expiry Date], AutoGenerate AS [AutoGenerate] " +
               "FROM ViewDocs WHERE (DocID = '" + DOCID + "') ORDER BY DocID";
    }

    public static string DeleteTasksByID(Int32 TaskID)
    {
        return "DELETE * FROM Tasks WHERE (TaskID = " + TaskID + ")";
    }

    public static String GetViewDocsByIDandStatus(String DOCID, String Status)
    {
        return "SELECT DocID AS [ID], CurrentRev AS [Current Revision], Status AS [Status], " +
               "DType AS [Type Description], Disc AS [Discipline], DocDesc AS [Description], " +
               "LastModBy AS [Last Modified By], LastModDate AS [Last Modified Date] " +
               "FROM ViewDocs " +
               "WHERE DocID LIKE '%" + DOCID + "%' " +
               "AND Status LIKE '%" + Status + "%' ORDER BY DocID";
    }

    public static String GetViewDocsByIDandStatus(String DOCID)
    {
        return "SELECT DocID AS [ID], CurrentRev AS [Current Revision], Status AS [Status], " +
               "DType AS [Type Description], Disc AS [Discipline], DocDesc AS [Description], " +
               "LastModBy AS [Last Modified By], LastModDate AS [Last Modified Date] " +
               "FROM ViewDocs " +
               "WHERE DocID LIKE '%" + DOCID + "%' " +
               "AND Status IN ('ARCHIVED', 'RELEASED') ORDER BY DocID";
    }

    public static String GetViewDocsDistinctStatus()
    {
        return "SELECT DISTINCT STATUS AS [Status] FROM ViewDocs WHERE STATUS IS NOT NULL ORDER BY Status";
    }

    public static String GetViewDocsList()
    {
        return "SELECT DISTINCT DocID AS [ID], DocDesc AS [Description], DType AS [Type], Status AS [Status], " +
               "'Current Revision:' & CurrentRev AS [Info] " +
               "FROM ViewDocs";
    }

    #endregion

    #region Table_ViewImpact

    public static String GetViewImpactByID(Int32 COID)
    {
        return "SELECT DISTINCT " +
               "OrderID AS [Order ID], LineItemID AS [Line Item ID], " +
               "OrderType AS [Order Type], OrderNum AS [Order Number], OrderStatus AS [Order Status], " +
               "ItemLine AS [Line Item], PartNo AS [Part Number], RStatus AS [Revision Status], " +
               "PartRev AS [Part Revision], PartEffDate AS [Part Effective Date], PartDesc AS [Part Description], " +
               "ItemUnit AS [Unit], ItemQty AS [Qty], Cost AS [Cost]" +
               "FROM ViewImpact WHERE (CO = " + COID + ") AND (PartNo IS NOT NULL)ORDER BY OrderType, OrderNum, ItemLine";
    }

    public static String GetViewImpactByID(Int32 COID, Int32 OrderID, Int32 LineItemID)
    {
        return "SELECT DISTINCT " +
               "OrderID AS [Order ID], LineItemID AS [Line Item ID], " +
               "OrderType AS [Order Type], OrderNum AS [Order Number], OrderStatus AS [Order Status], " +
               "ItemLine AS [Line Item], PartNo AS [Part Number], RStatus AS [Revision Status], " +
               "PartRev AS [Part Revision], PartEffDate AS [Part Effective Date], PartDesc AS [Part Description], " +
               "ItemUnit AS [Unit], ItemQty AS [Qty], Cost AS [Cost]" +
               "FROM ViewImpact WHERE (CO = " + COID + ") AND (OrderID = " + OrderID + ") AND (LineItemID = " + LineItemID + ") ORDER BY OrderType, OrderNum, ItemLine";
    }

    #endregion

    #region Table_ViewImpactSaved

    public static String GetViewImpactSavedByID(Int32 COID)
    {
        return "SELECT DISTINCT " +
                "OrderID AS [Order ID], LineItemID AS [Line Item ID], " +
                "OrderType AS [Order Type], OrderNum AS [Order Number], OrderStatus AS [Order Status], " +
                "ItemLine AS [Line Item], PartNo AS [Part Number], RStatus AS [Revision Status], " +
                "PartRev AS [Part Revision], PartEffDate AS [Part Effective Date], PartDesc AS [Part Description], " +
                "ItemUnit AS [Unit], ItemQty AS [Qty], Cost AS [Cost]" +
                "FROM ViewImpactSaved WHERE (CO = " + COID + ") AND (PartNo IS NOT NULL)ORDER BY OrderType, OrderNum, ItemLine";
    }

    #endregion

    #region Table_ViewMatDisp

    public static String GetViewMatDispByCOID(Int32 COID)
    {
        return "SELECT MatDispID AS [Mat Disp ID], OrderDateBatch AS [Batch], DateDue AS [Due Date], " +
               "DispEffDate AS [Effective Date], Status AS [Status], ImpAreaDesc AS [Impact Area], DispType AS [Disp Type], " +
               "DispCost AS [Cost], ULNF AS [Assigned To]" +
               "FROM ViewMatDisp " +
               "WHERE (CO = " + COID + ") ORDER BY DateDue";
    }

    public static String GetViewMatDispByMDID(Int32 MDID)
    {
        return "SELECT MatDispID AS [Mat Disp ID], OrderDateBatch AS [Batch], DateDue AS [Due Date], " +
               "DispEffDate AS [Effective Date], Status AS [Status], ImpAreaDesc AS [Rev Type], DispType AS [Disp Type], " +
               "DispCost AS [Cost], ULNF AS [Assigned To]" +
               "FROM ViewMatDisp " +
               "WHERE (MatDispID = " + MDID + ") ORDER BY DateDue";
    }

    public static String GetViewMatDispList()
    {
        return "SELECT MatDispID AS [ID], ImpAreaDesc AS [Description], DispType AS [Type], Status AS [Status], " +
               "'Change Order:' & CO & ' Order/Date/Batch ID:' & OrderDateBatch & ' DueDate:' & DateDue AS [Info] " +
               "FROM ViewMatDisp";
    }

    #endregion

    #region Table_ViewNotes

    public static String GetViewNotesByTypeAndID(String ReferenceType, String ReferenceID)
    {
        return "SELECT NoteID AS [Note ID], NoteDT AS [Date], NType AS [Type], ULNF AS [Created By], NoteSubj AS [Subject], NoteTxt AS [Note Text] " +
               "FROM ViewNotes  WHERE (RefType = '" + ReferenceType + "') AND (RefID = '" + ReferenceID + "') ORDER BY NoteDT DESC";

    }

    #endregion   

    #region Table_ViewParts

    public static String GetViewParts(String DocID)
    {
        return "SELECT PartID AS [Part ID], PartNo AS [Part Number], CurRev AS [Current Revision], " +
               "PartDesc AS [Description], RStatus AS [Status], RType AS [Revision Type], Cost , LifecycleStatus, " +
               "EffDate AS [Effective Date], FAI AS [FAI], FAIDate AS [FAI Date] " +
               "FROM ViewParts WHERE (DOCID = '" + DocID + "') ORDER BY PartNo";
    }

    public static String GetViewPartsByID(Int32 PartID)
    {
        return "SELECT PartNo AS [Part Number], CurRev AS [Current Revision], FileID AS [File ID], " +
               "FileName AS [File Name],PartDesc AS [Description], RType AS [Revision Type], " +
               "RStatus AS [Status], EffDate AS [Effective Date], ExpDate AS [Expiry Date], " +
               "FileLocation AS [File Location], FileLink AS [File Link], FAI AS [FAI], " +
               "FAIDate AS [FAI Date], Cost , LifecycleStatus, " +
               "VendorID AS [Vendor ID], VCName AS [Vendor Name], " +
               "RefTypeDesc AS [Reference Type], VCLocation AS [Vendor Location] " +
               "FROM ViewParts WHERE (PartID = " + PartID + ")";
    }

    #endregion

    #region Table_ViewProjects

    public static String GetViewProjectsList(bool isAdmin, int UserId)
    {
        if (isAdmin)
            return "SELECT ProjNum AS [ID], Project AS [Description], 'Project' AS [Type], Status AS [Status], " +
                   "'Vendor/Customer:' & VCName AS [Info] " +
                   "FROM ViewProjects";
        else
            return "SELECT ProjNum AS [ID], Project AS [Description], 'Project' AS [Type], Status AS [Status], " +
                   "'Vendor/Customer:' & VCName AS [Info] " +
                   "FROM ViewProjects Where AssignTo=" + UserId;
    }

    public static String GetViewProjectbyID(String PID)
    {
        return "SELECT ProjNum AS [ID], ProjName AS [Project Name], Status AS [Status], " +
               "PlannedStart AS [Planned Start Date], PlannedFinish AS [Planned End Date], " +
               "BudgetLabor AS [Planned Hours], BudgetMaterial AS [Planned Cost], " +
               "ActualStart AS [Actual Start Date], ActualFinish AS [Actual End Date], " +
               "ActualLabor AS [Actual Hours], ActualMaterial AS [Actual Cost], VCName AS [Vendor Name], " +
               "VendCustID AS [Vendor ID], VCContID AS [Vendor Contact ID], VCContact AS [Vendor Contact Name], " +
               "MSProjFile AS [ProjectFile Path] " +
               "FROM ViewProjects WHERE (ProjNum = '" + PID + "')";
    }

    #endregion

    #region Table_ViewResNotice

    public static String GetViewResNotice(String RefType, String RefID)
    {
        return "SELECT RNotID AS [ID], RNDesc AS [Description] FROM ViewResNotice " +
               "WHERE (RefType = '" + RefType + "') AND (RefID = '" + RefID + "')";
    }

    public static String GetViewResNoticeText(String RefType, String RefID)
    {
        return "SELECT RNText1 AS [Text1], RNText2 AS [Text2] FROM ViewResNotice " +
               "WHERE (RefType = '" + RefType + "') AND (RefID = '" + RefID + "')";
    }

    #endregion

    #region Table_ViewSecClass

    public static String GetViewSecClass(String RefType, String RefID)
    {
        return "SELECT SecRefID AS [ID], SecClass AS [Code], SecClassDesc AS [Security Class] FROM ViewSecClass "
               + "WHERE (RefType = '" + RefType + "') AND (RefID = '" + RefID + "') "
               + "ORDER BY SecClass";
    }

    #endregion

    #region Table_ViewTasks

    public static String GetViewTasksByID(Int32 TID)
    {
        return "SELECT TaskID AS [Task ID], ParentTask  AS [Parent Task ID], CostType AS [Cost Type Desc], " +
                "RefType AS [Ref Type ID], RType AS [Ref Type Desc], RefNum AS [Ref ID], TaskStatus AS [Task Status ID], " +
                "Status AS [Task Status Desc], ChargeAcct AS [Charge Account], Priority AS [Priority], ProjNum AS [Project Number], " +
                "ProjName As [Project Name], Project AS [Project Desc], StdTask AS [Std Task Desc], AssnBy AS [Assigned By], " +
                "DateAssigned AS [Assigned Date], AssnTo AS [Assigned To], AssignWkgrp AS [Assigned WG], Workgroup AS [WG], " +
                "ResourceName AS [Resource Name], RateGroupDesc AS [Rate Group Desc], TaskDesc AS [Task Desc], TaskDetail AS [Task Detail], " +
                "PlannedStart AS [Planned Start Date], PlannedFinish AS [Planned End Date], EstHours AS [Planned Hours], EstCost AS [Planned Cost], " +
                "OverrunHrs AS [Overrun Hours], OverrunEstFinish AS [Overrun End Date], OvrCost AS [Overrun Cost], " +
                "ActualStart AS [Actual Start Date], ActualFinish AS [Actual End Date], ActualHours AS [Actual Hours], " +
                "ActualCost AS [Actual Cost], PcntComplete AS [Percent Complete], SchedVisible AS [Schedule Visible] " +
                "FROM ViewTasks WHERE (TaskID = " + TID + ") ORDER BY TaskID";
    }


    public static String GetViewTasksList()
    {
        return "SELECT TaskID AS [ID], TaskDesc AS [Description], StdTask AS [Type], Status AS [Status], " +
               "'Priority:' & Priority AS [Info] " +
               "FROM ViewTasks";
    }

    public static String GetViewTasksListOpenByUser(Int32 AssignToID, Boolean IsAdmin)
    {
        if (IsAdmin)
        {
            return "SELECT TaskID AS [ID], TaskDesc AS [Description], StdTask AS [Type], Status AS [Status], " +
                   "'Priority:' & Priority AS [Info] " +
                   "FROM ViewTasks WHERE Status IN ('OPEN')";
        }
        else
        {
            return "SELECT TaskID AS [ID], TaskDesc AS [Description], StdTask AS [Type], Status AS [Status], " +
                   "'Priority:' & Priority AS [Info] " +
                   "FROM ViewTasks WHERE Status IN ('OPEN') AND AssignTo = " + AssignToID;
        }
    }
    #endregion

    #region Table_ViewWFActions

    public static String GetViewWFActions()
    {
        return "SELECT WAID AS [ID], AType + ' - ' + WAName AS [Description] FROM ViewWFActions ORDER BY AType, WAName";
    }

    public static String GetViewWFActionsList()
    {
        return "SELECT WAID AS [ID], ATYPE AS [Type], WAName AS [Description] FROM ViewWFActions ORDER BY AType, WAName";
    }

    public static String GetViewWFActions(Int32 WFActionID)
    {
        return "SELECT WAName AS [WFAction Name], WAType AS [WFAction Type Code], AType AS [WFAction Type Name], " +
               "WADesc AS [Description], WAAByType AS [Assign By Code], AByType AS [Assign By Type], WAAssnBy AS [Assign By ID], " +
               "WAAToType AS [Assign To Code], AToType AS [Assign To Type], WAAssnTo AS [Assign To ID], WAStdTaskID AS [Standard Task Code], " +
               "TaskDesc AS [Task Description], WorkGroupID AS [WorkGroup ID], TaskUOM AS [Task UOM], TaskStdHrs AS [Task Hours], " +
               "TaskStdDur AS [Task Duration], WAChgAcct AS [Charge Account], WADur As [Duration], WAHrs AS [Hours], WAMins AS [Minutes], " +
               "WACost AS [Cost], WACtrlRef AS [Control Reference Code], CRef AS [Control Reference Description], WAParams AS [WA Parameter], " +
               "IseMailRequired  " +
               "FROM ViewWFActions WHERE (WAID = " + WFActionID + ")";
    }

    #endregion

    #region Table_ViewWFGroups

    public static String GetViewWFGroups()
    {
        return "SELECT WFGID AS [ID], GType AS [Type], WFGroup AS [Group Name] FROM ViewWFGroups ORDER BY GType";
    }


    public static String GetViewWFGroupsByID(Int32 GroupID)
    {
        return "SELECT WFGID AS [ID], WFGroup AS [Group Name], WFGroupType AS [Type Code], GType AS [Type Name] " +
               "FROM ViewWFGroups WHERE WFGID = " + GroupID + " ORDER BY GType";
    }

    #endregion

    #region Table_ViewWFGroupType

    public static String GetViewWFGroupType()
    {
        return "SELECT OptCode AS [Code], OptDesc AS [Description] FROM ViewWFGroupType ORDER BY OptDesc";
    }

    #endregion

    #region Table_ViewWFGMembs

    public static String GetViewWFGMembs(Int32 GroupID)
    {
        return "SELECT WFMID AS [ID], WFMEmpID AS [Employee ID], WFMName AS [User Provided Name], WFMEmail AS [User Provided eMail] " +
               "FROM ViewWFGMembs WHERE (WFGID = " + GroupID + ") ORDER BY WFMName";
    }

    public static String GetViewWFGMembsByID(Int32 GroupMemberID)
    {
        return "SELECT WFMID AS [ID], WFMEmpID AS [Employee ID], WFMName AS [User Provided Name], WFMEmail AS [User Provided eMail], " +
               "ULNF AS [Employee Name] FROM ViewWFGMembs WHERE (WFMID = " + GroupMemberID + ") ORDER BY WFMName";
    }

    #endregion

    #region Table_ViewWFInfo

    public static String GetViewWFInfo(String RefType, String RefID)
    {
        return "SELECT DISTINCT WTID AS [Template ID], TType AS [Template Type], WTName AS [Template Name] , " +
               "RType AS [Reference Type], RefNum AS [Reference Number], WFCreated AS [Created On] " +
               "FROM ViewWFInfo WHERE (RefType ='" + RefType + "') AND (RefNum = '" + RefID + "')";
    }

    #endregion

    #region Table_ViewWFTasks

    public static String GetViewWFTasks(String RefID, String RefType, String StepNumber)
    {
        return "SELECT WATID AS [WF Task ID], WTID AS [WF TemplateID], WATStep AS [Step], WATStatus AS [Step Status], " +
               "TaskID AS [Task ID], TaskDesc AS [Task Description], Status AS [Task Status], WAAssnTo AS [WFTask Assgn To Type ID], " +
               "IseMailRequired " +
               "FROM ViewWFTasks WHERE (RefType = '" + RefType + "') AND (RefNum = '" + RefID +
               "') AND (WATStep = '" + StepNumber + "') AND (WFActive = TRUE) " +
               "ORDER BY TStep, TSubstep";
    }

    public static String GetViewWFTasks(String RefID, String RefType)
    {
        return "SELECT WATID AS [WF Task ID], WTID AS [WF TemplateID], WATStep AS [Step], WATStatus AS [Step Status]," +
               "TaskID AS [Task ID], TaskDesc AS [Task Description], Status AS [Task Status], " +
               "SWITCH(WATStatus='ACTIVE', PlannedStart, WATStatus = 'COMPLETED', ActualStart, True, '" + Constants.DateTimeMinimum + "') AS [Start Date], " +
               "SWITCH(WATStatus='ACTIVE', BFinish, WATStatus = 'COMPLETED', ActualFinish, True, '" + Constants.DateTimeMinimum + "') AS [End Date] " +
               "FROM ViewWFTasks WHERE (RefType = '" + RefType + "') AND (RefNum = '" + RefID + "') AND (WFActive = TRUE) " +
               "ORDER BY TStep, TSubstep";
    }

    public static String GetViewWFTasksReference(String RefID, String RefType)
    {
        return "SELECT WATID AS [WF Task ID], WTID AS [WF TemplateID], TaskID AS [Task ID], WATStep AS [Step], " +
               "TaskDesc AS [Action Name], WATNext AS [Next Step], AssnTo AS [Assigned To], WATBack AS [Back Step], " +
               "AType AS [Action Type], Status AS [Task Status] " +
               "FROM ViewWFTasks WHERE (RefType = '" + RefType + "') AND (RefNum = '" + RefID + "') AND (WFActive = TRUE) " +
               "ORDER BY TStep, TSubstep";

        //return "SELECT WATID AS [WF Task ID], WTID AS [WF TemplateID], TaskID AS [Task ID], WATStep AS [Step],  " +
        //"WATNext AS [Next Step], WFGroups.WFGroup AS [Assigned To], WATBack AS [Back Step], WAAByType AS [Action Type], WATStatus AS [Task Status] " +
        //"FROM WFlowTasks LEFT JOIN WFGroups ON WFGroups.WFGID = WFlowTasks.AssnTo WHERE(WFRefType = '" + RefType + "') AND(WFRefID = '" + RefID + "') ORDER BY WATStep";
    }

    public static String GetViewWFTasks(Int32 WFTaskID)
    {
        return "SELECT TaskID AS [Task ID], TaskStatus AS [Task Status Code], Status AS [Task Status Description], " +
        "TaskPriority AS [Priority Code], Priority As [Priority Description], ChargeAcct AS [Charge Account], " +
        "StdTaskID AS [Standard Task ID], StdTask AS [Standard Task Description], ProjNum AS [Project Code], " +
        "Project AS [Project Description], TaskDesc AS [Task Description], TaskDetail AS [Task Assignment Description], " +
        "PlannedStart AS [Planned Start Date], PlannedFinish AS [Planned End Date], OverrunEstFinish AS [Overrun End Date], " +
        "ActualStart AS [Actual Start Date], ActualFinish AS [Actual End Date], EstHours AS [Planned Hours], OverrunHrs AS [Overrun Hours], " +
        "BHrs AS [PlannedOverrun Hours], ActualHours AS [Actual Hours], PcntComplete AS [Percentage], EstCost AS [Planned Cost], " +
        "OvrCost AS [Overrun Cost], BMCost AS [PlannedOverrun Cost], ActualCost AS [Actual Cost], RType AS [Ref Type Description], " +
        "RefNum AS [Ref ID], Workgroup AS [WorkGroup Description], DateAssigned AS [Assigned Date], AssignWkgrp AS [Assigned WorkGroup], " +
        "WTID AS [WF Task ID], " +
        "WATType AS [WF Task Type Code], AType AS [WF Task Type Description], " +
        "WATStep AS [Step ID], WATNext AS [Next Step ID], WATNextStatus AS [Next Step Status], WATBack AS [Back Step ID], " +
        "WATBackStatus AS [Back Step Status], WAAByType AS [WFTask Assign By Type Code], AByType AS [WFTask Assign By Type Description], " +
        "WAAssnBy AS [WFTask Assgn By Type ID], WAAToType AS [WFTask Assign To Type Code], AToType AS [WFTask Assign To Type Description], " +
        "WAAssnTo AS [WFTask Assgn To Type ID], WFAssnTo AS [Group Member ID], WATCtrlRef AS [WFTask Control Ref Type], " +
        "WATRefID As [WFTask Control Ref ID], WATParams AS [WFTask Parameters], WATSchedAdj AS [IsWFTaskScheduled], " +
        "WATAdjPStart AS [WFTask Planned Start Date], WATAdjPFinish AS [WFTask Planned End Date], WATAdjOFinish AS [WFTask Overrun End Date], " +
        "WATAdjAStart AS [WFTask Actual Start Date], WATAdjAFinish AS [WFTask Actual End Date], " +
        "WATActive AS [WF Task Active], WATStatus AS [WF Task Status], IseMailRequired " +
        "FROM ViewWFTasks WHERE (WATID = " + WFTaskID + ")";
    }


    #endregion

    #region Table_ViewWFTemp

    public static String GetViewWFTemp()
    {
        //return "SELECT WTID AS [ID], TType + ' - ' + WTName AS [Description] FROM ViewWFTemp";
        return "SELECT WTID AS [ID], TType + ' - ' + WTName AS [Description] FROM ViewWFTemp where wtid in ( select WTID from ViewWFTItems)";
    }

    public static String GetViewWFTempByID(Int32 WFTemplateID)
    {
        return "SELECT WTName AS [Name], TType AS [Type], WTType AS [Type Code], WTDesc AS [Description] FROM ViewWFTemp " +
               "WHERE (WTID =" + WFTemplateID + ") ORDER BY TType, WTName";
    }

    #endregion

    #region Table_ViewWFTItems

    public static String GetViewWFTItemsListByTemplateID(Int32 WFTemplateID)
    {
        return "SELECT WTIID AS [ID], WTIStep + ':' + TIType + '-' + WTIName AS [Description] " +
               "FROM ViewWFTItems WHERE (WTID = " + WFTemplateID + ") ORDER BY WTIStep";
    }

    public static String GetViewWFTItemsByTemplateID(Int32 WFTemplateID)
    {
        return "SELECT WTIID AS [WFItem ID], WTID AS [WFTemplate ID],WTIStep AS [Step], WTIName AS [Action Name], " +
               "WTINext AS [Next Step], WTIBack AS [Back Step], TIType AS [Action Type] " +
               "FROM ViewWFTItems WHERE (WTID = " + WFTemplateID + ") ORDER BY WTIStep";
    }
    public static String GetViewWFTItemsByTemplateIDForAction(Int32 WFTemplateID)
    {
        return "SELECT WTIStep AS [Step], WTIStep +' - '+ WTIName AS [ActionName] " +
               "FROM ViewWFTItems WHERE (WTID = " + WFTemplateID + ") ORDER BY WTIStep";
    }

    public static String GetViewWFTItemsByItemID(Int32 WFItemID)
    {
        return "SELECT WTIName AS [WFAction Name], WTIType AS [WFAction Type Code], TIType AS [WFAction Type Name], " +
               "WTIStep AS [Step], WTINext AS [Next Step], WTINextStatus AS [Next Step Status], WTIBack AS [Back Step], " +
               "WTIBackStatus AS [Back Step Status], WTIDesc AS [Description], WTIStdTaskID AS [Standard Task Code], " +
               "TaskDesc AS [Task Description], WTIChgAcct AS [Charge Account], WTIDur AS [Duration], WTIHrs AS [Hours], " +
               "WTIMins AS [Minutes], WTICost AS [Cost], WTIAByType AS [Assign By Code], AByType AS [Assign By Type], " +
               "WTIAssnBy AS [Assign By ID], WTIAToType AS [Assign To Code], AToType AS [Assign To Type], WTIAssnTo AS [Assign To ID], " +
               "WTICtrlRef  AS [Control Reference Code], CRef AS [Control Reference Description], WTIParams As [WA Parameter], IseMailRequired " +
               "FROM ViewWFTItems WHERE (WTIID = " + WFItemID + ")";
    }

    #endregion

    #region Table_WFGroups

    public static String GetWFGroupsMaxID()
    {
        return "SELECT Max(WFGID) AS [MaxID] FROM WFGroups";
    }

    public static String DeleteWFGroups(Int32 WFGroupID)
    {
        return "DELETE * FROM WFGroups WHERE (WFGID = " + WFGroupID + ")";
    }

    public static String GetWFGroups()
    {
        return "SELECT WFGID AS [ID], WFGroup AS [Description] FROM WFGroups ORDER BY WFGroup";
    }

    public static String GetWFGroups(String GroupType)
    {
        return "SELECT WFGID AS [ID], WFGroup AS [Description] FROM WFGroups " +
               "WHERE (WFGroupType = '" + GroupType + "') ORDER BY WFGroup";
    }

    public static String GetWFGroupsByID(Int32 WFGroupID)
    {
        return "SELECT WFGID AS [ID], WFGroup AS [Description], WFGroupType AS [Type] FROM WFGroups " +
               "WHERE (WFGID = " + WFGroupID + ")";
    }

    public static String InsertWFGroups(String GroupTypeCode, String GroupName)
    {
        return "INSERT INTO WFGroups" +
                    "(WFGroupType, WFGroup) " +
               "VALUES" +
                   "('" + GroupTypeCode + "','" + GroupName + "')";
    }

    public static String UpdateWFGroups(String GroupTypeCode, String GroupName, Int32 GroupID)
    {
        return "UPDATE WFGroups " +
               "SET WFGroup = '" + GroupName + "', " +
                   "WFGroupType = '" + GroupTypeCode + "'  " +
               "WHERE WFGID = " + GroupID;
    }

    #endregion

    #region Table_WFGroupMembs

    public static String GetWFGroupMembsMaxID()
    {
        return "SELECT Max(WFMID) AS [MaxID] FROM WFGroupMembs";
    }

    public static String DeleteWFGroupMembs(Int32 WFGroupID)
    {
        return "DELETE * FROM WFGroupMembs WHERE (WFGID = " + WFGroupID + ")";
    }

    public static String DeleteWFGroupMembsByID(Int32 GroupMemberID)
    {
        return "DELETE * FROM WFGroupMembs WHERE (WFMID = " + GroupMemberID + ")";
    }

    public static String InsertWFGroupMembs(Int32 GroupID, Int32 EmployeeID, String GroupMemberName,
                                            String eMail)
    {
        return "INSERT INTO WFGroupMembs" +
                    "(WFGID, WFMEmpID, WFMName, WFMEmail) " +
               "VALUES" +
                   "(" + GroupID + "," + EmployeeID + ",'" + GroupMemberName + "','" + eMail + "')";
    }

    public static String UpdateWFGroupMembs(Int32 GroupID, Int32 EmployeeID, String GroupMemberName,
                                            String eMail, Int32 GroupMemberID)
    {
        return "UPDATE WFGroupMembs " +
               "SET WFGID = " + GroupID + ", " +
                  " WFMEmpID = " + EmployeeID + ", " +
                  " WFMName = '" + GroupMemberName + "', " +
                  " WFMEmail = '" + eMail + "' " +
               "WHERE WFMID = " + GroupMemberID;
    }


    public static String GetWFGroupMembsByID(Int32 GroupID)
    {
        return "SELECT FIRST(WFMEmpID) AS [Member ID] FROM WFGroupMembs " +
               "WHERE (WFGID = " + GroupID + ") AND (WFMEmpID IS NOT NULL)";
    }

    public static String GetWFGroupMembsListByID(Int32 GroupID)
    {
        return "SELECT WFMID AS [MID], WFMEmpID AS [ID], WFMName AS [Description] FROM WFGroupMembs " +
               "WHERE (WFGID = " + GroupID + ")";
    }

    public static String GetWFGroupMembsListByMemberID(Int32 GroupID, Int32 GroupMemberID)
    {
        return "SELECT WFMID AS [MID], WFMEmpID AS [ID], WFMName AS [Description] FROM WFGroupMembs " +
               "WHERE (WFGID = " + GroupID + ") AND (WFMEmpID = " + GroupMemberID + ")";
    }

    #endregion

    #region Table_WFlowActions

    public static String GetWFlowActionsMaxID()
    {
        return "SELECT Max(WAID) AS [MaxID] FROM WFlowActions";
    }

    public static String DeleteWFlowActionsByID(Int32 ActionID)
    {
        return "DELETE * FROM WFlowActions WHERE (WAID = " + ActionID + ")";
    }

    public static String InsertWFlowActions(String ActionName, String ActionTypeCode, String Description,
                                            String StdTaskCode, String ChargeAccount, Single Duration,
                                            Int32 Hours, Int32 Minutes, Decimal Cost, String AssignByCode,
                                            Int32 AssignByID, String AssignToCode, Int32 AssignToID,
                                            String ControlRefCode, String ControlRefParams, String IseMailRequired)
    {
        return "INSERT INTO WFlowActions" +
                    "(WAName, WAType, " +
                    " WADesc, WAStdTaskID, " +
                    " WAChgAcct, WADur, WAHrs, WAMins, " +
                    " WACost, WAAByType, WAAssnBy, WAAToType, " +
                    " WAAssnTo, WACtrlRef, WAParams, IseMailRequired) " +
               "VALUES" +
                   "('" + ActionName + "','" + ActionTypeCode + "', '" +
                          Description + "','" + StdTaskCode + "','" +
                          ChargeAccount + "'," + Duration + "," + Hours + "," + Minutes + "," +
                          Cost + ",'" + AssignByCode + "'," + AssignByID + ",'" + AssignToCode + "'," +
                          AssignToID + ",'" + ControlRefCode + "','" + ControlRefParams + "','" + IseMailRequired + "')";
    }

    public static String UpdateWFlowActions(String ActionName, String ActionTypeCode, String Description,
                                            String StdTaskCode, String ChargeAccount, Single Duration,
                                            Int32 Hours, Int32 Minutes, Decimal Cost, String AssignByCode,
                                            Int32 AssignByID, String AssignToCode, Int32 AssignToID,
                                            String ControlRefCode, String ControlRefParams, String IseMailRequired,
                                            Int32 ActionID)
    {
        return "UPDATE WFlowActions " +
               "SET  WAName = '" + ActionName + "', " +
                   " WAType = '" + ActionTypeCode + "', " +
                   " WADesc = '" + Description + "', " +
                   " WAStdTaskID = '" + StdTaskCode + "', " +
                   " WAChgAcct = '" + ChargeAccount + "', " +
                   " WADur = " + Duration + ", " +
                   " WAHrs = " + Hours + ", " +
                   " WAMins = " + Minutes + ", " +
                   " WACost = " + Cost + ", " +
                   " WAAByType = '" + AssignByCode + "', " +
                   " WAAssnBy = " + AssignByID + ", " +
                   " WAAToType = '" + AssignToCode + "', " +
                   " WAAssnTo = " + AssignToID + ", " +
                   " WACtrlRef = '" + ControlRefCode + "', " +
                   " WAParams = '" + ControlRefParams + "'," +
                   " IseMailRequired = '" + IseMailRequired + "'" +
               "WHERE WAID = " + ActionID;
    }

    #endregion

    #region Table_WFlowTasks

    public static String GetWFlowTasksCount(Int32 TemplateID)
    {
        return "SELECT COUNT(TaskID) AS [Total Tasks] FROM WFlowTasks WHERE (WTID = " + TemplateID + ") AND (WFActive = TRUE)";
    }

    public static String GetWFlowTasksMaxID(Int32 TemplateID)
    {
        return "SELECT Max(WATID) AS [MaxID] FROM WFlowTasks WHERE (WTID = " + TemplateID + ") AND (WFActive = TRUE)";
    }

    public static String GetWFlowTasksIDByReference(String Status, String RefControlCode, String RefControlID)
    {
        return "SELECT FIRST(WATID) AS [WF Task ID] FROM WFlowTasks " +
               "WHERE (WATStatus = '" + Status + "') AND ((WFRefType = '" + RefControlCode + "') AND (WFRefID = '" + RefControlID + "'))";
    }

    public static String InsertWFlowTasks(Int32 WFTemplateID, Int32 WFItemID, String ReferenceType,
                                          String ReferenceID, Int32 TaskID, String IsWFActive, String IsWFTaskActive,
                                          String WFTaskStatus, DateTime WFTaskCreateDate, Int32 WFTaskCreatedByID,
                                          String WFTaskType, String WFTaskStep, String WFTaskNext, String WFTaskNextStatus,
                                          String WFTaskBack, String WFTaskBackStatus, String WFAssignByType,
                                          Int32 WFAssignByID, String WFAssignToType, Int32 WFAssignToID, Int32 AssignToID,
                                          String WFTaskCtrlRef, String WFTaskRefID, String WFTaskParameters,
                                          String IsTaskSchedule, DateTime WFTaskAdjPlannedStart, DateTime WFTaskAdjPlannedFinish,
                                          DateTime WFTaskAdjOverrunFinish, DateTime WFTaskAdjActualStart, DateTime WFTaskAdjActualFinish,
                                          String IsEmailRequired)
    {
        return "INSERT INTO WFlowTasks" +
                        "(WTID, WTIID, WFRefType, " +
                        "WFRefID, TaskID, WFActive, WATActive, " +
                        "WATStatus, WATCreated, WATCreatedBy, WATType, " +
                        "WATStep, WATNext, WATNextStatus, WATBack, " +
                        "WATBackStatus, WAAByType, WAAssnBy, WAAToType, " +
                        "WAAssnTO, AssnTo, WATCtrlRef, WATRefID, " +
                        "WATParams, WATSchedAdj, WATAdjPStart, WATAdjPFinish, " +
                        "WATAdjOFinish, WATAdjAStart,WATAdjAFinish, IsEmailRequired) " +
            "VALUES (" +
                    WFTemplateID + "," + WFItemID + ",'" + ReferenceType + "','" +
                    ReferenceID + "'," + TaskID + ",'" + IsWFActive + "','" + IsWFTaskActive + "','" +
                    WFTaskStatus + "','" + WFTaskCreateDate + "'," + WFTaskCreatedByID + ",'" + WFTaskType + "','" +
                    WFTaskStep + "','" + WFTaskNext + "','" + WFTaskNextStatus + "','" + WFTaskBack + "','" +
                    WFTaskBackStatus + "','" + WFAssignByType + "'," + WFAssignByID + ",'" + WFAssignToType + "'," +
                    WFAssignToID + "," + AssignToID + ",'" + WFTaskCtrlRef + "','" + WFTaskRefID + "','" +
                    WFTaskParameters + "','" + IsTaskSchedule + "','" + WFTaskAdjPlannedStart + "','" + WFTaskAdjPlannedFinish + "','" +
                    WFTaskAdjOverrunFinish + "','" + WFTaskAdjActualStart + "','" + WFTaskAdjActualFinish + "','" +
                    IsEmailRequired + "')";
    }

    public static String DeleteWFlowTasksByID(Int32 TaskID)
    {
        return "DELETE * FROM WFlowTasks WHERE (TaskID = " + TaskID + ")";
    }

    public static String UpdateWFlowTasks(Int32 WFTemplateID, Int32 WFItemID, String ReferenceType,
                                          String ReferenceID, Int32 TaskID, String WFTaskType, String WFTaskStep,
                                          String WFTaskNext, String WFTaskNextStatus,
                                          String WFTaskBack, String WFTaskBackStatus, String WFAssignByType,
                                          Int32 WFAssignByID, String WFAssignToType, Int32 WFAssignToID,
                                          String WFTaskCtrlRef, String WFTaskRefID, String WFTaskParameters,
                                          DateTime WFTaskAdjPlannedStart, DateTime WFTaskAdjPlannedFinish,
                                          DateTime WFTaskAdjOverrunFinish, DateTime WFTaskAdjActualStart,
                                          DateTime WFTaskAdjActualFinish, String IsEmailRequired, Int32 WFTaskID)
    {
        return "UPDATE WFlowTasks " +
                "SET WTID = " + WFTemplateID + ", " +
                "WTIID = " + WFItemID + ", " +
                "WFRefType = '" + ReferenceType + "', " +
                "WFRefID = '" + ReferenceID + "', " +
                "TaskID = " + TaskID + ", " +
                //"WFActive = '" + IsWFActive + "', " +
                //"WATActive = '" + IsWFTaskActive + "', " +
                //"WATStatus = '" + WFTaskStatus + "', " +
                //"WATCreated = '" + WFTaskCreateDate + "', " +
                //"WATCreatedBy = " + WFTaskCreatedByID + ", " +
                "WATType = '" + WFTaskType + "', " +
                "WATStep = '" + WFTaskStep + "', " +
                "WATNext = '" + WFTaskNext + "', " +
                "WATNextStatus = '" + WFTaskNextStatus + "', " +
                "WATBack = '" + WFTaskBack + "'," +
                "WATBackStatus = '" + WFTaskBackStatus + "', " +
                "WAAByType = '" + WFAssignByType + "', " +
                "WAAssnBy = " + WFAssignByID + ", " +
                "WAAToType = '" + WFAssignToType + "', " +
                "WAAssnTo = " + WFAssignToID + ", " +
                //"AssnTo = " + AssignToID + ", " +
                "WATCtrlRef = '" + WFTaskCtrlRef + "', " +
                "WATRefID = '" + WFTaskRefID + "', " +
                "WATParams = '" + WFTaskParameters + "', " +
                //"WATSchedAdj = '" + IsTaskSchedule + "', " +
                "WATAdjPStart = '" + WFTaskAdjPlannedStart + "', " +
                "WATAdjPFinish = '" + WFTaskAdjPlannedFinish + "', " +
                "WATAdjOFinish = '" + WFTaskAdjOverrunFinish + "', " +
                "WATAdjAStart = '" + WFTaskAdjActualStart + "', " +
                "WATAdjAFinish = '" + WFTaskAdjActualFinish + "', " +
                "IsEmailRequired = '" + IsEmailRequired + "' " +
                "WHERE (WATID = " + WFTaskID + ") ";
    }

    #endregion

    #region Table_WFlowTemplate

    public static String DeleteWFlowTemplateByID(Int32 WFTemplateID)
    {
        return "DELETE * FROM WFlowTemplate WHERE (WTID = " + WFTemplateID + ")";
    }

    public static String GetWFlowTemplateMaxID()
    {
        return "SELECT Max(WTID) AS [MaxID] FROM WFlowTemplate";
    }

    public static String InsertWFlowTemplate(String WFTemplateName, String WFTemplateTypeCode,
                                             String WFTemplateDescription)
    {
        return "INSERT INTO WFlowTemplate" +
                    "(WTName, WTType, WTDesc) " +
               "VALUES" +
                   "('" + WFTemplateName + "','" + WFTemplateTypeCode + "','" + WFTemplateDescription + "')";
    }


    public static String UpdateWFlowTemplate(Int32 WFTemplateID, String WFTemplateName, String WFTemplateTypeCode,
                                             String WFTemplateDescription)
    {
        return "UPDATE WFlowTemplate " +
               "SET  WTName = '" + WFTemplateName + "', " +
                   " WTType = '" + WFTemplateTypeCode + "', " +
                   " WTDesc = '" + WFTemplateDescription + "' " +
               "WHERE WTID = " + WFTemplateID;
    }

    #endregion

    #region Table_WFlowTempItems

    public static String DeleteWFlowTempItemsByTemplateID(Int32 WFTemplateID)
    {
        return "DELETE * FROM WFlowTempItems WHERE (WTID = " + WFTemplateID + ")";
    }

    public static String DeleteWFlowTempItemsByID(Int32 WFStepID)
    {
        return "DELETE * FROM WFlowTempItems WHERE (WTIID = " + WFStepID + ")";
    }

    public static String GetWFlowTempItemsMaxID()
    {
        return "SELECT Max(WTIID) AS [MaxID] FROM WFlowTempItems";
    }

    public static String GetWFlowTempItemsStepCount(Int32 TemplateID)
    {
        return "SELECT COUNT(WTIStep) AS [Total Steps] FROM WFlowTempItems WHERE (WTID = " + TemplateID + ")";
    }

    public static String InsertWFlowTempItems(Int32 WFTemplateID, String WFStepName, String WFStepType,
                                              Int32 WFStepID, Int32 WFNextStepID, String WFNextStepStatusCode,
                                              Int32 WFBackStepID, String WFBackStepStatusCode, String WFStepDescription,
                                              String WFStepStdTaskCode, String WFStepChargeAccount, Single Duration,
                                              Int32 Hours, Int32 Minutes, Decimal Cost, String WFAssignByCode,
                                              Int32 WFAssignByID, String WFAssignToCode, Int32 WFAssignToID,
                                              String WFControlRefCode, String WFControlRefParams, String IseMailRequired)
    {
        return "INSERT INTO WFlowTempItems" +
                    "(WTID, WTIName, WTIType, WTIStep, " +
                    " WTINext, WTINextStatus, WTIBack, " +
                    " WTIBackStatus, WTIDesc, WTIStdTaskID, " +
                    " WTIChgAcct, WTIDur, WTIHrs, WTIMins, " +
                    " WTICost, WTIAByType, WTIAssnBy, WTIAToType, " +
                    " WTIAssnTo, WTICtrlRef, IseMailRequired, WTIParams) " +
               "VALUES" +
                   "(" + WFTemplateID + ",'" + WFStepName + "','" + WFStepType + "', " + WFStepID + "," +
                         WFNextStepID + ",'" + WFNextStepStatusCode + "', " + WFBackStepID + ",'" +
                         WFBackStepStatusCode + "','" + WFStepDescription + "','" + WFStepStdTaskCode + "','" +
                         WFStepChargeAccount + "'," + Duration + "," + Hours + "," + Minutes + "," +
                         Cost + ",'" + WFAssignByCode + "'," + WFAssignByID + ",'" + WFAssignToCode + "'," +
                         WFAssignToID + ",'" + WFControlRefCode + "','" + IseMailRequired + "','" + WFControlRefParams + "')";
    }

    public static String UpdateWFlowTempItems(Int32 WFTemplateID, String WFStepName, String WFStepType,
                                              Int32 WFStepID, Int32 WFNextStepID, String WFNextStepStatusCode,
                                              Int32 WFBackStepID, String WFBackStepStatusCode, String WFStepDescription,
                                              String WFStepStdTaskCode, String WFStepChargeAccount, Single Duration,
                                              Int32 Hours, Int32 Minutes, Decimal Cost, String WFAssignByCode,
                                              Int32 WFAssignByID, String WFAssignToCode, Int32 WFAssignToID,
                                              String WFControlRefCode, String WFControlRefParams, String IseMailRequired,
                                              Int32 WFTemplateStepID)
    {
        return "UPDATE WFlowTempItems " +
               "SET  WTID = " + WFTemplateID + ", " +
                   " WTIName = '" + WFStepName + "', " +
                   " WTIType = '" + WFStepType + "', " +
                   " WTIStep = " + WFStepID + ", " +
                   " WTINext = " + WFNextStepID + ", " +
                   " WTINextStatus = '" + WFNextStepStatusCode + "', " +
                   " WTIBack = " + WFBackStepID + ", " +
                   " WTIBackStatus = '" + WFBackStepStatusCode + "', " +
                   " WTIDesc = '" + WFStepDescription + "', " +
                   " WTIStdTaskID = '" + WFStepStdTaskCode + "', " +
                   " WTIChgAcct = '" + WFStepChargeAccount + "', " +
                   " WTIDur = " + Duration + ", " +
                   " WTIHrs = " + Hours + ", " +
                   " WTIMins = " + Minutes + ", " +
                   " WTICost = " + Cost + ", " +
                   " WTIAByType = '" + WFAssignByCode + "', " +
                   " WTIAssnBy = " + WFAssignByID + ", " +
                   " WTIAToType = '" + WFAssignToCode + "', " +
                   " WTIAssnTo = " + WFAssignToID + ", " +
                   " WTICtrlRef = '" + WFControlRefCode + "', " +
                   " WTIParams = '" + WFControlRefParams + "'," +
                   " IseMailRequired = '" + IseMailRequired + "' " +
               "WHERE WTIID = " + WFTemplateStepID;
    }

    #endregion

    #region Role Moduke
    public static String GetAppProfile()
    {
        return "SELECT ProfileId,ProfileDesc FROM AppSecProfiles  ";
    }
    public static String GetAppProfileForSubMenu(int ProfileId)
    {
        return "SELECT ProfileId,ProfileDesc FROM AppSecProfiles where ( ProfileId = " + ProfileId + ")";
    }
    public static String AddRole(String TxtBoxRole)
    {

        return "INSERT INTO AppSecProfiles" +
                    "( ProfileDesc) " +
               "VALUES" +
                   "('" + TxtBoxRole + "')";
    }
    public static String GetAppPagesList(int PageId)
    {
        return @"select * from(
select ChangesID as ID,  ControlId,ControlName,PageId
FROM Form_Changes
union all
SELECT DocInfoID as ID, ControlId,ControlName,PageId FROM Form_Documents
union all
select  TaskId as ID, ControlId,ControlName,PageId from Form_TaskInformation
union all
SELECT ProjectId as ID , ControlId,ControlName,PageId FROM Form_Project
union all
SELECT GroupInfoID as ID , ControlId,ControlName,PageId FROM Form_Groups
union all
SELECT ActionInfoID as ID , ControlId,ControlName,PageId FROM Form_Actions
union all
SELECT TemplateInfoID as ID , ControlId,ControlName,PageId FROM Form_Templates
union all 
SELECT HD_ID as ID , ControlId,ControlName,PageId FROM Form_HelpDesk
)a  where ( a.PageId = " + PageId + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static String GetAppPagesForRoleModuleGrid(int PageId)
    {
        return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId,IIf([Ap.ID] in(select P.Parentid From AppPage P where P.Parentid is not null), 0, IIf([Ap.ID]not in(select  P.Parentid From AppPage P where P.Parentid is not null), 1)) As HasChildernMenu  From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID  where ( P.ID = " + PageId + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static String NewGetAppPagesForRoleModuleGrid(int PageId, Int32 RoleID)
    {
        return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId,IIf([Ap.ID] in(select P.Parentid From AppPage P where P.Parentid is not null), 0, IIf([Ap.ID]not in(select  P.Parentid From AppPage P where P.Parentid is not null), 1)) As HasChildernMenu,IIf([Ap.ID] in(select u.Child_ModuleID From User_Main_Modules u  where RoleId=" + RoleID + "), 0, IIf([Ap.ID] not in(select u.Child_ModuleID From User_Main_Modules u  where RoleId=" + RoleID + "), 1)) As Checked  From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID  where ( P.ID = " + PageId + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }

    public static String getSubenu(int SubMenuId)
    {
        return "SELECT  SubId,SubmenuName From SubMenu where (SubMenuId = " + SubMenuId + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";
    }
    public static string InsertSubMenu(String SubMenuName, Int32 MainMenuId, Int32 SubModuleId)
    {
        return "INSERT INTO SubMenu" +
                    "(SubmenuName,MainMenuId,SubMenuId) " +
               "VALUES" +
                   "('" + SubMenuName + "'," + MainMenuId + "," + SubModuleId + ")";
    }
    public static String GetAllPagesWherePageIdiSnOTnULL()
    {
        return "SELECT ID,PageName FROM AppPage  where ParentID is Null and ID<>24";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static String GetChildenPages(Int32 ParentID)
    {
        return "SELECT ID,PageName FROM AppPage  where ParentID is not Null and (ParentID = " + ParentID + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }

    public static String GetSubModulePages(Int32 ParentID)
    {
        return "SELECT ID,PageName FROM AppPage  where  (ParentID = " + ParentID + ")";
        //+
        //"and (ParentID = " + ParentID + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static String GetSubModules3level(Int32 ParentID)
    {
        return "SELECT ID,PageName FROM AppPage  where ParentID is not Null and (ParentID = " + ParentID + ")";
        //+
        //"and (ParentID = " + ParentID + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static String GetAllPagesWherePageIdiSnOTnULLForSubMenu(int ID)
    {
        return "SELECT ID,PageName FROM AppPage  where (ID = " + ID + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static String getsubmenu(int ID, Int32 RoleID)
    {
        return "select AppPage.ID as MenuId, PageName as Title,PageFolder,PageFolderName, IIF(ISNULL(ParentId), 0, ParentId) as ParentMenuId ,PageFolder & '/'& PageFolderName as Url,IIf([AppPage.ID] in(select u.Child_ModuleID From User_Main_Modules u  where RoleId=" + RoleID + "), 0,IIf([AppPage.ID] not in(select u.Child_ModuleID From User_Main_Modules u  where RoleId=" + RoleID + "), 1)) As Checked from AppPage where AppPage.ParentId=" + ID + "";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    //public static String getrecord(int RoldId)
    //{
    //    return "select AppPage.series,AppPage.ID as MenuId, PageName as Title,PageFolder,PageFolderName, IIF(ISNULL(ParentId), 0, ParentId) as ParentMenuId ,PageFolder & '/'& PageFolderName as Url from AppPage inner join User_Main_Modules on AppPage.ID = User_Main_Modules.Main_ModuleID where ParentId is null and User_Main_Modules.RoleID = " + RoldId + " order by AppPage.series asc"
    //        + " UNION "+
    //    "select AppPage.series, AppPage.ID as MenuId, PageName as Title,PageFolder,PageFolderName, IIF(ISNULL(ParentId), 0, ParentId) as ParentMenuId , '../'& PageFolder & '/' & PageFolderName as Url from AppPage inner join User_Main_Modules on AppPage.ID = User_Main_Modules.Child_ModuleID where ParentId is not null and User_Main_Modules.RoleID = " + RoldId + " order by AppPage.series Desc";
    //    //return "select ID as MenuId, PageName as Title,PageFolder,PageFolderName, IIF(ISNULL(ParentId), 0, ParentId) as ParentMenuId ,PageFolder & '/'& PageFolderName as Url from AppPage";
    //    //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    //}
    public static String GetSideBarMainMenu(int ProfileId)
    {
        return "SELECT Distinct a.ID,PageName,b.Profile_ID FROM AppPage a inner join User_Main_Modules b on a.ID = b.Main_ModuleID where ParentID is Null and (b.RoleID =" + ProfileId + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static String ShowFieldsData(Int32 PageId, Int32 RoleId)
    {
        return "select b.ID, a.DocInfoId,a.Controlid  from  Form_Documents a inner join User_Assign_Fields b on a.DocInfoId =b.FieldsID where (b.RoleID = " + RoleId + ")and(b.PageID=" + PageId + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static string DeleteFromRolePages(Int32 RoleID)
    {
        return "Delete * from RolePages where (RoleID = " + RoleID + ")";
    }
    public static string InsertRolePage(Int32 RoleID, Int32 PageID)
    {
        return "INSERT INTO RolePages" +
                    "(RoleID, PageID) " +
               "VALUES" +
                   "(" + RoleID + ",'" + PageID + "')";
    }

    public static string InsertRolePages(Int32 RoleID, Int32 Profile_ID, Int32 Main_ModuleID, Int32 Child_ModuleID)
    {
        return "INSERT INTO  User_Main_Modules" +
                    "(RoleID,Profile_ID, Main_ModuleID,Child_ModuleID) " +
               "VALUES" +
                   "(" + RoleID + "," + Profile_ID + ",'" + Main_ModuleID + "','" + Child_ModuleID + "')";
    }

    public static string InsertAssignFields(Int32 RoleID, Int32 PaegID, Int32 FieldsID, byte ViewStatus)
    {
        return "INSERT INTO  User_Assign_Fields" +
                    "(RoleID,PageID, FieldsID,ViewStatus) " +
               "VALUES" +
                   "(" + RoleID + "," + PaegID + ",'" + FieldsID + "','" + ViewStatus + "')";
    }


    public static string deletePageRoles(Int32 RoleID, Int32 Main_ModuleID, Int32 Child_ModuleId)
    {
        return "Delete * from  User_Main_Modules where (RoleID = " + RoleID + ")and(Main_ModuleId=" + Main_ModuleID + ")and( Child_ModuleID=" + Child_ModuleId + ")";
    }
    public static string getPageIdByRoleId(Int32 RoleId)
    {
        return "select AP.PageName as PageName,AP.PageFolder As Folder, AP.PageFolderName as FolderPage, AP.ParentID As Parent,RoleID from AppPage AP inner join RolePages RP on RP.PageID = Ap.ID where (RP.RoleID = " + RoleId + ")";
    }
    public static string getpageByroleIdatalist(Int32 Profile_ID, int ParentId)
    {
        return "SELECT distinct b.Parentid,b.PageName,b.PageFolder & '/'& b.PageFolderName as PagePath FROM User_Main_Modules a inner join AppPage b on a.Child_ModuleID = b.ID where b.Parentid = " + ParentId + " and (a.RoleID = " + Profile_ID + ")";
    }

    public static String ShowFromGroupsData(Int32 PageId, Int32 RoleId)
    {
        return "select b.ID, a.ControlId,a.GroupInfoid  from  Form_Groups a inner join User_Assign_Fields b on a.GroupInfoId =b.FieldsID where (b.RoleID = " + RoleId + ")and(b.PageID=" + PageId + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }

    public static String ShowFromActionsData(Int32 PageId, Int32 RoleId)
    {
        return "select b.ID, a.ControlId,a.ActionInfoid  from  Form_Actions a inner join User_Assign_Fields b on a.ActionInfoId =b.FieldsID where (b.RoleID = " + RoleId + ")and(b.PageID=" + PageId + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }

    public static string DeleteAssignFields(Int32 RoleID, Int32 PaegID)
    {
        return "delete from User_Assign_Fields where RoleID=" + RoleID + "" + " and PageID = " + PaegID + "";
    }

    public static string DeleteAssignFields(Int32 RoleID, Int32 PaegID, int FieldId)
    {
        return "delete from User_Assign_Fields where RoleID=" + RoleID + "" + " and PageID = " + PaegID + " and FieldsID = " + FieldId + "";
    }
    public static String ShowFromTemplatesData(Int32 PageId, Int32 RoleId)
    {
        return "select b.ID, a.ControlId,a.TemplateInfoid  from  Form_Templates a inner join User_Assign_Fields b on a.TemplateInfoId =b.FieldsID where (b.RoleID = " + RoleId + ")and(b.PageID=" + PageId + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }

    public static String GetAssignedFormFieldsData(Int32 PageId, Int32 RoleId)
    {
        return "select * from (" +
            "select d.DocInfoId as Id,d.controlId,a.pageId,a.roleid from form_documents d" +
" inner join user_assign_fields a on d.pageId = a.pageId and d.DocInfoId = a.FieldsID " +
" union all " +
            "select d.ChangesID as Id,d.controlId,a.pageId,a.roleid from form_Changes d" +
 " inner join user_assign_fields a on d.pageId = a.pageId and d.ChangesID = a.FieldsID " +
 " union all " +
            "select d.TaskId as Id,d.controlId,a.pageId,a.roleid from form_TaskInformation d" +
" inner join user_assign_fields a on d.pageId = a.pageId and d.TaskId = a.FieldsID " +
" union all " +
            "select d.ProjectId as Id,d.controlId,a.pageId,a.roleid from form_project d" +
" inner join user_assign_fields a on d.pageId = a.pageId and d.ProjectId = a.FieldsID " +
" union all " +
            "select d.GroupInfoID as Id,d.controlId,a.pageId,a.roleid from form_groups d" +
" inner join user_assign_fields a on d.pageId = a.pageId and d.GroupInfoID = a.FieldsID " +
" union all " +
            "select d.ActionInfoID as Id,d.controlId,a.pageId,a.roleid from form_actions d" +
" inner join user_assign_fields a on d.pageId = a.pageId and d.ActionInfoID = a.FieldsID " +
            " union all " +
            "select d.TemplateInfoId as Id,d.controlId,a.pageId,a.roleid from form_templates d" +
" inner join user_assign_fields a on d.pageId = a.pageId and d.TemplateInfoId = a.FieldsID " +
" Union All " +
"SELECT h.HD_ID as Id,h.ControlId,h.PageId,a.roleid FROM Form_HelpDesk h inner join user_assign_fields a on h.PageId = a.pageId and h.HD_ID = a.FieldsID" +
")a"
            + " where (a.RoleID = " + RoleId + ")and(a.PageID=" + PageId + ")";

    }
    #endregion
    #region
    //Add ROLE
    public static String GetAllPagesWherePageIdiSnOTnULLFiedwise()
    {
        return "SELECT ID,PageName FROM AppPage  where ParentID is Null and ID<>24 and ID=1";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static String GetAllRoles()
    {
        return "SELECT 0 as ProfileId , '-Select Profile-' as ProfileDesc  FROM Roles union SELECT ProfileId,ProfileDesc FROM AppSecProfiles ";
    }
    public static String SelectAllRolesForGridview(Int32 RoleID)
    {
        if (RoleID == 0)
        {
            return "SELECT ProfileId,ProfileDesc FROM AppSecProfiles";
        }
        else
        {
            return "SELECT ProfileId,ProfileDesc FROM AppSecProfiles where ProfileId=" + RoleID + "";
        }

        //  return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId,IIf([Ap.ID] in(select P.Parentid From AppPage P where P.Parentid is not null), 0, IIf([Ap.ID]not in(select  P.Parentid From AppPage P where P.Parentid is not null), 1)) As HasChildernMenu,IIf([Ap.ID] in(select u.Child_ModuleID From User_Main_Modules u  where RoleId=" + RoleID + "), 0, IIf([Ap.ID] not in(select u.Child_ModuleID From User_Main_Modules u  where RoleId=" + RoleID + "), 1)) As Checked  From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID  where ( P.ID = " + PageId + ")";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static String checkexistingRoles(String RoleName)
    {
        return "SELECT ProfileId,ProfileDesc FROM AppSecProfiles where ProfileDesc='" + RoleName + "'";
    }
    public static String AddRoles(String TxtBoxRole)
    {

        return "INSERT INTO AppSecProfiles(ProfileDesc)" +

               "VALUES" +
                   "('" + TxtBoxRole + "')";
    }
    public static String UpdateRoles(String TxtBoxRole, Int32 RoleId)
    {

        return "update AppSecProfiles set ProfileDesc='" + TxtBoxRole + "' where ProfileId=" + RoleId + "";
    }
    public static String DeleteRoles(Int32 RoleId)
    {

        return "Delete from  AppSecProfiles where ProfileId=" + RoleId + "";
    }
    public static String GetAssigningFields(int PageId, int RoleID, int securityMode)
    {
        if (securityMode == 1)
        {
            return "SELECT a.ID, a.MasterFieldID, a.MasterFieldDesc, a.SubFieldID, a.SubFieldDesc, a.PageID,IIf([a.MasterFieldID] in(SELECT a.MasterID  FROM U_Assign_Dropdowns a where a.PageID=" + PageId + " and a.IsVisible<>0 and a.RoleID=" + RoleID + "), 1, " +
            "IIf([a.MasterFieldID] not in(SELECT a.MasterID FROM U_Assign_Dropdowns a where a.PageID =" + PageId + "and a.IsVisible <> 0 and a.RoleID = " + RoleID + "), 0)) As Checked FROM AssignFields a where a.PageID=" + PageId + "";
        }
        if (securityMode == 2)
        {
            return "SELECT a.ID, a.MasterFieldID, a.MasterFieldDesc, a.SubFieldID, a.SubFieldDesc, a.PageID,IIf([a.MasterFieldID] in(SELECT a.MasterID  FROM U_Assign_Dropdowns a where a.PageID=" + PageId + " and a.IsView<>0 and a.RoleID=" + RoleID + "), 1, " +
            "IIf([a.MasterFieldID] not in(SELECT a.MasterID FROM U_Assign_Dropdowns a where a.PageID =" + PageId + "and a.IsView <> 0 and a.RoleID = " + RoleID + "), 0)) As Checked FROM AssignFields a where a.PageID=" + PageId + "";
        }
        else
        {
            return "SELECT a.ID, a.MasterFieldID, a.MasterFieldDesc, a.SubFieldID, a.SubFieldDesc, a.PageID,IIf([a.MasterFieldID] in(SELECT a.MasterID  FROM U_Assign_Dropdowns a where a.PageID=" + PageId + " and a.IsEdit<>0 and a.RoleID=" + RoleID + "), 1, " +
         "IIf([a.MasterFieldID] not in(SELECT a.MasterID FROM U_Assign_Dropdowns a where a.PageID =" + PageId + "and a.IsEdit <> 0 and a.RoleID = " + RoleID + "), 0)) As Checked FROM AssignFields a where a.PageID=" + PageId + "";

        }


    }
    public static String GetAllSubPages(Int32 ParentId)
    {
        return "SELECT ID,PageName FROM AppPage  where ParentID is not Null and ID<>24 and ParentId=" + ParentId + "";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static string Insert_Dropdowns(Int32 PageID, String MasterID, string ChildID, Int32 RoleID, Int32 securityMode)
    {

        if (securityMode == 1)
        {
            return "insert into U_Assign_Dropdowns(PageID,MasterID,ChildID,RoleID,IsVisible) VALUES" + "(" + PageID + ",'" + MasterID + "','" + ChildID + "'," + RoleID + "," + securityMode + ")";
        }
        if (securityMode == 2)
        {
            return "insert into U_Assign_Dropdowns(PageID,MasterID,ChildID,RoleID,IsView) VALUES" + "(" + PageID + ",'" + MasterID + "','" + ChildID + "'," + RoleID + "," + securityMode + ")";
        }
        else
        {
            return "insert into U_Assign_Dropdowns(PageID,MasterID,ChildID,RoleID,IsEdit) VALUES" + "(" + PageID + ",'" + MasterID + "','" + ChildID + "'," + RoleID + "," + securityMode + ")";

        }
    }
    public static string DeleteDropdowns(Int32 PageID, String MasterID, string ChildID, Int32 RoleID, Int32 securityMode)
    {
        if (securityMode == 1)
        {
            return "Delete From U_Assign_Dropdowns where PageID=" + PageID + " and MasterID='" + MasterID + "'and RoleID=" + RoleID + " and IsVisible=True";
        }
        if (securityMode == 2)
        {
            return "Delete From U_Assign_Dropdowns where PageID=" + PageID + " and MasterID='" + MasterID + "'and RoleID=" + RoleID + "and IsView=True";
        }
        else
        {
            return "Delete From U_Assign_Dropdowns where PageID=" + PageID + " and MasterID='" + MasterID + "'and RoleID=" + RoleID + " and IsEdit=True";
        }
    }
    public static string DeleteDropsDownAll(Int32 PageID, Int32 RoleID, Int32 securityMode)
    {
        if (securityMode == 1)
        {
            return "Delete From U_Assign_Dropdowns where PageID=" + PageID + " and RoleID=" + RoleID + " and IsVisible=True";
        }
        if (securityMode == 2)
        {
            return "Delete From U_Assign_Dropdowns where PageID=" + PageID + " and RoleID=" + RoleID + "and IsView=True";
        }
        else
        {
            return "Delete From U_Assign_Dropdowns where PageID=" + PageID + "and RoleID=" + RoleID + " and IsEdit=True";
        }
    }

    public static String ShowDropdowns(Int32 RoleId, Int32 PageId)
    {
        return "SELECT a.ID, a.MasterID FROM U_Assign_Dropdowns a where ( a.RoleID = " + RoleId + ")and(a.PageID=" + PageId + ") and  a.IsVisible<>0";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static String visibleDropDown(Int32 RoleId, Int32 PageId)
    {
        return "SELECT a.ID, a.ChildID FROM U_Assign_Dropdowns a where ( a.RoleID = " + RoleId + ")and(a.PageID=" + PageId + ") and  a.IsView<>0";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    public static String EnabledDropDown(Int32 RoleId, Int32 PageId)
    {
        return "SELECT a.ID, a.ChildID FROM U_Assign_Dropdowns a where ( a.RoleID = " + RoleId + ")and(a.PageID=" + PageId + ") and  a.IsEdit<>0";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    #endregion
    #region 
    //HlepDesk
    #region

    public static String Insert_HelpDesk(Int32 RequestNo, String Status, String RequestType, String Priority, String RequestBy, DateTime RequestDate, String Department, String Supervisor, DateTime DueDate, String Project, String Description)
    {
        return "INSERT INTO HelpDesk " +
                    "(RequestNo, Status,RequestType,Priority,RequestBy,RequestDate,Department,Supervisor, DueDate,Project,Description)" +
                "VALUES ( " + RequestNo + ",'" + Status + "','" + RequestType + "','" + Priority + "','" + RequestBy + "','"
                            + RequestDate + "','" + Department + "','" + Supervisor + "','" + DueDate + "','" + Project + "','" + Description + "')";
    }
    public static String GetViewChangesByIDsHelpdesk(Int32 RequestNo)
    {
        return "SELECT RequestNo, Status,RequestType,Priority,RequestBy,RequestDate,Department,Supervisor, DueDate,Project,Description FROM HelpDesk WHERE (RequestNo = '" + RequestNo + "') ORDER BY RequestNo";
    }

    public static string GetHelpDeskTemplate(Int32 Id)
    {
        return "SELECT Template From HelpDeskTemplate Where RequestTypeId = " + Id + "";
    }
    public static String getmaxHelpdeskid()
    {
        return "select max(HD_ID)+1 as Maxid  from HelpDesk";
    }
    public static String UpdateChangesRequestHelpdesk(Int32 RequestNo, String Status, String RequestType, String Priority, String RequestBy, DateTime RequestDate, String Department,
         String Supervisor, DateTime DueDate, String Project, String Description)
    {

        return "UPDATE HelpDesk " +
               "SET  Status = '" + Status + "'" +
               ", RequestType = '" + RequestType + "'" +
               ", Priority = '" + Priority + "'" +
               ", RequestBy = '" + RequestBy + "'" +
               ", RequestDate = '" + RequestDate + "'" +
               ", Department = '" + Department + "'" +
               ", Supervisor = '" + Supervisor + "'" +
               ", DueDate = '" + DueDate + "'" +
               ", Project = '" + Project + "'" +
               ", Description = '" + Description + "'" +

               "WHERE RequestNo ='" + RequestNo + "'";
    }
    public static String DeleteRequestHelpDESK(String RequestNo)
    {
        return "DELETE * FROM HelpDesk WHERE (RequestNo = '" + RequestNo + "')";
    }
    //public static String DeleteChangesByID(String ReferenceType, Int32 ChangeID)
    //{
    //    return "DELETE * FROM Changes WHERE (RefType = '" + ReferenceType + "') AND (CO = " + ChangeID + ")";
    //}
    public static string DeletePreviousRights(Int32 ToRoleID)
    {
        return "Delete From User_Main_Modules where RoleID=" + ToRoleID;

    }
    public static string deleteDropDownRights(Int32 ToRoleID)
    {
        return "Delete From U_Assign_Dropdowns where RoleID=" + ToRoleID;

    }
    public static string CopyRolesRights(Int32 FromRoleID, Int32 ToRoleID)
    {
        return " INSERT INTO  User_Main_Modules(RoleID,Profile_ID, Main_ModuleID,Child_ModuleID)" +
               " select " + ToRoleID + " , Profile_ID , Main_ModuleID,Child_ModuleID from User_Main_Modules where RoleID =" + FromRoleID;
    }
    public static string DeletePreviousAssignFields(Int32 ToRoleID)
    {
        return "Delete from User_Assign_Fields where RoleID=" + ToRoleID;

    }
    public static string CopyAssignFields(Int32 FromRoleID, Int32 ToRoleID)
    {
        return " INSERT INTO  User_Assign_Fields (RoleID,PageID, FieldsID,ViewStatus)" +
               " select " + ToRoleID + " , PageID , FieldsID, " + 1 + " from User_Assign_Fields where RoleID =" + FromRoleID;
    }
    public static string CopyDropdownFields(Int32 FromRoleID, Int32 ToRoleID)
    {
        return " insert into U_Assign_Dropdowns(PageID,MasterID,ChildID,IsVisible,IsView,IsEdit,RoleID) " +
               " PageID,MasterID,ChildID,IsVisible,IsView,IsEdit," + ToRoleID + " from U_Assign_Dropdowns where RoleID=" + FromRoleID;
    }
    #endregion
    public static String getDashBoardDataHelpDesk(string userName)
    {
        return "SELECT a.HD_ID, a.RequestNo as RequestNo,a.Status,a.RequestType,a.RequestDate,a.Department,a.Supervisor" +
            ",a.DueDate,a.Project,a.Description FROM HelpDesk a where a.RequestBy='" + userName + "'";

    }
    public static String getMainMenuLinks(int RoldId)
    {
        return @"select distinct AppPage.ID as MenuId, PageName as Title,PageFolder,PageFolderName, IIF(ISNULL(ParentId), 0, ParentId) as ParentMenuId ,
        PageFolder & '/' & PageFolderName as Url from AppPage inner join User_Main_Modules on AppPage.ID = User_Main_Modules.Child_ModuleId
        where User_Main_Modules.RoleID = " + RoldId + " and ParentId is not null and IsMainLink = true";
        //return "select ID as MenuId, PageName as Title,PageFolder,PageFolderName, IIF(ISNULL(ParentId), 0, ParentId) as ParentMenuId ,PageFolder & '/'& PageFolderName as Url from AppPage";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }

    public static String getrecord(int RoldId)
    {
        return "select AppPage.ID as MenuId, PageName as Title,PageFolder,PageFolderName, IIF(ISNULL(ParentId), 0, ParentId) as ParentMenuId ,PageFolder & '/'& PageFolderName as Url from AppPage inner join User_Main_Modules on AppPage.ID = User_Main_Modules.Main_ModuleID where ParentId is null and User_Main_Modules.RoleID = " + RoldId + " and IsMainLink = false"
            + " UNION " +
"select AppPage.ID as MenuId, PageName as Title,PageFolder,PageFolderName, IIF(ISNULL(ParentId), 0, ParentId) as ParentMenuId , IIF(ISNULL(PageFolder),'', '/')  & PageFolder & '/' & PageFolderName as Url from AppPage inner join User_Main_Modules on AppPage.ID = User_Main_Modules.Child_ModuleID where ParentId is not null and User_Main_Modules.RoleID = " + RoldId + " and IsMainLink = false";
        //return "select ID as MenuId, PageName as Title,PageFolder,PageFolderName, IIF(ISNULL(ParentId), 0, ParentId) as ParentMenuId ,PageFolder & '/'& PageFolderName as Url from AppPage";
        //return "select P.ID, P.PageName As Parent, Ap.PageName AS ChildName , Ap.ID as CId From AppPage P INNER JOIN AppPage Ap on Ap.ParentId = P.ID";

    }
    #endregion

    #region TemplatePage
    public static String GetHtmlTemplates(int id = 0)
    {
        var whereClause = "";
        if (id > 0)
        {
            whereClause = " where ht.id=" + id;
        }
        return @"  SELECT ht.id as Id,ht.Name as Name,ht.TemplateData,ap.ID as PageId, ht.SubRequestType + '|' + ht.SubRequestCode as RequestCode, ap.PageName as PageName, so.optDesc as Description
                from ( HtmlTemplates ht LEFT JOIN AppPage ap on ap.ID=ht.RequestId ) inner join stdoptions so on ht.SubRequestCode = so.optcode and ht.SubRequestType = so.optType" + whereClause;
    }

    public static String GetRequestChildData()
    {
        return "SELECT ap.ID as [PageId],ap.PageName as [PageName] FROM AppPage ap  Where parentId=1 ";
    }

    public static String AddTemplate(string templateName, string templateData, int controlId, string SubRequestType, string SubRequestCode)
    {
        return "INSERT INTO HtmlTemplates" +
                    "(Name,TemplateData,RequestId, SubRequestType, SubRequestCode) " +
               "VALUES" +
                   "('" + templateName + "','" + templateData + "'," + controlId + ", '" + SubRequestType + "', '" + SubRequestCode + "')";
    }

    public static String UpdateTemplate(string templateName, string templateData, int templateId)
    {
        return "Update HtmlTemplates Set " +
            " Name = '" + templateName + "'" +
            " ,TemplateData = '" + templateData + "'" +
            " where id = " + templateId;
    }

    public static String DeleteTemplate(int id)
    {
        return "Delete From HtmlTemplates Where Id=" + id;
    }

    public static String GetTemplateByRequestId(string currentPageName)
    {
        return "Select TemplateData From HtmlTemplates Where RequestId in (SELECT ID FROM AppPage WHERE PageFolderName ='" + currentPageName + "')";
    }

    public static String GetUsersForProjects()
    {
        return "SELECT EmpID as ID,UName +' [' + dept.Department + ']' as UserName FROM UserXRef as userdata LEFT JOIN DeptXRef as dept ON userdata.DeptNo=dept.DeptNo WHERE userdata.UStat = 'ACT' AND UName is not null AND dept.Department is not null";
    }

    public static String GetTemplateByRequestId(string currentPageName, string changeType)
    {
        return "Select TemplateData From HtmlTemplates Where subrequestcode = '" + changeType + "' and RequestId in (SELECT ID FROM AppPage WHERE PageFolderName ='" + currentPageName + "')";
    }
    #endregion
}