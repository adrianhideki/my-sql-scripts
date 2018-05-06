How to allow remote connections on SQL Instance

• Enable remote connections on SQL Instance;

• Activate pipinames and TCP/IP on SQL Server Configuration Manager;

• Run the service SQL Browser;

• On sql configuration manager:
  • Network configurations
    • Protocols <your instance name>
      • TCP/IP - Right Click / Click into Properties:
        • IP Adress > Choose a IP > set the TCP Port to 1433 > set dynamic port to '' > apply and ok;
  • restart the server;
  • On the windows go to: "Windows Defender Firewall with Advanced Security"
    • Inbound rules > new rules > choise port radio > Local especif port > set to 1433 > allow connections > OK > OK;
    • Outbound rules > same process of the inbound rule;
  • test connection on sql server
