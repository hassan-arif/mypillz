using System;
using System.Data;
using WebApplication3.DAL;

namespace WebApplication3
{
    public partial class WebForm8 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadForumGrid(sender, e);//load all discussion
            pendingRequest(sender, e);//load all requests
            LoadPreviousConsultancies(sender, e);//load all previous consultations
            LoadProfileGrid(sender, e);//load profile
        }

        protected void Log_Out_Doctor(object sender, EventArgs e)
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
            LoadForumGrid(sender,e);
        }

        protected void pendingRequest(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;

            found = objMyDal.SelectPendingRequests(ref DT);

            if (found > 0)
            {
                RequestGrid.DataSource = DT;
                RequestGrid.DataBind();
            }
            else
            {
                request_message.InnerHtml = Convert.ToString("None!");
                RequestGrid.DataSource = null;
                RequestGrid.DataBind();
            }
        }

        protected void confirm_request(object sender, EventArgs e)
        {
            int Id, found = 0;
            if (int.TryParse(accept_consultancy_id.Text, out Id))
            {
                myDAL objMyDal = new myDAL();
                found = objMyDal.AcceptRequest(Id);
            }

            if (found == 1)
            {
                pendingRequest(sender, e);
                LoadPreviousConsultancies(sender, e);
                accept_consultancy_message.InnerHtml = Convert.ToString("Consultation accepted successfully!");
            }
            else
            {
                accept_consultancy_message.InnerHtml = Convert.ToString("Invalid action detected!");
            }

        }

        protected void LoadPreviousConsultancies(object sender, EventArgs e)
        {
            DataTable DT = new DataTable();
            myDAL objMyDal = new myDAL();

            int found;

            found = objMyDal.ChoosePrevConsultancies(ref DT);

            if (found > 0)
            {
                completed_consultancies.DataSource = DT;
                completed_consultancies.DataBind();
            }
            else
            {
                completed_consultancies_message.InnerHtml = Convert.ToString("None!");
                completed_consultancies.DataSource = null;
                completed_consultancies.DataBind();
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