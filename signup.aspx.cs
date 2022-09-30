using System;
using System.Data;
using WebApplication3.DAL;

namespace WebApplication3
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Create_Account(object sender, EventArgs e)
        {
            String AccType = "n";
            if (rdDoctor.Checked) AccType = "d";
            if (rdPatient.Checked) AccType = "p";
            if (rdVendor.Checked) AccType = "v";

            String Name = txtName.Text;

            String Gender = gender.Text;
            if (Gender == "Male") Gender = "M";
            else if (Gender == "Female") Gender = "F";
            else if (Gender == "Other") Gender = "O";

            String dob = Request["birthday"];

            String Pw = txtPassword1.Text;
            String email = TextBox1.Text;

            myDAL objMyDal = new myDAL();

            String id = "fail";

            id = objMyDal.SignupUser(AccType, Name, Gender, dob, Pw, email);

            if (id != "fail")
            {
                message1.InnerHtml = Convert.ToString("Account Created Successfully with username \"" + id + "\"");
            }
            else
            {
                message1.InnerHtml = Convert.ToString("Invalid Data Entered!");
            }

        }
    }
}