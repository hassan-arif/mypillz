using System;
using System.Data;
using System.Data.SqlClient;

namespace WebApplication3.DAL
{
    public class myDAL
    {
        private static readonly string connString =
        System.Configuration.ConfigurationManager.ConnectionStrings["sqlCon1"].ConnectionString;

        private static string userid = "null";

        public int LoginUser(String Id, String Pw)
        {
            int Found = 0;
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("loginUser ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@_username", SqlDbType.NVarChar, 15);
                cmd.Parameters.Add("@_password", SqlDbType.NVarChar, 30);
                cmd.Parameters.Add("@success", SqlDbType.Int).Direction = ParameterDirection.Output;

                cmd.Parameters["@_username"].Value = Id;
                cmd.Parameters["@_password"].Value = Pw;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@success"].Value); //convert to output parameter to interger format

                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }
            if (Found > 0) userid = Id;
            return Found;
        }

        public String SignupUser(String AccType, String Name, String Gender, String dob, String Pw, String email)
        {
            String Id = "fail";
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("newUser ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@Type", SqlDbType.NVarChar, 1);
                cmd.Parameters.Add("@_name", SqlDbType.NVarChar, 30);
                cmd.Parameters.Add("@_gender", SqlDbType.NVarChar, 1);
                cmd.Parameters.Add("@_dob", SqlDbType.Date);
                cmd.Parameters.Add("@Password", SqlDbType.NVarChar, 30);
                cmd.Parameters.Add("@_email", SqlDbType.NVarChar, 30);

                cmd.Parameters.Add("@_username", SqlDbType.NVarChar, 15).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@Type"].Value = AccType;
                cmd.Parameters["@_name"].Value = Name;
                cmd.Parameters["@_gender"].Value = Gender;
                cmd.Parameters["@_dob"].Value = Convert.ToDateTime(dob);
                cmd.Parameters["@Password"].Value = Pw;
                cmd.Parameters["@_email"].Value = email;

                cmd.ExecuteNonQuery();

                // read output value 
                Id = Convert.ToString(cmd.Parameters["@_username"].Value); //convert to output parameter to interger format
                con.Close();

            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }

            return Id;

        }

        public String LogOut()
        {
            String temp = userid;
            userid = "null";
            return temp;
        }

        public DataSet SelectForumDiscussion() //to get the values of all the items from table Items and return the Dataset
        {

            DataSet ds = new DataSet(); //declare and instantiate new dataset
            SqlConnection con = new SqlConnection(connString); //declare and instantiate new SQL connection
            con.Open(); // open sql Connection
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("select forum_username as ID, date_ as [Date], time_ as [Time], conversation as Chat from Forum", con);  //instantiate SQL command 
                cmd.CommandType = CommandType.Text; //set type of sqL Command
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(ds); //Add the result  set  returned from SQLCommand to ds
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());
            }
            finally
            {
                con.Close();
            }

            return ds; //return the dataset
        }

        public void AddMyMsg(String Message)
        {
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("newMessage ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.NVarChar, 15);
                cmd.Parameters.Add("@convo", SqlDbType.NVarChar, 100);

                cmd.Parameters["@username"].Value = userid;
                cmd.Parameters["@convo"].Value = Message;

                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }
        }
        public DataSet SelectAllMed() //to get the values of all the items from table Items and return the Dataset
        {

            DataSet ds = new DataSet(); //declare and instantiate new dataset
            SqlConnection con = new SqlConnection(connString); //declare and instantiate new SQL connection
            con.Open(); // open sql Connection
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("Select drug_type AS Type, drug_id AS ID, drug_name AS Name from Drug order by drug_type", con);  //instantiate SQL command 
                cmd.CommandType = CommandType.Text; //set type of sqL Command
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(ds); //Add the result  set  returned from SQLCommand to ds
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());
            }
            finally
            {
                con.Close();
            }

            return ds; //return the dataset
        }

        public int SelectMyMed(ref DataTable DT) //to get the values of all the items from table Items and return the Dataset
        {

            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("showVendorDrug ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))

                    {
                        da.Fill(ds);
                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }

            return Found;
        }

        public int RemoveMyMed(String Type, int Id, String Name)
        {
            int Found = 0;
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("dropVendorDrug ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.NVarChar, 15);
                cmd.Parameters.Add("@drug_type", SqlDbType.NVarChar, 30);
                cmd.Parameters.Add("@drug_id", SqlDbType.Int);
                cmd.Parameters.Add("@drug_name", SqlDbType.NVarChar, 30);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                cmd.Parameters["@username"].Value = userid;
                cmd.Parameters["@drug_type"].Value = Type;
                cmd.Parameters["@drug_id"].Value = Id;
                cmd.Parameters["@drug_name"].Value = Name;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int AddMyMed(String Type, int Id, String Name)
        {
            int Found = 0;
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("newVendorDrug ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@type", SqlDbType.NVarChar, 30);
                cmd.Parameters.Add("@id", SqlDbType.Int);
                cmd.Parameters.Add("@name", SqlDbType.NVarChar, 30);
                cmd.Parameters.Add("@username", SqlDbType.NVarChar, 15);
                cmd.Parameters.Add("@success", SqlDbType.Int).Direction = ParameterDirection.Output;

                cmd.Parameters["@username"].Value = userid;
                cmd.Parameters["@type"].Value = Type;
                cmd.Parameters["@id"].Value = Id;
                cmd.Parameters["@name"].Value = Name;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@success"].Value); //convert to output parameter to interger format

                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int SelectDrugVendors(int id, ref DataTable DT) //to get the values of all the items from table Items and return the Dataset
        {
            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("showVendorByDrugID ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@drugid", SqlDbType.Int);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@drugid"].Value = id;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))

                    {
                        da.Fill(ds);
                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }

            return Found;
        }

        public int AddNewOrder(String vId, int dId, int quantity)
        {
            int Found = 0;
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("orderDrug ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@patient_username", SqlDbType.NVarChar, 15);
                cmd.Parameters.Add("@vendor_username", SqlDbType.NVarChar, 15);
                cmd.Parameters.Add("@drug_id", SqlDbType.Int);
                cmd.Parameters.Add("@quantity", SqlDbType.Int);
                cmd.Parameters.Add("@success", SqlDbType.Int).Direction = ParameterDirection.Output;

                cmd.Parameters["@patient_username"].Value = userid;
                cmd.Parameters["@vendor_username"].Value = vId;
                cmd.Parameters["@drug_id"].Value = dId;
                cmd.Parameters["@quantity"].Value = quantity;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@success"].Value); //convert to output parameter to interger format

                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int ChooseInProgressPatientOrders(ref DataTable DT)
        {
            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("inProgressOrder ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@patient_username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@success", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@patient_username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@success"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);

                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());
            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int ChooseInProgressVendorOrders(ref DataTable DT) //to get the values of all the items from table Items and return the Dataset
        {
            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("vendorInProgressOrders ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))

                    {
                        da.Fill(ds);
                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }

            return Found;
        }

        public int MarkCompletion(int Id)
        {
            int Found = 0;
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("markCompletion ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@id", SqlDbType.Int);
                cmd.Parameters.Add("@success", SqlDbType.Int).Direction = ParameterDirection.Output;

                cmd.Parameters["@id"].Value = Id;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@success"].Value); //convert to output parameter to interger format

                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int ChangeLocation(int Id, String Location)
        {
            int Found = 0;
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("updateLocation ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@id", SqlDbType.Int);
                cmd.Parameters.Add("@location", SqlDbType.VarChar,40);
                cmd.Parameters.Add("@success", SqlDbType.Int).Direction = ParameterDirection.Output;

                cmd.Parameters["@id"].Value = Id;
                cmd.Parameters["@location"].Value = Location;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@success"].Value); //convert to output parameter to interger format

                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int SelectMyCompletedOrders(ref DataTable DT) //to get the values of all the items from table Items and return the Dataset
        {

            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("vendorCompletedOrders ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))

                    {
                        da.Fill(ds);
                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }

            return Found;
        }

        public int SelectMyUnratedOrders(ref DataTable DT) //to get the values of all the items from table Items and return the Dataset
        {

            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("unratedOrder ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))

                    {
                        da.Fill(ds);
                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }

            return Found;
        }

        public int rateNewVendor(int orderId, int rate)
        {
            int Found = 0;
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("rateVendor ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@orderId", SqlDbType.Int);
                cmd.Parameters.Add("@rate", SqlDbType.Int);
                cmd.Parameters.Add("@success", SqlDbType.Int).Direction = ParameterDirection.Output;

                cmd.Parameters["@orderId"].Value = orderId;
                cmd.Parameters["@rate"].Value = rate;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@success"].Value); //convert to output parameter to interger format

                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int ChooseRatedOrders(ref DataTable DT) //to get the values of all the items from table Items and return the Dataset
        {
            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("previousOrders ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))

                    {
                        da.Fill(ds);
                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }

            return Found;
        }

        public DataSet SelectAllDoctors() //to get the values of all the items from table Items and return the Dataset
        {

            DataSet ds = new DataSet(); //declare and instantiate new dataset
            SqlConnection con = new SqlConnection(connString); //declare and instantiate new SQL connection
            con.Open(); // open sql Connection
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("select doctor_username as DoctorID, doctor_name as Name, doctor_stime as StartTime, doctor_etime as EndTime, doctor_rating as Rating from Doctor", con);  //instantiate SQL command 
                cmd.CommandType = CommandType.Text; //set type of sqL Command
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(ds); //Add the result  set  returned from SQLCommand to ds
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());
            }
            finally
            {
                con.Close();
            }

            return ds; //return the dataset
        }

        public int BookDoc(String docId)
        {
            int Found = 0;
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("bookAppointment ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@patient_username", SqlDbType.NVarChar, 15);
                cmd.Parameters.Add("@doctor_username", SqlDbType.NVarChar, 15);
                cmd.Parameters.Add("@success", SqlDbType.Int).Direction = ParameterDirection.Output;

                cmd.Parameters["@patient_username"].Value = userid;
                cmd.Parameters["@doctor_username"].Value = docId;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@success"].Value); //convert to output parameter to interger format

                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int SelectBookedAppointment(ref DataTable DT)
        {
            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("bookedAppointment ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@patient_username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@patient_username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);

                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());
            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int SelectPendingRequests(ref DataTable DT)
        {
            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("pendingRequests ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);

                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());
            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int AcceptRequest(int Id)
        {
            int Found = 0;
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("confirmRequests ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@id", SqlDbType.Int);
                cmd.Parameters.Add("@username", SqlDbType.NVarChar, 15);
                cmd.Parameters.Add("@success", SqlDbType.Int).Direction = ParameterDirection.Output;

                cmd.Parameters["@id"].Value = Id;
                cmd.Parameters["@username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@success"].Value); //convert to output parameter to interger format

                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int ChoosePrevConsultancies(ref DataTable DT) //to get the values of all the items from table Items and return the Dataset
        {
            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("completedConsultancies ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))

                    {
                        da.Fill(ds);
                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }

            return Found;
        }

        public int SelectMyUnratedConsultancy(ref DataTable DT) //to get the values of all the items from table Items and return the Dataset
        {

            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("unratedDoctor ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))

                    {
                        da.Fill(ds);
                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }

            return Found;
        }

        public int rateNewDoctor(int consultancyId, int rate)
        {
            int Found = 0;
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("rateDoctor ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@consultancyId", SqlDbType.Int);
                cmd.Parameters.Add("@rate", SqlDbType.Int);
                cmd.Parameters.Add("@success", SqlDbType.Int).Direction = ParameterDirection.Output;

                cmd.Parameters["@consultancyId"].Value = consultancyId;
                cmd.Parameters["@rate"].Value = rate;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@success"].Value); //convert to output parameter to interger format

                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }
            return Found;
        }

        public int ChooseRatedConsultancies(ref DataTable DT) //to get the values of all the items from table Items and return the Dataset
        {
            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("previousConsultations ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found == 1)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))

                    {
                        da.Fill(ds);
                    }
                    DT = ds.Tables[0];
                }
                con.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }

            return Found;
        }

        public int SearchProfile(ref DataTable DT)
        {

            int Found = 0;
            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(connString);
            con.Open();
            SqlCommand cmd;
            try
            {
                cmd = new SqlCommand("userProfile ", con); //name of your procedure
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@username", SqlDbType.VarChar, 15);
                cmd.Parameters.Add("@found", SqlDbType.Int).Direction = ParameterDirection.Output;

                // set parameter values
                cmd.Parameters["@username"].Value = userid;

                cmd.ExecuteNonQuery();

                // read output value 
                Found = Convert.ToInt32(cmd.Parameters["@found"].Value); //convert to output parameter to interger format

                if (Found > 0)
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))

                    {
                        da.Fill(ds);

                    }
                    DT = ds.Tables[0];

                }
                con.Close();


            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());

            }
            finally
            {
                con.Close();
            }

            return Found;

        }
    }
}