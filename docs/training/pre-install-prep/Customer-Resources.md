# New Platform One User Onboarding Guide to P1 Managed Services
Many of P1's services are protected by combinations of controls including Authentication, Authorization, and a Software Defined Perimeter.    

The following document is intended to inform new users of:    
* The need to create an Account that works with our Single Sign On enabled Authentication Proxies.
* Prerequisites necessary to upgrade your SSO Account to be Authorized to use a Service.
* How to upgrade your SSO Account and configure your machine to gain access to P1 Hosted Services protected by Authorization and Software Defined Perimeter Security Controls.



## How to Create a P1 SSO Account
1. Visit <https://login.dso.mil>
2. There's a spot that says "No account? Click here to register now.", that will allow you to create an account in a self service manner.
3. Use your work or .mil email to sign up. Signing up with a .mil email is prefered as doing so will automatically associate your account with a group authorized to access IL2 and IL4 resources. 



## How to add your SSO Account to the IL2 / IL4 Authorized user groups:
### Option 1: .mil email = IL2 & IL4 access
If you sign up with a .mil email, then your SSO account will automatically be associated with IL2 and IL4 user groups.

### Option 2: Associate your CAC with SSO = IL2 & IL4 access
If you sign up with a work email, have a CAC (Common Access Card or equivalent), CAC reader with drivers installed / properly configured, and CAC Card Plugged into CAC Reader. Then visit https://chat.il4.dso.mil, you should see a message that says DoD PKI Detected, and the webpage will ask if you want to associate your CAC with your SSO Account. Say yes and your account will get associated with IL2 and IL4 user groups. (The following page has more info if you get stuck <https://sso-info.il2.dso.mil/#whatdoineedtodo>)

### Option 3: CAC In Progress + Security Manager who can confirm + Training + Gov Sponsor + DD2875 = 90 days of IL4 access
If you don't have a .mil email or CAC, but are far enough into the [process of getting a CAC](https://www.cac.mil/common-access-card/getting-your-cac/) that you can be looked up in DEERS (Defense Enrollment Eligibility Reporting System) by a Security Manager who can validate your Background Investigation or Clearance Information, have received a .pdf certificate from completing the [1 hour Cyber Awareness Challenge Training](https://public.cyber.mil/training/cyber-awareness-challenge/), and know a Government / DoD Mission Owner willing to use their CAC to sign a doc (Sponsor you). Then you can fill out a DD2875 to gain 90 days of access to IL4.    

> **IMPORTANT NOTE: For those who plan to use a DD2875 to gain access to both IL2 and IL4**    
> You'll need to submit 2 seperate DD2875 forms. One for IL2 Access One for IL4 Access. They both need signatures so it's recommended that you complete them both 98% similiar documents at the same time / request people CAC sign both copies of the form at the same time.

The DD2875 document can be found on this page: <https://repo1.dso.mil/razor-crest-public/2875s>

#### Workflow for filling out DD2875 for IL4 Access:    

1. The requestor fills out boxes 1 - 16a themselves.     
[The razor-crest-public repo has tips on how to fill out the form]https://repo1.dso.mil/razor-crest-public/2875s#dd-2875-guidance-fields-commonly-filled-out-incorrectly)
Here's some additional guidance beyond what's on that page:     
   * Background Context about what to put in USER ID and USER Signature (Box 11):    
  The DD2875 form is used for multiple scenarios, one scenario is where everyone has a CAC. The USER ID refers to your DoD ID Number, which is on the back of a CAC card. Since you're in the scenario where you don't have a CAC. You can leave USER ID blank, and use Adobe Acrobat to create a self signed digital certificate and sign with that.
   * Box 6 if you're a contractor you can list Contractor as your GRADE/RANK    
     Example: DevOps Engineer / Contractor
2. The Requestor is responsible for Identifying a DoD Mission Owner/Government Sponsor who has a CAC card. 
   * If you're a contractor of a P1 Customer, that customer will be a DoD Organization with government personel, ask members of your organization to recommend a government Sponsor within your organization for that person's email and an introduction.
   * If you're a contractor working for Platform One, ask your Value Stream PM to introduce you to a Government Sponsor.
   * Email your DoD Mission Owner / Government Sponsor a copy of your DD2875 that has boxes 1-16a filled out, and request they fill in boxes 17-20b, and then email the document back to you.    
   `Note:` Boxes 1-16a must be filled out completely and accurately before sending it to the DoD Mission Owner / Government Sponsor. You can't fill out 1-16, request they sign it, and then try to figure out box 16a, After they sign box 18, boxes 1-18 will become uneditable.
3. The Requestor is responsible for Identifying a SECURITY MANAGER that can fill out Part III (Boxes 28 - 32), The Security Manager is basically anyone with a CAC who can validate your Background Investigation or Clearance Information, in other words they're a person who can verify that paperwork exists in DEERS showing that the requestor has a CAC and Background Investigation in Progress.
   * Many DoD contracting firms have FSOs (Facility Security Officers) who help start the process of a contractor / requestor getting a security clearance / Common Access Card, they represent an example of someone who can fulfill this role, To clarify it doesn't have to be an FSO. If your contracting firm doesn't have FSOs and your CAC application was sponsored by a partner organization, ask them to help you identify and introduce you via email to their FSO or someone else who has a CAC and can look you up in DEERS, note this person can be a contractor / isn't required to be a government personel.
   * Email your Security Manager, give them the version with boxes 1-20b filled out. Ask them to fill out Part III (Boxes 28-32).    
  `Note:` Yes this does mean boxes 21 - 27 will be blank / empty, don't worry about it, it's fine. After the Security Manager fills out Part III, boxes 21 - 27 will still be editable. The P1 Helpdesk will fill them out later in the process.
   * The Security Manager will return to you a DD2875 that has boxes 1-20b and 28-32 filled out.
4. Submit the completed DD2875 per the directions on the following page: <https://repo1.dso.mil/razor-crest-public/2875s#the-process>

### Option 4: Training + Gov Sponsor + DD2875 = 90 days of IL2 access
If you don't have a CAC in Progress, but do know a Government / DoD Mission Owner willing to use their CAC to sign a doc (Sponsor you), then you can complete a [1 hour Cyber Awareness Challenge Training](https://public.cyber.mil/training/cyber-awareness-challenge/) to receive a .pdf certificate. Then you can fill out a DD2875 to gain 90 days of access to IL2.
The steps are nearly identical to Option 3, the only difference is that IL4 access requires the requestor to collect 2 CAC signatures (one from a Gov Sponsor and 1 from a Security Manager), IL2 only requires 1 CAC signature from the Gov Sponsor, in other words the only difference between the Steps of Option 4 and Option 3 is that Option 3's step 3 is skipped. 


## Prerequisites for accessing authentication protected P1 Hosted Services
* **IronBank's Container Registry:** registry1.dso.mil 
  1. You only need to create an P1 SSO account.

* **IL2 Matter Most:** chat.il2.dso.mil
  1. Your P1 SSO Account needs to be in the IL2 group to be authorized.
  2. Then visit this link, https://chat.il2.dso.mil/signup_user_complete/?id=uizuoayahpfs9qfkzkz1g43smy to join the main Platform One MM Chat full of public channels, like https://chat.il2.dso.mil/platform-one/channels/team---big-bang 
  3. The following link is recommended only for programs going through a Big Bang Discovery Sprint, only IL2 approved conversations can occur here, but the BigBang Customer Integration Team can make private channels per customer going through a Discovery Sprint. https://chat.il2.dso.mil/signup_user_complete/?id=ojhhogobqbrhby3opgr7k1gt1c (After joining, you can request a chat admin add you to the appropriate private channel, Note: they won't see you're name as an option to add to a channel until you've connected at least once.)

* **IL2 Gitlab, Jira, Confluence:** code.il2.dso.mil, jira.il2.dso.mil, confluence.il2.dso.mil
  1. Your P1 SSO Account needs to be in the IL2 group.
  2. Visit one of the webpages, get redirected to P1's SSO, and login.
  3. If you see a message about your account does not having access to the application group. Then email P1's Helpdesk at help@dsop.io and include the following information
     ```text
     * Which Impact Level (IL):
     * Which product(s) you need to regain access to:
     * Which team or project you are supporting:
     * An individual who can verify your funding status:
     * We will temporarily re-grant your access while we verify your funding status.
     ```
  4. Note: After gaining authorization to see / connect to IL2 Gitlab, Jira, Confluence, you still may need to ask an admin of those services to authorize you to access private resources within those services. Be aware that said admins won't see you're name as an option to be added to private resources, until you've connected to the service at least once before.

* **IL4 Matter Most:** chat.il4.dso.mil
  1. Your P1 SSO Account needs to be in the IL4 group.
  2. Then visit this link, https://chat.il4.dso.mil/signup_user_complete/?id=kzjxs7zacjb78mrmhyb4jqpbkh This can be used to join the BB Onboarding MM Chat, where the BB Customer Integration Team has a private channel per customer.
  3. After joining you can request a chat admin add you to the appropriate private channel. (They won't be able to see your name as an option to join the channel until you've connected to the service at least once.)

* **IL4 Gitlab, Jira, Confluence:** code.il4.dso.mil, jira.il4.dso.mil, confluence.il4.dso.mil
  1. Your P1 SSO Account needs to be in the IL4 group.
  2. Follow the steps on this page, https://confluence.il2.dso.mil/display/P1/CNAP+AppGate+SDP+Client to Install App Gate and add the profile link.
  3. Note: The IL4 websites will give a ERR_CONNECTDION_TIMED_OUT message if you try to go directly to their URLs. You need to login to the App Gate Client (which is the CNAP client) and use it to access those websites. (This is part of the Cloud Native Access Point's Software Definied Perimeter functionality, which helps P1 achieve layered security AKA Defense in Depth.)
  4. If the entries for IL4 P1 services do not show up in the App Gate Client, or after logging into App Gate Client, and then trying to visit one of the webpages, you see a message about not having access to the application group. Then email P1's Helpdesk at help@dsop.io and include the following information
     ```text
     * Which Impact Level (IL):
     * Which product(s) you need to regain access to:
     * Which team or project you are supporting:
     * An individual who can verify your funding status:
     * We will temporarily re-grant your access while we verify your funding status.
     ```
  5. Note: After gaining authorization to see / connect to IL4 Gitlab, Jira, Confluence, you still may need to ask an admin of those services to authorize you to access private resources within those services. Be aware that said admins won't see you're name as an option to be added to private resources, until you've connected to the service at least once before.


# Where to reach out to for additional help?
  * Password / MFA Reset of SSO Account - P1 Helpdesk's email  help@dsop.io
  * General Q&A - https://chat.il2.dso.mil/platform-one/channels/team---big-bang
  * Onboarding Help - Your Big Bang Onboarding PoC 
  * Payments, pricing, and acquisitions - Platform One Customer Success team (platformone@afwerxpartner.com). 

