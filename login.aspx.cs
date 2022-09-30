using System;
using System.Data;
using WebApplication3.DAL;

namespace WebApplication3
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Verify_Account(object sender, EventArgs e)
        {

            String Id = TextBox2.Text;
            String Pw = txtPassword.Text;

            myDAL objMyDal = new myDAL();

            int found;
            found = objMyDal.LoginUser(Id, Pw);

            if (found == 1)
            {
                Response.Redirect("doctor.aspx");
            }
            else if(found == 2)
            {
                Response.Redirect("patient.aspx");
            }
            else if(found == 3)
            {
                Response.Redirect("vendor.aspx");
            }
            else
            {
                message.InnerHtml = Convert.ToString("Username or Password entered is invalid");
                //ItemGrid.DataSource = null;
                //ItemGrid.DataBind();
            }

        }

    }
}