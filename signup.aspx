<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="signup.aspx.cs" Inherits="WebApplication3.WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SignUp - MyPillz</title>
    <style>  
        body {
            background-image: url("st.jpg");

            text-align: center;
            color: white;
            font-family: Arial, Verdana;
            font-weight:bold;
            font-size: 110%
        }
        .img-container {
            text-align: center;
            display: block;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <br /><br /><br /><br /><br /><br /><h1>Sign Up</h1>

        <%-- Radio Button for Account Type --%>
        Please Enter your Account Type:
        <div>
        <asp:RadioButton ID="rdDoctor" GroupName="AccountType" runat="server" Text="Doctor"/>
        <asp:RadioButton ID="rdPatient" GroupName="AccountType" runat="server" Text="Patient"/>
        <asp:RadioButton ID="rdVendor" GroupName="AccountType" runat="server" Text="Vendor"/>
        </div>
        <br /><br />


        <%-- First + Last Name Textbox --%>
        Please enter the following credentials<br /><br />
        Name:&nbsp;&nbsp;
        <asp:TextBox ID="txtName" runat="server"></asp:TextBox>&nbsp;<br /><br />

        <%-- Dropdown List for Gender --%>
        Gender:&nbsp;
        <asp:DropDownList ID="gender" runat="server">
            <asp:ListItem Text="Select" Value="0"></asp:ListItem>
            <asp:ListItem Text="Male" Value="M"></asp:ListItem>
            <asp:ListItem Text="Female" Value="F"></asp:ListItem>
            <asp:ListItem Text="Other" Value="O"></asp:ListItem>
        </asp:DropDownList><br /><br />

        <%-- Calendar --%>
            <label for="birthday">Date of Birth:</label>
            <input type="date" id="birthday" name="birthday"/><br /><br />
        
        <%-- Password TextBox --%>
        Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox ID="txtPassword1" Text="Password" TextMode="password" runat="server"></asp:TextBox><br /><br />

        <%-- Email TextBox --%>
        Email:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox ID="TextBox1" placeholder="xyz@gmail.com" Type="email" runat="server"></asp:TextBox><br /><br />

         <%-- Button --%>
        <asp:Button ID="btnCreate" Text="Create Account" OnClick="Create_Account" runat="server" />&nbsp;
            <%-- Button --%>
        <asp:Button ID="Button1" Text="Login Existing Account" PostBackUrl="~/main.aspx" runat="server" /><br /><br />

            <div id="message1" runat="server"></div>
        </div>
    </form>
</body>
</html>