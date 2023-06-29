<%@  language="VBScript" %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head>
    <link rel="stylesheet" type="text/css" href="../pg_style.css">
    <link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
    <title>Quick Search Tools</title>
    <!-- <style type="text/css">
        .auto-style1 {
            width: 817px;
        }
        .auto-style2 {
            width: 68%;
        }
        .auto-style3 {
            width: 733px;
        }
        .auto-style4 {
            width: 251px;
        }
    </style>-->
</head>

<body>
    <div id="layoutSidenav_content">
        <main>
            <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                <div class="container-xl px-4">
                    <div class="page-header-content">
                        <div class="row align-items-center justify-content-between pt-3">
                            <div class="col-auto mb-3">
                                <h1 class="page-header-title">
                                    <div class="page-header-icon"><i data-feather="user"></i></div>
                                    Quick Search Tools
                                </h1>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <!-- Main page content-->
            <div class="container-xl px-4 mt-4">
                <div class="row">
                    <div class="col-xl-12">
                        <!-- Quick Search  card-->
                        <div class="card mb-4">
                            <div class="card-header">SEARCHING THE SYSTEM</div>
                            <div class="card-body">
                                <p>
                                    <form method="POST" action="ret_search.asp">
                                        <input type="hidden" name="A" value="QSearch">
                                        <input type="hidden" name="PageSize" value="50">
                                        <table border="0" cellpadding="2" aria-checked="undefined" class="auto-style2" align="center">
                                            <tr>
                                                <td><font size="2">Record Type:</font></td>
                                                <td class="auto-style4"><font size="2">Search String: </font></td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <select class="form-select" name="SearchBase" size="1">
                                                        <option value="Documents">Documents (Document Number)</option>
                                                        <option value="Change Orders">Change Orders (Change Number)</option>
                                                        <option value="Orders">Orders (Order Number)</option>
                                                        <option value="Parts">Parts (Part Number)</option>
                                                        <option value="Projects">Projects (Project Number)</option>
                                                        <option value="Tasks">Tasks (Task ID Number)</option>
                                                        <option value="ControlLists">Control Lists(Opt Code)</option>
                                                        <option value="Restrictions">Restrictions(Ref ID)</option>
                                                        <option value="Help">Help Tickets (Request Number)</option>
                                                         
                                                    </select></td>
                                                <td class="auto-style4">
                                                    <input class="form-control" type="text" name="V" size="30" />
                                                </td>
                                                <td>

                                                    <input type="submit" class="btn btn-primary-soft" value="GO" name="B1"></td>
                                            </tr>
                                            <tr>
                                                <td valign="top"><strong><font face="Verdana" size="2">BASIC SEARCH TECHNIQUESTECHNIQUES</font></strong></td>
                                                <td valign="top">
                                                    <ol>
                                                        <li><font face="Verdana" size="2">Select the search record type and then enter a valid search string.</font></li>
                                                        <li><font face="Verdana" size="2">The [Modifier] selection provides the allowable range of
            the search.</font></li>
                                                        <li><font face="Verdana" size="2">Provide a value for the search. If a [<strong>LIKE*</strong>]            search is selected, <strong>wildcard</strong> searches are allowed <em>(see Performing            LIKE Searches)</em>.<br>
                                                        </font></li>
                                                    </ol>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top"><strong><font face="Verdana" size="2">Performing LIKE Searches</font></strong></td>
                                                <td valign="top"><font face="Verdana" size="2">When performing [<strong>LIKE*</strong>]        searches, or ranged searches, it is best to use a partial value with a <strong>wildcard        character</strong> [<strong>*</strong>]. Wildcard characters can be used anywhere, and/or        multiple times within your search string.</font><p>
                                                    <strong><font face="Verdana" size="3">Allowed        Wildcard Characters</font></strong><ul>
                                                        <li><font face="Verdana" size="2"><strong>[*] Asterisk, [%] Percent</strong> - Both perform            the same function providing for any value to exist within the area it occupies in the            search string.</font></li>
                                                        <li><font face="Verdana" size="2"><strong>[_] Underscore</strong> - Provides wildcard            functionality on a single character in the position it occupies in the search string.</font></li>
                                                    </ul>
                                                </td>

                                            </tr>
                                        </table>
                                    </form>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>
</html>

