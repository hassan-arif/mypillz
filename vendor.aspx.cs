using System;
using System.Data;
using WebApplication3.DAL;

namespace WebApplication3
{
    public partial class vendor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadMyGrid(sender, e);//load current vendor's medicines
            VenMedLoadGrid(sender, e);//load all medicines
            VenCurrentOrderLoadGrid(sender, e);//load inprogress orders of vendor
            vendorCompletedOrder(sender, e);//load all completed orders of vendor
            LoadProfileGrid(sender, e);//load profile
        }
        protected void Log_Out_Vendor(object sender, EventArgs e)
        {
            myDAL objMyDal = new myDAL();
            String s = objMyDal.LogOut();
            //Response.Write(s);
            Response.Redirect("login.aspx");
        }

        //function which prints all medicines of Drug table
        protected void VenMedLoadGrid(object sender, EventArgs e)
        {
            myDAL objMyDal = new myDAL();
            MedVenItemGrid.DataSource = objMyDal.SelectAllMed();//seting data source for this Grid
            MedVenItemGrid.DataBind(); //bind the data source to this grid
        }

        protected void LoadMyGrid(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;
            found = objMyDal.SelectMyMed(ref DT);

            if (found > 0)
            {
                MyVenMed.DataSource = DT;
                MyVenMed.DataBind();
            }
            else
            {
                my_drug_message.InnerHtml = Convert.ToString("You're not selling any medicines yet!");
                MyVenMed.DataSource = null;
                MyVenMed.DataBind();
            }
        }

        protected void DropMyDrug(object sender, EventArgs e)
        {

            String Type = med_type_ven.Text;
            String Name = med_name_ven.Text;
            int Id, found = 0;
            if (int.TryParse(med_id_ven.Text, out Id)) {
                myDAL objMyDal = new myDAL();
                found = objMyDal.RemoveMyMed(Type, Id, Name);
            }

            if (found == 1)
            {
                LoadMyGrid(sender, e);
                add_drop_message.InnerHtml = Convert.ToString("Medicine removed successfully!");
            }
            else
            {
                add_drop_message.InnerHtml = Convert.ToString("Invalid entry Or no medicine found!");
            }

        }

        protected void AddMyDrug(object sender, EventArgs e)
        {
            String Type = med_type_ven.Text;
            String Name = med_name_ven.Text;
            int Id, found = 0;
            if (int.TryParse(med_id_ven.Text, out Id))
            {
                myDAL objMyDal = new myDAL();
                found = objMyDal.AddMyMed(Type, Id, Name);
            }

            if (found == 0)
            {
                LoadMyGrid(sender, e);
                VenMedLoadGrid(sender, e);
                add_drop_message.InnerHtml = Convert.ToString("Medicine added successfully!");
            }
            else if (found == 1)
            {
                add_drop_message.InnerHtml = Convert.ToString("You're already selling this medicine!");
            }
            else
            {
                add_drop_message.InnerHtml = Convert.ToString("Invalid Entry!");
            }
        }

        protected void VenCurrentOrderLoadGrid(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;

            found = objMyDal.ChooseInProgressVendorOrders(ref DT);

            if (found > 0)
            {
                VenCurrentOrderGrid.DataSource = DT;
                VenCurrentOrderGrid.DataBind();
            }
            else
            {
                in_progress_vendor_orders.InnerHtml = Convert.ToString("None!");
                VenCurrentOrderGrid.DataSource = null;
                VenCurrentOrderGrid.DataBind();
            }
        }

        protected void MarkOrder(object sender, EventArgs e)
        {
            int Id, found = 0;
            if (int.TryParse(update_order_id.Text, out Id))
            {
                myDAL objMyDal = new myDAL();
                found = objMyDal.MarkCompletion(Id);
            }

            if (found == 1)
            {
                VenCurrentOrderLoadGrid(sender, e);
                vendorCompletedOrder(sender, e);
                update_order_message.InnerHtml = Convert.ToString("Order Completion successful!");
            }
            else
            {
                update_order_message.InnerHtml = Convert.ToString("Invalid Order Id!");
            }
        }

        protected void UpdateLocation(object sender, EventArgs e)
        {
            int Id, found = 0;
            String newloc = update_order_location.Text;
            if (int.TryParse(update_order_id.Text, out Id))
            {
                myDAL objMyDal = new myDAL();
                found = objMyDal.ChangeLocation(Id,newloc);
            }

            if (found == 1)
            {
                VenCurrentOrderLoadGrid(sender, e);
                update_order_message.InnerHtml = Convert.ToString("Location changed successfully!");
            }
            else
            {
                update_order_message.InnerHtml = Convert.ToString("Invalid Data Entered!");
            }
        }

        protected void vendorCompletedOrder(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;
            found = objMyDal.SelectMyCompletedOrders(ref DT);

            if (found > 0)
            {
                vendorCompletedGrid.DataSource = DT;
                vendorCompletedGrid.DataBind();
            }
            else
            {
                vendor_completed_order_message.InnerHtml = Convert.ToString("No orders completed yet!");
                vendorCompletedGrid.DataSource = null;
                vendorCompletedGrid.DataBind();
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
                ProfileGrid.DataSource = DT;
                ProfileGrid.DataBind();
            }
            else
            {
                profile_message.InnerHtml = Convert.ToString("You're not logged in!");
                ProfileGrid.DataSource = null;
                ProfileGrid.DataBind();
            }

        }
    }
}