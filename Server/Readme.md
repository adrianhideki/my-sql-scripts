## How to allow remote connections on SQL Instance

1. Enable **remote connections** on SQL Instance;

2. Activate ```pipenames``` and ```TCP/IP``` on SQL Server Configuration Manager;

3. Run the service SQL Browser;

4. On SQL Server Configuration Manager:
   - Network configurations
     - Protocols ```your instance name```
       - ```TCP/IP``` - Right Click / Click into Properties:
         - IP Adress > **Choose a IP** > set the TCP Port to ```1433``` > set dynamic port to ```''``` _(void)_ > apply and ok;

5. Restart the SQL Server Service;

6. On the windows go to: "Windows Defender Firewall with Advanced Security":
   - Inbound rules > new rules > choise port radio > Local especif port > set to 1433 > allow connections > OK > OK;
   - Outbound rules > same process of the inbound rule;

7. Test your connection with the sql server;
