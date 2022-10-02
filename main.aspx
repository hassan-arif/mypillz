<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="main.aspx.cs" Inherits="WebApplication3.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - MyPillz</title>
    <style>  
        body {
            background-image: url('login.png');
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-size: 100% 100%;

            text-align: center;
            color: dimgrey;
            font-family: Arial, Verdana;
            font-size: 90%
        }
        .img-container {
            text-align: center;
            display: block;
        }
        .square {
            height: 80%;
            width: 20%;
            background-color: white;
            border-radius: 5%;
            
            position: absolute;
            left: 40%;
            top: 10%;
        }
    </style>
</head>
<body>
    <div class="square">
    
    <%-- Image --%>
    <br /><br /><br />
    <asp:Image ID="Image2" height="293" Width="270" class="center" ImageUrl="logo.png" runat="server" />

    <form id="form1" runat="server">
    <div>
        <h1>Login</h1>
        Please enter the following credentials<br /><br />
        
        <%-- Username TextBox --%>
        Username:  <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox><br />
        
        <%-- Password TextBox --%><h1></h1>
        Password:  <asp:TextBox ID="txtPassword" Text="Password" TextMode="password" runat="server"></asp:TextBox><br /><br />

         <%-- Button --%>
        <asp:Button ID="btnCreate" Text="Login" runat="server" OnClick="Verify_Account"/>&nbsp;
        <asp:button ID="Button1" Text="SignUp" runat ="server" PostBackUrl="~/signup.aspx"></asp:button><br /><br />
        <div id="message" runat="server"></div>
    </div>
    </form>
        
    </div>
</body>
</html>