<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="testingpage.aspx.cs"  ValidateRequest="false" Inherits="testingpage" Title="testingpage" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>

<%@ MasterType VirtualPath="~/Default.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
     <script type="text/javascript">

         function toggleDiv(divid, linkid) {
             var linktext = '';
             if (document.getElementById(divid).style.display == 'none') {
                 document.getElementById(divid).style.display = 'block';
                 linktext = '-';
             }
             else {
                 document.getElementById(divid).style.display = 'none';
                 linktext = '+';
             }
             var link = document.getElementById(linkid);
             if (document.all) { //IS IE 4 or 5 or later 
                 link.innerText = linktext;
             }
             //IS NETSCAPE 4 or below
             if (document.layers) {
                 link.innerText = linktext;
             }
             //Mozilla/Netscape6+ and all the other Gecko-based browsers
             if (document.getElementById && !document.all) {
                 link.firstChild.nodeValue = linktext;
             }
         }

         function GetChangeDeleteUserConf() {
             var userselect = confirm("This action will also remove other associated records!\n" +
                 "  • Associated Document References\n" +
                 "  • Associated Attachments\n" +
                 "  • Associated Notes\n" +
                 "  • Associated Custom Fields\n" +
                 "  Are you sure you want to continue?");

             document.getElementById('hdnDeleteUserPref').value = userselect;
         }

     </script>
    
<!-- jQuery -->
<script src="../../plugins/jquery/jquery.min.js"></script>
<!-- Bootstrap 4 -->
<script src="../../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE App -->
<script src="../../dist/js/adminlte.min.js"></script>
<!-- Summernote -->
<script src="../../plugins/summernote/summernote-bs4.min.js"></script>
<!-- CodeMirror -->
<script src="../../plugins/codemirror/codemirror.js"></script>
<script src="../../plugins/codemirror/mode/css/css.js"></script>
<script src="../../plugins/codemirror/mode/xml/xml.js"></script>
<script src="../../plugins/codemirror/mode/htmlmixed/htmlmixed.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="../../dist/js/demo.js"></script>
<!-- Page specific script -->
<script>
    $(function () {
        // Summernote
        $('#summernote').summernote()

        // CodeMirror
        CodeMirror.fromTextArea(document.getElementById("codeMirrorDemo"), {
            mode: "htmlmixed",
            theme: "monokai"
        });
    })
</script>
    <script src="JS/jquery-1.10.2.min.js" type="text/javascript"></script>  
<script src="JS/jquery-te-1.4.0.min.js" type="text/javascript"></script>  
   </asp:Content>
<asp:Content ID="ChangeManagement" ContentPlaceHolderID="PageContent" runat="Server">
    <script  type="text/javascript" src="ckeditor/ckeditor.js"></script>
   



    <main>
                    <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                       
                    </header>
                    <!-- Main page content-->
                    <div class="container-xl px-4 mt-4">                                               
                        <div class="row">                          
                            <div class="col-xl-12">
                                <!-- Task Document card-->
                                <div class="card mb-4">
                                    <div class="card-header">Service Request Information</div>                                     
                                    <div class="card-body">
                                        <p class="alert-danger-soft">
                                        <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                                            </p>
                                      
                                           <form id="Editor" runat="server">  
                                               <textarea id="summernote">
                Place <em>some</em> <u>text</u> <strong>here</strong>
              </textarea>
    </form>  
                                            
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                                            
                                            
</main>
</asp:Content>
