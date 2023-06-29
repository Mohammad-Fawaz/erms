using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
using System.Web.Configuration;
using System.Net.Mail;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;

/// <summary>
/// Utils
/// </summary>
public static class Utils
{
    /// <summary>
    /// Get Session User Variables
    /// </summary>
    /// <param name="SessionID"></param>
    /// <returns></returns>
    public static Dictionary<String, String> GetSessionItems(String SessionID)
    {
        Dictionary<String, String> _dictonarySession = new Dictionary<string, string>();
        Int32 _rowCount = 0;

        try
        {
            if (!String.IsNullOrEmpty(SessionID))
            {
                using (System.Data.DataTable _tempSessionItems = DataAccess.GetRecords(DataQueries.GetEWebSessions(SessionID)))
                {
                    _rowCount = _tempSessionItems.Rows.Count;

                    if (_rowCount == 1)
                    {
                        _dictonarySession.Add("UserID", _tempSessionItems.Rows[0]["User ID"].ToString());
                        _dictonarySession.Add("UserName", _tempSessionItems.Rows[0]["User Name"].ToString());
                        _dictonarySession.Add("EmpID", _tempSessionItems.Rows[0]["Emp ID"].ToString());
                        _dictonarySession.Add("ProfileID", _tempSessionItems.Rows[0]["ProfileID"].ToString());
                    }
                }
            }

            return _dictonarySession;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);  //Write Log and Exceptions 
        }
    }

    /// <summary>
    /// Dump Sessions
    /// </summary>
    /// <param name="SID"></param>
    /// <param name="UserID"></param>
    public static void DumpSessions(String SessionID, String UserID)
    {
        try
        {
            //Delete User Session
            if (!String.IsNullOrEmpty(UserID))
            {
                DataAccess.ModifyRecords(DataQueries.DeleteEWebSessionsByUserID(UserID));
            }

            //Delete Specific Session
            DataAccess.ModifyRecords(DataQueries.DeleteEWebSessionsBySessionID((SessionID)));

            //Delete Sessions Older than 8 hours.
            DateTime _minDateTime = Convert.ToDateTime(DateTime.Today).AddHours(-8);
            DataAccess.ModifyRecords(DataQueries.DeleteEWebSessions(_minDateTime));
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions  
        }
    }

    /// <summary>
    /// Validate Required Field from Configuration
    /// </summary>
    /// <param name="reqTableName"></param>
    /// <param name="reqFieldName"></param>
    /// <returns></returns>
    public static Boolean IsRequiredField(String reqTableName, String reqFieldName)
    {
        Int32 _rowCount = 0;
        Boolean IsRequiredField = false;

        try
        {
            if (!String.IsNullOrEmpty(reqTableName) && !String.IsNullOrEmpty(reqFieldName))
            {
                using (DataTable _tempIsRequired = DataAccess.GetConfigurationRecords(DataQueries.GetCfgRF(reqTableName, reqFieldName)))
                {
                    _rowCount = _tempIsRequired.Rows.Count;

                    if (_rowCount > 0)
                    {
                        IsRequiredField = Convert.ToBoolean(_tempIsRequired.Rows[0][0].ToString());
                        //IsRequiredField = true;
                    }
                }
            }

            return IsRequiredField;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Get the Return Value from System Configuration Table
    /// </summary>
    /// <param name="Section"></param>
    /// <param name="Item"></param>
    /// <returns></returns>
    public static String GetSystemConfigurationReturnValue(String Section, String Item)
    {
        Int32 _rowCount = 0;
        String _ReturnValue = null;
        using (DataTable _tempReturnValue = DataAccess.GetConfigurationRecords(DataQueries.GetSysSettingsBySectParam(Section, Item)))
        {
            _rowCount = _tempReturnValue.Rows.Count;

            if (_rowCount > 0)
            {
                _ReturnValue = _tempReturnValue.Rows[0]["Return Value"].ToString();

            }
        }

        return _ReturnValue;
    }

    /// <summary>
    /// Get the Return Value from Machine Configuration Table
    /// </summary>
    /// <param name="Section"></param>
    /// <param name="Item"></param>
    /// <param name="MachineID"></param>
    /// <returns></returns>
    public static String GetMachineConfigurationReturnValue(String Section, String Item, String MachineID)
    {
        Int32 _rowCount = 0;
        String _ReturnValue = null;

        using (DataTable _tempReturnValue = DataAccess.GetConfigurationRecords(DataQueries.GetMachineSettingsBySectParamID(Section, Item, MachineID)))
        {
            _rowCount = _tempReturnValue.Rows.Count;

            if (_rowCount > 0)
            {
                _ReturnValue = _tempReturnValue.Rows[0]["Return Value"].ToString();

            }
        }

        return _ReturnValue;
    }

    /// <summary>
    /// Get Change Order New ID
    /// </summary>
    /// <returns></returns>
    public static Int32 GetChangeOrderNewID()
    {
        Int32 _ID = 0;

        try
        {
            using (DataTable _tempNewID = DataAccess.GetRecords(DataQueries.GetViewChangesMaxID()))
            {
                _ID = Convert.ToInt32(_tempNewID.Rows[0]["ID"].ToString()) + 1;
            }

            return _ID;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Get Tasks New ID
    /// </summary>
    /// <returns></returns>
    public static Int32 GetTasksNewID()
    {
        Int32 _ID = 0;

        try
        {
            using (DataTable _tempNewID = DataAccess.GetRecords(DataQueries.GetTasksMaxID()))
            {
                _ID = Convert.ToInt32(_tempNewID.Rows[0]["ID"].ToString()) + 1;
            }

            return _ID;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Get Step Count
    /// </summary>
    /// <param name="TemplateID"></param>
    /// <returns></returns>
    public static Int32 GetWFTemplateStepCount(Int32 TemplateID)
    {
        Int32 _Count = 0;

        try
        {
            using (DataTable _tempCount = DataAccess.GetRecords(DataQueries.GetWFlowTempItemsStepCount(TemplateID)))
            {
                _Count = Convert.ToInt32(_tempCount.Rows[0]["Total Steps"].ToString());
            }

            return _Count;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Get Task Count
    /// </summary>
    /// <param name="TemplateID"></param>
    /// <returns></returns>
    public static Int32 GetWFTaskCount(Int32 TemplateID)
    {
        Int32 _Count = 0;

        try
        {
            using (DataTable _tempCount = DataAccess.GetRecords(DataQueries.GetWFlowTasksCount(TemplateID)))
            {
                _Count = Convert.ToInt32(_tempCount.Rows[0]["Total Tasks"].ToString());
            }

            return _Count;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Get File Link from Location
    /// </summary>
    /// <param name="FileLocation"></param>
    /// <returns></returns>
    public static String GetFileLink(String FileLocation)
    {
        String _fLink = null;
        if (FileLocation.Substring(0, 2) == "\\")
        {
            _fLink = "FILE:" + FileLocation.Replace("\\", "/");
        }
        else
        {
            _fLink = "FILE://" + FileLocation.Replace("\\", "/");
        }

        return _fLink;
    }




    #region Number Scheme Generation

    /// <summary>
    /// Get New ID
    /// </summary>
    /// <param name="SchemeID"></param>
    /// <param name="SegCategory"></param>
    /// <returns></returns>
    public static String GetNewID(Int32 SchemeID, String SegCategory, String ParentID)
    {
        String _NewID = null;
        Boolean IsNewIDValid = false;
        Int32 _NumberPosition = 0;
        Int32 _MaxNumberPosition = 0;
        Int32 _rowCount = 0;

        try
        {
            _NewID = GetIDOnCheck(SchemeID, SegCategory, ParentID);

            // Validate  and Increment            
            if (!String.IsNullOrEmpty(_NewID))
            {
                //Int32 LastSegLength = 0;

                //Get Max Number Position
                _rowCount = 0;
                using (DataTable _tempMaxNumPos = DataAccess.GetRecords(DataQueries.GetQNumSchemesMaxNumPos(SchemeID)))
                {
                    _rowCount = _tempMaxNumPos.Rows.Count;
                    if (_rowCount > 0)
                    {
                        _MaxNumberPosition = Convert.ToInt32(_tempMaxNumPos.Rows[0]["Max Number Position"].ToString());
                    }
                }
                _NumberPosition = _MaxNumberPosition;

                //Loop the Increment Segment Number
                do
                {
                    Int32 LastSegLength = 0;
                    IsNewIDValid = CheckIDExists(_NewID, SegCategory);

                    if (!IsNewIDValid)
                    {
                        try
                        {
                            _NewID = GetSegmentIDIncremented(SchemeID, _NewID, SegCategory, _NumberPosition, ref LastSegLength);
                        }
                        catch (System.ArgumentOutOfRangeException ex)
                        {
                            /* -- Downgrade from the Max Segment Level upto the last segment -- */
                            if (_NumberPosition > 1)
                            {
                                _NumberPosition = _MaxNumberPosition - 1;
                            }
                            else
                            {
                                throw new Exception(ex.Message);
                            }
                        }
                        catch (System.Exception)
                        {
                            throw new Exception("The system encountered an unexpected error attempting to" +
                                                "generate a valid number. A number could not be validated." +
                                                "Please try the operation again...");
                        }
                    }
                } while (!IsNewIDValid);
            }
            else // if Scheme Format is NULL
            {
                throw new Exception("The Number Format information could not be retrieved.");
            }

            return _NewID;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions             
        }


    }

    /// <summary>
    /// Check for Start ID
    /// </summary>
    /// <param name="SchemeID"></param>
    /// <param name="SegCategory"></param>
    /// <param name="ParentID"></param>
    /// <returns></returns>
    private static String GetIDOnCheck(Int32 SchemeID, String SegCategory, String ParentID)
    {
        String _NewID = null;
        Int32 _rowCount = 0;

        //Get Initial Format for the given Scheme ID
        _rowCount = 0;
        using (DataTable _tempScheme = DataAccess.GetRecords(DataQueries.GetQNumSchemesByID(SchemeID)))
        {
            _rowCount = _tempScheme.Rows.Count;
            if (_rowCount > 0)
            {
                if (!String.IsNullOrEmpty(_tempScheme.Rows[0]["Scheme Format"].ToString()))
                {
                    _NewID = _tempScheme.Rows[0]["Scheme Format"].ToString();
                }
                else
                {
                    throw new Exception("The Number Scheme information could not be retrieved.");
                }
            }
            else
            {
                throw new Exception("The Number Scheme information could not be retrieved.");
            }
        }

        switch (SegCategory)
        {
            case "Documents":
                break;
            case "Parts":
                String _OldValue = _NewID.Substring(0, ParentID.Length);
                _NewID = _NewID.Replace(_OldValue, ParentID);
                break;
        }

        return _NewID;
    }

    /// <summary>
    /// Get Incremented Segment ID
    /// </summary>
    /// <param name="SchemeID"></param>
    /// <param name="InitialSchemeID"></param>
    /// <param name="SegCategory"></param>
    /// <param name="NumberPosition"></param>
    /// <param name="LastSegLength"></param>
    /// <returns></returns>
    private static String GetSegmentIDIncremented(Int32 SchemeID, String InitialSchemeID, String SegCategory,
                                                  Int32 NumberPosition, ref Int32 LastSegLength)
    {
        Int32 _rowCount = 0;
        String _NewID = null;
        String _MaxID = null;

        using (DataTable _tempSchemeByID = DataAccess.GetRecords(DataQueries.GetQNumSchemesByID(SchemeID, NumberPosition)))
        {
            String _NewSegmentID = null;
            String _OldSegmentID = null;

            String _SearchSegment = null;
            String _SegmentFormat = null;
            Int32 _RangeStop = 0;
            Int32 _RangeStart = 0;
            Int32 _SegmentLength = 0;
            String _LeadCharacter = null;
            String _EndCharacter = null;
            Int32 _IncrementSet = 0;

            _rowCount = _tempSchemeByID.Rows.Count;
            if (_rowCount > 0)
            {
                //Segment Length
                if (!String.IsNullOrEmpty(_tempSchemeByID.Rows[0]["Segment Length"].ToString()))
                {
                    _SegmentLength = Convert.ToInt32(_tempSchemeByID.Rows[0]["Segment Length"].ToString());
                }

                //Range Start
                if (!String.IsNullOrEmpty(_tempSchemeByID.Rows[0]["Range Start"].ToString()))
                {
                    _RangeStart = Convert.ToInt32(_tempSchemeByID.Rows[0]["Range Start"].ToString());
                }

                //Range Stop
                if (!String.IsNullOrEmpty(_tempSchemeByID.Rows[0]["Range Stop"].ToString()))
                {
                    _RangeStop = Convert.ToInt32(_tempSchemeByID.Rows[0]["Range Stop"].ToString());
                }

                //Segement Format
                if (!String.IsNullOrEmpty(_tempSchemeByID.Rows[0]["Segment Format"].ToString()))
                {
                    _SegmentFormat = _tempSchemeByID.Rows[0]["Segment Format"].ToString();
                }

                //Lead Character
                _LeadCharacter = _tempSchemeByID.Rows[0]["Lead Character"].ToString();

                //End Character                
                _EndCharacter = _tempSchemeByID.Rows[0]["End Character"].ToString();

                //Increment Set
                if (!String.IsNullOrEmpty(_tempSchemeByID.Rows[0]["Increment Set"].ToString()))
                {
                    _IncrementSet = Convert.ToInt32(_tempSchemeByID.Rows[0]["Increment Set"].ToString());
                }

                //Find MaxID From Documents Table for the Number Position Range
                if (!String.IsNullOrEmpty(_EndCharacter))
                {
                    LastSegLength = LastSegLength + _SegmentFormat.Length;
                }
                else
                {
                    LastSegLength = LastSegLength + _SegmentLength;
                }

                _SearchSegment = InitialSchemeID.Substring(0, (InitialSchemeID.Length - LastSegLength));

                _MaxID = GetSegmentsMaxID(_SearchSegment, _RangeStart, _RangeStop, SegCategory);
                if (String.IsNullOrEmpty(_MaxID))
                {
                    _MaxID = InitialSchemeID;
                }

                //Check Segment with Lead/End Character
                _OldSegmentID = _MaxID.Substring((_MaxID.Length - LastSegLength), _SegmentLength);
                _NewSegmentID = Convert.ToString(Convert.ToInt32(_OldSegmentID) + _IncrementSet);

                //Add Lead/End Character Length To Next Level Search         
                if (String.IsNullOrEmpty(_EndCharacter))
                {
                    LastSegLength = LastSegLength + (_SegmentFormat.Length - _SegmentLength);
                }

                //CheckBox for RangeStop and Format Number Segment
                if (Convert.ToInt32(_NewSegmentID) > _RangeStop)
                {
                    String Msg = "Stop Range Exceeded for SchemeID: " + SchemeID + " Number Position: " + NumberPosition;
                    throw new ArgumentOutOfRangeException(_NewSegmentID, Msg);
                }
                else
                {
                    if (_NewSegmentID.Length < _SegmentLength)
                    {
                        _NewSegmentID = _NewSegmentID.PadLeft(_NewSegmentID.Length + (_SegmentLength - _NewSegmentID.Length), '0');
                    }
                }

                //Pad Lead and End Characters
                if (!String.IsNullOrEmpty(_LeadCharacter))
                {
                    _OldSegmentID = _OldSegmentID.PadLeft(_OldSegmentID.Length + 1, Char.Parse(_LeadCharacter));
                    _NewSegmentID = _NewSegmentID.PadLeft(_NewSegmentID.Length + 1, Char.Parse(_LeadCharacter));
                }

                if (!String.IsNullOrEmpty(_EndCharacter))
                {
                    _OldSegmentID = _OldSegmentID.PadRight(_OldSegmentID.Length + 1, Char.Parse(_EndCharacter));
                    _NewSegmentID = _NewSegmentID.PadRight(_NewSegmentID.Length + 1, Char.Parse(_EndCharacter));
                }

                _NewID = _MaxID.Replace(_OldSegmentID, _NewSegmentID);

            } // records found                

        } // using                 

        return _NewID;
    }

    /// <summary>
    /// Get MaxID for the given Segment in the table
    /// </summary>
    /// <param name="SearchSegment"></param>
    /// <param name="RangeStart"></param>
    /// <param name="RangeStop"></param>
    /// <param name="SegCategory"></param>
    /// <returns></returns>
    private static String GetSegmentsMaxID(String SearchSegment, Int32 RangeStart, Int32 RangeStop,
                                           String SegCategory)
    {
        String _maxID = null;

        switch (SegCategory)
        {
            case "Documents":

                using (DataTable _tempDoc = DataAccess.GetRecords(DataQueries.GetDocumentsMaxID(SearchSegment, RangeStart, RangeStop)))
                {
                    if (!String.IsNullOrEmpty(_tempDoc.Rows[0]["MaxID"].ToString()))
                    {
                        _maxID = _tempDoc.Rows[0]["MaxID"].ToString();
                    }
                }

                break;
            case "Parts":

                using (DataTable _tempParts = DataAccess.GetRecords(DataQueries.GetPartsXRefMaxID(SearchSegment, RangeStart, RangeStop)))
                {
                    if (!String.IsNullOrEmpty(_tempParts.Rows[0]["MaxID"].ToString()))
                    {
                        _maxID = _tempParts.Rows[0]["MaxID"].ToString();
                    }
                }

                break;
        }

        return _maxID;
    }

    /// <summary>
    /// Valid if the ID DO NOT exist in the table  
    /// </summary>
    /// <param name="_newID"></param>
    /// <param name="SegCategory"></param>
    /// <returns></returns>
    private static Boolean CheckIDExists(String _newID, String SegCategory)
    {
        Boolean _IsNewIDValid = false;
        Int32 _rowCount = 0;

        switch (SegCategory)
        {
            case "Documents":
                using (DataTable _tempDocByID = DataAccess.GetRecords(DataQueries.GetDocumentsByID(_newID)))
                {
                    _rowCount = _tempDocByID.Rows.Count;
                    if (_rowCount == 0)
                    {
                        _IsNewIDValid = true;
                    }
                }
                break;
            case "Parts":
                using (DataTable _tempPartByID = DataAccess.GetRecords(DataQueries.GetPartsXRefByID(_newID)))
                {
                    _rowCount = _tempPartByID.Rows.Count;
                    if (_rowCount == 0)
                    {
                        _IsNewIDValid = true;
                    }
                }
                break;
        }

        return _IsNewIDValid;
    }

    #endregion




    /// <summary>
    /// Get Description of the given Assign Type Code and ID
    /// </summary>
    /// <param name="AssignByID"></param>
    /// <param name="AssignType"></param>
    /// <returns></returns>
    public static String GetAssignTypeName(String AssignTypeCode, Int32 AssignTypeID)
    {
        String _NameQuery = null;
        String _ReturnName = null;

        try
        {
            if (AssignTypeCode == "WGRP" || AssignTypeCode == "DEPT")
            {
                _NameQuery = DataQueries.GetWFGroupsByID(AssignTypeID);
            }
            else if (AssignTypeCode == "EMP")
            {
                _NameQuery = DataQueries.GetUserXRef(AssignTypeID);
            }

            Int32 _rowCount = 0;
            using (DataTable _tempDesc = DataAccess.GetRecords(_NameQuery))
            {
                _rowCount = _tempDesc.Rows.Count;

                if (_rowCount > 0)
                {
                    _ReturnName = _tempDesc.Rows[0]["Description"].ToString();
                }
            }

            return _ReturnName;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Get Group Member Name / Employee Name
    /// </summary>
    /// <param name="AssignTypeCode"></param>
    /// <param name="AssignTypeID"></param>
    /// <returns></returns>
    public static String GetAssignTypeMemberName(String AssignTypeCode, Int32 AssignTypeID, Int32 GroupMemberID)
    {
        String _NameQuery = null;
        String _ReturnName = null;
        Int32 _rowCount = 0;
        Int32 _GroupID = 0;

        try
        {
            if (AssignTypeCode == "WGRP" || AssignTypeCode == "DEPT")
            {
                _NameQuery = DataQueries.GetWFGroupMembsListByMemberID(AssignTypeID, GroupMemberID);
            }
            else if (AssignTypeCode == "EMP")
            {
                _NameQuery = DataQueries.GetUserXRef(AssignTypeID);
            }

            _rowCount = 0;
            using (DataTable _tempDesc = DataAccess.GetRecords(_NameQuery))
            {
                _rowCount = _tempDesc.Rows.Count;

                if (_rowCount > 0)
                {
                    _ReturnName = _tempDesc.Rows[0]["Description"].ToString();
                }
            }

            return _ReturnName;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Get First Member ID of the given AssignType Group
    /// </summary>
    /// <param name="AssignTypeCode"></param>
    /// <param name="AssignByID"></param>
    /// <returns></returns>
    public static Int32 GetAssignTypeFirstMemberID(String AssignTypeCode, Int32 AssignTypeID)
    {
        Int32 _AssignTypeID = AssignTypeID;

        try
        {
            if (AssignTypeCode == "WGRP" || AssignTypeCode == "DEPT")
            {
                using (DataTable _tempID = DataAccess.GetRecords(DataQueries.GetWFGroupMembsByID(_AssignTypeID)))
                {
                    Int32 _rowCount = _tempID.Rows.Count;

                    if (_rowCount > 0)
                    {
                        if (!String.IsNullOrEmpty(_tempID.Rows[0]["Member ID"].ToString()))
                        {
                            _AssignTypeID = Convert.ToInt32(_tempID.Rows[0]["Member ID"].ToString());
                        }
                    }
                }
            }

            return _AssignTypeID;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Get Individual Employee or Group Type List
    /// </summary>
    /// <param name="AssignTypeCode"></param>
    /// <returns></returns>
    public static DataTable GetAssignTypeList(String AssignTypeCode)
    {
        String _NameQuery = null;

        try
        {
            //if (AssignTypeCode == "WGRP" || AssignTypeCode == "DEPT")
            //{
            //    _NameQuery = DataQueries.GetWFGroups(AssignTypeCode);
            //}
            //else if (AssignTypeCode == "EMP")
            //{
            //    _NameQuery = DataQueries.GetUserXRef();
            //}

            if (AssignTypeCode == "EMP")
            {
                _NameQuery = DataQueries.GetUserXRef();
            }
            else
            {
                _NameQuery = DataQueries.GetWFGroups(AssignTypeCode);
            }


            using (DataTable _tempUser = new DataTable())
            {
                _tempUser.Columns.Add("ID", Type.GetType("System.Int32"));
                _tempUser.Columns.Add("Description", Type.GetType("System.String"));
                _tempUser.Rows.Add(0, "-NONE-");

                int _rowCount = 0;
                using (DataTable _tempList = DataAccess.GetRecords(_NameQuery))
                {
                    _rowCount = _tempList.Rows.Count;

                    if (_rowCount > 0)
                    {
                        _tempUser.Merge(_tempList, true);
                    }
                }

                return _tempUser;
            }
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Get Member List for the given GroupID
    /// </summary>
    /// <param name="AssignTypeCode"></param>
    /// <param name="AssignToID"></param>
    /// <returns></returns>
    public static DataTable GetAssignTypeGroupMemberList(String AssignTypeCode, Int32 AssignTypeID)
    {
        DataTable _MemberList = new DataTable();
        try
        {
            if (AssignTypeCode == "WGRP" || AssignTypeCode == "DEPT")
            {
                _MemberList = DataAccess.GetRecords(DataQueries.GetWFGroupMembsListByID(AssignTypeID));
                if (_MemberList.Rows.Count > 0)
                {
                    return _MemberList;
                }
            }

            return _MemberList;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Get Employee or Group Member List.
    /// </summary>
    /// <param name="AssignTypeCode"></param>
    /// <param name="AssignTypeID"></param>
    /// <returns></returns>
    public static DataTable GetAssignTypeMemberList(String AssignTypeCode, Int32 AssignTypeID)
    {
        String _NameQuery = null;

        try
        {
            if (AssignTypeCode == "WGRP" || AssignTypeCode == "DEPT")
            {
                _NameQuery = DataQueries.GetWFGroupMembsListByID(AssignTypeID);
            }
            else if (AssignTypeCode == "EMP")
            {
                _NameQuery = DataQueries.GetUserXRef();
            }

            using (DataTable _tempUser = new DataTable())
            {
                _tempUser.Columns.Add("ID", Type.GetType("System.Int32"));
                _tempUser.Columns.Add("Description", Type.GetType("System.String"));
                _tempUser.Rows.Add(0, "-NONE-");

                int _rowCount = 0;
                using (DataTable _tempList = DataAccess.GetRecords(_NameQuery))
                {
                    _rowCount = _tempList.Rows.Count;

                    if (_rowCount > 0)
                    {
                        _tempUser.Merge(_tempList, true);
                    }
                }

                return _tempUser;
            }
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }




    /// <summary>
    /// Get Control Reference Description
    /// </summary>
    /// <param name="ControlRefCode"></param>
    /// <param name="StatusCode"></param>
    /// <returns></returns>
    public static String GetControlRefDescription(String ControlRefCode, String OptCode, String OptType)
    {
        String _OptType = null;
        String _ControlStatusQuery = null;
        String _Description = null;

        try
        {
            switch (ControlRefCode)
            {
                case Constants.ChangeReferenceType:
                    if (ControlRefCode == OptCode && !String.IsNullOrEmpty(OptType))
                    {
                        _OptType = OptType;
                    }
                    else
                    {
                        _OptType = Constants.ChangeStatus;
                    }
                    _ControlStatusQuery = DataQueries.GetStdOptionsByType(_OptType, OptCode);
                    break;
                case Constants.DocReferenceType:
                    if (ControlRefCode == OptCode && !String.IsNullOrEmpty(OptType))
                    {
                        _OptType = OptType;
                    }
                    else
                    {
                        _OptType = Constants.DocumentStatus;
                    }
                    _ControlStatusQuery = DataQueries.GetStdOptionsByType(_OptType, OptCode);
                    break;
                case Constants.TaskReferenceType:
                    if (ControlRefCode == OptCode && !String.IsNullOrEmpty(OptType))
                    {
                        _OptType = OptType;
                    }
                    else
                    {
                        _OptType = Constants.TaskStatus;
                    }
                    _ControlStatusQuery = DataQueries.GetStdOptionsByType(_OptType, OptCode);
                    break;
                case Constants.MaterialDispReferenceType:
                    if (ControlRefCode == OptCode && !String.IsNullOrEmpty(OptType))
                    {
                        _ControlStatusQuery = DataQueries.GetStdOptionsByType(OptType, OptCode);
                    }
                    else
                    {
                        _ControlStatusQuery = DataQueries.GetQDispStatus(OptCode);
                    }
                    break;
                case Constants.NonConformanceReferenceType:
                    _Description = "NONE";
                    return _Description;
                    break;
                case Constants.CorrectiveActionReferenceType:
                    _Description = "NONE";
                    return _Description;
                    break;
                case Constants.ProjectReferenceType:
                    if (ControlRefCode == OptCode && !String.IsNullOrEmpty(OptType))
                    {
                        _ControlStatusQuery = DataQueries.GetStdOptionsByType(OptType, OptCode);
                    }
                    else
                    {
                        _ControlStatusQuery = DataQueries.GetQProjStatus(OptCode);
                    }
                    break;
            }

            int _rowCount = 0;
            using (DataTable _tempRefDescription = DataAccess.GetRecords(_ControlStatusQuery))
            {
                _rowCount = _tempRefDescription.Rows.Count;

                if (_rowCount > 0)
                {
                    _Description = _tempRefDescription.Rows[0]["Description"].ToString();
                }
            }

            return _Description;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Get Control Reference List
    /// </summary>
    /// <param name="ControlRefCode"></param>
    /// <returns></returns>
    public static DataTable GetControlRefStatusList(String ControlRefCode)
    {
        String _StatusTypeCode = null;
        String _ControlStatusQuery = null;

        try
        {
            using (DataTable _tempStatus = new DataTable())
            {
                _tempStatus.Columns.Add("Code", Type.GetType("System.String"));
                _tempStatus.Columns.Add("Description", Type.GetType("System.String"));
                _tempStatus.Rows.Add("-NONE-", "-NONE-");

                switch (ControlRefCode)
                {
                    case Constants.ChangeReferenceType:
                        _StatusTypeCode = Constants.ChangeStatus;
                        _ControlStatusQuery = DataQueries.GetStdOptionsByType(_StatusTypeCode);
                        break;
                    case Constants.DocReferenceType:
                        _StatusTypeCode = Constants.DocumentStatus;
                        _ControlStatusQuery = DataQueries.GetStdOptionsByType(_StatusTypeCode);
                        break;
                    case Constants.TaskReferenceType:
                        _StatusTypeCode = Constants.TaskStatus;
                        _ControlStatusQuery = DataQueries.GetStdOptionsByType(_StatusTypeCode);
                        break;
                    case Constants.MaterialDispReferenceType:
                        _ControlStatusQuery = DataQueries.GetQDispStatus();
                        break;
                    case Constants.NonConformanceReferenceType:
                        return _tempStatus;
                        break;
                    case Constants.CorrectiveActionReferenceType:
                        return _tempStatus;
                        break;
                    case Constants.ProjectReferenceType:
                        _ControlStatusQuery = DataQueries.GetQProjStatus();
                        break;
                }

                Int32 _rowCount = 0;
                using (DataTable _tempList = DataAccess.GetRecords(_ControlStatusQuery))
                {
                    _rowCount = _tempStatus.Rows.Count;

                    if (_rowCount > 0)
                    {
                        _tempStatus.Merge(_tempList, true);
                    }
                }

                return _tempStatus;
            }
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Check for valid Reference Item
    /// </summary>
    /// <param name="ControlRefCode"></param>
    /// <param name="ControlRefID"></param>
    /// <returns></returns>
    public static Int32 GetControlRefRecordCount(String ControlRefCode, String ControlRefID)
    {
        String _ControlStatusQuery = null;
        Int32 _rowCount = 0;

        try
        {
            switch (ControlRefCode)
            {
                case Constants.ChangeReferenceType:
                    Int32 _CORefID = Convert.ToInt32(ControlRefID);
                    _ControlStatusQuery = DataQueries.GetViewChangesByID(_CORefID);
                    break;
                case Constants.DocReferenceType:
                    _ControlStatusQuery = DataQueries.GetViewDocsByID(ControlRefID);
                    break;
                case Constants.TaskReferenceType:
                    Int32 _TaskRefID = Convert.ToInt32(ControlRefID);
                    _ControlStatusQuery = DataQueries.GetViewTasksByID(_TaskRefID);
                    break;
                case Constants.MaterialDispReferenceType:
                    Int32 _MDispRefID = Convert.ToInt32(ControlRefID);
                    _ControlStatusQuery = DataQueries.GetViewMatDispByMDID(_MDispRefID);
                    break;
                case Constants.NonConformanceReferenceType:
                    return _rowCount;
                    break;
                case Constants.CorrectiveActionReferenceType:
                    return _rowCount;
                    break;
                case Constants.ProjectReferenceType:
                    _ControlStatusQuery = DataQueries.GetViewProjectbyID(ControlRefID);
                    break;
            }

            using (DataTable _tempList = DataAccess.GetRecords(_ControlStatusQuery))
            {
                _rowCount = _tempList.Rows.Count;
            }

            return _rowCount;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }


    /// <summary>
    /// Update Reference Item Status
    /// </summary>
    /// <param name="ControlRefCode"></param>
    /// <param name="ControlRefID"></param>
    /// <param name="StatusCode"></param>
    /// <param name="ModifiedBy"></param>
    /// <returns></returns>
    public static Int32 UpdateReferenceItemStatus(String ControlRefCode, String ControlRefID,
                                                  String StatusCode, String ModifiedBy, DateTime ModifiedDate)
    {
        String _ControlStatusQuery = null;
        Int32 _rowCount = 0;

        try
        {
            switch (ControlRefCode)
            {
                case Constants.ChangeReferenceType:
                    Int32 _CORefID = Convert.ToInt32(ControlRefID);
                    _ControlStatusQuery = DataQueries.UpdateChangesRequest(_CORefID, ControlRefCode, StatusCode,
                                                                           ModifiedBy, ModifiedDate);
                    break;
                case Constants.DocReferenceType:
                    _ControlStatusQuery = DataQueries.UpdateDocumentByID(ControlRefID, StatusCode, ModifiedBy,
                                                                         ModifiedDate);
                    break;
                case Constants.TaskReferenceType:
                    Int32 _TaskRefID = Convert.ToInt32(ControlRefID);
                    _ControlStatusQuery = DataQueries.UpdateTasksStatus(_TaskRefID, StatusCode);
                    break;
                case Constants.MaterialDispReferenceType:
                    return _rowCount;
                    break;
                case Constants.NonConformanceReferenceType:
                    return _rowCount;
                    break;
                case Constants.CorrectiveActionReferenceType:
                    return _rowCount;
                    break;
                case Constants.ProjectReferenceType:
                    _ControlStatusQuery = DataQueries.UpdateProjXRef(ControlRefID, StatusCode);
                    break;
            }

            _rowCount = DataAccess.ModifyRecords(_ControlStatusQuery);
            return _rowCount;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }

    /// <summary>
    /// Send Mail
    /// </summary>
    /// <param name="eFrom"></param>
    /// <param name="eTo"></param>
    /// <param name="eSubject"></param>
    /// <param name="eBody"></param>
    public static void SendEmail(String eFrom, String eTo, String eSubject, String eBody)
    {
        try
        {
            eFrom = "tanmaygupta2802@gmail.com";
            MailMessage MyMail = new MailMessage(eFrom, eTo, eSubject, eBody);
            MyMail.IsBodyHtml = true;
            NetworkCredential NetworkCred = new NetworkCredential("AKIA5QFM3I47ZOSESXES", "BGIIxD9L3M2sJkE3wtBg05b4Grk6jy3G3VBuXu+paa0C");

            SmtpClient emailClient = new SmtpClient("email-smtp.us-east-2.amazonaws.com", 587);
            emailClient.UseDefaultCredentials = true;
            emailClient.Credentials = NetworkCred;
            emailClient.EnableSsl = false;
            emailClient.Send(MyMail);
        }
        catch (Exception ex)
        {

        }

    }

    /// <summary>
    /// Get Revision for given document
    /// </summary>
    /// <param name="DocumentID"></param>
    /// <returns></returns>
    public static String GetDocumentCurrentRevision(String DocumentID)
    {
        String _Revision = null;
        String Query = DataQueries.GetViewDocsByID(DocumentID);

        int _rowCount = 0;
        using (DataTable _tempRevision = DataAccess.GetRecords(Query))
        {
            _rowCount = _tempRevision.Rows.Count;

            if (_rowCount > 0)
            {
                _Revision = _tempRevision.Rows[0]["Current Revision"].ToString();
            }
        }

        return _Revision;
    }

    /// <summary>
    /// Get Restriction Text
    /// </summary>
    /// <param name="RefID"></param>
    /// <param name="RefType"></param>
    /// <returns></returns>
    public static String GetDocumentRestrictionText(String RefID, String RefType)
    {
        String _RestrictionText = null;
        String Query = DataQueries.GetViewResNoticeText(RefType, RefID);

        int _rowCount = 0;
        using (DataTable _tempRes = DataAccess.GetRecords(Query))
        {
            _rowCount = _tempRes.Rows.Count;

            if (_rowCount > 0)
            {
                _RestrictionText = _tempRes.Rows[0]["Text1"].ToString();
            }
        }

        return _RestrictionText;

    }

    /// <summary>
    /// Is Admin
    /// </summary>
    /// <param name="SessionID"></param>
    /// <returns></returns>
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

    public static String ValidateFieldData(String FieldData, String FieldDesc, String DataType,
                                   Int32 FieldLen)
    {
        Boolean bValid = false;
        String sTitle = "";
        String sMsg = "";

        FieldData = FieldData.Trim();
        if (FieldData != null && FieldData.Length > 0)
        {
            if (FieldData.Length <= FieldLen)
            {
                sMsg = null;
            }
            else
            {
                sMsg = "The data contained in the [" + FieldDesc + "] field must be a valid string " + " <br>" +
                   "no more than " + FieldLen + " characters in length." + "<br>" +
                       "The current value is [" + FieldData.Substring(0, FieldLen) + "].";
            }
        }
        else
        {
            sMsg = "The data contained in the [" + FieldDesc + "] field must be a valid string " + "<br>" +
                       "no more than " + FieldLen + " characters in length.";
        }

        return sMsg;
    }

    //Get Value from Cookies "isProdDB" (Seeting from SuperAdmin)
    public static string GetIsProdDBValue()
    {
        string isProdDB = string.Empty;
        HttpCookie reqCookies = HttpContext.Current.Request.Cookies["isProdDB"];
        if (reqCookies != null)
            isProdDB = reqCookies.Value.ToLower();
        return isProdDB;
    }

    //Set Connection string Test or Production (Seeting from SuperAdmin)
    public static String GetConnectionString()
    {
        string connectionString = string.Empty;
        string path = string.Empty;
        string isProdDB = GetIsProdDBValue();
        string testDBPath = HttpContext.Current.Server.MapPath(System.Configuration.ConfigurationManager.AppSettings["TestDBPath"]);
        string prodDBPath = HttpContext.Current.Server.MapPath(System.Configuration.ConfigurationManager.AppSettings["ProdDBPath"]);
        string provider = System.Configuration.ConfigurationManager.AppSettings["Provider"];
        if (isProdDB == "true")
            path = prodDBPath;
        else
            path = testDBPath;

        string[] files = Directory.GetFiles(path);
        if (files.Length > 0)
        {
            string fileName = Path.GetFileName(files.Where(x => x.Contains(".mdb")).FirstOrDefault());
            path = path + fileName;
        }

        connectionString = provider + path;
        return connectionString;
    }
    public static String GetConfigConnectionString()
    {
        string connectionString = string.Empty;
        string configDBPath = HttpContext.Current.Server.MapPath(System.Configuration.ConfigurationManager.AppSettings["ConfigDBPath"]);
        string provider = System.Configuration.ConfigurationManager.AppSettings["Provider"];

        connectionString = provider + configDBPath;
        return connectionString;
    }

    //Delete all the files from Directory
    public static void DeleteFilesFromDirectory(string path)
    {
        System.IO.DirectoryInfo di = new DirectoryInfo(path);
        foreach (FileInfo file in di.GetFiles())
        {
            file.Delete();
        }
        foreach (DirectoryInfo dir in di.GetDirectories())
        {
            dir.Delete(true);
        }
    }

    public static int GetRandomNumber()
    {
        Random generator = new Random();
        return generator.Next(10000, 100000);
    }
}