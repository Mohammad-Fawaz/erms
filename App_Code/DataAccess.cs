using System;
using System.Data;
using System.Configuration;
using System.Web.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.OleDb;

/// <summary>
/// Database Access Class
/// </summary>
static public class DataAccess
{
    /// <summary>
    /// Get Records by Query
    /// </summary>
    /// <param name="queryText"></param>
    /// <returns></returns>
    public static DataTable GetRecords(string queryText)
    {
        DataTable dtResultSet = new DataTable();

        try
        {

            using (OleDbConnection conResultSet = new OleDbConnection(Utils.GetConnectionString()))
            //using (OleDbConnection conResultSet = new OleDbConnection(WebConfigurationManager.ConnectionStrings["TestERMS"].ConnectionString))
            {
                using (OleDbCommand cmdResultSet = new OleDbCommand(queryText, conResultSet))
                {
                    conResultSet.Open();

                    using (OleDbDataReader drResultSet = cmdResultSet.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        dtResultSet.Load(drResultSet);
                    }
                }
            }

            return dtResultSet;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
        finally
        {
            dtResultSet.Dispose();
        }
    }

    /// <summary>
    /// Get Records from Configuration Database.
    /// </summary>
    /// <param name="queryText"></param>
    /// <returns></returns>
    public static DataTable GetConfigurationRecords(string queryText)
    {
        DataTable dtResultSet = new DataTable();

        try
        {
            using (OleDbConnection conResultSet = new OleDbConnection(Utils.GetConfigConnectionString()))
            //using (OleDbConnection conResultSet = new OleDbConnection(WebConfigurationManager.ConnectionStrings["TestConfigERMS"].ConnectionString))
            {
                using (OleDbCommand cmdResultSet = new OleDbCommand(queryText, conResultSet))
                {
                    conResultSet.Open();
                    using (OleDbDataReader drResultSet = cmdResultSet.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        dtResultSet.Load(drResultSet);
                    }
                }
            }

            return dtResultSet;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
        finally
        {
            dtResultSet.Dispose();
        }
    }

    /// <summary>
    /// Update OR Insert Record by Query
    /// </summary>
    /// <param name="queryText"></param>
    /// <returns></returns>
    public static Int32 ModifyRecords(String queryText)
    {
        Int32 _StatusCheck = 0;

        try
        {
            using (OleDbConnection conResultSet = new OleDbConnection(Utils.GetConnectionString()))
            //using (OleDbConnection conResultSet = new OleDbConnection(WebConfigurationManager.ConnectionStrings["TestERMS"].ConnectionString))
            {
                using (OleDbCommand cmdResultSet = new OleDbCommand(queryText, conResultSet))
                {
                    conResultSet.Open();
                    _StatusCheck = cmdResultSet.ExecuteNonQuery();
                }
            }

            return _StatusCheck;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message); //Write Log and Exceptions
        }
    }
}
