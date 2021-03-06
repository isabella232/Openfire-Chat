<%--
  - $Revision$
  - $Date$
  -
  - Copyright (C) 2004-2008 Jive Software. All rights reserved.
  -
  - Licensed under the Apache License, Version 2.0 (the "License");
  - you may not use this file except in compliance with the License.
  - You may obtain a copy of the License at
  -
  -     http://www.apache.org/licenses/LICENSE-2.0
  -
  - Unless required by applicable law or agreed to in writing, software
  - distributed under the License is distributed on an "AS IS" BASIS,
  - WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  - See the License for the specific language governing permissions and
  - limitations under the License.
--%>

<%@ page import="org.jivesoftware.util.*,
                 java.util.*,               
                 java.net.URLEncoder"                 
    errorPage="error.jsp"
%>
<%@ page import="org.jivesoftware.openfire.plugin.rest.RESTServicePlugin" %>
<%  
    List<String> resp = null;
    int devices = 0;
    String sipProfile = JiveGlobals.getProperty("freeswitch.sip.internal", "indexinside");

    if (RESTServicePlugin.getInstance() != null)
    {
        resp = RESTServicePlugin.getInstance().sendFWCommand("sofia status profile " + sipProfile + " reg");
        
        if (resp != null)
        {   
            for (String line : resp) 
            {
                if (line.startsWith("MWI-Account"))
                {
                    devices++;      
                }
            }
        }
    }
%>
<html>
    <head>
        <title>FreeSwitch Registrations</title>
        <link rel="stylesheet" type="text/css" href="global.css">
    </head>
    <body>
    <p>
    Active Registrations: <%= devices %>,
    </p>
    
    <div class="jive-table">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    <thead>
        <tr>
        <th nowrap>User</th>
        <th nowrap>Contact</th>           
        <th nowrap>Agent</th>
        <th nowrap>Status</th>
        <th nowrap>Ping</th>        
        <th nowrap>IP Address</th>    
        <th nowrap>Auth User</th>    
        <th nowrap>Domain</th>
        <th nowrap>Account</th>           
        </tr>
    </thead>
    <tbody> 

<% 
        if (devices == 0) {
%>
    <tr>
        <td align="center" colspan="10">
            There are no active registrations
        </td>
    </tr>   
<%
    }
    
    if (resp != null)
    {
        int count = 0;
        String user = "&nbsp;"; 
        String contact = "&nbsp;";
        String agent = "&nbsp;";
        String status = "&nbsp;";
        String ping = "&nbsp;";     
        String ipaddress = "&nbsp;";    
        String authuser = "&nbsp;";
        String domain = "&nbsp;";
        String account = "&nbsp;";
        String ip = "";
        
        for (String line : resp) 
        {
            if (line.startsWith("Call-ID:"))
            {
%>
                <tr class="jive-<%= (((count%2)==0) ? "even" : "odd") %>">
<%
            }
            
            if (line.startsWith("User:"))
            {
                user = line.substring(5).trim();
%>
                <td width="10%">
                    <%= user %>
                </td>
<%
            }
            
            if (line.startsWith("Contact:"))
            {
                contact = line.substring(8).trim();
%>
                <td width="10%">
                    <%= contact %>
                </td>
<%
            }
            if (line.startsWith("Agent:"))
            {
                agent = line.substring(6).trim();
%>
                <td width="10%">
                    <%= agent %>
                </td>
<%
            }
            if (line.startsWith("Status:"))
            {
                status = line.substring(7, line.indexOf("(")).trim();
%>
                <td width="10%">
                    <%= status %>
                </td>
<%
            }
            if (line.startsWith("Ping-Status:"))
            {
                ping = line.substring(12).trim();
%>
                <td width="10%">
                    <%= ping %>
                </td>
<%
            }
            if (line.startsWith("IP:"))
            {
                ip = line.substring(3).trim();
            }
            if (line.startsWith("Port:"))
            {
                ipaddress = ip + ":" + line.substring(5).trim();
%>
                <td width="10%">
                    <%= ipaddress %>
                </td>
<%
            }
            if (line.startsWith("Auth-User:"))
            {
                authuser = line.substring(10).trim();
%>
                <td width="10%">
                    <%= authuser %>
                </td>
<%
            }
            if (line.startsWith("Auth-Realm:"))
            {
                domain = line.substring(11).trim();
%>
                <td width="10%">
                    <%= domain %>
                </td>
<%
            }           
            
            if (line.startsWith("MWI-Account:"))
            {
                account = line.substring(12).trim();            
%>
                <td width="10%">
                    <%= account %>
                </td>
                </tr>
<%          
                count++;        
            }           
        }
    }
%>
</tbody>
</table>
</div>
</body>
</html>
