using System;
using System.Data;
using WebApplication3.DAL;

namespace WebApplication3
{
    public partial class patient : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadForumGrid(sender, e);//load forum discussion

            PatMedLoadGrid(sender, e);//load all medicine catalogue
            inProgressPatOrders(sender, e);//load inprogress orders of patient
            patientUnratedOrder(sender, e);//load all completed orders which are unrated
            ratedOrders(sender, e);//load all rated orders

            LoadDocGrid();//load all doctors
            BookedAppointment(sender, e);//loads all booked appointments

            patientUnratedConsultancy(sender, e);//load all completed consultancies which are unrated
            ratedConsultancy(sender, e);//load all completed consultancies which are rated
            LoadProfileGrid(sender, e);//load profile
        }
        protected void Log_Out_Patient(object sender, EventArgs e)
        {
            myDAL objMyDal = new myDAL();
            String s = objMyDal.LogOut();
            //Response.Write(s);
            Response.Redirect("login.aspx");
        }

        public void LoadForumGrid(object sender, EventArgs e)
        {
            myDAL objMyDal = new myDAL();
            ForumGrid.DataSource = objMyDal.SelectForumDiscussion();//seting data source for this Grid
            ForumGrid.DataBind(); //bind the data source to this grid
        }

        protected void sendMessage(object sender, EventArgs e)
        {
            String Message = forum_message.Text;
            
            myDAL objMyDal = new myDAL();
            objMyDal.AddMyMsg(Message);
            LoadForumGrid(sender, e);
        }

        //function which prints all medicines of Drug table
        protected void PatMedLoadGrid(object sender, EventArgs e)
        {
            myDAL objMyDal = new myDAL();
            MedPatItemGrid.DataSource = objMyDal.SelectAllMed();//seting data source for this Grid
            MedPatItemGrid.DataBind(); //bind the data source to this grid
        }

        protected void SearchDrugVendors(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            int id, found = -1;

            if (int.TryParse(drug_id_ven.Text, out id))
            {
                myDAL objMyDal = new myDAL();
                found = objMyDal.SelectDrugVendors(id, ref DT);
            }

            if (found == 1)
            {
                search_vendor_drug_id.InnerHtml = Convert.ToString("Following Vendors Found!");
                DrugVendors.DataSource = DT;
                DrugVendors.DataBind();
            }
            else
            {
                search_vendor_drug_id.InnerHtml = Convert.ToString("No Vendors Found!");
                DrugVendors.DataSource = null;
                DrugVendors.DataBind();
            }
        }

        protected void CreateNewOrder(object sender, EventArgs e)
        {
            String venId = new_order_vendor_id.Text;
            int drugId, quantity, found = 0;

            if (int.TryParse(new_order_drug_id.Text, out drugId))
            {
                if (int.TryParse(new_order_quantity.Text, out quantity))
                {
                    myDAL objMyDal = new myDAL();
                    found = objMyDal.AddNewOrder(venId,drugId,quantity);
                }
            }

            if (found == 0)
            {
                new_order_message.InnerHtml = Convert.ToString("Invalid Entry!");
            }
            else
            {
                new_order_message.InnerHtml = Convert.ToString("Order Succeeded with Id = \"" + found + "\"");
                inProgressPatOrders(sender, e);
            }
        }

        protected void inProgressPatOrders(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;

            found = objMyDal.ChooseInProgressPatientOrders(ref DT);

            if (found > 0)
            {
                inProgressOrdersGrid.DataSource = DT;
                inProgressOrdersGrid.DataBind();   
            }
            else
            {
                in_progress_message.InnerHtml = Convert.ToString("None!");
                inProgressOrdersGrid.DataSource = null;
                inProgressOrdersGrid.DataBind();
            }
        }

        protected void patientUnratedOrder(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;
            found = objMyDal.SelectMyUnratedOrders(ref DT);

            if (found > 0)
            {
                rateOrderGrid.DataSource = DT;
                rateOrderGrid.DataBind();
            }
            else
            {
                rate_order_message.InnerHtml = Convert.ToString("Nothing to rate here!");
                rateOrderGrid.DataSource = null;
                rateOrderGrid.DataBind();
            }
        }

        protected void rateVendor(object sender, EventArgs e)
        {
            int orderId, rate, found = 0;

            if (int.TryParse(rating_order_id.Text, out orderId))
            {
                if (int.TryParse(rating_rate.Text, out rate))
                {
                    if (rate < 0) rate = 0;
                    else if (rate > 10) rate = 10;
                    myDAL objMyDal = new myDAL();
                    found = objMyDal.rateNewVendor(orderId,rate);
                }
            }

            if (found == 0)
            {
                rating_message.InnerHtml = Convert.ToString("Invalid Action detected!");
            }
            else
            {
                rating_message.InnerHtml = Convert.ToString("Vendor rated successfully!");
                patientUnratedOrder(sender, e);
                ratedOrders(sender, e);
            }
        }

        protected void ratedOrders(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;

            found = objMyDal.ChooseRatedOrders(ref DT);

            if (found > 0)
            {
                CompletedOrdersGrid.DataSource = DT;
                CompletedOrdersGrid.DataBind();
            }
            else
            {
                previous_orders_message.InnerHtml = Convert.ToString("No rated orders yet!");
                CompletedOrdersGrid.DataSource = null;
                CompletedOrdersGrid.DataBind();
            }
        }

        public void LoadDocGrid()
        {
            myDAL objMyDal = new myDAL();
            AvailableDocGrid.DataSource = objMyDal.SelectAllDoctors();//seting data source for this Grid
            AvailableDocGrid.DataBind(); //bind the data source to this grid
        }

        protected void BookAppointment(object sender, EventArgs e)
        {
            String docId = book_doctor_id.Text;
            int found = 0;

            myDAL objMyDal = new myDAL();
            found = objMyDal.BookDoc(docId);

            if (found == 0)
            {
                book_doctor_message.InnerHtml = Convert.ToString("Invalid Entry!");
            }
            else
            {
                book_doctor_message.InnerHtml = Convert.ToString("Appointment booked successfully with " + docId);
                BookedAppointment(sender, e);
            }
        }

        protected void BookedAppointment(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;

            found = objMyDal.SelectBookedAppointment(ref DT);

            if (found > 0)
            {
                BookedAppointmentGrid.DataSource = DT;
                BookedAppointmentGrid.DataBind();
            }
            else
            {
                booked_appointment_message.InnerHtml = Convert.ToString("None!");
                BookedAppointmentGrid.DataSource = null;
                BookedAppointmentGrid.DataBind();
            }
        }

        protected void patientUnratedConsultancy(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;
            found = objMyDal.SelectMyUnratedConsultancy(ref DT);

            if (found > 0)
            {
                ratingDoctorGrid.DataSource = DT;
                ratingDoctorGrid.DataBind();
            }
            else
            {
                rating_doctor_list_message.InnerHtml = Convert.ToString("Nothing to rate here!");
                ratingDoctorGrid.DataSource = null;
                ratingDoctorGrid.DataBind();
            }
        }

        protected void rateDoctor(object sender, EventArgs e)
        {
            int consultancyId, rate, found = 0;

            if (int.TryParse(consultancy_rating_order_id.Text, out consultancyId))
            {
                if (int.TryParse(consultancy_rating_value.Text, out rate))
                {
                    if (rate < 0) rate = 0;
                    else if (rate > 10) rate = 10;
                    myDAL objMyDal = new myDAL();
                    found = objMyDal.rateNewDoctor(consultancyId, rate);
                }
            }

            if (found == 0)
            {
                consultancy_rating_output.InnerHtml = Convert.ToString("Invalid Action detected!");
            }
            else
            {
                consultancy_rating_output.InnerHtml = Convert.ToString("Doctor rated successfully!");
                patientUnratedConsultancy(sender, e);
                ratedConsultancy(sender, e);
            }
        }

        protected void ratedConsultancy(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;

            found = objMyDal.ChooseRatedConsultancies(ref DT);

            if (found > 0)
            {
                PrevConsultancyGrid.DataSource = DT;
                PrevConsultancyGrid.DataBind();
            }
            else
            {
                prev_consultancy_message.InnerHtml = Convert.ToString("No rated consultations yet!");
                PrevConsultancyGrid.DataSource = null;
                PrevConsultancyGrid.DataBind();
            }
        }

        protected void LoadProfileGrid(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;

            found = objMyDal.SearchProfile(ref DT);

            if (found > 0)
            {
                ProfilePatientGrid.DataSource = DT;
                ProfilePatientGrid.DataBind();
            }
            else
            {
                profile_patient_message.InnerHtml = Convert.ToString("You're not logged in!");
                ProfilePatientGrid.DataSource = null;
                ProfilePatientGrid.DataBind();
            }

        }
    }
}