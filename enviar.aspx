<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.Text" %>
<script runat="server">
  protected void Page_Load(object sender, EventArgs e)
  {
    string redirectBase = "contacto.html";
    if (Request.UrlReferrer != null)
    {
      string refPath = Request.UrlReferrer.AbsolutePath;
      if (refPath.EndsWith("contacto_en.html")) redirectBase = "contacto_en.html";
      else if (refPath.EndsWith("contacto_eu.html")) redirectBase = "contacto_eu.html";
    }

    if (Request.HttpMethod != "POST")
    {
      Response.Redirect(redirectBase);
      return;
    }

    // Honeypot: si este campo llega relleno, es un bot. Simulamos exito sin enviar nada.
    if (!string.IsNullOrEmpty(Request.Form["botcheck"]))
    {
      Response.Redirect(redirectBase + "?enviado=1");
      return;
    }

    string name = Request.Form["name"] ?? "";
    string email = Request.Form["email"] ?? "";
    string phone = Request.Form["phone"] ?? "";
    string message = Request.Form["message"] ?? "";
    string[] areas = Request.Form.GetValues("areas_interes");

    if (string.IsNullOrWhiteSpace(name) || string.IsNullOrWhiteSpace(email) ||
        string.IsNullOrWhiteSpace(message) || areas == null || areas.Length == 0)
    {
      Response.Redirect(redirectBase + "?error=1");
      return;
    }

    try
    {
      var body = new StringBuilder();
      body.AppendLine("Nuevo mensaje desde el formulario de exdci-solutions.com");
      body.AppendLine();
      body.AppendLine("Nombre: " + name);
      body.AppendLine("Email: " + email);
      body.AppendLine("Telefono: " + phone);
      body.AppendLine("Areas de interes: " + string.Join(", ", areas));
      body.AppendLine();
      body.AppendLine("Mensaje:");
      body.AppendLine(message);

      string smtpUser = WebConfigurationManager.AppSettings["SmtpUser"];
      string smtpPassword = WebConfigurationManager.AppSettings["SmtpPassword"];
      string smtpHost = WebConfigurationManager.AppSettings["SmtpHost"];
      int smtpPort = int.Parse(WebConfigurationManager.AppSettings["SmtpPort"]);

      var mail = new MailMessage();
      mail.From = new MailAddress(smtpUser, "Formulario exdci-solutions.com");
      mail.To.Add(smtpUser);
      mail.ReplyToList.Add(new MailAddress(email, name));
      mail.Subject = "Nuevo mensaje desde exdci-solutions.com";
      mail.Body = body.ToString();

      var client = new SmtpClient(smtpHost, smtpPort);
      client.EnableSsl = true;
      client.Credentials = new System.Net.NetworkCredential(smtpUser, smtpPassword);
      client.Send(mail);

      Response.Redirect(redirectBase + "?enviado=1");
    }
    catch
    {
      Response.Redirect(redirectBase + "?error=1");
    }
  }
</script>
