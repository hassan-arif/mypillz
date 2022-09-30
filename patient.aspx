﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="patient.aspx.cs" Inherits="WebApplication3.patient" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <title>Patient</title>
    <meta name="description" content=""/>
    <meta name="viewport" content="width=device-width"/>

    <link href="http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800" rel="stylesheet"/>

    <link href="css/animate.css" rel="stylesheet" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/font-awesome.min.css" rel="stylesheet" />
    <link href="css/normalize.min.css" rel="stylesheet" />
    <link href="css/templatemo_misc.css" rel="stylesheet" />
    <link href="css/templatemo_style.css" rel="stylesheet" />
    <script src="js/vendor/modernizr-2.6.2.min.js"></script>
</head>

<body>
    <form runat="server">
    <div class="bg-overlay">
        <asp:button runat="server" style="margin:10px;float:right;width:100px;border-radius:9px" text="Sign Out" OnClick="Log_Out_Patient"></asp:button>
        <!-- /.Log out Button -->
    </div>

    <div class="container-fluid">
        <div class="row">
            
            <div class="col-md-4 col-sm-12">
                <div class="sidebar-menu">
                    
                    <div class="logo-wrapper">
                        <h1 class="logo"><%--135,90--%>
                            <a href="#"><img src="images/logo.png" style = "width:100%;height:100%" alt="MyPillz"/></a>
                        </h1>
                    </div> <!-- /.logo-wrapper -->
                    
                    <div class="menu-wrapper">
                        <ul class="menu">
                            <li><a class="homebutton" href="#">Home</a></li>
                            <li><a class="show-1" href="#">Order</a></li>
                            <li><a class="show-2" href="#">Consultancies</a></li>
                            <li><a class="show-3" href="#">Forum</a></li>
                            <li><a class="show-4" href="#">Profile</a></li>
                            <li><a class="show-5" href="#">Gallery</a></li>
                            <li><a class="show-6" href="#">About</a></li>
                        </ul> <!-- /.menu -->
                        <a href="#" class="toggle-menu"><i class="fa fa-bars"></i></a>
                    </div> <!-- /.menu-wrapper -->

                    <!--Arrow Navigation-->
                    <a id="prevslide" class="load-item"><i class="fa fa-angle-left"></i></a>
                    <a id="nextslide" class="load-item"><i class="fa fa-angle-right"></i></a>

                </div> <!-- /.sidebar-menu -->
            </div> <!-- /.col-md-4 -->

            <div class="col-md-8 col-sm-12">
                
                <div id="menu-container">

                    <div id="menu-1" class="services content">
                        <div class="row">
                            <ul class="tabs">
                                <li class="col-md-4 col-sm-4">
                                    <a href="#tab4" class="icon-item">
                                        <i class="fa fa-cogs"></i>
                                    </a> <!-- /.icon-item -->
                                </li>
                                <li class="col-md-4 col-sm-4">
                                    <a href="#tab5" class="icon-item">
                                        <i class="fa fa-leaf"></i>
                                    </a> <!-- /.icon-item -->
                                </li>
                                <li class="col-md-4 col-sm-4">
                                    <a href="#tab6" class="icon-item">
                                        <i class="fa fa-users"></i>
                                    </a> <!-- /.icon-item -->
                                </li>
                            </ul> <!-- /.tabs -->
                            <div class="col-md-12 col-sm-12">
                                <div class="toggle-content text-center" id="tab4">
                                    <h3>Booking</h3>
                                    <div>
                                        <p>Book medicine and get your order id...</p>
                                        <b>DRUG ID</b>&nbsp;&nbsp;<asp:TextBox ID="new_order_drug_id" style="background-color:lightgrey;width:100px" runat="server"></asp:TextBox>&nbsp;&nbsp;
                                        <b>VENDOR ID</b>&nbsp;&nbsp;<asp:TextBox ID="new_order_vendor_id" style="background-color:lightgrey;width:100px" runat="server"></asp:TextBox>&nbsp;&nbsp;
                                        <b>QUANTITY</b>&nbsp;&nbsp;<asp:TextBox ID="new_order_quantity" style="background-color:lightgrey;width:100px" runat="server"></asp:TextBox><br />
                                        <asp:button runat="server" style="margin:10px;width:100px;border-radius:9px" text="Order" onclick="CreateNewOrder"></asp:button>
                                        <div id="new_order_message" runat="server"></div>
                                    </div>

                                    <div><br />
                                        <p>Search all vendors by drug id...</p>
                                        <b>DRUG ID</b>&nbsp;&nbsp;<asp:TextBox ID="drug_id_ven" style="background-color:lightgrey;width:100px" runat="server"></asp:TextBox>&nbsp;&nbsp;
                                        <asp:button runat="server" style="margin:10px;width:100px;border-radius:9px" text="Search" OnClick="SearchDrugVendors"></asp:button>
                                        <div id="search_vendor_drug_id" runat="server"></div>
                                        <asp:GridView ID="DrugVendors" runat="server">
                                        </asp:GridView>
                                    </div><br />
                                    <p>Medicine Catalogue...</p>
                                    <asp:GridView ID="MedPatItemGrid" runat="server">
                                    </asp:GridView>
                                </div>

                                <div class="toggle-content text-center" id="tab5">
                                    <h3>Tracking</h3>
                                    <p>InProgress Orders...</p>
                                    <div id="in_progress_message" runat="server"></div><br />
                                    <asp:GridView ID="inProgressOrdersGrid" runat="server">
                                    </asp:GridView>

                                    <br /><br /><p>See all your previous orders...</p>
                                    <div id="previous_orders_message" runat="server"></div><br />
                                    <asp:GridView ID="CompletedOrdersGrid" runat="server">
                                    </asp:GridView>
                                </div>

                                <div class="toggle-content text-center" id="tab6">
                                    <h3>Rate</h3>
                                    <p>Rate vendors here after receiving your medicine...</p>
                                    <div id="rate_order_message" runat="server"></div>
                                    <asp:GridView ID="rateOrderGrid" runat="server">
                                    </asp:GridView><br /><br />
                                    
                                    <b>ORDER ID</b>&nbsp;&nbsp;<asp:TextBox ID="rating_order_id" style="background-color:lightgrey;width:80px" runat="server"></asp:TextBox>&nbsp;&nbsp;
                                    <b>RATING</b>&nbsp;&nbsp;<asp:TextBox ID="rating_rate" style="background-color:lightgrey;width:50px" runat="server"></asp:TextBox><br />
                                    <asp:button runat="server" style="margin:10px;width:100px;border-radius:9px" text="Rate" OnClick="rateVendor"></asp:button>
                                    <div id="rating_message" runat="server"></div>

                                </div>
                            </div> <!-- /.col-md-12 -->
                        </div> <!-- /.row -->
                    </div> <!-- /.order -->

                    <div id="menu-2" class="services content">
                        <div class="row">
                            <ul class="tabs">
                                <li class="col-md-4 col-sm-4">
                                    <a href="#tab7" class="icon-item">
                                        <i class="fa fa-cogs"></i>
                                    </a> <!-- /.icon-item -->
                                </li>
                                <li class="col-md-4 col-sm-4">
                                    <a href="#tab8" class="icon-item">
                                        <i class="fa fa-leaf"></i>
                                    </a> <!-- /.icon-item -->
                                </li>
                                <li class="col-md-4 col-sm-4">
                                    <a href="#tab9" class="icon-item">
                                        <i class="fa fa-users"></i>
                                    </a> <!-- /.icon-item -->
                                </li>
                            </ul> <!-- /.tabs -->
                            <div class="col-md-12 col-sm-12">
                                <div class="toggle-content text-center" id="tab7">
                                    <h3>Booking</h3>
                                    <b>DOCTOR ID</b>&nbsp;&nbsp;<asp:TextBox ID="book_doctor_id" style="background-color:lightgrey;width:50px" runat="server"></asp:TextBox>&nbsp;
                                    <asp:button runat="server" style="margin:10px;width:100px;border-radius:9px" text="Register" onclick="BookAppointment"></asp:button><br />
                                    <div id="book_doctor_message" runat="server"></div>

                                    <br /><p>Booked Appointments...(if any)</p>
                                    <asp:GridView ID="BookedAppointmentGrid" runat="server">
                                    </asp:GridView>
                                    <div id="booked_appointment_message" runat="server"></div>

                                    <br /><br /><p>List of all doctors (if exist) with their Available Timings</p>
                                    <asp:GridView ID="AvailableDocGrid" runat="server">
                                    </asp:GridView>
                                </div>

                                <div class="toggle-content text-center" id="tab8">
                                    <h3>History</h3>
                                    <p>Check your all previous consultancies here...</p>
                                    
                                    <div id="prev_consultancy_message" runat="server"></div><br />
                                    <asp:GridView ID="PrevConsultancyGrid" runat="server">
                                    </asp:GridView>
                                </div>

                                <div class="toggle-content text-center" id="tab9">
                                    <h3>Rate</h3>
                                    <p>Rate doctors here after receiving their consultation...</p>
                                    <div id="rating_doctor_list_message" runat="server"></div>
                                    <asp:GridView ID="ratingDoctorGrid" runat="server">
                                    </asp:GridView><br /><br />
                                    
                                    <b>CONSULTANCY ID</b>&nbsp;&nbsp;<asp:TextBox ID="consultancy_rating_order_id" style="background-color:lightgrey;width:80px" runat="server"></asp:TextBox>&nbsp;&nbsp;
                                    <b>RATING</b>&nbsp;&nbsp;<asp:TextBox ID="consultancy_rating_value" style="background-color:lightgrey;width:50px" runat="server"></asp:TextBox><br />
                                    <asp:button runat="server" style="margin:10px;width:100px;border-radius:9px" text="Rate" OnClick="rateDoctor"></asp:button>
                                    <div id="consultancy_rating_output" runat="server"></div>
                                </div>
                            </div> <!-- /.col-md-12 -->
                        </div> <!-- /.row -->
                    </div> <!-- /.consultancies -->

                    <div id="menu-3" class="contact content">
                        <div class="row">
                        	
                            <div class="col-md-12">
                                <div class="toggle-content text-center spacing">
                                    <h3>Discussion</h3>
                                    <asp:GridView ID="ForumGrid" runat="server">
                                    </asp:GridView>
                                </div>
                                <asp:button runat="server" style=" align-content:center;margin-top:2px;float:right;width:100px;border-radius:9px;color:black" text="Refresh" onclick="LoadForumGrid"></asp:button>
                                <!-- Refresh Forum and show last 10 messages -->
                            </div> <!-- /.col-md-12 -->
                            
                            
                            <div class="col-md-12">
                                <div class="contact-form">
                                    <div class="row">
                                    	
                                         <asp:textbox runat="server" name="message" id="forum_message" placeholder="Message"></asp:textbox>
                                            
                                         <asp:Button runat="server" type="submit" name="send" value="Send Message" Text="Submit Message" id="submitMessage" class="button" onclick="sendMessage"/>
                                        
                                    </div> <!-- /.row -->
                                </div> <!-- /.contact-form -->
                            </div> <!-- /.col-md-12 -->
                        </div> <!-- /.row -->
                    </div> <!-- /.forum -->


                    <div id="menu-4" class="contact content">
                        <div class="row">
                        	
                            <div class="col-md-12">
                                <div class="toggle-content text-center spacing">
                                    <h3>My Portfolio</h3>
                                    <div id="profile_patient_message" runat="server"></div>
                                    <asp:GridView ID="ProfilePatientGrid" runat="server">
                                    </asp:GridView>
                                </div>
                            </div> <!-- /.col-md-12 -->
                            
                            
                            <%--<div class="col-md-12">
                                <div class="contact-form">
                                    <div class="row">
                                            <fieldset class="col-md-12">
                                                <textarea name="message" id="message" placeholder="Message"></textarea>
                                            </fieldset>
                                            <fieldset class="col-md-12">
                                                <input type="submit" name="send" value="Send Message" id="submit" class="button"/>
                                            </fieldset>
                                    </div> <!-- /.row -->
                                </div> <!-- /.contact-form -->
                            </div> <!-- /.col-md-12 -->--%>
                        </div> <!-- /.row -->
                    </div> <!-- /.profile -->

                    <div id="menu-5" class="gallery content">
                        <div class="row">
                            
                            <div class="col-md-4 col-ms-6">
                                <div class="g-item">
                                    <img src="images/gallery/g1.jpg" alt=""/>
                                    <a data-rel="lightbox" class="overlay" href="images/gallery/g1.jpg">
                                        <span>+</span>
                                    </a>
                                </div> <!-- /.g-item -->
                            </div> <!-- /.col-md-4 -->
                            <div class="col-md-4 col-ms-6">
                                <div class="g-item">
                                    <img src="images/gallery/g2.jpg" alt=""/>
                                    <a data-rel="lightbox" class="overlay" href="images/gallery/g2.jpg">
                                        <span>+</span>
                                    </a>
                                </div> <!-- /.g-item -->
                            </div> <!-- /.col-md-4 -->
                            <div class="col-md-4 col-ms-6">
                                <div class="g-item">
                                    <img src="images/gallery/g3.jpg" alt=""/>
                                    <a data-rel="lightbox" class="overlay" href="images/gallery/g3.jpg">
                                        <span>+</span>
                                    </a>
                                </div> <!-- /.g-item -->
                            </div> <!-- /.col-md-4 -->
                            <div class="col-md-4 col-ms-6">
                                <div class="g-item">
                                    <img src="images/gallery/g4.jpg" alt=""/>
                                    <a data-rel="lightbox" class="overlay" href="images/gallery/g4.jpg">
                                        <span>+</span>
                                    </a>
                                </div> <!-- /.g-item -->
                            </div> <!-- /.col-md-4 -->
                            <div class="col-md-4 col-ms-6">
                                <div class="g-item">
                                    <img src="images/gallery/g5.jpg" alt=""/>
                                    <a data-rel="lightbox" class="overlay" href="images/gallery/g5.jpg">
                                        <span>+</span>
                                    </a>
                                </div> <!-- /.g-item -->
                            </div> <!-- /.col-md-4 -->
                            <div class="col-md-4 col-ms-6">
                                <div class="g-item">
                                    <img src="images/gallery/g6.jpg" alt=""/>
                                    <a data-rel="lightbox" class="overlay" href="images/gallery/g6.jpg">
                                        <span>+</span>
                                    </a>
                                </div> <!-- /.g-item -->
                            </div> <!-- /.col-md-4 -->
                            <div class="col-md-4 col-ms-6">
                                <div class="g-item">
                                    <img src="images/gallery/g7.jpg" alt=""/>
                                    <a data-rel="lightbox" class="overlay" href="images/gallery/g7.jpg">
                                        <span>+</span>
                                    </a>
                                </div> <!-- /.g-item -->
                            </div> <!-- /.col-md-4 -->
                            <div class="col-md-4 col-ms-6">
                                <div class="g-item">
                                    <img src="images/gallery/g8.jpg" alt=""/>
                                    <a data-rel="lightbox" class="overlay" href="images/gallery/g8.jpg">
                                        <span>+</span>
                                    </a>
                                </div> <!-- /.g-item -->
                            </div> <!-- /.col-md-4 -->
                            <div class="col-md-4 col-ms-6">
                                <div class="g-item">
                                    <img src="images/gallery/g9.jpg" alt=""/>
                                    <a data-rel="lightbox" class="overlay" href="images/gallery/g9.jpg">
                                        <span>+</span>
                                    </a>
                                </div> <!-- /.g-item -->
                            </div> <!-- /.col-md-4 -->

                        </div> <!-- /.row -->
                    </div> <!-- /.gallery -->

                    <div id="menu-6" class="about content">
                        <div class="row">
                            <ul class="tabs">
                                <li class="col-md-4 col-sm-4">
                                    <a href="#tab1" class="icon-item">
                                        <i class="fa fa-umbrella"></i>
                                    </a> <!-- /.icon-item -->
                                </li>
                                <li class="col-md-4 col-sm-4">
                                    <a href="#tab2" class="icon-item">
                                        <i class="fa fa-camera"></i>
                                    </a> <!-- /.icon-item -->
                                </li>
                                <li class="col-md-4 col-sm-4">
                                    <a href="#tab3" class="icon-item">
                                        <i class="fa fa-coffee"></i>
                                    </a> <!-- /.icon-item -->
                                </li>
                            </ul> <!-- /.tabs -->
                            <div class="col-md-12 col-sm-12">
                                <div class="toggle-content text-center" id="tab1">
                                    <h3>About Us</h3>
                                    <p>This website is going to be Pakistan's Premier Online Healthcare Service which will Patients to Doctors and Vendors.</p>
                                    <p>Doctors will provide medical consultancy while Vendors will provide door to door delivery of the prescribed medicines. All 3 will have to sign up on this platform which will be managed by the Database Administrator who has built a mechanism to maintain records and provide additional functionalities.</p>
                                </div>

                                <div class="toggle-content text-center" id="tab2">
                                    <h3>Overview</h3>
                                    <p>
                                        Our company strives to provide the best possible experience to our users. We are the lumber 1 platform to connect patients with doctors and drug vendors. We provide a streamlined route for patients to get their diagnosis and order the required medications in one sitting, from the comfort of their homes. The highly qualified Doctors affiliated with us use the platform to maximize their working hours and productivity. Approved Drug Vendors use our platform to increase their reach and provide online delivery services to their customers. 
                                    </p>    
                                </div>

                                <div class="toggle-content text-center" id="tab3">
                                    <h3>Our Team</h3>
                                    <p><b>Ubaid:</b> Backend SQL Developer</p>
                                    <p><b>Omar:</b> Frontend Web Developer</p>
                                    <p><b>Mahd:</b> Frontend SQL Developer</p>
                                    <p><b>Hassan:</b> Backend Web Developer</p>
                                </div>
                            </div> <!-- /.col-md-12 -->
                        </div> <!-- /.row -->

                        <div class="row">
                            <div class="col-md-3 col-sm-3">
                                <div class="member-item">
                                    <div class="thumb">
                                        <img src="images/team/member-3.jpg" alt="Ubaid"/>
                                    </div>
                                    <h4>Ubaidullah Waleed</h4>
                                    <span>CEO</span>
                                </div> <!-- /.member-item -->

                            </div> <!-- /.col-md-4 -->
                            <div class="col-md-3 col-sm-3">
                                <div class="member-item">
                                    <div class="thumb">
                                        <img src="images/team/member-2.jpg" alt="Omar"/>
                                    </div>
                                    <h4>Omar Habeeb</h4>
                                    <span>CSO</span>
                                </div> <!-- /.member-item -->
                            </div> <!-- /.col-md-4 --><%--</div>
                           <div class="row">--%>
                            <div class="col-md-3 col-sm-3">
                                <div class="member-item">
                                    <div class="thumb">
                                        <img src="images/team/member-4.jpg" alt="Mahd"/>
                                    </div>
                                    <h4>Mahd Bin Tariq</h4>
                                    <span>COO</span>
                                </div> <!-- /.member-item -->
                            </div> <!-- /.col-md-4 -->
                            <div class="col-md-3 col-sm-3">
                                <div class="member-item">
                                    <div class="thumb">
                                        <img src="images/team/member-1.jpg" alt="Hassan"/>
                                    </div>
                                    <h4>Hassan Mahmood</h4>
                                    <span>CTO</span>
                                </div> <!-- /.member-item -->
                            </div> <!-- /.col-md-4 -->
                        </div> <!-- /.row -->
                    </div> <!-- /.about -->

                </div> <!-- /#menu-container -->

            </div> <!-- /.col-md-8 -->

        </div> <!-- /.row -->
    </div> <!-- /.container-fluid -->
    
    <div class="container-fluid">   
        <div class="row">
            <div class="col-md-12 footer">
                <p id="footer-text">
                
                	Copyright &copy; 2022 <a href="#">MyPillz</a>
                 	
<%--                    | design: templatemo--%>
                 
                 </p>
            </div><!-- /.footer --> 
        </div>
    </div> <!-- /.container-fluid -->
    </form>

    <script src="js/vendor/jquery-1.10.1.min.js"></script>
    <script>window.jQuery || document.write('<script src="js/vendor/jquery-1.10.1.min.js"><\/script>')</script>
    <script src="js/jquery.easing-1.3.js"></script>
    <script src="js/bootstrap.js"></script>
    <script src="js/plugins.js"></script>
    <script src="js/main.js"></script>
    <script type="text/javascript">
            
			jQuery(function ($) {

                $.supersized({

                    // Functionality
                    slide_interval: 3000, // Length between transitions
                    transition: 1, // 0-None, 1-Fade, 2-Slide Top, 3-Slide Right, 4-Slide Bottom, 5-Slide Left, 6-Carousel Right, 7-Carousel Left
                    transition_speed: 700, // Speed of transition

                    // Components                           
                    slide_links: 'blank', // Individual links for each slide (Options: false, 'num', 'name', 'blank')
                    slides: [ // Slideshow Images
                        {
                            image: 'images/templatemo-slide-1.jpg'
                        }, {
                            image: 'images/templatemo-slide-2.jpg'
                        }, {
                            image: 'images/templatemo-slide-3.jpg'
                        }, {
                            image: 'images/templatemo-slide-4.jpg'
                        }
                    ]

                });
            });
            
    </script>

</body>
</html>